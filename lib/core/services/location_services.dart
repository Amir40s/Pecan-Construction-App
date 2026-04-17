import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  static Future<PermissionStatus> checkLocationPermission() async {
    return await Permission.location.status;
  }

  /// Request location permission
  static Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.location.request();
  }

  /// Get current location with permission handling
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable location services.');
      }

      // Check permission status
      PermissionStatus permission = await checkLocationPermission();

      if (permission == PermissionStatus.denied) {
        // Request permission
        permission = await requestLocationPermission();
        if (permission == PermissionStatus.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == PermissionStatus.permanentlyDenied) {
        throw Exception('Location permissions are permanently denied. Please enable them in app settings.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  /// Get current location coordinates as strings
  static Future<Map<String, String>?> getCurrentLocationCoordinates() async {
    try {
      Position? position = await getCurrentLocation();
      if (position != null) {
        return {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        };
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get location coordinates: $e');
    }
  }
}