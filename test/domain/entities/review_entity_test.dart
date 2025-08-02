import 'package:flutter_test/flutter_test.dart';
import 'package:kaabo/domain/entities/review_entity.dart';

void main() {
  group('ReviewEntity', () {
    final tReviewEntity = ReviewEntity(
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

    test('should be a subclass of Equatable', () {
      expect(tReviewEntity, isA<ReviewEntity>());
    });

    test('should return correct props', () {
      expect(tReviewEntity.props, [
        '1',
        'prop1',
        'landlord1',
        'reviewer1',
        'Test Reviewer',
        4.5,
        'Great property',
        DateTime(2024, 1, 1),
        ReviewType.property,
      ]);
    });

    test('should support equality comparison', () {
      final tReviewEntity2 = ReviewEntity(
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

      expect(tReviewEntity, equals(tReviewEntity2));
    });

    test('should handle null landlordId', () {
      final tReviewEntityNoLandlord = ReviewEntity(
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

      expect(tReviewEntityNoLandlord.landlordId, isNull);
    });
  });
}