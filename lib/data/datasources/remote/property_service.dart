import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kaabo/domain/entities/property_entity.dart';

import '../../../core/config/cloudinary_config.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../../data/models/property_model.dart';

@injectable
class PropertyService {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinaryService;

  PropertyService(this._firestore, this._cloudinaryService);

  Future<List<PropertyModel>> getProperties({
    String? state,
    PropertyType? type,
    double? maxPrice,
  }) async {
    try {
      Query query = _firestore
          .collection('properties')
          .where('isAvailable', isEqualTo: true);

      if (state != null) {
        query = query.where('state', isEqualTo: state);
      }
      if (type != null) {
        query = query.where('type', isEqualTo: type.name);
      }
      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map(
            (doc) => PropertyModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get properties: $e');
    }
  }

  Future<List<PropertyModel>> getLandlordProperties(String landlordId) async {
    try {
      final snapshot =
          await _firestore
              .collection('properties')
              .where('landlordId', isEqualTo: landlordId)
              .get();

      return snapshot.docs
          .map((doc) => PropertyModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get landlord properties: $e');
    }
  }

  Future<void> addProperty(PropertyModel property) async {
    try {
      await _firestore
          .collection('properties')
          .doc(property.id)
          .set(property.toJson());
    } catch (e) {
      throw Exception('Failed to add property: $e');
    }
  }

  Future<void> updateProperty(PropertyModel property) async {
    try {
      await _firestore
          .collection('properties')
          .doc(property.id)
          .update(property.toJson());
    } catch (e) {
      throw Exception('Failed to update property: $e');
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      await _firestore.collection('properties').doc(propertyId).delete();
    } catch (e) {
      throw Exception('Failed to delete property: $e');
    }
  }

  Future<List<String>> uploadPropertyImages(
    List<File> images,
    String propertyId,
  ) async {
    return await _cloudinaryService.uploadMultipleImages(
      images,
      '${CloudinaryConfig.propertyImagesFolder}/$propertyId',
    );
  }

  Future<void> deletePropertyImages(List<String> imageUrls) async {}
}
