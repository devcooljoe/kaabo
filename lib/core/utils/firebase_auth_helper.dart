/*
 * Kaabo - Property Rental Platform
 * Open source project by Joseph Onipede (onipedejoseph2018@gmail.com)
 * Developer: Joseph Onipede | Email: onipedejoseph2018@gmail.com
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthHelper {
  static void configureAuth() {
    if (kDebugMode) {
      // Suppress debug warnings in development
      FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );
    }
  }

  static void handleAuthStateChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) print('User is currently signed out!');
      } else {
        if (kDebugMode) print('User is signed in: ${user.uid}');
      }
    });
  }
}
