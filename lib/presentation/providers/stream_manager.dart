import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'property_stream_provider.dart';
import 'review_stream_provider.dart';
import 'tenant_stream_provider.dart';

class StreamManager {
  static void invalidateAllPropertyStreams(Ref ref) {
    ref.invalidate(propertyStreamProvider);
    ref.invalidate(landlordPropertyStreamProvider);
  }

  static void invalidateAllReviewStreams(Ref ref) {
    ref.invalidate(propertyReviewsStreamProvider);
    ref.invalidate(landlordReviewsStreamProvider);
  }

  static void invalidateAllTenantStreams(Ref ref) {
    ref.invalidate(landlordTenantsStreamProvider);
    ref.invalidate(pendingApplicationsStreamProvider);
    ref.invalidate(overdueTenantsStreamProvider);
  }

  static void invalidateAll(Ref ref) {
    invalidateAllPropertyStreams(ref);
    invalidateAllReviewStreams(ref);
    invalidateAllTenantStreams(ref);
  }
}