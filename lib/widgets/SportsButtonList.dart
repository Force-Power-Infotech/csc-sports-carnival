import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/ownerLogin.dart';
import 'package:rpgl/screens/match_selection_screen.dart';

class SportsButtonList extends StatelessWidget {
  final List<ParticipantDetails>? participantdetails;

  // Constructor to accept participant details
  const SportsButtonList({
    Key? key,
    required this.participantdetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 4 : 3; // Adjusts button layout

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.85,
      ),
      itemCount: participantdetails?.length,
      itemBuilder: (BuildContext context, int index) {
        final sport = participantdetails?[index];

        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MatchSelectionScreen(
            //       participantdetails: participantdetails,
            //     ),
            //   ),
            // );
          },
          child: Card(
            elevation: 6,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.blueAccent.withOpacity(0.3),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: ClipOval(
                        child: Image.network(
                          sport?.sportsLogo ?? '',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      sport?.sportsName ?? 'Sport',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
