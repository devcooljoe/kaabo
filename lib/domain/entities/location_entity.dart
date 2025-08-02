import 'package:equatable/equatable.dart';
import 'package:kaabo/data/models/location_model.dart';

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String? nearestCampus;
  final double? distanceToCampus;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.nearestCampus,
    this.distanceToCampus,
  });

  LocationModel toModel() => LocationModel(
    latitude: latitude,
    longitude: longitude,
    address: address,
    nearestCampus: nearestCampus,
    distanceToCampus: distanceToCampus,
  );

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    address,
    nearestCampus,
    distanceToCampus,
  ];
}
