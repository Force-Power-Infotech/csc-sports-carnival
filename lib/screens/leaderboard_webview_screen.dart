import 'package:flutter/material.dart';
import 'package:rpgl/widgets/CustomWebView.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LeaderboardWebViewScreen extends StatelessWidget {
  final String url = 'https://app.forcempower.com/HTML/leaderboard.html';

  LeaderboardWebViewScreen({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard'),
        ),
        body: CustomWebView(initialUrl: url));
  }
}
