import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/property_model.dart';
import '../../domain/entities/property_entity.dart';

final propertyStreamProvider = StreamProvider<List<PropertyEntity>>((ref) {
  return FirebaseFirestore.instance
      .collection('properties')
      .where('isAvailable', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PropertyModel.fromJson(doc.data()).toEntity())
          .toList());
});

final landlordPropertyStreamProvider = StreamProvider.family<List<PropertyEntity>, String>((ref, landlordId) {
  return FirebaseFirestore.instance
      .collection('properties')
      .where('landlordId', isEqualTo: landlordId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PropertyModel.fromJson(doc.data()).toEntity())
          .toList());
});