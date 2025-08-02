import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/location_model.dart';
import '../constants/app_constants.dart';

@injectable
class LocationService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea}';
      }
    } catch (e) {
      // Handle error
    }
    return 'Unknown location';
  }

  static LocationModel enhanceLocationWithCampusInfo(
    double lat,
    double lng,
    String address,
  ) {
    String? nearestCampus;
    double? minDistance;

    for (final entry in AppConstants.universities.entries) {
      final campusLat = entry.value['lat']!;
      final campusLng = entry.value['lng']!;
      final distance = _calculateDistance(lat, lng, campusLat, campusLng);

      if (distance <= AppConstants.campusProximityRadius) {
        if (minDistance == null || distance < minDistance) {
          minDistance = distance;
          nearestCampus = entry.key;
        }
      }
    }

    return LocationModel(
      latitude: lat,
      longitude: lng,
      address: address,
      nearestCampus: nearestCampus,
      distanceToCampus: minDistance,
    );
  }

  static double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadius = 6371;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  static List<String> getCampusesNearLocation(double lat, double lng) {
    List<String> nearbyCampuses = [];

    for (final entry in AppConstants.universities.entries) {
      final campusLat = entry.value['lat']!;
      final campusLng = entry.value['lng']!;
      final distance = _calculateDistance(lat, lng, campusLat, campusLng);

      if (distance <= AppConstants.campusProximityRadius) {
        nearbyCampuses.add(entry.key);
      }
    }

    return nearbyCampuses;
  }
}
