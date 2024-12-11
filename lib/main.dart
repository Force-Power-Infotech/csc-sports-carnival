import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rpgl/bases/api/firebase_api.dart';
import 'package:rpgl/bases/flagcheck.dart';
import 'package:rpgl/screens/about_screen.dart';
import 'package:rpgl/screens/committee_screen.dart';
import 'package:rpgl/screens/home_screen.dart';
import 'package:rpgl/screens/leaderboard_screen.dart';
import 'package:rpgl/screens/splash_screen.dart';
import 'package:rpgl/screens/sponsor_screen.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Correct Hive package

/// Background message handler for Firebase Messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures plugin services are initialized

  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    print('Firebase initialized successfully');

    // Request notification permissions and initialize Firebase Messaging
    await FirebaseAPI().initNotification();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize Hive and open required boxes
    await Hive.initFlutter();
    await Hive.openBox('ownerLoginAPI');
    await Hive.openBox('flag');

    // Check and update the flag value
    bool flagValue = await checkFlagValue();
    if (!flagValue) {
      await Hive.box('ownerLoginAPI').clear();
      await setFlagValue(true);
    }
  } catch (e) {
    print('Error during initialization: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSC Sports Carnival',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          secondary: Colors.white,
          primary: Colors.white,
        ),
        useMaterial3: true,
      ),
      // Set the initial screen to SplashScreen
      home: SplashScreen(),
    );
  }
}
