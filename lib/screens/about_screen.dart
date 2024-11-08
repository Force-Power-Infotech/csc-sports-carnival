import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/about.dart';
import 'package:rpgl/bases/themes.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Future<AboutAPI>? _aboutDataFuture;

  @override
  void initState() {
    super.initState();
    _aboutDataFuture = AboutAPI.leaderboardlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.getBackground(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'About',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Handle close action
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: AppThemes.getBackground(),
        elevation: 1,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: Container(
          color: Colors.grey[100],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  FutureBuilder<AboutAPI>(
                    future: _aboutDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppThemes.getBackground(),
                            strokeWidth: 3.0,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Something went wrong. Please try again later.',
                            style: TextStyle(
                              color: Colors.red[300],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.aboutData == null) {
                        return Center(
                          child: Text(
                            'No information available at the moment.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[300],
                                thickness: 0.5,
                                indent: 16,
                                endIndent: 16,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.aboutData!.length,
                              itemBuilder: (context, index) {
                                final item = snapshot.data!.aboutData![index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title ?? 'Untitled',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppThemes.getBackground()
                                            .withOpacity(0.9),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item.description ?? 'No Description',
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
