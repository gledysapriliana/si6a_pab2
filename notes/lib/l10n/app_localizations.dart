import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get appTitle;

  /// No description provided for @subscribeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to Topic'**
  String get subscribeTooltip;

  /// No description provided for @copyFcmToken.
  ///
  /// In en, this message translates to:
  /// **'Copy FCM Token'**
  String get copyFcmToken;

  /// No description provided for @fcmTokenCopied.
  ///
  /// In en, this message translates to:
  /// **'FCM Token copied to clipboard'**
  String get fcmTokenCopied;

  /// No description provided for @noteAdded.
  ///
  /// In en, this message translates to:
  /// **'Note added successfully'**
  String get noteAdded;

  /// No description provided for @noteAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add note: {error}'**
  String noteAddFailed(String error);

  /// No description provided for @noteUpdated.
  ///
  /// In en, this message translates to:
  /// **'Note updated successfully'**
  String get noteUpdated;

  /// No description provided for @noteUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update note: {error}'**
  String noteUpdateFailed(String error);

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete Note'**
  String get deleteNote;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteConfirm(String title);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note deleted successfully'**
  String get noteDeleted;

  /// No description provided for @noteDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete note: {error}'**
  String noteDeleteFailed(String error);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get noNotes;

  /// No description provided for @addNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Press + to add a note'**
  String get addNoteHint;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @titleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title cannot be empty'**
  String get titleEmpty;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Description cannot be empty'**
  String get descriptionEmpty;

  /// No description provided for @pickImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String pickImageFailed(String error);

  /// No description provided for @tapToAddImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to add image'**
  String get tapToAddImage;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @subscribeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to Topic'**
  String get subscribeScreenTitle;

  /// No description provided for @customTopicTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Topic'**
  String get customTopicTitle;

  /// No description provided for @customTopicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g: entertainment, game'**
  String get customTopicHint;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @suggestedTopics.
  ///
  /// In en, this message translates to:
  /// **'Suggested Topics'**
  String get suggestedTopics;

  /// No description provided for @otherTopics.
  ///
  /// In en, this message translates to:
  /// **'Other Topics'**
  String get otherTopics;

  /// No description provided for @unsubscribedFromTopic.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribed from topic: {topic}'**
  String unsubscribedFromTopic(String topic);

  /// No description provided for @subscribedToTopic.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to topic: {topic}'**
  String subscribedToTopic(String topic);

  /// No description provided for @alreadySubscribed.
  ///
  /// In en, this message translates to:
  /// **'Already subscribed to topic: {topic}'**
  String alreadySubscribed(String topic);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageIndonesian;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
