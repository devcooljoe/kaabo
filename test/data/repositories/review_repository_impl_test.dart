import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaabo/core/errors/failures.dart';
import 'package:kaabo/data/repositories/review_repository_impl.dart';
import 'package:kaabo/domain/entities/review_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class FakeDocumentReference extends Fake implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDocumentReference());
    registerFallbackValue(<String, dynamic>{});
  });
  late ReviewRepositoryImpl repository;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockCollectionReference mockPropertiesCollection;

  late MockQuerySnapshot mockQuerySnapshot;
  late MockDocumentReference mockDocumentReference;
  late MockDocumentReference mockPropertyDocumentReference;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockPropertiesCollection = MockCollectionReference();

    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentReference = MockDocumentReference();
    mockPropertyDocumentReference = MockDocumentReference();
    repository = ReviewRepositoryImpl(mockFirestore);
  });

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

  group('addReview', () {
    test(
      'should return Right(null) when review is added successfully',
      () async {
        when(
          () => mockFirestore.collection('reviews'),
        ).thenReturn(mockCollection);
        when(
          () => mockFirestore.collection('properties'),
        ).thenReturn(mockPropertiesCollection);
        when(() => mockCollection.doc(any())).thenReturn(mockDocumentReference);
        when(
          () => mockPropertiesCollection.doc(any()),
        ).thenReturn(mockPropertyDocumentReference);
        when(() => mockDocumentReference.set(any())).thenAnswer((_) async {});
        when(
          () => mockPropertyDocumentReference.update(any()),
        ).thenAnswer((_) async {});
        when(
          () => mockCollection.where(
            'propertyId',
            isEqualTo: any(named: 'isEqualTo'),
          ),
        ).thenReturn(mockCollection);
        when(
          () => mockCollection.where('type', isEqualTo: any(named: 'isEqualTo')),
        ).thenReturn(mockCollection);
        when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockQuerySnapshot.docs).thenReturn([]);

        final result = await repository.addReview(tReviewEntity);

        expect(result, equals(const Right(null)));
      },
    );

    test('should return ServerFailure when adding review fails', () async {
      when(
        () => mockFirestore.collection('reviews'),
      ).thenThrow(Exception('Firestore error'));

      final result = await repository.addReview(tReviewEntity);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });

  group('getPropertyReviews', () {
    test('should return list of reviews when successful', () async {
      when(
        () => mockFirestore.collection('reviews'),
      ).thenReturn(mockCollection);
      when(
        () => mockCollection.where(
          'propertyId',
          isEqualTo: any(named: 'isEqualTo'),
        ),
      ).thenReturn(mockCollection);
      when(
        () => mockCollection.where('type', isEqualTo: any(named: 'isEqualTo')),
      ).thenReturn(mockCollection);
      when(
        () => mockCollection.orderBy(
          'createdAt',
          descending: any(named: 'descending'),
        ),
      ).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await repository.getPropertyReviews('prop1');

      expect(result, isA<Right<Failure, List<ReviewEntity>>>());
    });

    test('should return ServerFailure when getting reviews fails', () async {
      when(
        () => mockFirestore.collection('reviews'),
      ).thenThrow(Exception('Firestore error'));

      final result = await repository.getPropertyReviews('prop1');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });

  group('getPropertyAverageRating', () {
    test('should return 0.0 when no reviews exist', () async {
      when(
        () => mockFirestore.collection('reviews'),
      ).thenReturn(mockCollection);
      when(
        () => mockCollection.where(
          'propertyId',
          isEqualTo: any(named: 'isEqualTo'),
        ),
      ).thenReturn(mockCollection);
      when(
        () => mockCollection.where('type', isEqualTo: any(named: 'isEqualTo')),
      ).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await repository.getPropertyAverageRating('prop1');

      expect(result, equals(const Right(0.0)));
    });

    test('should return ServerFailure when getting rating fails', () async {
      when(
        () => mockFirestore.collection('reviews'),
      ).thenThrow(Exception('Firestore error'));

      final result = await repository.getPropertyAverageRating('prop1');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });
}
