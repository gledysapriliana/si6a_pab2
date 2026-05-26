// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Catatan Saya';

  @override
  String get subscribeTooltip => 'Langganan Topik';

  @override
  String get copyFcmToken => 'Salin Token FCM';

  @override
  String get fcmTokenCopied => 'Token FCM disalin ke clipboard';

  @override
  String get noteAdded => 'Note berhasil ditambahkan';

  @override
  String noteAddFailed(String error) {
    return 'Gagal menambahkan note: $error';
  }

  @override
  String get noteUpdated => 'Note berhasil diupdate';

  @override
  String noteUpdateFailed(String error) {
    return 'Gagal mengupdate note: $error';
  }

  @override
  String get deleteNote => 'Hapus Note';

  @override
  String deleteConfirm(String title) {
    return 'Apakah Anda yakin ingin menghapus \"$title\"?';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get noteDeleted => 'Note berhasil dihapus';

  @override
  String noteDeleteFailed(String error) {
    return 'Gagal menghapus note: $error';
  }

  @override
  String get errorOccurred => 'Terjadi kesalahan';

  @override
  String get noNotes => 'Belum ada catatan';

  @override
  String get addNoteHint => 'Tekan tombol + untuk menambahkan catatan';

  @override
  String get addNote => 'Tambah Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get titleLabel => 'Judul';

  @override
  String get titleEmpty => 'Judul tidak boleh kosong';

  @override
  String get descriptionLabel => 'Deskripsi';

  @override
  String get descriptionEmpty => 'Deskripsi tidak boleh kosong';

  @override
  String pickImageFailed(String error) {
    return 'Gagal memilih gambar: $error';
  }

  @override
  String get tapToAddImage => 'Ketuk untuk menambah gambar';

  @override
  String get changeImage => 'Ganti Gambar';

  @override
  String get save => 'Simpan';

  @override
  String get add => 'Tambah';

  @override
  String get subscribeScreenTitle => 'Langganan Topik';

  @override
  String get customTopicTitle => 'Tambah Topik Kustom';

  @override
  String get customTopicHint => 'Misal: hiburan, game';

  @override
  String get subscribe => 'Langganan';

  @override
  String get suggestedTopics => 'Saran Topik';

  @override
  String get otherTopics => 'Topik Lainnya';

  @override
  String unsubscribedFromTopic(String topic) {
    return 'Berhenti berlangganan dari topik: $topic';
  }

  @override
  String subscribedToTopic(String topic) {
    return 'Berhasil berlangganan ke topik: $topic';
  }

  @override
  String alreadySubscribed(String topic) {
    return 'Sudah berlangganan ke topik: $topic';
  }

  @override
  String get language => 'Bahasa';

  @override
  String get languageEnglish => 'Inggris';

  @override
  String get languageIndonesian => 'Indonesia';
}
