// lib/l10n/l10n.dart
import 'package:flutter/material.dart';

class L10n {
  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static const String defaultLocale = 'ar';

  static bool isRtl(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  static String of(BuildContext context, String key) {
    // Simple localization without code generation
    // Fallback to Arabic
    return key;
  }
}
