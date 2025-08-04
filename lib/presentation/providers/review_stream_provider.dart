import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/review_model.dart';
import '../../domain/entities/review_entity.dart';

final propertyReviewsStreamProvider = StreamProvider.family<List<ReviewEntity>, String>((ref, propertyId) {
  return FirebaseFirestore.instance
      .collection('reviews')
      .where('propertyId', isEqualTo: propertyId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()).toEntity())
          .toList());
});

final landlordReviewsStreamProvider = StreamProvider.family<List<ReviewEntity>, String>((ref, landlordId) {
  return FirebaseFirestore.instance
      .collection('reviews')
      .where('landlordId', isEqualTo: landlordId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()).toEntity())
          .toList());
});