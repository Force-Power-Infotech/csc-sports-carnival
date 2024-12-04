import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rpgl/bases/api/tokenStorage.dart';

class FirebaseAPI {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
      return;
    }

    // Get token
    try {
      String? token = await _firebaseMessaging.getToken();
      TokenStorage.fcmToken = token; // Store the token

      print('FCM Token: $token');
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }
}
