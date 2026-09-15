import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LocaleNotifier — manages the app's current locale and persists it.
// Reads/writes to SharedPreferences so the choice survives app restarts.
// ─────────────────────────────────────────────────────────────────────────────
class LocaleNotifier extends Notifier<Locale> {
  static const _prefKey = 'locale_language_code';

  @override
  Locale build() {
    // Start with English; _loadSaved will update after SharedPreferences reads.
    _loadSaved();
    return const Locale('en');
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey) ?? 'en';
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
    state = locale;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
