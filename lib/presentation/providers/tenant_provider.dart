import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/tenant_model.dart';
import '../../../data/models/rental_application_model.dart';
import '../../data/datasources/remote/tenant_service.dart';

final tenantServiceProvider = Provider<TenantService>((ref) => TenantService());

final landlordTenantsProvider = FutureProvider.family<List<TenantModel>, String>((ref, landlordId) {
  final tenantService = ref.watch(tenantServiceProvider);
  return tenantService.getLandlordTenants(landlordId);
});

final pendingApplicationsProvider = FutureProvider.family<List<RentalApplicationModel>, String>((ref, landlordId) {
  final tenantService = ref.watch(tenantServiceProvider);
  return tenantService.getPendingApplications(landlordId);
});

final overdueTenantsProvider = FutureProvider.family<List<TenantModel>, String>((ref, landlordId) {
  final tenantService = ref.watch(tenantServiceProvider);
  return tenantService.getOverdueTenants(landlordId);
});

final tenantControllerProvider = StateNotifierProvider<TenantController, AsyncValue<void>>((ref) {
  return TenantController(ref.watch(tenantServiceProvider));
});

class TenantController extends StateNotifier<AsyncValue<void>> {
  final TenantService _tenantService;

  TenantController(this._tenantService) : super(const AsyncValue.data(null));

  Future<void> submitApplication(RentalApplicationModel application) async {
    state = const AsyncValue.loading();
    try {
      await _tenantService.submitApplication(application);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> approveApplication(String applicationId, String propertyId) async {
    state = const AsyncValue.loading();
    try {
      await _tenantService.approveApplication(applicationId, propertyId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> recordPayment(String tenantId, PaymentRecord payment) async {
    state = const AsyncValue.loading();
    try {
      await _tenantService.recordPayment(tenantId, payment);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}