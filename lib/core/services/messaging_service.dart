import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint("Handling a background message: ${message.messageId}");
  debugPrint('Got a message whilst in the Background!');
  debugPrint('Message data: ${message.notification?.toMap()}');
}

class MessagingService {
  static final MessagingService _singleton = MessagingService._internal();

  factory MessagingService() {
    return _singleton;
  }

  MessagingService._internal();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'All Notifications',
    'All Notifications',
    playSound: true,
    showBadge: true,
    enableLights: true,
    enableVibration: true,
    ledColor: lPrimaryColor,
    importance: Importance.high,
    description: 'This channel is used for all notifications.',
  );

  Future requestPushNotification() async {
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      provisional: false,
      announcement: false,
      criticalAlert: false,
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
              'Message also contained a notification: ${message.notification?.toMap()}');

          RemoteNotification notification = message.notification!;

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                playSound: true,
                enableLights: true,
                color: lPrimaryColor,
                enableVibration: true,
                importance: Importance.high,
                icon: '@mipmap/ic_launcher',
                channelDescription: channel.description,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
          );
        }
      },
    );

    final String? token = await FirebaseMessaging.instance.getToken();
    log("token: $token");
  }
}
