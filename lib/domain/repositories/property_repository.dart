import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/property_entity.dart';

abstract class PropertyRepository {
  Future<Either<Failure, List<PropertyEntity>>> getProperties();
  Future<Either<Failure, PropertyEntity>> getProperty(String id);
  Future<Either<Failure, void>> addProperty(PropertyEntity property);
  Future<Either<Failure, void>> updateProperty(PropertyEntity property);
  Future<Either<Failure, void>> deleteProperty(String id);
  Future<Either<Failure, List<PropertyEntity>>> getLandlordProperties(String landlordId);
}