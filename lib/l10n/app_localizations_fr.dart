// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Enregistreur audio';

  @override
  String get navRecord => 'Enregistrer';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get recorderTitle => 'Nouvel enregistrement';

  @override
  String get recorderIdle => 'Prêt à enregistrer';

  @override
  String get recorderRecording => 'Enregistrement en cours';

  @override
  String get recorderPaused => 'En pause';

  @override
  String get actionStart => 'Démarrer';

  @override
  String get actionPause => 'Pause';

  @override
  String get actionResume => 'Reprendre';

  @override
  String get actionStop => 'Arrêter';

  @override
  String get libraryTitle => 'Mes enregistrements';

  @override
  String get libraryEmpty => 'Aucun enregistrement pour le moment';

  @override
  String get micPermissionRequired =>
      'L\'accès au microphone est nécessaire pour enregistrer.';

  @override
  String get recorderSaved => 'Enregistrement sauvegardé';

  @override
  String get errorStartFailed => 'Impossible de démarrer l\'enregistrement.';

  @override
  String get errorStopFailed => 'Impossible de terminer l\'enregistrement.';

  @override
  String get errorLowStorage =>
      'Espace de stockage insuffisant pour enregistrer.';

  @override
  String get errorStorageStopped =>
      'Espace de stockage presque plein : l\'enregistrement a été arrêté et sauvegardé.';

  @override
  String get navSettings => 'Réglages';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get languageSystem => 'Système';

  @override
  String get notifChannelName => 'Enregistrement en cours';

  @override
  String recordingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enregistrements',
      one: '1 enregistrement',
      zero: 'Aucun enregistrement',
    );
    return '$_temp0';
  }
}
