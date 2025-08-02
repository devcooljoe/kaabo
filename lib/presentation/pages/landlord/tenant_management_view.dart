import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/tenant_model.dart';
import '../../../data/models/rental_application_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tenant_provider.dart';

class TenantManagementView extends ConsumerWidget {
  const TenantManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null)
      return const Scaffold(body: Center(child: Text('Please login')));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tenant Management'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Active Tenants'),
              Tab(text: 'Applications'),
              Tab(text: 'Overdue'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ActiveTenantsTab(landlordId: user.id),
            _ApplicationsTab(landlordId: user.id),
            _OverdueTenantsTab(landlordId: user.id),
          ],
        ),
      ),
    );
  }
}

class _ActiveTenantsTab extends ConsumerWidget {
  final String landlordId;

  const _ActiveTenantsTab({required this.landlordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantsAsync = ref.watch(landlordTenantsProvider(landlordId));

    return tenantsAsync.when(
      data:
          (tenants) =>
              tenants.isEmpty
                  ? const Center(child: Text('No active tenants'))
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tenants.length,
                    itemBuilder: (context, index) {
                      final tenant = tenants[index];
                      return _TenantCard(tenant: tenant);
                    },
                  ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

class _ApplicationsTab extends ConsumerWidget {
  final String landlordId;

  const _ApplicationsTab({required this.landlordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(
      pendingApplicationsProvider(landlordId),
    );

    return applicationsAsync.when(
      data:
          (applications) =>
              applications.isEmpty
                  ? const Center(child: Text('No pending applications'))
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final application = applications[index];
                      return _ApplicationCard(application: application);
                    },
                  ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

class _OverdueTenantsTab extends ConsumerWidget {
  final String landlordId;

  const _OverdueTenantsTab({required this.landlordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdueAsync = ref.watch(overdueTenantsProvider(landlordId));

    return overdueAsync.when(
      data:
          (tenants) =>
              tenants.isEmpty
                  ? const Center(child: Text('No overdue tenants'))
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tenants.length,
                    itemBuilder: (context, index) {
                      final tenant = tenants[index];
                      return _OverdueTenantCard(tenant: tenant);
                    },
                  ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

class _TenantCard extends StatelessWidget {
  final TenantModel tenant;

  const _TenantCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(tenant.id.substring(0, 2).toUpperCase()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tenant ${tenant.id.substring(0, 8)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('₦${tenant.monthlyRent.toStringAsFixed(0)}/month'),
                    ],
                  ),
                ),
                _StatusChip(status: tenant.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    'Next Payment',
                    DateFormat('MMM dd, yyyy').format(tenant.nextPaymentDue),
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    'Lease End',
                    DateFormat('MMM dd, yyyy').format(tenant.leaseEnd),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showPaymentHistory(context),
                    child: const Text('Payment History'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _recordPayment(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Record Payment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentHistory(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Payment History'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tenant.paymentHistory.length,
                itemBuilder: (context, index) {
                  final payment = tenant.paymentHistory[index];
                  return ListTile(
                    title: Text('₦${payment.amount.toStringAsFixed(0)}'),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy').format(payment.paidDate),
                    ),
                    trailing: Icon(
                      payment.status == PaymentStatus.paid
                          ? Icons.check_circle
                          : Icons.pending,
                      color:
                          payment.status == PaymentStatus.paid
                              ? Colors.green
                              : Colors.orange,
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _recordPayment(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Record payment feature')));
  }
}

class _ApplicationCard extends ConsumerWidget {
  final RentalApplicationModel application;

  const _ApplicationCard({required this.application});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    application.tenantName.substring(0, 2).toUpperCase(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.tenantName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(application.occupation),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    'Income',
                    '₦${application.monthlyIncome.toStringAsFixed(0)}',
                  ),
                ),
                Expanded(
                  child: _InfoItem('Employer', application.employerName),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showFullApplication(context),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _approveApplication(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFullApplication(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${application.tenantName} - Application'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InfoItem('Email', application.tenantEmail),
                  _InfoItem('Phone', application.tenantPhone),
                  _InfoItem('Previous Address', application.previousAddress),
                  _InfoItem('Emergency Contact', application.emergencyContact),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _approveApplication(BuildContext context, WidgetRef ref) async {
    await ref
        .read(tenantControllerProvider.notifier)
        .approveApplication(application.id, application.propertyId);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Application approved!')));
    }
  }
}

class _OverdueTenantCard extends StatelessWidget {
  final TenantModel tenant;

  const _OverdueTenantCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    final daysPastDue = DateTime.now().difference(tenant.nextPaymentDue).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(tenant.id.substring(0, 2).toUpperCase()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tenant ${tenant.id.substring(0, 8)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$daysPastDue days overdue'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'OVERDUE',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _sendReminder(context),
              icon: const Icon(Icons.notifications),
              label: const Text('Send Reminder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendReminder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Automated reminder sent to tenant'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TenantStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case TenantStatus.active:
        color = Colors.green;
        text = 'ACTIVE';
        break;
      case TenantStatus.overdue:
        color = Colors.red;
        text = 'OVERDUE';
        break;
      case TenantStatus.terminated:
        color = Colors.grey;
        text = 'TERMINATED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
