import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabo/data/models/property_model.dart';
import 'package:kaabo/domain/entities/property_entity.dart';
import 'package:kaabo/domain/entities/review_entity.dart';
import 'package:kaabo/presentation/pages/review_page.dart';
import 'package:kaabo/presentation/providers/property_provider.dart';
import 'package:kaabo/presentation/widgets/rating_widget.dart';
import 'package:kaabo/presentation/widgets/reviews_list_widget.dart';

class PropertyDetailView extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyProvider(propertyId));

    return propertyAsync.when(
      data:
          (property) =>
              property == null
                  ? Scaffold(
                    appBar: AppBar(title: Text('Property Not Found')),
                    body: Center(child: Text('Property not found')),
                  )
                  : _buildPropertyDetail(context, ref, property.toEntity()),
      loading:
          () => Scaffold(
            appBar: AppBar(title: Text('Loading...')),
            body: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stack) => Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('Error: $error')),
          ),
    );
  }

  Widget _buildPropertyDetail(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey.shade300,
              child:
                  property.images.isNotEmpty
                      ? Image.network(
                        property.images.first,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const Icon(Icons.home, size: 100),
                      )
                      : const Icon(Icons.home, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${property.location}, ${property.city}, ${property.state}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '₦${property.price.toStringAsFixed(0)}/month',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildInfoChip(
                          Icons.bed,
                          '${property.bedrooms} Bedrooms',
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.bathroom,
                          '${property.bathrooms} Bathrooms',
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.home,
                          property.type.name.toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Amenities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        property.amenities.map((amenity) {
                          return Chip(
                            label: Text(amenity),
                            backgroundColor: Colors.green.shade50,
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 24),
                  if (property.averageRating > 0)
                    RatingWidget(
                      rating: property.averageRating,
                      reviewCount: property.reviewCount,
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ReviewPage(
                                        propertyId: property.id,
                                        landlordId: property.landlordId,
                                        reviewType: ReviewType.property,
                                      ),
                                ),
                              ),
                          child: const Text('Write Review'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showContactDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Contact'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () => _applyForProperty(context, property),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Apply Now',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Reviews',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ReviewsListWidget(
                    propertyId: property.id,
                    landlordId: property.landlordId,
                    reviewType: ReviewType.property,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Contact Landlord'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Phone: +234 123 456 7890'),
                SizedBox(height: 8),
                Text('Email: landlord@example.com'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _applyForProperty(BuildContext context, PropertyEntity property) {
    // Navigate to application form
    context.push('/apply-property/${property.id}/${property.landlordId}');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Application feature - Connect to apply_property_view'),
    //     backgroundColor: Colors.green,
    //   ),
    // );
  }
}
