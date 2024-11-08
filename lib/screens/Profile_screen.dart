import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rpgl/bases/api/ownerLogin.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.getBackground(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: AppThemes.getBackground(),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: OwnerLoginAPI.readDataLocally(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            // No data found, show login button
            return _buildLoginPrompt(context);
          } else {
            // Data is found, display profile information
            final ownerLoginAPI = snapshot.data;
            return _buildProfileContent(context, ownerLoginAPI!);
          }
        },
      ),
    );
  }

  // Widget to build profile content when data is available
  Widget _buildProfileContent(
      BuildContext context, OwnerLoginAPI ownerLoginAPI) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FA), Color(0xFFEAEFF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      NetworkImage(ownerLoginAPI.participantImage ?? ''),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 20),
                Text(
                  ownerLoginAPI.participantData?.memberName ?? 'Unknown User',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                // const SizedBox(height: 8),

                const SizedBox(height: 40),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  shadowColor: Colors.grey.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading:
                              const Icon(Icons.group, color: Colors.blueGrey),
                          title: const Text(
                            'Team Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF444444),
                            ),
                          ),
                          subtitle: Text(
                            ownerLoginAPI.participantData?.teamName ?? 'N/A',
                            style: const TextStyle(
                              color: Color(0xFF777777),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to show login prompt when no data is available
  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please log in to view your profile',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen(
                          isFromLogin: true,
                        )),
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
