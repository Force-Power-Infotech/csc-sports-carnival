import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/bannerImage.dart';
import 'package:rpgl/bases/api/homescreen.dart'; // Import the API file
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/screens/notification_screen.dart';
import 'package:rpgl/widgets/BottomNavigationBar.dart';
import 'package:rpgl/widgets/ScoreCarousel.dart';
import 'package:rpgl/widgets/StaticButtonGrid.dart';
import 'package:rpgl/widgets/StreamCarousel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? leagueName; // Variable to store data from the API
  String? score;
  String? homeScreenSideImage;
  List<String> bannerImages = [];
  List<String> bannerLinks = [];
  List<String> streamImages = [];
  List<String> streamLinks = [];
  List<String> scoreImages = [];
  List<String> scoreLinks = [];

  @override
  void initState() {
    super.initState();
    _fetchHomeScreenData(); // Fetch data from the homescreenlist API
  }

  Future<void> _fetchHomeScreenData() async {
    HomescreenAPI response = await HomescreenAPI.homescreenlist();
    homeScreenSideImage = response.homeScreenSideImage ?? '';
    leagueName = response.usernameExistStatus ?? '';
    print("Home Screen Side Image URL: $homeScreenSideImage"); // Debug print

    List<String> newBannerImages = [];
    List<String> newBannerLinks = [];
    List<String> newScoreImages = [];
    List<String> newScoreLinks = [];
    List<String> newStreamImages = [];
    List<String> newStreamLinks = [];

    if (response.leaderboardTypeData?.bANNER != null) {
      response.leaderboardTypeData!.bANNER!.forEach((banner) {
        if (banner.bannerImage != null) {
          newBannerImages.add(banner.bannerImage!);
          print("Score Image URL: ${banner.bannerImage}"); // Debug print
        }
        if (banner.link != null) {
          newBannerLinks.add(banner.link!);
          print("Score Link URL: ${banner.link}"); // Debug print
        }
      });
    }
    if (response.leaderboardTypeData?.sCORE != null) {
      response.leaderboardTypeData!.sCORE!.forEach((score) {
        if (score.bannerImage != null) {
          newScoreImages.add(score.bannerImage!);
          print("Score Image URL: ${score.bannerImage}"); // Debug print
        }
        if (score.link != null) {
          newScoreLinks.add(score.link!);
          print("Score Link URL: ${score.link}"); // Debug print
        }
      });
    }
    if (response.leaderboardTypeData?.sTREAM != null) {
      response.leaderboardTypeData!.sTREAM!.forEach((stream) {
        if (stream.bannerImage != null) {
          newStreamImages.add(stream.bannerImage!);
          print("Score Image URL: ${stream.bannerImage}"); // Debug print
        }
        if (stream.link != null) {
          newStreamLinks.add(stream.link!);
          print("Score Link URL: ${stream.link}"); // Debug print
        }
      });
    }

    setState(() {
      scoreImages = newScoreImages;
      scoreLinks = newScoreLinks;
      streamImages = newStreamImages;
      streamLinks = newStreamLinks;
      bannerImages = newBannerImages;
      bannerLinks = newBannerLinks;
      print("Updated scoreImages in state: $scoreImages"); // Debug print
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: bannerImages.isNotEmpty
                      ? Image.network(
                          bannerImages[0] ?? '',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 200,
                            color: Colors.grey,
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey,
                        ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: -35,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: homeScreenSideImage != null
                          ? Image.network(
                              homeScreenSideImage ?? '',
                              height: 70,
                              width: 130,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 70,
                                width: 130,
                                color: Colors.grey[300],
                              ),
                            )
                          : Container(
                              height: 70,
                              width: 130,
                              color: Colors.grey[300],
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 64),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF4E50), Color(0xFF8B0000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  leagueName ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            StaticButtonGrid(),
            ScoreCarousel(
              scoreImages: scoreImages,
              scoreLinks: scoreLinks,
            ),
            StreamCarousel(
              streamImages: streamImages,
              streamLinks: streamLinks,
            ),
          ],
        ),
      ),
      floatingActionButton: const CustomBottomNavigationBar(
        sponsorImageUrl: '',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
