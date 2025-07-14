import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

// Foreground message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
  print('Handling a foreground message: ${message.messageId}');

  // Local notification göster
  await NotificationService.instance.showLocalNotification(
    id: message.hashCode,
    title: message.notification?.title ?? 'Yeni Mesaj',
    body: message.notification?.body ?? '',
    payload: json.encode(message.data),
  );
}

// Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');

  // Background'da local notification göster
  await NotificationService.instance.showLocalNotification(
    id: message.hashCode,
    title: message.notification?.title ?? 'Yeni Mesaj',
    body: message.notification?.body ?? '',
    payload: json.encode(message.data),
  );
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Notification kanalları
  static const String _defaultChannelId = 'default_channel';
  static const String _chatChannelId = 'chat_channel';
  static const String _eventChannelId = 'event_channel';

  // Notification ID'leri
  static const int _chatNotificationId = 1000;
  static const int _eventNotificationId = 2000;

  // Stream controllers
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<Map<String, dynamic>> _dataStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>>
      _foregroundNotificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Streams
  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  Stream<Map<String, dynamic>> get dataStream => _dataStreamController.stream;

  Stream<Map<String, dynamic>> get foregroundNotificationStream =>
      _foregroundNotificationController.stream;

  /// Returns whether notifications are enabled (authorized) for this app
  Future<bool> get notificationsEnabled async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Initialization
  Future<void> initialize() async {
    try {
      print('NotificationService: Initializing...');

      // Firebase Messaging izinleri
      await _requestPermissions();

      // Local notifications setup
      await _setupLocalNotifications();

      // Firebase Messaging handlers
      await _setupFirebaseMessaging();

      // Token'ı al ve kaydet
      await _getAndSaveToken();

      print('NotificationService: Initialized successfully');
    } catch (e) {
      print('NotificationService: Initialization error: $e');
    }
  }

  // İzinleri iste
  Future<void> _requestPermissions() async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print(
          'NotificationService: Permission status: ${settings.authorizationStatus}');
    } catch (e) {
      print('NotificationService: Permission request error: $e');
    }
  }

  // Local notifications setup
  Future<void> _setupLocalNotifications() async {
    try {
      // Android initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // General initialization
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Notification kanalları oluştur
      await _createNotificationChannels();

      print('NotificationService: Local notifications setup completed');
    } catch (e) {
      print('NotificationService: Local notifications setup error: $e');
    }
  }

  // Notification kanalları oluştur
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      // Default kanal
      const AndroidNotificationChannel defaultChannel =
          AndroidNotificationChannel(
        _defaultChannelId,
        'Genel Bildirimler',
        description: 'Genel uygulama bildirimleri',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      // Chat kanalı
      const AndroidNotificationChannel chatChannel = AndroidNotificationChannel(
        _chatChannelId,
        'Chat Bildirimleri',
        description: 'Mesajlaşma bildirimleri',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('chat_notification'),
      );

      // Event kanalı
      const AndroidNotificationChannel eventChannel =
          AndroidNotificationChannel(
        _eventChannelId,
        'Etkinlik Bildirimleri',
        description: 'Etkinlik ve konser bildirimleri',
        importance: Importance.low,
        playSound: true,
        enableVibration: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(defaultChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(chatChannel);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(eventChannel);
    }
  }

  // Firebase Messaging setup
  Future<void> _setupFirebaseMessaging() async {
    try {
      // Foreground handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Background handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // App opened from notification
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);

      // Initial notification (app closed)
      RemoteMessage? initialMessage =
          await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationOpened(initialMessage);
      }

      print('NotificationService: Firebase messaging setup completed');
    } catch (e) {
      print('NotificationService: Firebase messaging setup error: $e');
    }
  }

  // Foreground message handler
  void _handleForegroundMessage(RemoteMessage message) {
    print(
        'NotificationService: Foreground message received: ${message.messageId}');

    _messageStreamController.add(message);

    if (message.data.isNotEmpty) {
      _dataStreamController.add(Map<String, dynamic>.from(message.data));
    }

    // Foreground notification stream'e gönder
    final notificationData = {
      'title': message.notification?.title ?? 'Yeni Mesaj',
      'body': message.notification?.body ?? '',
      'type': message.data['type'] ?? 'general',
      'data': message.data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    _foregroundNotificationController.add(notificationData);

    // Local notification göster (sadece background'da)
    // showLocalNotification(
    //   id: message.hashCode,
    //   title: message.notification?.title ?? 'Yeni Mesaj',
    //   body: message.notification?.body ?? '',
    //   payload: json.encode(message.data),
    //   channelId: _getChannelId(message),
    // );
  }

  // Notification opened handler
  void _handleNotificationOpened(RemoteMessage message) {
    print('NotificationService: Notification opened: ${message.messageId}');

    _messageStreamController.add(message);

    if (message.data.isNotEmpty) {
      _dataStreamController.add(Map<String, dynamic>.from(message.data));
    }
  }

  // Local notification tapped handler
  void _onNotificationTapped(NotificationResponse response) {
    print(
        'NotificationService: Local notification tapped: ${response.payload}');

    if (response.payload != null) {
      try {
        final data = json.decode(response.payload!) as Map<String, dynamic>;
        _dataStreamController.add(data);
      } catch (e) {
        print('NotificationService: Payload parse error: $e');
      }
    }
  }

  // Token al ve kaydet
  Future<void> _getAndSaveToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('NotificationService: FCM Token: $token');
        // Token'ı backend'e gönder veya local storage'a kaydet
        await _saveTokenToStorage(token);
      }

      // Token refresh listener
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('NotificationService: Token refreshed: $newToken');
        _saveTokenToStorage(newToken);
      });
      unawaited(sendTokenToServer(token));
    } catch (e) {
      print('NotificationService: Token error: $e');
    }
  }

  // Token'ı storage'a kaydet
  Future<void> _saveTokenToStorage(String token) async {
    // SharedPreferences veya başka bir storage kullan
    // Örnek: await SharedPreferences.getInstance().then((prefs) => prefs.setString('fcm_token', token));
    print('NotificationService: Token saved to storage: $token');
  }

  // Topic'e abone ol
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('NotificationService: Subscribed to topic: $topic');
    } catch (e) {
      print('NotificationService: Topic subscription error: $e');
    }
  }

  // Topic'ten çık
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('NotificationService: Unsubscribed from topic: $topic');
    } catch (e) {
      print('NotificationService: Topic unsubscription error: $e');
    }
  }

  // Local notification göster
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = _defaultChannelId,
    String? imageUrl,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        _defaultChannelId,
        'Genel Bildirimler',
        channelDescription: 'Genel uygulama bildirimleri',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      print('NotificationService: Local notification shown: $title');
    } catch (e) {
      print('NotificationService: Local notification error: $e');
    }
  }

  // Chat notification göster
  Future<void> showChatNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        _chatChannelId,
        'Chat Bildirimleri',
        channelDescription: 'Mesajlaşma bildirimleri',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('chat_notification'),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      print('NotificationService: Chat notification shown: $title');
    } catch (e) {
      print('NotificationService: Chat notification error: $e');
    }
  }

  // Event notification göster
  Future<void> showEventNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        _eventChannelId,
        'Etkinlik Bildirimleri',
        channelDescription: 'Etkinlik ve konser bildirimleri',
        importance: Importance.low,
        priority: Priority.low,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      print('NotificationService: Event notification shown: $title');
    } catch (e) {
      print('NotificationService: Event notification error: $e');
    }
  }

  // Notification'ları temizle
  Future<void> clearAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      print('NotificationService: All notifications cleared');
    } catch (e) {
      print('NotificationService: Clear notifications error: $e');
    }
  }

  // Belirli notification'ı temizle
  Future<void> clearNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
      print('NotificationService: Notification cleared: $id');
    } catch (e) {
      print('NotificationService: Clear notification error: $e');
    }
  }

  // Channel ID'yi belirle
  String _getChannelId(RemoteMessage message) {
    // Message data'sına göre channel belirle
    if (message.data.containsKey('type')) {
      switch (message.data['type']) {
        case 'chat':
          return _chatChannelId;
        case 'event':
          return _eventChannelId;
        default:
          return _defaultChannelId;
      }
    }
    return _defaultChannelId;
  }

  // Manuel notification gönder (test için)
  void sendManualNotification({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
  }) {
    final notificationData = {
      'title': title,
      'body': body,
      'type': type,
      'data': data ?? {},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    _foregroundNotificationController.add(notificationData);
    print('NotificationService: Manual notification sent: $title');
  }

  // Dispose
  void dispose() {
    _messageStreamController.close();
    _dataStreamController.close();
    _foregroundNotificationController.close();
  }

  Future<void> sendTokenToServer(String? token) async {
    try {
      final set = FirebaseFirestore.instance
          .collection('fcmTokens')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token});
      await set.then((value) {
        print('NotificationService: FCM Token sending to Firestore: $token');
      });
    } catch (e) {
      print('NotificationService: Sending FCM Token to Firestore error: $e');
      rethrow;
    }
  }
}
