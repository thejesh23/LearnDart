// Haversine formula — great-circle distance between two points
// (lat, lon) on a sphere. Given latitudes φ₁, φ₂ and longitudes
// λ₁, λ₂ (in radians), and sphere radius R:
//
//   a = sin²(Δφ/2) + cos(φ₁)·cos(φ₂)·sin²(Δλ/2)
//   c = 2·atan2(√a, √(1 − a))
//   d = R · c
//
// The name comes from the *haversine* function hav(θ) = sin²(θ/2),
// popular in 19th-century navigation tables because it avoids the
// numerical issues of using the law of cosines for tiny distances.
//
// Earth is not a perfect sphere — flattened at the poles, bulged
// at the equator — so haversine gives ~0.5% error for continental
// distances. For sub-meter accuracy, use Vincenty's formulae on
// the WGS-84 ellipsoid instead.
//
// Uses: GPS "distance to nearest café", flight-path plotting,
// weather-radar range calculations, geofencing.
import 'dart:math';

const double earthRadiusKm = 6371.0088;

double _hav(double x) => (sin(x / 2)) * (sin(x / 2));
double _toRad(double deg) => deg * pi / 180;

double haversineDistance(
    double lat1Deg, double lon1Deg, double lat2Deg, double lon2Deg,
    {double radius = earthRadiusKm}) {
  final phi1 = _toRad(lat1Deg);
  final phi2 = _toRad(lat2Deg);
  final dPhi = _toRad(lat2Deg - lat1Deg);
  final dLam = _toRad(lon2Deg - lon1Deg);
  final a = _hav(dPhi) + cos(phi1) * cos(phi2) * _hav(dLam);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radius * c;
}

void main() {
  // New York → London
  print(haversineDistance(40.7128, -74.0060, 51.5074, -0.1278).toStringAsFixed(1));
  // ≈ 5570 km  (great-circle distance)

  // San Francisco → Tokyo
  print(haversineDistance(37.7749, -122.4194, 35.6762, 139.6503).toStringAsFixed(1));
  // ≈ 8272 km

  // Same point → 0
  print(haversineDistance(0, 0, 0, 0));
}
