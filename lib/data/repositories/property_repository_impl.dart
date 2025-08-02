import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/remote/property_service.dart';
import '../models/property_model.dart';

@LazySingleton(as: PropertyRepository)
class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyService _propertyService;

  PropertyRepositoryImpl(this._propertyService);

  @override
  Future<Either<Failure, List<PropertyEntity>>> getProperties() async {
    try {
      final properties = await _propertyService.getProperties();
      return Right(properties.map((p) => p.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PropertyEntity>> getProperty(String id) async {
    try {
      final properties = await _propertyService.getProperties();
      final property = properties.firstWhere((p) => p.id == id);
      return Right(property.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addProperty(PropertyEntity property) async {
    try {
      final propertyModel = PropertyModel(
        id: property.id,
        title: property.title,
        description: property.description,
        price: property.price,
        location: property.location,
        state: property.state,
        city: property.city,
        type: property.type,
        bedrooms: property.bedrooms,
        bathrooms: property.bathrooms,
        images: property.images,
        amenities: property.amenities,
        landlordId: property.landlordId,
        isAvailable: property.isAvailable,
        createdAt: property.createdAt,
        averageRating: property.averageRating,
        reviewCount: property.reviewCount,
        nearestCampus: property.nearestCampus,
        distanceFromCampus: property.distanceFromCampus,
      );

      await _propertyService.addProperty(propertyModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProperty(PropertyEntity property) async {
    try {
      final propertyModel = PropertyModel(
        id: property.id,
        title: property.title,
        description: property.description,
        price: property.price,
        location: property.location,
        state: property.state,
        city: property.city,
        type: property.type,
        bedrooms: property.bedrooms,
        bathrooms: property.bathrooms,
        images: property.images,
        amenities: property.amenities,
        landlordId: property.landlordId,
        isAvailable: property.isAvailable,
        createdAt: property.createdAt,
        averageRating: property.averageRating,
        reviewCount: property.reviewCount,
        nearestCampus: property.nearestCampus,
        distanceFromCampus: property.distanceFromCampus,
      );

      await _propertyService.updateProperty(propertyModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProperty(String id) async {
    try {
      await _propertyService.deleteProperty(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PropertyEntity>>> getLandlordProperties(
    String landlordId,
  ) async {
    try {
      final properties = await _propertyService.getLandlordProperties(
        landlordId,
      );
      return Right(properties.map((p) => p.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
