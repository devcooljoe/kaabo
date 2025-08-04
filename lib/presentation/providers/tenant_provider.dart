import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaabo/core/di/injection.dart';

import '../../../data/models/rental_application_model.dart';
import '../../../data/models/tenant_model.dart';
import '../../data/datasources/remote/tenant_service.dart';

final tenantServiceProvider = Provider<TenantService>(
  (ref) => getIt<TenantService>(),
);

final landlordTenantsProvider =
    FutureProvider.family<List<TenantModel>, String>((ref, landlordId) {
      final tenantService = ref.watch(tenantServiceProvider);
      return tenantService.getLandlordTenants(landlordId);
    });

final pendingApplicationsProvider =
    FutureProvider.family<List<RentalApplicationModel>, String>((
      ref,
      landlordId,
    ) {
      final tenantService = ref.watch(tenantServiceProvider);
      return tenantService.getPendingApplications(landlordId);
    });

final overdueTenantsProvider = FutureProvider.family<List<TenantModel>, String>(
  (ref, landlordId) {
    final tenantService = ref.watch(tenantServiceProvider);
    return tenantService.getOverdueTenants(landlordId);
  },
);

final tenantControllerProvider =
    StateNotifierProvider<TenantController, AsyncValue<void>>((ref) {
      return TenantController(ref.watch(tenantServiceProvider), ref);
    });

class TenantController extends StateNotifier<AsyncValue<void>> {
  final TenantService _tenantService;
  final Ref _ref;

  TenantController(this._tenantService, this._ref) : super(const AsyncValue.data(null));

  Future<void> submitApplication(RentalApplicationModel application) async {
    state = const AsyncValue.loading();
    try {
      await _tenantService.submitApplication(application);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> approveApplication(
    String applicationId,
    String propertyId,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _tenantService.approveApplication(applicationId, propertyId);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> recordPayment(String tenantId, PaymentRecord payment) async {
    state = const AsyncValue.loading();
    try {
      await _tenantService.recordPayment(tenantId, payment);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void _invalidateProviders() {
    _ref.invalidate(landlordTenantsProvider);
    _ref.invalidate(pendingApplicationsProvider);
    _ref.invalidate(overdueTenantsProvider);
  }
}
