/*
 * Kaabo - Property Rental Platform
 * Open source project by Joseph Onipede (onipedejoseph2018@gmail.com)
 * 
 * Developer: Joseph Onipede
 * Email: onipedejoseph2018@gmail.com
 * LinkedIn: https://www.linkedin.com/in/devcooljoe
 * GitHub: https://github.com/devcooljoe
 */

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/developer_info.dart';
import 'core/di/injection.dart';
import 'core/utils/app_router.dart';
import 'core/utils/firebase_auth_helper.dart';
import 'core/utils/localization_service.dart';
import 'firebase_options.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/widgets/language_selector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container();
  };

  // Initialize developer attribution
  DeveloperInfo.initialize();

  await dotenv.load(fileName: ".env");
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log('Firebase initialization failed: $e');
  }

  // Configure Firebase Auth
  FirebaseAuthHelper.configureAuth();
  FirebaseAuthHelper.handleAuthStateChanges();

  configureDependencies();
  // await NotificationService.initialize();
  await LocalizationService.loadStatic('en');
  runApp(const ProviderScope(child: KaaboApp()));
}

class KaaboApp extends ConsumerWidget {
  const KaaboApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '${DeveloperInfo.projectName} - by ${DeveloperInfo.name}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Scaffold(
          body: child,
          endDrawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final user = ref.watch(currentUserProvider);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (user != null) ...[
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : 'U',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ] else
                              const Text('Settings'),
                            const SizedBox(height: 8),
                            Text(
                              DeveloperInfo.getAttribution(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const ExpansionTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: LanguageSelector(),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    onTap: () {
                      Future.microtask(() async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signOut();
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.green),
                    title: const Text('About Developer'),
                    subtitle: Text(DeveloperInfo.name),
                    onTap: () {
                      router.push('/about-developer');
                    },
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
