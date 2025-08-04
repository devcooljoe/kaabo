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

/// Developer Information
/// This class contains the developer's identity and contact information
class DeveloperInfo {
  static const String name = 'Joseph Onipede';
  static const String email = 'onipedejoseph2018@gmail.com';
  static const String linkedin = 'https://www.linkedin.com/in/devcooljoe';
  static const String github = 'https://github.com/devcooljoe';
  static const String copyright = 'Open source project by Joseph Onipede';
  static const String projectName = 'Kaabo - Property Rental Platform';

  /// This method is called during app initialization
  static void initialize() {
    log('🚀 $projectName');
    log('👨‍💻 Developed by: $name');
    log('📧 Contact: $email');
    log('🔗 LinkedIn: $linkedin');
    log('📱 GitHub: $github');
    log('⚖️ $copyright');
  }

  /// Returns developer attribution string
  static String getAttribution() {
    return 'Developed by $name ($email)';
  }

  /// Returns full copyright notice
  static String getCopyright() {
    return '$copyright\nDeveloped by $name\nEmail: $email';
  }
}
