import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/fcm_service.dart';

import 'firebase_options.dart';
import 'screens/note_list_screen.dart';

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
    await flutterLocalNotificationsPlugin.initialize(
      settings: initSettings, // Use named parameter
    );

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Firebase agar seluruh service Firebase dapat digunakan
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Mendaftarkan background handler untuk menangani
    // pesan FCM saat aplikasi berada di background/terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Inisialisasi service FCM dan tunggu agar subscription/topic channel complete
    await FcmService().initialize();
  } catch (e) {
    // Menangkap error saat proses inisialisasi Firebase
    debugPrint('Error during Firebase initialization: $e');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const NoteListScreen(),
    );
  }
}
