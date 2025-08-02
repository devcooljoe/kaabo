import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaabo/data/datasources/remote/property_service.dart';
import 'package:kaabo/data/models/property_model.dart';
import 'package:kaabo/domain/entities/property_entity.dart';
import 'package:kaabo/core/services/cloudinary_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCloudinaryService extends Mock implements CloudinaryService {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late PropertyService propertyService;
  late MockFirebaseFirestore mockFirestore;
  late MockCloudinaryService mockCloudinaryService;
  late MockCollectionReference mockCollection;

  late MockQuerySnapshot mockQuerySnapshot;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCloudinaryService = MockCloudinaryService();
    mockCollection = MockCollectionReference();

    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentReference = MockDocumentReference();
    propertyService = PropertyService(mockFirestore, mockCloudinaryService);
  });

  group('getProperties', () {
    test('should return list of properties when successful', () async {
      when(() => mockFirestore.collection('properties')).thenReturn(mockCollection);
      when(() => mockCollection.where('isAvailable', isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await propertyService.getProperties();

      expect(result, isA<List<PropertyModel>>());
      verify(() => mockFirestore.collection('properties')).called(1);
    });

    test('should filter by state when provided', () async {
      when(() => mockFirestore.collection('properties')).thenReturn(mockCollection);
      when(() => mockCollection.where('isAvailable', isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.where('state', isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      await propertyService.getProperties(state: 'Lagos');

      verify(() => mockCollection.where('state', isEqualTo: 'Lagos')).called(1);
    });

    test('should throw exception when Firestore fails', () async {
      when(() => mockFirestore.collection('properties')).thenThrow(Exception('Firestore error'));

      expect(
        () => propertyService.getProperties(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('addProperty', () {
    test('should add property successfully', () async {
      final property = PropertyModel(
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

      when(() => mockFirestore.collection('properties')).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.set(any())).thenAnswer((_) async {});

      await propertyService.addProperty(property);

      verify(() => mockDocumentReference.set(any())).called(1);
    });

    test('should throw exception when adding property fails', () async {
      final property = PropertyModel(
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

      when(() => mockFirestore.collection('properties')).thenThrow(Exception('Add failed'));

      expect(
        () => propertyService.addProperty(property),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('deleteProperty', () {
    test('should delete property successfully', () async {
      when(() => mockFirestore.collection('properties')).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.delete()).thenAnswer((_) async {});

      await propertyService.deleteProperty('1');

      verify(() => mockDocumentReference.delete()).called(1);
    });

    test('should throw exception when deleting property fails', () async {
      when(() => mockFirestore.collection('properties')).thenThrow(Exception('Delete failed'));

      expect(
        () => propertyService.deleteProperty('1'),
        throwsA(isA<Exception>()),
      );
    });
  });
}