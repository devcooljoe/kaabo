/*
 * Kaabo - Property Rental Platform
 * Open source project by Joseph Onipede (onipedejoseph2018@gmail.com)
 * Developer: Joseph Onipede | Email: onipedejoseph2018@gmail.com
 */

import 'package:equatable/equatable.dart';
import 'package:kaabo/data/models/user_model.dart';

enum UserType { tenant, landlord }

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserType type;
  final DateTime createdAt;
  final double averageRating;
  final int reviewCount;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.type,
    required this.createdAt,
    this.averageRating = 0.0,
    this.reviewCount = 0,
  });

  UserModel toModel() => UserModel(
    id: id,
    email: email,
    name: name,
    phone: phone,
    type: type,
    createdAt: createdAt,
    averageRating: averageRating,
    reviewCount: reviewCount,
  );

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phone,
    type,
    createdAt,
    averageRating,
    reviewCount,
  ];
}
