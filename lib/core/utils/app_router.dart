import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabo/domain/entities/review_entity.dart';
import 'package:kaabo/presentation/pages/auth/login_view.dart';
import 'package:kaabo/presentation/pages/auth/signup_view.dart';
import 'package:kaabo/presentation/pages/home/home_view.dart';
import 'package:kaabo/presentation/pages/landlord/landlord_dashboard_view.dart';
import 'package:kaabo/presentation/pages/property/add_property_view.dart';
import 'package:kaabo/presentation/pages/property/property_detail_view.dart';
import 'package:kaabo/presentation/pages/property/property_list_view.dart';
import 'package:kaabo/presentation/pages/review_page.dart';
import 'package:kaabo/presentation/pages/tenant/apply_property_view.dart';
import 'package:kaabo/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeView()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
      GoRoute(
        path: '/properties',
        builder: (context, state) => const PropertyListView(),
      ),
      GoRoute(
        path: '/property/:id',
        builder:
            (context, state) =>
                PropertyDetailView(propertyId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/add-property',
        builder: (context, state) => const AddPropertyView(),
      ),
      GoRoute(
        path: '/landlord-dashboard',
        builder: (context, state) => const LandlordDashboardView(),
      ),
      GoRoute(
        path: '/apply-property/:propertyId/:landlordId',
        builder:
            (context, state) => ApplyPropertyView(
              propertyId: state.pathParameters['propertyId']!,
              landlordId: state.pathParameters['landlordId']!,
            ),
      ),
      GoRoute(
        path: '/review/:propertyId/:landlordId/:type',
        builder:
            (context, state) => ReviewPage(
              propertyId: state.pathParameters['propertyId']!,
              landlordId: state.pathParameters['landlordId'],
              reviewType:
                  state.pathParameters['type'] == 'property'
                      ? ReviewType.property
                      : ReviewType.landlord,
            ),
      ),
    ],
  );
});
