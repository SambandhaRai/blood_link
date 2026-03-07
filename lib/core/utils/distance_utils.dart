import 'dart:math' as math;

class DistanceUtils {
  DistanceUtils._();

  static double haversineDistanceKm({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    const earthRadiusKm = 6371.0;

    final dLat = _toRadians(toLat - fromLat);
    final dLng = _toRadians(toLng - fromLng);

    final lat1 = _toRadians(fromLat);
    final lat2 = _toRadians(toLat);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static String formatDistanceKm(double km) {
    if (km.isNaN || km.isInfinite) return "—";
    if (km < 0.1) return "<0.1km";
    return "${km.toStringAsFixed(1)}km";
  }

  static double _toRadians(double degrees) => degrees * (math.pi / 180);
}
