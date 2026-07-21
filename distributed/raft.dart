// Raft — Understandable Distributed Consensus (Ongaro & Ousterhout, 2014).
// Raft is used in etcd (Kubernetes' store), CockroachDB, TiKV, Consul.
// It decomposes consensus into three largely independent sub-problems:
//   1. Leader election (this file)
//   2. Log replication   (a leader appends entries; followers replicate)
//   3. Safety            (only up-to-date nodes can win elections)
//
// State machine:
//   Follower  → hears no heartbeat in election timeout → Candidate.
//   Candidate → sends RequestVote RPCs → wins majority → Leader.
//   Candidate → another leader wins    → Follower (higher term).
//   Leader    → sends heartbeats (AppendEntries with empty payload)
//               every 150 ms to prevent new elections.
//
// Terms: a monotonically increasing logical clock.  Each election starts
// a new term.  A node rejects RPC from a lower term; seeing a higher
// term forces immediate reversion to Follower.
//
// Safety: a candidate must carry the most up-to-date log seen by a
// majority before it can be elected (not modelled here for brevity).
//
// Relation to distributed/vector_clock.dart: Raft's term is a scalar
// logical clock; vector clocks generalise this to N processes.
//
// Run:  dart run distributed/raft.dart

enum RaftState { follower, candidate, leader }

class RaftNode {
  final String id;
  final List<String> peers;

  int currentTerm = 0;
  String? votedFor;
  RaftState state = RaftState.follower;
  String? currentLeader;

  // Votes received when in candidate state.
  final Set<String> _votesReceived = {};

  RaftNode(this.id, this.peers);

  int get clusterSize => peers.length + 1;  // includes self
  int get majority => (clusterSize / 2).ceil();

  // --- state transitions -----------------------------------------------

  void startElection() {
    _becomeCandidate();
    print('$id: starting election for term $currentTerm '
        '(needs $majority votes)');
  }

  void _becomeCandidate() {
    state = RaftState.candidate;
    currentTerm++;
    votedFor = id;
    currentLeader = null;
    _votesReceived
      ..clear()
      ..add(id);  // vote for self
    print('$id: → CANDIDATE  (term $currentTerm, voted for self)');
  }

  void _becomeLeader() {
    state = RaftState.leader;
    currentLeader = id;
    print('$id: → LEADER  (term $currentTerm, '
        'won ${_votesReceived.length}/$clusterSize votes: '
        '${_votesReceived.toList()..sort()})');
  }

  void _becomeFollower(int term) {
    state = RaftState.follower;
    currentTerm = term;
    votedFor = null;
    _votesReceived.clear();
    print('$id: → FOLLOWER  (term $currentTerm, higher term observed)');
  }

  // --- RPC handlers ----------------------------------------------------

  /// Handle an incoming RequestVote RPC.
  /// Returns (granted, term) to the caller.
  (bool, int) receiveVoteRequest(String candidateId, int candidateTerm) {
    if (candidateTerm < currentTerm) return (false, currentTerm);
    if (candidateTerm > currentTerm) _becomeFollower(candidateTerm);
    final canVote = votedFor == null || votedFor == candidateId;
    if (canVote) {
      votedFor = candidateId;
      print('$id: granted vote to $candidateId for term $candidateTerm');
      return (true, currentTerm);
    }
    print('$id: denied vote to $candidateId (already voted for $votedFor)');
    return (false, currentTerm);
  }

  /// Process a vote granted by [from] for our candidacy.
  void receiveVote(String from, int term, bool granted) {
    if (state != RaftState.candidate) return;
    if (term > currentTerm) { _becomeFollower(term); return; }
    if (!granted) return;
    _votesReceived.add(from);
    print('$id: received vote from $from '
        '(${_votesReceived.length}/$majority needed)');
    if (_votesReceived.length >= majority) _becomeLeader();
  }

  /// Process an AppendEntries/heartbeat from a leader.
  void receiveHeartbeat(String leaderId, int leaderTerm) {
    if (leaderTerm < currentTerm) {
      print('$id: rejected stale heartbeat from $leaderId '
          '(their term $leaderTerm < mine $currentTerm)');
      return;
    }
    if (leaderTerm > currentTerm) _becomeFollower(leaderTerm);
    state = RaftState.follower;
    currentLeader = leaderId;
    print('$id: accepted heartbeat from $leaderId (term $leaderTerm)');
  }

  @override
  String toString() => '$id[${state.name}, term=$currentTerm]';
}

// --- simulated cluster -------------------------------------------------

void _simulateElection(List<RaftNode> nodes) {
  final all = nodes.map((n) => n.id).toList();
  // Pick node-0 as the one that times out first.
  final candidate = nodes[0];

  print('\n--- ${candidate.id} election timeout → RequestVote ---\n');
  candidate.startElection();

  // Send RequestVote to all peers.
  for (final peer in nodes.skip(1)) {
    final (granted, term) = peer.receiveVoteRequest(
        candidate.id, candidate.currentTerm);
    candidate.receiveVote(peer.id, term, granted);
    if (candidate.state == RaftState.leader) break;
  }
}

void main() {
  print('=== Raft Leader Election (5-node cluster) ===\n');

  final ids = ['node-0', 'node-1', 'node-2', 'node-3', 'node-4'];
  final nodes = ids.map((id) => RaftNode(id, ids.where((x) => x != id).toList())).toList();

  print('Initial state:');
  for (final n in nodes) print('  $n');

  _simulateElection(nodes);

  print('\nFinal state:');
  for (final n in nodes) print('  $n');

  // Demonstrate that a higher-term heartbeat causes step-down.
  print('\n--- New node claims term 99 ---\n');
  nodes[1].receiveHeartbeat('node-99', 99);
  print('node-1 after heartbeat: ${nodes[1]}');

  // Show that if two candidates split the vote (4-node cluster), no winner.
  print('\n--- Split vote scenario (4 nodes, 2 candidates) ---\n');
  final four = ['s0','s1','s2','s3']
      .map((id) => RaftNode(id, ['s0','s1','s2','s3'].where((x) => x != id).toList()))
      .toList();
  four[0].startElection();   // s0 starts election
  four[2].startElection();   // s2 also starts election (same term coincidence)

  // s1 votes for s0, s3 votes for s2 → 2/4 each → no majority.
  final (g1, t1) = four[1].receiveVoteRequest('s0', four[0].currentTerm);
  four[0].receiveVote('s1', t1, g1);
  final (g3, t3) = four[3].receiveVoteRequest('s2', four[2].currentTerm);
  four[2].receiveVote('s3', t3, g3);

  print('\nResult: ${four.map((n) => '$n').join(", ")}');
  print('No winner → both will timeout and re-run (randomised timeouts prevent repeat splits)');
}
