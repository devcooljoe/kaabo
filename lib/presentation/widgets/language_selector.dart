import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/localization_service.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(localizationProvider);

    return Column(
      children: AppConstants.supportedLanguages.map((String languageCode) {
        return TextButton(
          onPressed: () {
            ref.read(localizationProvider.notifier).changeLanguage(languageCode);
          },
          child: Row(
            children: [
              Text(_getLanguageName(languageCode)),
              if (currentLanguage == languageCode) ...[
                const Spacer(),
                const Icon(Icons.check, color: Colors.green),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'pcm':
        return 'Pidgin';
      case 'ha':
        return 'Hausa';
      case 'yo':
        return 'Yoruba';
      case 'ig':
        return 'Igbo';
      default:
        return code.toUpperCase();
    }
  }
}
