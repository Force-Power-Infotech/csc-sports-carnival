import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/versioncheck.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/screens/home_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoading = true; // Indicates if the version check is in progress

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    );

    _controller.forward();

    // Call the version check function
    _checkAppVersion();
    _getAppVersion();
  }

  Future<void> _checkAppVersion() async {
    try {
      // Fetch the version data from the API
      VersionCheckAPI versionData = await VersionCheckAPI.versioncheck();

      // Retrieve the current app version
      String currentAppVersion = await _getAppVersion();
      log('currentAppVersion: $currentAppVersion');

      // Compare the versions
      if (currentAppVersion.compareTo(versionData.currentAppVersion!) < 0) {
        // Show update dialog if the API version is newer than the current app version
        _showUpdateDialog();
      } else {
        // Proceed to the home screen if versions match or current app version is newer
        _goToHomeScreen();
      }
    } catch (e) {
      // Handle any errors (e.g., network issues)
      print("Error checking app version: $e");
      _goToHomeScreen();
    } finally {
      setState(() {
        _isLoading = false; // Update loading status
      });
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Update icon
                Icon(
                  Icons.system_update,
                  size: 60,
                  color: AppThemes.getBackground(),
                ),
                const SizedBox(height: 20),

                // Dialog Title
                const Text(
                  "Update Available",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // Dialog Content
                const Text(
                  "A new version of the app is available. Please update to continue for the best experience.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Later Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        _goToHomeScreen(); // Continue without updating
                      },
                      child: const Text("Later"),
                    ),

                    // Update Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppThemes.getBackground(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        const url =
                            "https://play.google.com/store/apps/details?id=com.forcepower.cscsportscarnival&pli=1";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print("Could not launch $url");
                        }
                      },
                      child: const Text("Update"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  void _goToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // White overlay
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          // Logo with animation
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/images/csc.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
          // Loading indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
