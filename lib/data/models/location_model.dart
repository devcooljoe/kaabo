import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/location_entity.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required double latitude,
    required double longitude,
    required String address,
    String? nearestCampus,
    double? distanceToCampus,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
}

extension LocationModelX on LocationModel {
  LocationEntity toEntity() => LocationEntity(
        latitude: latitude,
        longitude: longitude,
        address: address,
        nearestCampus: nearestCampus,
        distanceToCampus: distanceToCampus,
      );
}