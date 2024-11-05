import 'package:flutter/material.dart';
import 'package:rpgl/screens/match_selection_screen.dart';
import 'package:rpgl/screens/playingsquad_screen.dart';
import 'package:rpgl/screens/squad_screen.dart';

class SportsButtonList extends StatelessWidget {
  final List<Map<String, dynamic>> sports = [
    {"icon": "assets/images/badminton.gif", "name": "Badminton"},
    {"icon": "assets/images/chess.png", "name": "Chess"},
    {"icon": "assets/images/cricket.gif", "name": "Cricket"},
    {"icon": "assets/images/darts.gif", "name": "Darts"},
    {"icon": "assets/images/futsal.gif", "name": "Futsal"},
    {"icon": "assets/images/poker.png", "name": "Poker"},
    {"icon": "assets/images/snooker.png", "name": "Snooker"},
    {"icon": "assets/images/squash.png", "name": "Squash"},
    {"icon": "assets/images/swimming.png", "name": "Swimming"},
    {"icon": "assets/images/tt.png", "name": "Table Tennis"},
    {"icon": "assets/images/triathlon.png", "name": "Triathlon"},
  ];

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to calculate the width of the screen
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate how many buttons can fit in one row based on screen width
    int crossAxisCount =
        screenWidth > 600 ? 4 : 3; // Show 4 buttons in a row on wider screens

    return GridView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling in gridview (to let the parent scroll)
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.85, // Adjusts the height of the items
      ),
      itemCount: sports.length,
      itemBuilder: (BuildContext context, int index) {
        final sport = sports[index];
        return GestureDetector(
          onTap: () {
            // Add your action here
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchSelectionScreen(
                    // builder: (context) => SquadScreen(
                    //   fieldCount: 4,
                    //   teamid: '2',
                    ),
              ),
            );
          },
          child: Card(
            elevation: 6, // Shadow for a floating effect
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            shadowColor: Colors.blueAccent.withOpacity(0.3),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 8), // Adjusted padding
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Ensures the column takes only needed space
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Colors.lightBlueAccent
                        ], // Gradient for avatar background
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding:
                        const EdgeInsets.all(8), // Padding around the image
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: ClipOval(
                        child: Image.asset(
                          sport['icon'],
                          width: 40,
                          height: 40,
                          fit: BoxFit
                              .cover, // Ensures the image covers the space
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      sport['name'],
                      style: const TextStyle(
                        fontSize: 14, // Reduced font size slightly
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis, // Prevents text overflow
                      maxLines: 1, // Limits text to one line
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
