import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/rental_application_model.dart';
import '../../../data/models/tenant_model.dart';

@injectable
class TenantService {
  final FirebaseFirestore _firestore;

  TenantService(this._firestore);

  Future<List<TenantModel>> getLandlordTenants(String landlordId) async {
    try {
      final snapshot =
          await _firestore
              .collection('tenants')
              .where('landlordId', isEqualTo: landlordId)
              .get();

      return snapshot.docs
          .map((doc) => TenantModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tenants: $e');
    }
  }

  Future<List<RentalApplicationModel>> getPendingApplications(
    String landlordId,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection('applications')
              .where('landlordId', isEqualTo: landlordId)
              .where('status', isEqualTo: 'pending')
              .get();

      return snapshot.docs
          .map((doc) => RentalApplicationModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get applications: $e');
    }
  }

  Future<void> submitApplication(RentalApplicationModel application) async {
    try {
      await _firestore
          .collection('applications')
          .doc(application.id)
          .set(application.toMap());
    } catch (e) {
      throw Exception('Failed to submit application: $e');
    }
  }

  Future<void> approveApplication(
    String applicationId,
    String propertyId,
  ) async {
    try {
      final batch = _firestore.batch();

      batch.update(_firestore.collection('applications').doc(applicationId), {
        'status': 'approved',
      });

      batch.update(_firestore.collection('properties').doc(propertyId), {
        'isAvailable': false,
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to approve application: $e');
    }
  }

  Future<void> addTenant(TenantModel tenant) async {
    try {
      await _firestore.collection('tenants').doc(tenant.id).set(tenant.toMap());
    } catch (e) {
      throw Exception('Failed to add tenant: $e');
    }
  }

  Future<void> recordPayment(String tenantId, PaymentRecord payment) async {
    try {
      final tenantDoc = _firestore.collection('tenants').doc(tenantId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(tenantDoc);
        final tenant = TenantModel.fromMap(snapshot.data()!);

        final updatedHistory = [...tenant.paymentHistory, payment];
        final nextDue = DateTime(
          tenant.nextPaymentDue.year,
          tenant.nextPaymentDue.month + 1,
          tenant.nextPaymentDue.day,
        );

        transaction.update(tenantDoc, {
          'paymentHistory': updatedHistory.map((p) => p.toMap()).toList(),
          'nextPaymentDue': nextDue.toIso8601String(),
          'status': 'active',
        });
      });
    } catch (e) {
      throw Exception('Failed to record payment: $e');
    }
  }

  Future<List<TenantModel>> getOverdueTenants(String landlordId) async {
    try {
      final now = DateTime.now();
      final snapshot =
          await _firestore
              .collection('tenants')
              .where('landlordId', isEqualTo: landlordId)
              .where('nextPaymentDue', isLessThan: now.toIso8601String())
              .get();

      return snapshot.docs
          .map((doc) => TenantModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get overdue tenants: $e');
    }
  }
}
