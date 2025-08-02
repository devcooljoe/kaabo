/*
 * Kaabo - Enterprise Property Rental Platform
 * Copyright (c) 2025 Joseph Onipede (onipedejoseph2018@gmail.com)
 * Developer: Joseph Onipede | Email: onipedejoseph2018@gmail.com
 */

import 'package:equatable/equatable.dart';
import 'package:kaabo/data/models/property_model.dart';

import 'location_entity.dart';

enum PropertyType { apartment, house, duplex, selfContain }

class PropertyEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final String state;
  final String city;
  final PropertyType type;
  final int bedrooms;
  final int bathrooms;
  final List<String> images;
  final List<String> amenities;
  final String landlordId;
  final bool isAvailable;
  final DateTime createdAt;
  final LocationEntity? geoLocation;
  final double averageRating;
  final int reviewCount;
  final String? nearestCampus;
  final double distanceFromCampus;

  const PropertyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.state,
    required this.city,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.images,
    required this.amenities,
    required this.landlordId,
    required this.isAvailable,
    required this.createdAt,
    this.geoLocation,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.nearestCampus,
    this.distanceFromCampus = 0.0,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    location,
    state,
    city,
    type,
    bedrooms,
    bathrooms,
    images,
    amenities,
    landlordId,
    isAvailable,
    createdAt,
    geoLocation,
    averageRating,
    reviewCount,
    nearestCampus,
    distanceFromCampus,
  ];
}

extension PropertyEntityX on PropertyEntity {
  toModel() => PropertyModel(
    id: id,
    title: title,
    description: description,
    price: price,
    location: location,
    state: state,
    city: city,
    type: type,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    images: images,
    amenities: amenities,
    landlordId: landlordId,
    isAvailable: isAvailable,
    createdAt: createdAt,
    geoLocation: geoLocation?.toModel(),
    averageRating: averageRating,
    reviewCount: reviewCount,
    nearestCampus: nearestCampus,
    distanceFromCampus: distanceFromCampus,
  );
}
