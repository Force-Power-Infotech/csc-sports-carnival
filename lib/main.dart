import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rpgl/bases/flagcheck.dart';
import 'package:rpgl/screens/about_screen.dart';
import 'package:rpgl/screens/committee_screen.dart';
import 'package:rpgl/screens/home_screen.dart';
import 'package:rpgl/screens/leaderboard_screen.dart';
import 'package:rpgl/screens/splash_screen.dart';
import 'package:rpgl/screens/sponsor_screen.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import the correct Hive package

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that plugin services are initialized before `runApp`

  await Hive.initFlutter(); // Initialize Hive with Flutter support

  await Hive.openBox('ownerLoginAPI'); // Open the Hive box
  await Hive.openBox('flag'); // Open the Hive box
  bool flagValue = await checkFlagValue(); // Check the flag value
  if (!flagValue) {
    // clear ownerLoginAPI box
    await Hive.box('ownerLoginAPI').clear();
    await setFlagValue(true); // Set the flag value
  }
  runApp(const MyApp()); // Run the app
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPGL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            secondary: Colors.white,
            primary: Colors.white),
        useMaterial3: true,
      ),
      // home: SponsorScreen(),
      home: SplashScreen(),
    );
  }
}
