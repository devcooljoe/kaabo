import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<Failure, void>> addReview(ReviewEntity review);
  Future<Either<Failure, List<ReviewEntity>>> getPropertyReviews(String propertyId);
  Future<Either<Failure, List<ReviewEntity>>> getLandlordReviews(String landlordId);
  Future<Either<Failure, double>> getPropertyAverageRating(String propertyId);
  Future<Either<Failure, double>> getLandlordAverageRating(String landlordId);
}