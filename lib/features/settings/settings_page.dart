import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/settings_providers.dart';
import '../../l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.settingsLanguage, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<AppLanguage>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: AppLanguage.system,
                label: Text(l10n.languageSystem),
              ),
              const ButtonSegment(
                value: AppLanguage.fr,
                label: Text('Français'),
              ),
              const ButtonSegment(
                value: AppLanguage.en,
                label: Text('English'),
              ),
            ],
            selected: {language},
            onSelectionChanged: (s) =>
                ref.read(languageProvider.notifier).set(s.first),
          ),
        ],
      ),
    );
  }
}