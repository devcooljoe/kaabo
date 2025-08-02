import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String propertyId;
  final String? landlordId;
  final String reviewerId;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final ReviewType type;

  const ReviewEntity({
    required this.id,
    required this.propertyId,
    this.landlordId,
    required this.reviewerId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        propertyId,
        landlordId,
        reviewerId,
        reviewerName,
        rating,
        comment,
        createdAt,
        type,
      ];
}

enum ReviewType { property, landlord }