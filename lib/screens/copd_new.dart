import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/copdnew.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/widgets/CustomWebView.dart';
import 'package:rpgl/widgets/bottomModal.dart';

class Copdnew extends StatefulWidget {
  @override
  _CopdnewState createState() => _CopdnewState();
}

class _CopdnewState extends State<Copdnew> {
  List<SportsDetails> sportsDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSportsDetails();
  }

  Future<void> fetchSportsDetails() async {
    try {
      CopdnewAPI responseData = await CopdnewAPI.pdflist();
      setState(() {
        sportsDetails = responseData.sportsDetails ?? [];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching sports details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void showWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen(url: url)),
    );
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
            'Rules & Regulations',
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : sportsDetails.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey[400],
                            size: 80,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No Data Available",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.85,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: sportsDetails.length,
                        itemBuilder: (context, index) {
                          final sport = sportsDetails[index];
                          return GestureDetector(
                            onTap: () {
                              if (sport.webview != null) {
                                showWebView(context, sport.webview!);
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: AppThemes.getBackground(),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.blue.shade300.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      sport.sportsLogo ?? '',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image,
                                              color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      sport.sportsName ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
