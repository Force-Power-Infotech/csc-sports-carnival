import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/copdnew.dart'; // Import your API file here
import 'package:rpgl/widgets/CustomWebView.dart';

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
      // Use the `pdflist` method from `CopdnewAPI`
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            elevation: 1,
          ),
          body: CustomWebView(
            initialUrl: url,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'COPD',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade300.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4),
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
                              errorBuilder: (context, error, stackTrace) {
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              sport.sportsName ?? '',
                              style: TextStyle(
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
    );
  }
}
