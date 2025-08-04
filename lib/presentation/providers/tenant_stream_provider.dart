import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/tenant_model.dart';
import '../../data/models/rental_application_model.dart';

final landlordTenantsStreamProvider = StreamProvider.family<List<TenantModel>, String>((ref, landlordId) {
  return FirebaseFirestore.instance
      .collection('tenants')
      .where('landlordId', isEqualTo: landlordId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => TenantModel.fromMap(doc.data()))
          .toList());
});

final pendingApplicationsStreamProvider = StreamProvider.family<List<RentalApplicationModel>, String>((ref, landlordId) {
  return FirebaseFirestore.instance
      .collection('applications')
      .where('landlordId', isEqualTo: landlordId)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => RentalApplicationModel.fromMap(doc.data()))
          .toList());
});

final overdueTenantsStreamProvider = StreamProvider.family<List<TenantModel>, String>((ref, landlordId) {
  final now = DateTime.now();
  return FirebaseFirestore.instance
      .collection('tenants')
      .where('landlordId', isEqualTo: landlordId)
      .where('nextPaymentDue', isLessThan: now.toIso8601String())
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => TenantModel.fromMap(doc.data()))
          .toList());
});