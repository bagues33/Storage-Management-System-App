// ignore_for_file: avoid_print

import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:storage_management_app/common/style.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AwesomeNotifications _awesomeNotification = AwesomeNotifications();
  static ReceivePort? receivePort;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//TODO: method untuk inisialisasi Push notification with local notification 
  Future initialize() async {
    var tokenFCM = await _firebaseMessaging.getToken();
    print('Token FCM : $tokenFCM');
    FirebaseMessaging.onBackgroundMessage(
        (message) => _firebaseMessageBackground(message));

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await _localNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((message) {
      showNotification(
          message.notification!.title ?? '', message.notification!.body ?? '');
    });
  }

//TODO: method untuk inisialisasi Push notification with awesome notification
  Future initializeAwesome() async {
    var tokenFCM = await _firebaseMessaging.getToken();
    print('Token FCM : $tokenFCM');
    await _awesomeNotification.initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'notif',
              channelName: 'Notif',
              channelDescription: 'Test Notification with Image',
              defaultColor: blueColor)
        ],
        debug: true);
    FirebaseMessaging.onMessage.listen((message) {
      showNotificationPicture(message.notification!.title ?? '',
          message.notification!.body ?? '', '');
    });
  }

//TODO: method untuk background service
  Future<void> _firebaseMessageBackground(RemoteMessage message) async {
    showNotification(
        message.notification!.title ?? '', message.notification!.body ?? '');
  }

//TODO: method untuk menampilkan notification wtih local notification
  void showNotification(String title, String body) {
    var androidPlatformChannel = const AndroidNotificationDetails(
        'channel_id_1', 'channel_name',
        importance: Importance.high);
    var platformChannel = NotificationDetails(android: androidPlatformChannel);
    _localNotificationsPlugin.show(0, title, body, platformChannel);
  }

//TODO: method untuk menampilkan notification wtih awesome notification and image
  void showNotificationPicture(String title, String body, String picture) {
    _awesomeNotification.createNotification(
        content: NotificationContent(
      id: -1,
      channelKey: 'notif',
      title: title,
      body: body,
      bigPicture: 'https://www.shutterstock.com/image-vector/88-3d-flash-sale-banner-260nw-2176913847.jpg',
      notificationLayout: NotificationLayout.BigPicture,
    ));
  }
}
