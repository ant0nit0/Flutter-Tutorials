// utils/ktranslate_preferences.dart
import 'dart:ui';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KTranslatePreferences implements ITranslatePreferences {
  static const String _selectedLocaleKey = 'selected_locale';

  @override
  Future<Locale?> getPreferredLocale() async {
    final preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey(_selectedLocaleKey)) return null;

    final String? locale = preferences.getString(_selectedLocaleKey);

    return locale != null ? localeFromString(locale) : null;
  }

  @override
  Future savePreferredLocale(Locale locale) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_selectedLocaleKey, localeToString(locale));
  }
}
