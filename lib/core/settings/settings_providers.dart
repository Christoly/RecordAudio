import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fourni au démarrage dans main.dart (et dans les tests).
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider non initialisé'),
);

enum AppLanguage { system, fr, en }

Locale? localeFor(AppLanguage language) => switch (language) {
      AppLanguage.system => null,
      AppLanguage.fr => const Locale('fr'),
      AppLanguage.en => const Locale('en'),
    };

final languageProvider =
    NotifierProvider<LanguageNotifier, AppLanguage>(LanguageNotifier.new);

class LanguageNotifier extends Notifier<AppLanguage> {
  static const _key = 'language';

  @override
  AppLanguage build() {
    final stored = ref.watch(sharedPreferencesProvider).getString(_key);
    return AppLanguage.values.firstWhere(
      (l) => l.name == stored,
      orElse: () => AppLanguage.system,
    );
  }

  Future<void> set(AppLanguage language) async {
    state = language;
    await ref.read(sharedPreferencesProvider).setString(_key, language.name);
  }
}