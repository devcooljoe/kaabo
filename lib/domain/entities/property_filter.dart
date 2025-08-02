import 'package:equatable/equatable.dart';
import 'property_entity.dart';

class PropertyFilter extends Equatable {
  final String? state;
  final PropertyType? type;
  final double? maxPrice;
  final String? nearestCampus;

  const PropertyFilter({
    this.state,
    this.type,
    this.maxPrice,
    this.nearestCampus,
  });

  @override
  List<Object?> get props => [state, type, maxPrice, nearestCampus];
}