import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  /// Request Permission
  Future<void> requestPermission() async {

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }
  }

  /// Get FCM Token
  Future<String?> getToken() async {
    String? token = await _messaging.getToken();
    print("FCM TOKEN: $token");
    return token;
  }

  /// Save Token in Firestore
  Future<void> saveTokenToFirestore() async {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String? token = await getToken();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({
      "fcmToken": token,
    }, SetOptions(merge: true));
  }

  /// Token Refresh Listener
  void tokenRefresh() {

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "fcmToken": newToken
      });

    });
  }


  Future<void> initLocalNotification() async {

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }



  Future<void> showNotification(RemoteMessage message) async {

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'pecan_channel',
      'Pecan Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  /// Foreground Notification
  void foregroundListener() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if (message.notification != null) {
        showNotification(message);
      }

    });
  }

  /// Notification Click (App Opened)
  void onNotificationClick() {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print("Notification Clicked");

      String? siteId = message.data['siteId'];

      if (siteId != null) {
        // Navigate to site detail
        print("Open site: $siteId");
      }

    });
  }

  /// App Killed State
  Future<void> checkInitialMessage() async {

    RemoteMessage? message =
    await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {

      String? siteId = message.data['siteId'];

      print("App opened from killed state");

      if (siteId != null) {
        print("Open site: $siteId");
      }

    }
  }

  /// Complete Setup
  Future<void> setup() async {

    await initLocalNotification();

    await requestPermission();

    await saveTokenToFirestore();

    tokenRefresh();

    foregroundListener();

    onNotificationClick();

    await checkInitialMessage();

  }
////////////////////////////////////

}