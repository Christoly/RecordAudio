// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Audio Recorder';

  @override
  String get navRecord => 'Record';

  @override
  String get navLibrary => 'Library';

  @override
  String get recorderTitle => 'New recording';

  @override
  String get recorderIdle => 'Ready to record';

  @override
  String get recorderRecording => 'Recording';

  @override
  String get recorderPaused => 'Paused';

  @override
  String get actionStart => 'Start';

  @override
  String get actionPause => 'Pause';

  @override
  String get actionResume => 'Resume';

  @override
  String get actionStop => 'Stop';

  @override
  String get libraryTitle => 'My recordings';

  @override
  String get libraryEmpty => 'No recordings yet';

  @override
  String get micPermissionRequired =>
      'Microphone access is required to record.';

  @override
  String get recorderSaved => 'Recording saved';

  @override
  String get errorStartFailed => 'Could not start recording.';

  @override
  String get errorStopFailed => 'Could not finish recording.';

  @override
  String get errorLowStorage => 'Not enough storage space to record.';

  @override
  String get errorStorageStopped =>
      'Storage almost full: the recording was stopped and saved.';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get notifChannelName => 'Recording in progress';

  @override
  String recordingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recordings',
      one: '1 recording',
      zero: 'No recordings',
    );
    return '$_temp0';
  }
}
