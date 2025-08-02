import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaabo/data/datasources/remote/tenant_service.dart';
import 'package:kaabo/data/models/rental_application_model.dart';
import 'package:kaabo/data/models/tenant_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockWriteBatch extends Mock implements WriteBatch {}

class FakeDocumentReference extends Fake
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDocumentReference());
    registerFallbackValue(<String, dynamic>{});
  });
  late TenantService tenantService;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;

  late MockQuerySnapshot mockQuerySnapshot;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();

    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentReference = MockDocumentReference();
    tenantService = TenantService(mockFirestore);
  });

  group('getLandlordTenants', () {
    test('should return list of tenants when successful', () async {
      when(
        () => mockFirestore.collection('tenants'),
      ).thenReturn(mockCollection);
      when(
        () => mockCollection.where(
          'landlordId',
          isEqualTo: any(named: 'isEqualTo'),
        ),
      ).thenReturn(mockCollection);
      when(
        () => mockCollection.get(),
      ).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await tenantService.getLandlordTenants('landlord1');

      expect(result, isA<List<TenantModel>>());
      verify(() => mockFirestore.collection('tenants')).called(1);
    });

    test('should throw exception when Firestore fails', () async {
      when(
        () => mockFirestore.collection('tenants'),
      ).thenThrow(Exception('Firestore error'));

      expect(
        () => tenantService.getLandlordTenants('landlord1'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('submitApplication', () {
    test('should submit application successfully', () async {
      final application = RentalApplicationModel(
        id: '1',
        propertyId: 'prop1',
        tenantId: 'tenant1',
        landlordId: 'landlord1',
        tenantName: 'Test Tenant',
        tenantEmail: 'test@test.com',
        tenantPhone: '1234567890',
        occupation: 'Software Engineer',
        monthlyIncome: 500000.0,
        employerName: 'Tech Company',
        previousAddress: '123 Previous St',
        emergencyContact: '0987654321',
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now(),
      );

      when(
        () => mockFirestore.collection('applications'),
      ).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.set(any())).thenAnswer((_) async {});

      await tenantService.submitApplication(application);

      verify(() => mockDocumentReference.set(any())).called(1);
    });
  });

  group('approveApplication', () {
    test('should approve application successfully', () async {
      final mockBatch = MockWriteBatch();

      when(() => mockFirestore.batch()).thenReturn(mockBatch);
      when(
        () => mockFirestore.collection('applications'),
      ).thenReturn(mockCollection);
      when(
        () => mockFirestore.collection('properties'),
      ).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocumentReference);
      when(() => mockBatch.update(any(), any())).thenReturn(mockBatch);
      when(() => mockBatch.commit()).thenAnswer((_) async {});

      await tenantService.approveApplication('app1', 'prop1');

      verify(() => mockBatch.commit()).called(1);
    });
  });
}
