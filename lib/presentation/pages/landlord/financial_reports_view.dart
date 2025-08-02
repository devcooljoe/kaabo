import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/tenant_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tenant_provider.dart';

class FinancialReportsView extends ConsumerWidget {
  const FinancialReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please login')));
    }

    final tenantsAsync = ref.watch(landlordTenantsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Reports'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: tenantsAsync.when(
        data:
            (tenants) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCards(tenants),
                  const SizedBox(height: 24),
                  _buildMonthlyIncomeChart(tenants),
                  const SizedBox(height: 24),
                  _buildPaymentStatusBreakdown(tenants),
                  const SizedBox(height: 24),
                  _buildRecentTransactions(tenants),
                ],
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildOverviewCards(List<TenantModel> tenants) {
    final totalMonthlyIncome = tenants.fold<double>(
      0,
      (sum, t) => sum + t.monthlyRent,
    );
    final totalCollected = tenants.fold<double>(0, (sum, tenant) {
      return sum +
          tenant.paymentHistory
              .where((p) => p.status == PaymentStatus.paid)
              .fold<double>(0, (pSum, p) => pSum + p.amount);
    });
    final overdueAmount = tenants
        .where((t) => t.status == TenantStatus.overdue)
        .fold<double>(0, (sum, t) => sum + t.monthlyRent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Monthly Income',
                '₦${totalMonthlyIncome.toStringAsFixed(0)}',
                Icons.trending_up,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Total Collected',
                '₦${totalCollected.toStringAsFixed(0)}',
                Icons.account_balance_wallet,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Overdue Amount',
                '₦${overdueAmount.toStringAsFixed(0)}',
                Icons.warning,
                Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Collection Rate',
                '${totalMonthlyIncome > 0 ? ((totalCollected / (totalCollected + overdueAmount)) * 100).toStringAsFixed(1) : 0}%',
                Icons.pie_chart,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyIncomeChart(List<TenantModel> tenants) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Income Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Income Chart Placeholder'),
                    Text('Integrate with charts_flutter for visualization'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatusBreakdown(List<TenantModel> tenants) {
    final activeTenants =
        tenants.where((t) => t.status == TenantStatus.active).length;
    final overdueTenants =
        tenants.where((t) => t.status == TenantStatus.overdue).length;
    final terminatedTenants =
        tenants.where((t) => t.status == TenantStatus.terminated).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Status Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusRow('Active Tenants', activeTenants, Colors.green),
            const SizedBox(height: 8),
            _buildStatusRow('Overdue Tenants', overdueTenants, Colors.red),
            const SizedBox(height: 8),
            _buildStatusRow(
              'Terminated Tenants',
              terminatedTenants,
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(
          count.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(List<TenantModel> tenants) {
    final allPayments = <PaymentRecord>[];
    for (final tenant in tenants) {
      allPayments.addAll(tenant.paymentHistory);
    }
    allPayments.sort((a, b) => b.paidDate.compareTo(a.paidDate));
    final recentPayments = allPayments.take(10).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 16),
            if (recentPayments.isEmpty)
              const Center(child: Text('No transactions yet'))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentPayments.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final payment = recentPayments[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          payment.status == PaymentStatus.paid
                              ? Colors.green
                              : Colors.orange,
                      child: Icon(
                        payment.status == PaymentStatus.paid
                            ? Icons.check
                            : Icons.pending,
                        color: Colors.white,
                      ),
                    ),
                    title: Text('₦${payment.amount.toStringAsFixed(0)}'),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy').format(payment.paidDate),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            payment.status == PaymentStatus.paid
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        payment.status.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              payment.status == PaymentStatus.paid
                                  ? Colors.green
                                  : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
