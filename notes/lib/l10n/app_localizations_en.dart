// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Notes';

  @override
  String get subscribeTooltip => 'Subscribe to Topic';

  @override
  String get copyFcmToken => 'Copy FCM Token';

  @override
  String get fcmTokenCopied => 'FCM Token copied to clipboard';

  @override
  String get noteAdded => 'Note added successfully';

  @override
  String noteAddFailed(String error) {
    return 'Failed to add note: $error';
  }

  @override
  String get noteUpdated => 'Note updated successfully';

  @override
  String noteUpdateFailed(String error) {
    return 'Failed to update note: $error';
  }

  @override
  String get deleteNote => 'Delete Note';

  @override
  String deleteConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get noteDeleted => 'Note deleted successfully';

  @override
  String noteDeleteFailed(String error) {
    return 'Failed to delete note: $error';
  }

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get noNotes => 'No notes yet';

  @override
  String get addNoteHint => 'Press + to add a note';

  @override
  String get addNote => 'Add Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get titleLabel => 'Title';

  @override
  String get titleEmpty => 'Title cannot be empty';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionEmpty => 'Description cannot be empty';

  @override
  String pickImageFailed(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get tapToAddImage => 'Tap to add image';

  @override
  String get changeImage => 'Change Image';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get subscribeScreenTitle => 'Subscribe to Topic';

  @override
  String get customTopicTitle => 'Add Custom Topic';

  @override
  String get customTopicHint => 'e.g: entertainment, game';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get suggestedTopics => 'Suggested Topics';

  @override
  String get otherTopics => 'Other Topics';

  @override
  String unsubscribedFromTopic(String topic) {
    return 'Unsubscribed from topic: $topic';
  }

  @override
  String subscribedToTopic(String topic) {
    return 'Subscribed to topic: $topic';
  }

  @override
  String alreadySubscribed(String topic) {
    return 'Already subscribed to topic: $topic';
  }

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Indonesian';
}
