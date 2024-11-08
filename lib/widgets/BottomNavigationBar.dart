import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/ownerLogin.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/screens/captainsRoom_screen.dart';
import 'package:rpgl/screens/leaderboard_screen.dart';
import 'package:rpgl/screens/leaderboard_webview_screen.dart';
import 'package:rpgl/screens/login_screen.dart';
import 'package:rpgl/screens/ownersRoom_screen.dart';
import 'package:rpgl/screens/result_screen.dart';
import 'package:rpgl/screens/schedule_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final String sponsorImageUrl;

  const CustomBottomNavigationBar({Key? key, required this.sponsorImageUrl})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  String? member_id = '';
  OwnerLoginAPI? ownerLoginAPI;
  // List<ButtonConfig> buttons = [];

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
        // initializeButtons(); // Initialize buttons after getting member_id
      });
    } else {
      // initializeButtons(); // Initialize buttons if member_id is null
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 60.0,
        // margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.transparent, // Make background transparent
          borderRadius: BorderRadius.circular(50),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.3),
          //     blurRadius: 8,
          //     offset: const Offset(0, 3), // Position shadow slightly above
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: AppThemes.getBackground(), // Slightly dark overlay
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNavItem(
                    context,
                    Icons.bar_chart,
                    'Leaderboard',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardWebViewScreen(),
                        // builder: (context) => LeaderboardScreen(
                        //   sponsorImageUrl: widget.sponsorImageUrl,
                        // ),
                      ),
                    ),
                  ),
                  buildNavItem(
                    context,
                    Icons.calendar_month,
                    'Schedule',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleScreen(),
                      ),
                    ),
                  ),
                  buildNavItem(
                    context,
                    Icons.star,
                    'Result',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(),
                      ),
                    ),
                  ),
                  buildNavItem(context, Icons.person, "Captain's Room",
                      () async {
                    // Fetch the data when the button is clicked
                    await readDataLocally();

                    // After fetching the data, navigate to the PlayAlongScreen
                    if (ownerLoginAPI?.participantData?.memberType == 'O') {
                      log('Owner');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CaptainsRoomScreen(
                            teamId:
                                ownerLoginAPI!.participantData?.teamId ?? '',
                            teamImage:
                                ownerLoginAPI!.participantData?.teamImage ?? '',
                            teamName:
                                ownerLoginAPI!.participantData?.teamName ?? '',
                            ownerName:
                                ownerLoginAPI!.participantData?.memberName ??
                                    '',
                            ownerid:
                                ownerLoginAPI!.participantData?.memberId ?? '',
                            ownerimage: ownerLoginAPI!.participantImage ?? '',
                            participantdetails:
                                ownerLoginAPI!.participantDetails,
                          ),
                        ),
                      );
                    } else {
                      log('Not Owner');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(
                            isFromLogin: true,
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
