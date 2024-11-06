import 'package:flutter/material.dart';
import 'package:rpgl/widgets/MatchCard.dart';

class MatchSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> demoData = [
    {'title': 'Match 1', 'date': '2023-10-01'},
    {'title': 'Match 2', 'date': '2023-10-05'},
    {'title': 'Match 3', 'date': '2023-10-10'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Match'),
      ),
      body: ListView.builder(
        itemCount: demoData.length,
        itemBuilder: (context, index) {
          final match = demoData[index];
          return MatchCard(
            matchNo: match['title'] ?? 'Match',
            logoA: 'https://example.com/logoA.png',
            teamA: 'Team A',
            logoB: 'https://example.com/logoB.png',
            teamB: 'Team B',
            date: match['date'] ?? '',
            time: '15:30',
            sportsName: 'Football',
            location: 'Stadium',
            showCreateTeamButton:
                true, // Show button only on MatchSelectionScreen
          );
        },
      ),
    );
  }
}
