import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Enregistreur audio'**
  String get appTitle;

  /// No description provided for @navRecord.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get navRecord;

  /// No description provided for @navLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque'**
  String get navLibrary;

  /// No description provided for @recorderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel enregistrement'**
  String get recorderTitle;

  /// No description provided for @recorderIdle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à enregistrer'**
  String get recorderIdle;

  /// No description provided for @recorderRecording.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement en cours'**
  String get recorderRecording;

  /// No description provided for @recorderPaused.
  ///
  /// In fr, this message translates to:
  /// **'En pause'**
  String get recorderPaused;

  /// No description provided for @actionStart.
  ///
  /// In fr, this message translates to:
  /// **'Démarrer'**
  String get actionStart;

  /// No description provided for @actionPause.
  ///
  /// In fr, this message translates to:
  /// **'Pause'**
  String get actionPause;

  /// No description provided for @actionResume.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get actionResume;

  /// No description provided for @actionStop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter'**
  String get actionStop;

  /// No description provided for @libraryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes enregistrements'**
  String get libraryTitle;

  /// No description provided for @libraryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun enregistrement pour le moment'**
  String get libraryEmpty;

  /// No description provided for @micPermissionRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'accès au microphone est nécessaire pour enregistrer.'**
  String get micPermissionRequired;

  /// No description provided for @recorderSaved.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement sauvegardé'**
  String get recorderSaved;

  /// No description provided for @errorStartFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de démarrer l\'enregistrement.'**
  String get errorStartFailed;

  /// No description provided for @errorStopFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de terminer l\'enregistrement.'**
  String get errorStopFailed;

  /// No description provided for @errorLowStorage.
  ///
  /// In fr, this message translates to:
  /// **'Espace de stockage insuffisant pour enregistrer.'**
  String get errorLowStorage;

  /// No description provided for @errorStorageStopped.
  ///
  /// In fr, this message translates to:
  /// **'Espace de stockage presque plein : l\'enregistrement a été arrêté et sauvegardé.'**
  String get errorStorageStopped;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get navSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get languageSystem;

  /// No description provided for @notifChannelName.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement en cours'**
  String get notifChannelName;

  /// No description provided for @recordingCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun enregistrement} =1{1 enregistrement} other{{count} enregistrements}}'**
  String recordingCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
