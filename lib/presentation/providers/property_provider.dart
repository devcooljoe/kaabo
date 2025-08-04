import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../data/models/property_model.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/entities/property_filter.dart';
import '../../domain/repositories/property_repository.dart';

final propertyRepositoryProvider = Provider<PropertyRepository>(
  (ref) => getIt<PropertyRepository>(),
);

final propertiesProvider =
    FutureProvider.family<List<PropertyEntity>, PropertyFilter?>((
      ref,
      filter,
    ) async {
      final repository = ref.watch(propertyRepositoryProvider);
      final result = await repository.getProperties();
      return result.fold((l) => <PropertyEntity>[], (r) => r);
    });

final propertyProvider = FutureProvider.family<PropertyModel?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(propertyRepositoryProvider);
  final result = await repository.getProperty(id);
  return result.fold(
    (l) => null,
    (r) => PropertyModel(
      id: r.id,
      title: r.title,
      description: r.description,
      price: r.price,
      location: r.location,
      state: r.state,
      city: r.city,
      type: r.type,
      bedrooms: r.bedrooms,
      bathrooms: r.bathrooms,
      images: r.images,
      amenities: r.amenities,
      landlordId: r.landlordId,
      isAvailable: r.isAvailable,
      createdAt: r.createdAt,
      averageRating: r.averageRating,
      reviewCount: r.reviewCount,
      nearestCampus: r.nearestCampus,
      distanceFromCampus: r.distanceFromCampus,
    ),
  );
});

final landlordPropertiesProvider =
    FutureProvider.family<List<PropertyEntity>, String>((
      ref,
      landlordId,
    ) async {
      final repository = ref.watch(propertyRepositoryProvider);
      final result = await repository.getLandlordProperties(landlordId);
      return result.fold((l) => <PropertyEntity>[], (r) => r);
    });

final propertyControllerProvider =
    StateNotifierProvider<PropertyController, AsyncValue<void>>((ref) {
      return PropertyController(ref.watch(propertyRepositoryProvider), ref);
    });

class PropertyController extends StateNotifier<AsyncValue<void>> {
  final PropertyRepository _repository;
  final Ref _ref;

  PropertyController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<Either<Failure, void>> addProperty(PropertyEntity property) async {
    state = const AsyncValue.loading();
    final result = await _repository.addProperty(property);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        _invalidateProviders();
      },
    );
    return result;
  }

  Future<Either<Failure, void>> updateProperty(PropertyEntity property) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateProperty(property);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        _invalidateProviders();
      },
    );
    return result;
  }

  Future<Either<Failure, void>> deleteProperty(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteProperty(id);
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
    _ref.invalidate(propertiesProvider);
    _ref.invalidate(landlordPropertiesProvider);
    _ref.invalidate(propertyProvider);
  }
}
