import 'package:flutter_test/flutter_test.dart';
import 'package:kaabo/data/models/review_model.dart';
import 'package:kaabo/domain/entities/review_entity.dart';

void main() {
  final tReviewModel = ReviewModel(
    id: '1',
    propertyId: 'prop1',
    landlordId: 'landlord1',
    reviewerId: 'reviewer1',
    reviewerName: 'Test Reviewer',
    rating: 4.5,
    comment: 'Great property',
    createdAt: DateTime(2024, 1, 1),
    type: ReviewType.property,
  );

  group('ReviewModel', () {
    test('should convert to entity correctly', () {
      final entity = tReviewModel.toEntity();

      expect(entity.id, equals('1'));
      expect(entity.propertyId, equals('prop1'));
      expect(entity.landlordId, equals('landlord1'));
      expect(entity.reviewerId, equals('reviewer1'));
      expect(entity.reviewerName, equals('Test Reviewer'));
      expect(entity.rating, equals(4.5));
      expect(entity.comment, equals('Great property'));
      expect(entity.createdAt, equals(DateTime(2024, 1, 1)));
      expect(entity.type, equals(ReviewType.property));
    });

    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': '1',
        'propertyId': 'prop1',
        'landlordId': 'landlord1',
        'reviewerId': 'reviewer1',
        'reviewerName': 'Test Reviewer',
        'rating': 4.5,
        'comment': 'Great property',
        'createdAt': '2024-01-01T00:00:00.000',
        'type': 'property',
      };

      final result = ReviewModel.fromJson(jsonMap);

      expect(result.id, equals('1'));
      expect(result.propertyId, equals('prop1'));
      expect(result.rating, equals(4.5));
      expect(result.type, equals(ReviewType.property));
    });

    test('should return a JSON map containing proper data', () {
      final result = tReviewModel.toJson();

      expect(result['id'], equals('1'));
      expect(result['propertyId'], equals('prop1'));
      expect(result['landlordId'], equals('landlord1'));
      expect(result['reviewerId'], equals('reviewer1'));
      expect(result['reviewerName'], equals('Test Reviewer'));
      expect(result['rating'], equals(4.5));
      expect(result['comment'], equals('Great property'));
      expect(result['type'], equals('property'));
    });

    test('should handle null landlordId', () {
      final reviewModelNoLandlord = ReviewModel(
        id: '1',
        propertyId: 'prop1',
        landlordId: null,
        reviewerId: 'reviewer1',
        reviewerName: 'Test Reviewer',
        rating: 4.5,
        comment: 'Great property',
        createdAt: DateTime(2024, 1, 1),
        type: ReviewType.property,
      );

      expect(reviewModelNoLandlord.landlordId, isNull);

      final entity = reviewModelNoLandlord.toEntity();
      expect(entity.landlordId, isNull);
    });

    test('should support copyWith', () {
      final updatedModel = tReviewModel.copyWith(rating: 5.0);

      expect(updatedModel.rating, equals(5.0));
      expect(updatedModel.id, equals('1'));
      expect(updatedModel.comment, equals('Great property'));
    });
  });
}
