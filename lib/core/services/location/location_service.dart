import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(prefs: ref.read(sharedPreferencesProvider));
});

enum LocationPermissionState { granted, denied, deniedForever, serviceDisabled }

class SavedLocation {
  final double lat;
  final double lng;

  const SavedLocation({required this.lat, required this.lng});
}

class LocationResult {
  final LocationPermissionState state;
  final SavedLocation? location;

  const LocationResult({required this.state, this.location});
}

class LocationService {
  static const String _keyUserLatitude = 'user_latitude';
  static const String _keyUserLongitude = 'user_longitude';

  final SharedPreferences _prefs;

  LocationService({required SharedPreferences prefs}) : _prefs = prefs;

  SavedLocation? getSavedLocation() {
    final lat = _prefs.getDouble(_keyUserLatitude);
    final lng = _prefs.getDouble(_keyUserLongitude);
    if (lat == null || lng == null) return null;
    return SavedLocation(lat: lat, lng: lng);
  }

  Future<void> saveLocation({
    required double lat,
    required double lng,
  }) async {
    await _prefs.setDouble(_keyUserLatitude, lat);
    await _prefs.setDouble(_keyUserLongitude, lng);
  }

  Future<LocationResult> requestAndStoreCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult(
        state: LocationPermissionState.serviceDisabled,
        location: getSavedLocation(),
      );
    }

    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      return LocationResult(
        state: LocationPermissionState.deniedForever,
        location: getSavedLocation(),
      );
    }

    if (!status.isGranted) {
      return LocationResult(
        state: LocationPermissionState.denied,
        location: getSavedLocation(),
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    final location = SavedLocation(
      lat: position.latitude,
      lng: position.longitude,
    );
    await saveLocation(lat: location.lat, lng: location.lng);

    return LocationResult(
      state: LocationPermissionState.granted,
      location: location,
    );
  }
}
