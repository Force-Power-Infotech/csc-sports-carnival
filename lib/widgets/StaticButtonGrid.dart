import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/ownerLogin.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/screens/about_screen.dart';
import 'package:rpgl/screens/committee_screen.dart';
import 'package:rpgl/screens/copd_new.dart';
import 'package:rpgl/screens/copd_screen.dart';
import 'package:rpgl/screens/gallery_screen.dart';
import 'package:rpgl/screens/login_screen.dart';
import 'package:rpgl/screens/ownersandteams_screen.dart';
import 'package:rpgl/screens/play_along_screen.dart';
import 'package:rpgl/screens/refereAndMarshal_screen.dart';
import 'package:rpgl/screens/sponsor_screen.dart';
import 'package:rpgl/screens/statistics_webview_screen.dart';

class StaticButtonGrid extends StatefulWidget {
  const StaticButtonGrid({super.key});

  @override
  State<StaticButtonGrid> createState() => _StaticButtonGridState();
}

class _StaticButtonGridState extends State<StaticButtonGrid> {
  String? member_id = '';
  OwnerLoginAPI? ownerLoginAPI;
  List<ButtonConfig> buttons = [];

  @override
  void initState() {
    super.initState();
    readDataLocally();
  }

  readDataLocally() async {
    ownerLoginAPI = await OwnerLoginAPI.readDataLocally();
    if (ownerLoginAPI != null && ownerLoginAPI!.participantData != null) {
      setState(() {
        member_id = ownerLoginAPI!.participantData!.memberId.toString();
        print('memberid----$member_id');
        initializeButtons(); // Initialize buttons after getting member_id
      });
    } else {
      initializeButtons(); // Initialize buttons if member_id is null
      setState(() {});
    }
  }

  void initializeButtons() {
    buttons = [
      ButtonConfig(
        imagePath: 'assets/images/about.png',
        text: 'About',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreen()),
          );
        },
      ),
      ButtonConfig(
        imagePath: 'assets/images/copd.png',
        text: 'COPD',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Copdnew()),
            // MaterialPageRoute(builder: (context) => CopdScreen()),
          );
        },
      ),
      ButtonConfig(
        imagePath: 'assets/images/committee.png',
        text: 'Committee',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommitteeScreen()),
          );
        },
      ),
      ButtonConfig(
        imagePath: 'assets/images/sponsors.png',
        text: 'Sponsors',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SponsorScreen()),
          );
        },
      ),
      ButtonConfig(
        imagePath: 'assets/images/owners_team.png',
        text: 'Captains & Teams',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OwnersAndTeamsScreen()),
          );
        },
      ),
      // ButtonConfig(
      //   imagePath: 'assets/images/statistic.png',
      //   text: 'Statistics',
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => StatisticsWebViewScreen()),
      //     );
      //   },
      // ),
      // ButtonConfig(
      //   imagePath: 'assets/images/refree.png',
      //   text: 'Referee & Marshall',
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => RefereeAndMarshalScreen()),
      //     );
      //   },
      // ),
      ButtonConfig(
        imagePath: 'assets/images/gallery.png',
        text: 'Gallery',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GalleryScreen()),
          );
        },
      ),
      ButtonConfig(
        imagePath: 'assets/images/people.png',
        text: 'Play Along',
        onTap: () async {
          // Fetch the data when the button is clicked
          await readDataLocally();

          // After fetching the data, navigate to the PlayAlongScreen
          if (member_id != null && member_id!.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayAlongScreen(member_id: member_id!),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(
                  isFromLogin: false,
                ),
              ),
            );
          }
        },
      ),
      // ButtonConfig(
      //   imagePath: 'assets/images/gallery.png',
      //   text: 'Scan ME',
      //   onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => GalleryScreen()),
      //   );
      // },
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive font size based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double baseFontSize = 12.0; // Base font size for larger screens
    double fontSize = screenWidth < 360
        ? baseFontSize * 0.8
        : baseFontSize; // Adjust for smaller screens

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0, // Keeps buttons square
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          final button = buttons[index];
          return Card(
            color: Colors.white,
            elevation: 6,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // More rounded corners
            ),
            child: InkWell(
              onTap: button.onTap ??
                  () {}, // Provide a default empty function if onTap is null
              child: Padding(
                padding:
                    const EdgeInsets.all(8.0), // Padding around the content
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: screenWidth * 0.15, // Make icon size responsive
                        height: screenWidth * 0.15,
                        child: Image.asset(
                          button.imagePath,
                          fit: BoxFit.contain,
                          color: AppThemes.getBackground(), // Icon color
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        button.text,
                        style: TextStyle(
                          fontSize: 10, // Use responsive font size
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow
                            .ellipsis, // Ensure text doesn't overflow
                        maxLines: 2, // Limit text to 2 lines if necessary
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonConfig {
  final String imagePath;
  final String text;
  final VoidCallback onTap; // Updated to accept a VoidCallback for onTap

  ButtonConfig({
    required this.imagePath,
    required this.text,
    required this.onTap, // Initialize onTap
  });
}
