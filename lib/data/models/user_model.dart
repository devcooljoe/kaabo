import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    required String phone,
    required UserType type,
    required DateTime createdAt,
    @Default(0.0) double averageRating,
    @Default(0) int reviewCount,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    name: name,
    phone: phone,
    type: type,
    createdAt: createdAt,
    averageRating: averageRating,
    reviewCount: reviewCount,
  );
}
