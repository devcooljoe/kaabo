import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/utils/app_router.dart';
import 'core/utils/localization_service.dart';
import 'core/utils/notification_service.dart';
import 'core/di/injection.dart';
import 'firebase_options.dart';
import 'presentation/widgets/language_selector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  await NotificationService.initialize();
  await LocalizationService.load('en');
  runApp(const ProviderScope(child: KaaboApp()));
}

class KaaboApp extends ConsumerWidget {
  const KaaboApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Kaabo - Find Your Perfect Home',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: (context, child) {
        return Scaffold(
          body: child,
          endDrawer: const Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  DrawerHeader(child: Text('Settings')),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    trailing: LanguageSelector(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
