import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../providers/review_provider.dart';
import 'financial_reports_view.dart';
import 'tenant_management_view.dart';

class LandlordDashboardView extends ConsumerWidget {
  const LandlordDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final propertiesAsync =
        user != null ? ref.watch(landlordPropertiesProvider(user.id)) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Landlord Dashboard'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body:
          propertiesAsync?.when(
            data:
                (properties) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Overview',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      'Total Properties',
                                      properties.length.toString(),
                                      Icons.home,
                                      Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildStatCard(
                                      'Available',
                                      properties
                                          .where((p) => p.isAvailable)
                                          .length
                                          .toString(),
                                      Icons.check_circle,
                                      Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      'Rented',
                                      properties
                                          .where((p) => !p.isAvailable)
                                          .length
                                          .toString(),
                                      Icons.key,
                                      Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child:
                                        user != null
                                            ? Consumer(
                                              builder: (context, ref, child) {
                                                final ratingAsync = ref.watch(
                                                  landlordRatingProvider(
                                                    user.id,
                                                  ),
                                                );
                                                return ratingAsync.when(
                                                  data:
                                                      (
                                                        rating,
                                                      ) => _buildStatCard(
                                                        'My Rating',
                                                        '${rating.toStringAsFixed(1)} ⭐',
                                                        Icons.star,
                                                        Colors.orange,
                                                      ),
                                                  loading:
                                                      () => _buildStatCard(
                                                        'My Rating',
                                                        'Loading...',
                                                        Icons.star,
                                                        Colors.orange,
                                                      ),
                                                  error:
                                                      (_, __) => _buildStatCard(
                                                        'My Rating',
                                                        '0.0 ⭐',
                                                        Icons.star,
                                                        Colors.orange,
                                                      ),
                                                );
                                              },
                                            )
                                            : _buildStatCard(
                                              'Total Value',
                                              '₦${properties.fold<double>(0, (sum, p) => sum + p.price).toStringAsFixed(0)}',
                                              Icons.attach_money,
                                              Colors.purple,
                                            ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildQuickActions(context),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Properties',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/add-property'),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Property'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (properties.isEmpty)
                        const Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.home_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No properties yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add your first property to get started',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final property = properties[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child:
                                      property.images.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              property.images.first,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) =>
                                                      const Icon(Icons.home),
                                            ),
                                          )
                                          : const Icon(Icons.home),
                                ),
                                title: Text(property.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${property.city}, ${property.state}'),
                                    Text(
                                      '₦${property.price.toStringAsFixed(0)}/month',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder:
                                      (context) => [
                                        const PopupMenuItem(
                                          value: 'view',
                                          child: Text('View'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                  onSelected: (value) {
                                    if (value == 'view') {
                                      context.push('/property/${property.id}');
                                    } else if (value == 'delete') {
                                      _showDeleteDialog(
                                        context,
                                        ref,
                                        property.id,
                                      );
                                    }
                                  },
                                ),
                                onTap:
                                    () =>
                                        context.push('/property/${property.id}'),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ) ??
          const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    String propertyId,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Property'),
            content: const Text(
              'Are you sure you want to delete this property?',
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  context.pop();
                  await ref
                      .read(propertyControllerProvider.notifier)
                      .deleteProperty(propertyId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Property deleted successfully'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Manage Tenants',
                'View applications, track payments',
                Icons.people,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TenantManagementView(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                'Financial Reports',
                'Income analytics & insights',
                Icons.analytics,
                Colors.purple,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FinancialReportsView(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
