import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/rental_application_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tenant_provider.dart';

class ApplyPropertyView extends ConsumerStatefulWidget {
  final String propertyId;
  final String landlordId;

  const ApplyPropertyView({
    super.key,
    required this.propertyId,
    required this.landlordId,
  });

  @override
  ConsumerState<ApplyPropertyView> createState() => _ApplyPropertyViewState();
}

class _ApplyPropertyViewState extends ConsumerState<ApplyPropertyView> {
  final _formKey = GlobalKey<FormState>();
  final _occupationController = TextEditingController();
  final _incomeController = TextEditingController();
  final _employerController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tenantState = ref.watch(tenantControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Property'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Income (₦)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (double.tryParse(value!) == null) return 'Invalid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employerController,
                decoration: const InputDecoration(
                  labelText: 'Employer Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Previous Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emergencyController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pre-screening Benefits',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Verified income and employment'),
                    Text('• Background check included'),
                    Text('• Direct landlord matching'),
                    Text('• No agent fees required'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: tenantState.isLoading ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: tenantState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Application', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final application = RentalApplicationModel(
        id: const Uuid().v4(),
        propertyId: widget.propertyId,
        tenantId: user.id,
        landlordId: widget.landlordId,
        tenantName: user.name,
        tenantEmail: user.email,
        tenantPhone: user.phone,
        occupation: _occupationController.text.trim(),
        monthlyIncome: double.parse(_incomeController.text),
        employerName: _employerController.text.trim(),
        previousAddress: _addressController.text.trim(),
        emergencyContact: _emergencyController.text.trim(),
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now(),
      );

      await ref.read(tenantControllerProvider.notifier).submitApplication(application);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _occupationController.dispose();
    _incomeController.dispose();
    _employerController.dispose();
    _addressController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }
}