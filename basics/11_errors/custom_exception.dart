// Sometimes the built-in exceptions don't describe your problem well.
// Define your own by implementing `Exception` and giving it a useful
// message and any relevant data.
class InsufficientFundsException implements Exception {
  final double balance;
  final double requested;

  InsufficientFundsException(this.balance, this.requested);

  @override
  String toString() =>
      'InsufficientFundsException: balance=$balance, requested=$requested';
}

class Account {
  double balance;
  Account(this.balance);

  void withdraw(double amount) {
    if (amount > balance) {
      throw InsufficientFundsException(balance, amount);
    }
    balance -= amount;
  }
}

void main() {
  final acct = Account(50);
  acct.withdraw(20);
  print('balance: ${acct.balance}');

  try {
    acct.withdraw(100);
  } on InsufficientFundsException catch (e) {
    print('caught: $e');
  }
}
