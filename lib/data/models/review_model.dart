import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/review_entity.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String propertyId,
    String? landlordId,
    required String reviewerId,
    required String reviewerName,
    required double rating,
    required String comment,
    required DateTime createdAt,
    required ReviewType type,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

extension ReviewModelX on ReviewModel {
  ReviewEntity toEntity() => ReviewEntity(
    id: id,
    propertyId: propertyId,
    landlordId: landlordId,
    reviewerId: reviewerId,
    reviewerName: reviewerName,
    rating: rating,
    comment: comment,
    createdAt: createdAt,
    type: type,
  );
}
