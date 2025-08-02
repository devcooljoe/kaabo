import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabo/domain/entities/property_entity.dart';
import 'package:kaabo/domain/entities/user_entity.dart';
import 'package:kaabo/presentation/widgets/campus_filter_widget.dart';
import 'package:kaabo/presentation/widgets/rating_widget.dart';

import '../../../core/utils/localization_service.dart';
import '../../../data/models/property_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../tenant/tenant_dashboard_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final propertiesAsync = ref.watch(propertiesProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          authState.when(
            data:
                (user) =>
                    user != null
                        ? PopupMenuButton(
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  value: 'dashboard',
                                  child: Text('dashboard'.tr),
                                ),
                                PopupMenuItem(
                                  value: 'logout',
                                  child: Text('logout'.tr),
                                ),
                              ],
                          onSelected: (value) {
                            if (value == 'dashboard') {
                              if (user.type == UserType.landlord) {
                                context.go('/landlord-dashboard');
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const TenantDashboardView(),
                                  ),
                                );
                              }
                            } else if (value == 'logout') {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .signOut();
                            }
                          },
                        )
                        : TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            'login'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              children: [
                Text(
                  'find_home'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'no_agent_fees'.tr,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'search_location'.tr,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => context.go('/properties'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                      ),
                      child: Text('search'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: propertiesAsync.when(
              data:
                  (properties) =>
                      properties.isEmpty
                          ? const Center(child: Text('No properties available'))
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount:
                                properties.length > 6 ? 6 : properties.length,
                            itemBuilder: (context, index) {
                              final property = properties[index];
                              return PropertyCard(property: property.toModel());
                            },
                          ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: authState.when(
        data:
            (user) =>
                user?.type == UserType.landlord
                    ? FloatingActionButton(
                      onPressed: () => context.go('/add-property'),
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.add, color: Colors.white),
                    )
                    : null,
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final PropertyModel property;

  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.go('/property/${property.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child:
                  property.images.isNotEmpty
                      ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        child: Image.network(
                          property.images.first,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(Icons.home, size: 50),
                        ),
                      )
                      : const Icon(Icons.home, size: 50),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.city}, ${property.state}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₦${property.price.toStringAsFixed(0)}/month',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (property.averageRating > 0)
                    RatingWidget(
                      rating: property.averageRating,
                      reviewCount: property.reviewCount,
                      size: 14,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.bed, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('${property.bedrooms} bed'),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.bathroom,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text('${property.bathrooms} bath'),
                    ],
                  ),
                  if (property.geoLocation?.nearestCampus != null) ...[
                    const SizedBox(height: 8),
                    CampusProximityChip(
                      campusName: property.geoLocation!.nearestCampus!,
                      distance: property.geoLocation!.distanceToCampus!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
