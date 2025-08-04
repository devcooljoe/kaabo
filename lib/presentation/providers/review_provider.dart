import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) => getIt<ReviewRepository>(),
);

final propertyReviewsProvider =
    FutureProvider.family<List<ReviewEntity>, String>((ref, propertyId) async {
      final repository = ref.watch(reviewRepositoryProvider);
      final result = await repository.getPropertyReviews(propertyId);
      return result.fold((l) => <ReviewEntity>[], (r) => r);
    });

final landlordReviewsProvider =
    FutureProvider.family<List<ReviewEntity>, String>((ref, landlordId) async {
      final repository = ref.watch(reviewRepositoryProvider);
      final result = await repository.getLandlordReviews(landlordId);
      return result.fold((l) => <ReviewEntity>[], (r) => r);
    });

final propertyRatingProvider = FutureProvider.family<double, String>((
  ref,
  propertyId,
) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final result = await repository.getPropertyAverageRating(propertyId);
  return result.fold((l) => 0.0, (r) => r);
});

final landlordRatingProvider = FutureProvider.family<double, String>((
  ref,
  landlordId,
) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final result = await repository.getLandlordAverageRating(landlordId);
  return result.fold((l) => 0.0, (r) => r);
});

final reviewControllerProvider =
    StateNotifierProvider<ReviewController, AsyncValue<void>>((ref) {
      return ReviewController(ref.watch(reviewRepositoryProvider), ref);
    });

class ReviewController extends StateNotifier<AsyncValue<void>> {
  final ReviewRepository _repository;
  final Ref _ref;

  ReviewController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<Either<Failure, void>> addReview(ReviewEntity review) async {
    state = const AsyncValue.loading();
    final result = await _repository.addReview(review);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        _invalidateProviders();
      },
    );
    return result;
  }

  void _invalidateProviders() {
    _ref.invalidate(propertyReviewsProvider);
    _ref.invalidate(landlordReviewsProvider);
    _ref.invalidate(propertyRatingProvider);
    _ref.invalidate(landlordRatingProvider);
  }
}
