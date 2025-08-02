import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:kaabo/core/errors/failures.dart';
import 'package:kaabo/data/repositories/property_repository_impl.dart';
import 'package:kaabo/data/datasources/remote/property_service.dart';
import 'package:kaabo/data/models/property_model.dart';
import 'package:kaabo/domain/entities/property_entity.dart';

class MockPropertyService extends Mock implements PropertyService {}
class FakePropertyModel extends Fake implements PropertyModel {}

void main() {
  late PropertyRepositoryImpl repository;
  late MockPropertyService mockPropertyService;

  setUpAll(() {
    registerFallbackValue(FakePropertyModel());
  });

  setUp(() {
    mockPropertyService = MockPropertyService();
    repository = PropertyRepositoryImpl(mockPropertyService);
  });

  final tPropertyModel = PropertyModel(
    id: '1',
    title: 'Test Property',
    description: 'Test Description',
    price: 100000,
    location: 'Test Location',
    state: 'Lagos',
    city: 'Lagos',
    type: PropertyType.apartment,
    bedrooms: 2,
    bathrooms: 1,
    images: [],
    amenities: ['WiFi'],
    landlordId: 'landlord1',
    isAvailable: true,
    createdAt: DateTime(2024, 1, 1),
  );

  group('getProperties', () {
    test('should return list of properties when successful', () async {
      when(() => mockPropertyService.getProperties())
          .thenAnswer((_) async => [tPropertyModel]);

      final result = await repository.getProperties();

      expect(result, isA<Right<Failure, List<PropertyEntity>>>());
      result.fold(
        (_) => fail('Should be success'),
        (properties) => expect(properties.length, 1),
      );
    });

    test('should return ServerFailure when service fails', () async {
      when(() => mockPropertyService.getProperties())
          .thenThrow(Exception('Service error'));

      final result = await repository.getProperties();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });

  group('addProperty', () {
    test('should return Right(null) when property is added successfully', () async {
      when(() => mockPropertyService.addProperty(any()))
          .thenAnswer((_) async {});

      final result = await repository.addProperty(tPropertyModel.toEntity());

      expect(result, equals(const Right(null)));
      verify(() => mockPropertyService.addProperty(any())).called(1);
    });

    test('should return ServerFailure when adding property fails', () async {
      when(() => mockPropertyService.addProperty(any()))
          .thenThrow(Exception('Add failed'));

      final result = await repository.addProperty(tPropertyModel.toEntity());

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });

  group('deleteProperty', () {
    test('should return Right(null) when property is deleted successfully', () async {
      when(() => mockPropertyService.deleteProperty(any()))
          .thenAnswer((_) async {});

      final result = await repository.deleteProperty('1');

      expect(result, equals(const Right(null)));
      verify(() => mockPropertyService.deleteProperty('1')).called(1);
    });

    test('should return ServerFailure when deleting property fails', () async {
      when(() => mockPropertyService.deleteProperty(any()))
          .thenThrow(Exception('Delete failed'));

      final result = await repository.deleteProperty('1');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });
}