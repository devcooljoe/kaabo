import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../models/review_model.dart';

@LazySingleton(as: ReviewRepository)
class ReviewRepositoryImpl implements ReviewRepository {
  final FirebaseFirestore _firestore;

  ReviewRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, void>> addReview(ReviewEntity review) async {
    try {
      final reviewModel = ReviewModel(
        id: review.id,
        propertyId: review.propertyId,
        landlordId: review.landlordId,
        reviewerId: review.reviewerId,
        reviewerName: review.reviewerName,
        rating: review.rating,
        comment: review.comment,
        createdAt: review.createdAt,
        type: review.type,
      );

      await _firestore.collection('reviews').doc(review.id).set(reviewModel.toJson());
      await _updateAverageRating(review);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getPropertyReviews(String propertyId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('propertyId', isEqualTo: propertyId)
          .where('type', isEqualTo: 'property')
          .orderBy('createdAt', descending: true)
          .get();

      final reviews = snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data()).toEntity()).toList();
      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getLandlordReviews(String landlordId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('landlordId', isEqualTo: landlordId)
          .where('type', isEqualTo: 'landlord')
          .orderBy('createdAt', descending: true)
          .get();

      final reviews = snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data()).toEntity()).toList();
      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getPropertyAverageRating(String propertyId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('propertyId', isEqualTo: propertyId)
          .where('type', isEqualTo: 'property')
          .get();

      if (snapshot.docs.isEmpty) return const Right(0.0);

      final total = snapshot.docs.fold<double>(
        0.0,
        (sum, doc) => sum + (doc.data()['rating'] ?? 0).toDouble(),
      );

      return Right(total / snapshot.docs.length);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getLandlordAverageRating(String landlordId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('landlordId', isEqualTo: landlordId)
          .where('type', isEqualTo: 'landlord')
          .get();

      if (snapshot.docs.isEmpty) return const Right(0.0);

      final total = snapshot.docs.fold<double>(
        0.0,
        (sum, doc) => sum + (doc.data()['rating'] ?? 0).toDouble(),
      );

      return Right(total / snapshot.docs.length);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<void> _updateAverageRating(ReviewEntity review) async {
    if (review.type == ReviewType.property) {
      final avgResult = await getPropertyAverageRating(review.propertyId);
      final reviewCount = await _getPropertyReviewCount(review.propertyId);
      
      avgResult.fold(
        (l) => null,
        (avgRating) async => await _firestore.collection('properties').doc(review.propertyId).update({
          'averageRating': avgRating,
          'reviewCount': reviewCount,
        }),
      );
    } else if (review.landlordId != null) {
      final avgResult = await getLandlordAverageRating(review.landlordId!);
      final reviewCount = await _getLandlordReviewCount(review.landlordId!);
      
      avgResult.fold(
        (l) => null,
        (avgRating) async => await _firestore.collection('users').doc(review.landlordId).update({
          'averageRating': avgRating,
          'reviewCount': reviewCount,
        }),
      );
    }
  }

  Future<int> _getPropertyReviewCount(String propertyId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('propertyId', isEqualTo: propertyId)
        .where('type', isEqualTo: 'property')
        .get();
    return snapshot.docs.length;
  }

  Future<int> _getLandlordReviewCount(String landlordId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('landlordId', isEqualTo: landlordId)
        .where('type', isEqualTo: 'landlord')
        .get();
    return snapshot.docs.length;
  }
}