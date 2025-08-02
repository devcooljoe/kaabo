import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:injectable/injectable.dart';

import '../config/cloudinary_config.dart';

@lazySingleton
class CloudinaryService {
  late final CloudinaryPublic _cloudinary;

  CloudinaryService() {
    _cloudinary = CloudinaryPublic(
      CloudinaryConfig.cloudName,
      CloudinaryConfig.uploadPreset,
      cache: false,
    );
  }

  Future<String> uploadImage(File imageFile, String folder) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles,
    String folder,
  ) async {
    final List<String> urls = [];

    for (final file in imageFiles) {
      final url = await uploadImage(file, folder);
      urls.add(url);
    }

    return urls;
  }

  Future<void> deleteImage(String publicId) async {
    throw UnimplementedError(
      'Image deletion requires server-side implementation',
    );
  }
}
