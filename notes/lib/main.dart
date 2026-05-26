import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/fcm_service.dart';
import 'firebase_options.dart';
import 'screens/note_list_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Register background handler for FCM
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize FCM service
    await FcmService().initialize();
  } catch (e) {
    debugPrint('Error during Firebase initialization: $e');
  }

  // Read saved locale, default to 'id' (Indonesia)
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('app_locale') ?? 'id';

  runApp(MainApp(initialLocale: Locale(savedLocale)));
}

// Ubah dari StatelessWidget menjadi StatefulWidget
// agar bisa memanggil setState saat bahasa diganti
class MainApp extends StatefulWidget {
  final Locale initialLocale;

  const MainApp({super.key, required this.initialLocale});

  // Static instance supaya bisa dipanggil dari widget mana saja
  static _MainAppState? _instance;

  // Method untuk mengganti bahasa, dipanggil dari widget lain
  static void setLocale(Locale locale) {
    _instance?._setLocale(locale);
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    MainApp._instance = this; // daftarkan instance
  }

  // Ganti bahasa + simpan ke SharedPreferences
  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('app_locale', locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),

      // ↓ Tiga baris ini yang mengaktifkan localization
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: const NoteListScreen(),
    );
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling a background message: ${message.messageId}');

  // If it's a data-only message (no notification object), we manually show it
  if (message.notification == null && message.data.isNotEmpty) {
    final title = message.data['title'] ?? 'Notifikasi Baru';
    final body = message.data['body'] ?? 'Klik untuk melihat detail';

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // We need to re-initialize for the background isolate
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(settings: initSettings);

    await flutterLocalNotificationsPlugin.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
