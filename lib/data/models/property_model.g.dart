// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyModelImpl _$$PropertyModelImplFromJson(
  Map<String, dynamic> json,
) => _$PropertyModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  location: json['location'] as String,
  state: json['state'] as String,
  city: json['city'] as String,
  type: $enumDecode(_$PropertyTypeEnumMap, json['type']),
  bedrooms: (json['bedrooms'] as num).toInt(),
  bathrooms: (json['bathrooms'] as num).toInt(),
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  amenities:
      (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
  landlordId: json['landlordId'] as String,
  isAvailable: json['isAvailable'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  geoLocation:
      json['geoLocation'] == null
          ? null
          : LocationModel.fromJson(json['geoLocation'] as Map<String, dynamic>),
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  nearestCampus: json['nearestCampus'] as String?,
  distanceFromCampus: (json['distanceFromCampus'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$PropertyModelImplToJson(_$PropertyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'location': instance.location,
      'state': instance.state,
      'city': instance.city,
      'type': _$PropertyTypeEnumMap[instance.type]!,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'images': instance.images,
      'amenities': instance.amenities,
      'landlordId': instance.landlordId,
      'isAvailable': instance.isAvailable,
      'createdAt': instance.createdAt.toIso8601String(),
      'geoLocation': instance.geoLocation?.toJson(),
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'nearestCampus': instance.nearestCampus,
      'distanceFromCampus': instance.distanceFromCampus,
    };

const _$PropertyTypeEnumMap = {
  PropertyType.apartment: 'apartment',
  PropertyType.house: 'house',
  PropertyType.duplex: 'duplex',
  PropertyType.selfContain: 'selfContain',
};
