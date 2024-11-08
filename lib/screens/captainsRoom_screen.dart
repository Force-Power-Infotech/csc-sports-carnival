import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/ownerLogin.dart';
import 'package:rpgl/bases/api/showMyTeam.dart';

import 'package:rpgl/screens/home_screen.dart';
import 'package:rpgl/widgets/SportsButtonList.dart';

class CaptainsRoomScreen extends StatefulWidget {
  final String teamId; // This can be a file path or URL
  final String teamImage; // This can be a file path or URL
  final String teamName; // This can be a file path or URL
  final String ownerName; // This can be a file path or URL
  final String ownerid; // This can be a file path or URL
  final String ownerimage; // This can be a file path or URL
  final List<ParticipantDetails>? participantdetails;

  const CaptainsRoomScreen(
      {super.key,
      required this.teamId,
      required this.teamImage,
      required this.teamName,
      required this.ownerName,
      required this.ownerid,
      required this.ownerimage,
      required this.participantdetails});
  @override
  _CaptainsRoomScreenState createState() => _CaptainsRoomScreenState();
}

class _CaptainsRoomScreenState extends State<CaptainsRoomScreen> {
  @override
  Widget build(BuildContext context) {
    void _handleLogout() async {
      // Perform your logout logic here, such as clearing session data

      // Call the function to delete all data from Hive
      await OwnerLoginAPI.deleteAllData();

      // Navigate to the HomeScreen after logout
      Navigator.of(context).pushReplacement(
        _createPageRoute(
            HomeScreen()), // Redirect to the HomeScreen after logout
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: Colors.white), // Three-dot icon
                onSelected: (String result) {
                  if (result == 'logout') {
                    // Handle logout action
                    _handleLogout();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double top = constraints.biggest.height;
                bool isCollapsed = top < 91.0;

                return Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            widget
                                .teamImage, // Replace with your cover photo URL
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: isCollapsed ? 60.0 : top - 60.0,
                      left: 16.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            _createPageRoute(FullScreenImage(
                              imageUrl: widget
                                  .ownerimage, // Replace with participant image URL
                            )),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(widget
                                .ownerimage), // Replace with participant image URL
                          ),
                        ),
                      ),
                    ),
                    if (isCollapsed)
                      Positioned(
                        top: 130.0,
                        left: MediaQuery.of(context).size.width / 2 - 60,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isCollapsed ? 1.0 : 0.0,
                          child: Text(
                            widget.ownerName, // Replace with the person's name
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 80), // Space for profile image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.ownerName, // Replace with the person's name
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        widget.teamName, // Replace with the team name
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                      SportsButtonList(
                          participantdetails: widget
                              .participantdetails), // Add the sports buttons here
                      // Add the sports buttons here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Fetch the team data when the widget is initialized
  }

  // Custom Page Route with transition animation
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: const Text(
          'Profile Image',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1, // Adjust the aspect ratio as needed
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
