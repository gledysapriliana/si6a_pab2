import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _baseUrl = 'https://notes-rest-api.vercel.app';
  static const String _topicName = 'notes'; // default topic

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

  /// Initialize FCM and Local Notifications
  Future<void> initialize() async {
    try {
      // 1. Request Permissions with timeout
      NotificationSettings? settings;
      try {
        settings = await _messaging
            .requestPermission(alert: true, badge: true, sound: true)
            .timeout(const Duration(seconds: 10));
      } catch (e) {
        debugPrint('FCM permission request timed out or failed: $e');
      }

      if (settings != null &&
          settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
      } else {
        debugPrint('User declined, timed out, or has not accepted permission');
      }

      // Ensure notifications can appear in the foreground on supported platforms
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 2. Initialize Local Notifications for Foreground (Mobile Only)
      if (!kIsWeb) {
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        const InitializationSettings initializationSettings =
            InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: DarwinInitializationSettings(),
            );

        // Use dynamic to bypass strict compile-time checks on Web
        final dynamic localNotifications = _localNotificationsPlugin;

        await _localNotificationsPlugin.initialize(
          settings: initializationSettings,
          onDidReceiveNotificationResponse: (details) {
            debugPrint('Notification clicked: ${details.payload}');
          },
        );

        // 3. Create Android Notification Channel
        await localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(_androidChannel);

        // 4. Handle Foreground Messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Got a message in the foreground!');
          debugPrint('Message data: ${message.data}');

          RemoteNotification? notification = message.notification;

          if (notification != null) {
            debugPrint(
              'Message also contained a notification: ${notification.title}',
            );

            localNotifications.show(
              id: notification.hashCode,
              title: notification.title,
              body: notification.body,
              notificationDetails: NotificationDetails(
                android: AndroidNotificationDetails(
                  _androidChannel.id,
                  _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@mipmap/ic_launcher', // Use fixed icon for reliability
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
              payload: jsonEncode(message.data),
            );
          } else if (message.data.isNotEmpty) {
            // Handle data-only messages if they contain title/body
            final title = message.data['title'] ?? 'Catatan Baru';
            final body = message.data['body'] ?? 'Cek aplikasi Anda';

            localNotifications.show(
              id: message.hashCode,
              title: title,
              body: body,
              notificationDetails: NotificationDetails(
                android: AndroidNotificationDetails(
                  _androidChannel.id,
                  _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@mipmap/ic_launcher',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
              payload: jsonEncode(message.data),
            );
          }
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          debugPrint('Notification opened: ${message.data}');
        });

        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            debugPrint(
              'App opened from terminated notification: ${message.data}',
            );
          }
        });
      } else {
        // On Web, foreground messages are handled by the browser
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint(
            'Foreground message on web: ${message.notification?.title}',
          );
        });
      }

      // 5. Subscribe to topics (Mobile Only)
      if (!kIsWeb) {
        await _messaging
            .subscribeToTopic(_topicName)
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () =>
                  debugPrint('Subscription to topic $_topicName timed out'),
            );
        await _messaging
            .subscribeToTopic('berita')
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () =>
                  debugPrint('Subscription to topic berita timed out'),
            );
        debugPrint('Subscribed to topics: $_topicName and berita');
      }

      // 6. Get and print token for debugging (with timeout)
      final token = await _messaging.getToken().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('FCM Token request timed out');
          return null;
        },
      );
      if (token != null) {
        debugPrint('FCM Token: $token');
      }
    } catch (e) {
      debugPrint('Error during FcmService initialization: $e');
    }
  }

  /// Show a local notification immediately on the device.
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      await _localNotificationsPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: payload != null ? jsonEncode(payload) : null,
      );
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  /// Send notification via REST API when a note is added
  Future<void> sendNoteNotification({
    required String title,
    required String description,
  }) async {
    try {
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final requestBody = jsonEncode({
        'topic': _topicName,
        'priority': 'high',
        'title': 'Catatan Baru: $title',
        'body': description,
        'notification': {'title': 'Catatan Baru: $title', 'body': description},
        'android': {
          'notification': {'channel_id': _androidChannel.id},
        },
        'data': {
          'senderName': 'User Notes',
          'senderPhoto':
              'https://firebase.google.com/static/images/brand-guidelines/logo-vertical.png',
          'created_at': formattedDate,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'new_note',
        },
      });

      final response = await http.post(
        Uri.parse('$_baseUrl/send-to-topic'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully');
      } else {
        debugPrint(
          'Failed to send notification: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  /// Subscribe to a specific topic
  Future<void> subscribeToTopic(String topic) async {
    if (kIsWeb) {
      debugPrint('Topic subscription is not supported on Web.');
      return;
    }
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Successfully subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from a specific topic
  Future<void> unsubscribeFromTopic(String topic) async {
    if (kIsWeb) {
      debugPrint('Topic unsubscription is not supported on Web.');
      return;
    }
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Successfully unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
    }
  }
}
