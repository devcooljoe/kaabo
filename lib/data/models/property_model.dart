import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/property_entity.dart';
import 'location_model.dart';

part 'property_model.freezed.dart';
part 'property_model.g.dart';

@freezed
class PropertyModel with _$PropertyModel {
  const factory PropertyModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required String location,
    required String state,
    required String city,
    required PropertyType type,
    required int bedrooms,
    required int bathrooms,
    required List<String> images,
    required List<String> amenities,
    required String landlordId,
    required bool isAvailable,
    required DateTime createdAt,
    LocationModel? geoLocation,
    @Default(0.0) double averageRating,
    @Default(0) int reviewCount,
    String? nearestCampus,
    @Default(0.0) double distanceFromCampus,
  }) = _PropertyModel;

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
}

extension PropertyModelX on PropertyModel {
  PropertyEntity toEntity() => PropertyEntity(
    id: id,
    title: title,
    description: description,
    price: price,
    location: location,
    state: state,
    city: city,
    type: type,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    images: images,
    amenities: amenities,
    landlordId: landlordId,
    isAvailable: isAvailable,
    createdAt: createdAt,
    geoLocation: geoLocation?.toEntity(),
    averageRating: averageRating,
    reviewCount: reviewCount,
    nearestCampus: nearestCampus,
    distanceFromCampus: distanceFromCampus,
  );
}
