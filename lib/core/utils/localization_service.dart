import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

class LocalizationService {
  static Map<String, String> _localizedStrings = {};
  static String _currentLanguage = AppConstants.defaultLanguage;

  static Future<void> load(String languageCode) async {
    _currentLanguage = languageCode;
    final jsonString = await rootBundle.loadString('assets/i18n/$languageCode.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static String get currentLanguage => _currentLanguage;
}

final localizationProvider = StateNotifierProvider<LocalizationNotifier, String>((ref) {
  return LocalizationNotifier();
});

class LocalizationNotifier extends StateNotifier<String> {
  LocalizationNotifier() : super(AppConstants.defaultLanguage) {
    _loadLanguage(AppConstants.defaultLanguage);
  }

  Future<void> changeLanguage(String languageCode) async {
    if (AppConstants.supportedLanguages.contains(languageCode)) {
      await _loadLanguage(languageCode);
      state = languageCode;
    }
  }

  Future<void> _loadLanguage(String languageCode) async {
    await LocalizationService.load(languageCode);
  }
}

extension StringExtension on String {
  String get tr => LocalizationService.translate(this);
}