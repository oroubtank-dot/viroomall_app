import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static const List<<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static const String defaultLocale = 'ar';

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static bool isRtl(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }
}