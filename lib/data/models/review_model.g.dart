// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      landlordId: json['landlordId'] as String?,
      reviewerId: json['reviewerId'] as String,
      reviewerName: json['reviewerName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: $enumDecode(_$ReviewTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'landlordId': instance.landlordId,
      'reviewerId': instance.reviewerId,
      'reviewerName': instance.reviewerName,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': _$ReviewTypeEnumMap[instance.type]!,
    };

const _$ReviewTypeEnumMap = {
  ReviewType.property: 'property',
  ReviewType.landlord: 'landlord',
};
