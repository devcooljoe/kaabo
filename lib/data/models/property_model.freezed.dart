// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) {
  return _PropertyModel.fromJson(json);
}

/// @nodoc
mixin _$PropertyModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  PropertyType get type => throw _privateConstructorUsedError;
  int get bedrooms => throw _privateConstructorUsedError;
  int get bathrooms => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  String get landlordId => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  LocationModel? get geoLocation => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  String? get nearestCampus => throw _privateConstructorUsedError;
  double get distanceFromCampus => throw _privateConstructorUsedError;

  /// Serializes this PropertyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyModelCopyWith<PropertyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyModelCopyWith<$Res> {
  factory $PropertyModelCopyWith(
    PropertyModel value,
    $Res Function(PropertyModel) then,
  ) = _$PropertyModelCopyWithImpl<$Res, PropertyModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    double price,
    String location,
    String state,
    String city,
    PropertyType type,
    int bedrooms,
    int bathrooms,
    List<String> images,
    List<String> amenities,
    String landlordId,
    bool isAvailable,
    DateTime createdAt,
    LocationModel? geoLocation,
    double averageRating,
    int reviewCount,
    String? nearestCampus,
    double distanceFromCampus,
  });

  $LocationModelCopyWith<$Res>? get geoLocation;
}

/// @nodoc
class _$PropertyModelCopyWithImpl<$Res, $Val extends PropertyModel>
    implements $PropertyModelCopyWith<$Res> {
  _$PropertyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? location = null,
    Object? state = null,
    Object? city = null,
    Object? type = null,
    Object? bedrooms = null,
    Object? bathrooms = null,
    Object? images = null,
    Object? amenities = null,
    Object? landlordId = null,
    Object? isAvailable = null,
    Object? createdAt = null,
    Object? geoLocation = freezed,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? nearestCampus = freezed,
    Object? distanceFromCampus = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String,
            state:
                null == state
                    ? _value.state
                    : state // ignore: cast_nullable_to_non_nullable
                        as String,
            city:
                null == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as PropertyType,
            bedrooms:
                null == bedrooms
                    ? _value.bedrooms
                    : bedrooms // ignore: cast_nullable_to_non_nullable
                        as int,
            bathrooms:
                null == bathrooms
                    ? _value.bathrooms
                    : bathrooms // ignore: cast_nullable_to_non_nullable
                        as int,
            images:
                null == images
                    ? _value.images
                    : images // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            amenities:
                null == amenities
                    ? _value.amenities
                    : amenities // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            landlordId:
                null == landlordId
                    ? _value.landlordId
                    : landlordId // ignore: cast_nullable_to_non_nullable
                        as String,
            isAvailable:
                null == isAvailable
                    ? _value.isAvailable
                    : isAvailable // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            geoLocation:
                freezed == geoLocation
                    ? _value.geoLocation
                    : geoLocation // ignore: cast_nullable_to_non_nullable
                        as LocationModel?,
            averageRating:
                null == averageRating
                    ? _value.averageRating
                    : averageRating // ignore: cast_nullable_to_non_nullable
                        as double,
            reviewCount:
                null == reviewCount
                    ? _value.reviewCount
                    : reviewCount // ignore: cast_nullable_to_non_nullable
                        as int,
            nearestCampus:
                freezed == nearestCampus
                    ? _value.nearestCampus
                    : nearestCampus // ignore: cast_nullable_to_non_nullable
                        as String?,
            distanceFromCampus:
                null == distanceFromCampus
                    ? _value.distanceFromCampus
                    : distanceFromCampus // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationModelCopyWith<$Res>? get geoLocation {
    if (_value.geoLocation == null) {
      return null;
    }

    return $LocationModelCopyWith<$Res>(_value.geoLocation!, (value) {
      return _then(_value.copyWith(geoLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PropertyModelImplCopyWith<$Res>
    implements $PropertyModelCopyWith<$Res> {
  factory _$$PropertyModelImplCopyWith(
    _$PropertyModelImpl value,
    $Res Function(_$PropertyModelImpl) then,
  ) = __$$PropertyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    double price,
    String location,
    String state,
    String city,
    PropertyType type,
    int bedrooms,
    int bathrooms,
    List<String> images,
    List<String> amenities,
    String landlordId,
    bool isAvailable,
    DateTime createdAt,
    LocationModel? geoLocation,
    double averageRating,
    int reviewCount,
    String? nearestCampus,
    double distanceFromCampus,
  });

  @override
  $LocationModelCopyWith<$Res>? get geoLocation;
}

/// @nodoc
class __$$PropertyModelImplCopyWithImpl<$Res>
    extends _$PropertyModelCopyWithImpl<$Res, _$PropertyModelImpl>
    implements _$$PropertyModelImplCopyWith<$Res> {
  __$$PropertyModelImplCopyWithImpl(
    _$PropertyModelImpl _value,
    $Res Function(_$PropertyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? location = null,
    Object? state = null,
    Object? city = null,
    Object? type = null,
    Object? bedrooms = null,
    Object? bathrooms = null,
    Object? images = null,
    Object? amenities = null,
    Object? landlordId = null,
    Object? isAvailable = null,
    Object? createdAt = null,
    Object? geoLocation = freezed,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? nearestCampus = freezed,
    Object? distanceFromCampus = null,
  }) {
    return _then(
      _$PropertyModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String,
        state:
            null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                    as String,
        city:
            null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as PropertyType,
        bedrooms:
            null == bedrooms
                ? _value.bedrooms
                : bedrooms // ignore: cast_nullable_to_non_nullable
                    as int,
        bathrooms:
            null == bathrooms
                ? _value.bathrooms
                : bathrooms // ignore: cast_nullable_to_non_nullable
                    as int,
        images:
            null == images
                ? _value._images
                : images // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        amenities:
            null == amenities
                ? _value._amenities
                : amenities // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        landlordId:
            null == landlordId
                ? _value.landlordId
                : landlordId // ignore: cast_nullable_to_non_nullable
                    as String,
        isAvailable:
            null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        geoLocation:
            freezed == geoLocation
                ? _value.geoLocation
                : geoLocation // ignore: cast_nullable_to_non_nullable
                    as LocationModel?,
        averageRating:
            null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                    as double,
        reviewCount:
            null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                    as int,
        nearestCampus:
            freezed == nearestCampus
                ? _value.nearestCampus
                : nearestCampus // ignore: cast_nullable_to_non_nullable
                    as String?,
        distanceFromCampus:
            null == distanceFromCampus
                ? _value.distanceFromCampus
                : distanceFromCampus // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyModelImpl implements _PropertyModel {
  const _$PropertyModelImpl({
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
    required final List<String> images,
    required final List<String> amenities,
    required this.landlordId,
    required this.isAvailable,
    required this.createdAt,
    this.geoLocation,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.nearestCampus,
    this.distanceFromCampus = 0.0,
  }) : _images = images,
       _amenities = amenities;

  factory _$PropertyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final double price;
  @override
  final String location;
  @override
  final String state;
  @override
  final String city;
  @override
  final PropertyType type;
  @override
  final int bedrooms;
  @override
  final int bathrooms;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<String> _amenities;
  @override
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  @override
  final String landlordId;
  @override
  final bool isAvailable;
  @override
  final DateTime createdAt;
  @override
  final LocationModel? geoLocation;
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  final String? nearestCampus;
  @override
  @JsonKey()
  final double distanceFromCampus;

  @override
  String toString() {
    return 'PropertyModel(id: $id, title: $title, description: $description, price: $price, location: $location, state: $state, city: $city, type: $type, bedrooms: $bedrooms, bathrooms: $bathrooms, images: $images, amenities: $amenities, landlordId: $landlordId, isAvailable: $isAvailable, createdAt: $createdAt, geoLocation: $geoLocation, averageRating: $averageRating, reviewCount: $reviewCount, nearestCampus: $nearestCampus, distanceFromCampus: $distanceFromCampus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.bedrooms, bedrooms) ||
                other.bedrooms == bedrooms) &&
            (identical(other.bathrooms, bathrooms) ||
                other.bathrooms == bathrooms) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(
              other._amenities,
              _amenities,
            ) &&
            (identical(other.landlordId, landlordId) ||
                other.landlordId == landlordId) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.geoLocation, geoLocation) ||
                other.geoLocation == geoLocation) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.nearestCampus, nearestCampus) ||
                other.nearestCampus == nearestCampus) &&
            (identical(other.distanceFromCampus, distanceFromCampus) ||
                other.distanceFromCampus == distanceFromCampus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
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
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_amenities),
    landlordId,
    isAvailable,
    createdAt,
    geoLocation,
    averageRating,
    reviewCount,
    nearestCampus,
    distanceFromCampus,
  ]);

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyModelImplCopyWith<_$PropertyModelImpl> get copyWith =>
      __$$PropertyModelImplCopyWithImpl<_$PropertyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyModelImplToJson(this);
  }
}

abstract class _PropertyModel implements PropertyModel {
  const factory _PropertyModel({
    required final String id,
    required final String title,
    required final String description,
    required final double price,
    required final String location,
    required final String state,
    required final String city,
    required final PropertyType type,
    required final int bedrooms,
    required final int bathrooms,
    required final List<String> images,
    required final List<String> amenities,
    required final String landlordId,
    required final bool isAvailable,
    required final DateTime createdAt,
    final LocationModel? geoLocation,
    final double averageRating,
    final int reviewCount,
    final String? nearestCampus,
    final double distanceFromCampus,
  }) = _$PropertyModelImpl;

  factory _PropertyModel.fromJson(Map<String, dynamic> json) =
      _$PropertyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  double get price;
  @override
  String get location;
  @override
  String get state;
  @override
  String get city;
  @override
  PropertyType get type;
  @override
  int get bedrooms;
  @override
  int get bathrooms;
  @override
  List<String> get images;
  @override
  List<String> get amenities;
  @override
  String get landlordId;
  @override
  bool get isAvailable;
  @override
  DateTime get createdAt;
  @override
  LocationModel? get geoLocation;
  @override
  double get averageRating;
  @override
  int get reviewCount;
  @override
  String? get nearestCampus;
  @override
  double get distanceFromCampus;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyModelImplCopyWith<_$PropertyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
