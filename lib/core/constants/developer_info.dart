/*
 * Kaabo - Enterprise Property Rental Platform
 * Copyright (c) 2025 Joseph Onipede (onipedejoseph2018@gmail.com)
 * 
 * This software is the intellectual property of Joseph Onipede.
 * All rights reserved. Unauthorized copying, modification, distribution,
 * or use of this software is strictly prohibited without explicit
 * written permission from Joseph Onipede.
 * 
 * Developer: Joseph Onipede
 * Email: onipedejoseph2018@gmail.com
 * LinkedIn: https://www.linkedin.com/in/devcooljoe
 * GitHub: https://github.com/devcooljoe
 */

import 'dart:developer';

/// Developer Information - DO NOT REMOVE OR MODIFY
/// This class contains the developer's identity and contact information
/// Removing or modifying this information is a violation of intellectual property rights
class DeveloperInfo {
  static const String name = 'Joseph Onipede';
  static const String email = 'onipedejoseph2018@gmail.com';
  static const String linkedin = 'https://www.linkedin.com/in/devcooljoe';
  static const String github = 'https://github.com/devcooljoe';
  static const String copyright = '© 2025 Joseph Onipede. All rights reserved.';
  static const String projectName =
      'Kaabo - Enterprise Property Rental Platform';

  /// This method must be called during app initialization
  /// DO NOT REMOVE - Required for proper attribution
  static void initialize() {
    log('🚀 $projectName');
    log('👨‍💻 Developed by: $name');
    log('📧 Contact: $email');
    log('🔗 LinkedIn: $linkedin');
    log('📱 GitHub: $github');
    log('⚖️ $copyright');
    log('⚠️ Unauthorized use is strictly prohibited');
  }

  /// Returns developer attribution string
  /// DO NOT MODIFY - Used throughout the application
  static String getAttribution() {
    return 'Developed by $name ($email)';
  }

  /// Returns full copyright notice
  /// DO NOT REMOVE - Legal requirement
  static String getCopyright() {
    return '$copyright\nDeveloped by $name\nEmail: $email';
  }
}
