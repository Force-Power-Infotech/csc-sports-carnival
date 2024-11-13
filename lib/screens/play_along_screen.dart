import 'package:flutter/material.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/widgets/CustomWebView.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlayAlongScreen extends StatelessWidget {
  final member_id;
  const PlayAlongScreen({super.key, required this.member_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.getBackground(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Play Along',
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
          child: CustomWebView(
            initialUrl:
                'http://sports.forcempower.com/auth/play_along.php?member_id=${member_id}',
          ),
        ),
      ),
    );
  }
}
