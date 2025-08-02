// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      type: $enumDecode(_$UserTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'type': _$UserTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
    };

const _$UserTypeEnumMap = {
  UserType.tenant: 'tenant',
  UserType.landlord: 'landlord',
};
