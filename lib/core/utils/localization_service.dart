import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';

@injectable
class LocalizationService {
  static Map<String, String> _localizedStrings = {};
  static String _currentLanguage = AppConstants.defaultLanguage;

  Future<void> load(String languageCode) async {
    _currentLanguage = languageCode;
    final jsonString = await rootBundle.loadString(
      'assets/i18n/$languageCode.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String get currentLanguage => _currentLanguage;

  static Future<void> loadStatic(String languageCode) async {
    _currentLanguage = languageCode;
    final jsonString = await rootBundle.loadString(
      'assets/i18n/$languageCode.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  static String translateStatic(String key) {
    return _localizedStrings[key] ?? key;
  }

  static String get currentLanguageStatic => _currentLanguage;
}

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, String>((ref) {
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
    await LocalizationService.loadStatic(languageCode);
  }
}

extension StringExtension on String {
  String get tr => LocalizationService.translateStatic(this);
}
