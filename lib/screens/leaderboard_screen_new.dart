import 'package:flutter/material.dart';

class LeaderboardScreenNew extends StatefulWidget {
  @override
  _LeaderboardScreenNewState createState() => _LeaderboardScreenNewState();
}

class _LeaderboardScreenNewState extends State<LeaderboardScreenNew> {
  final List<String> sports = [
    'Basketball',
    'Football',
    'Swimming',
    'Tennis',
    'Cricket',
  ];

  final List<Team> teams = [
    Team('Team A', 'assets/logo1.png', {
      'Basketball': 24,
      'Football': 18,
      'Swimming': 20,
      'Tennis': 22,
      'Cricket': 19
    }),
    Team('Team B', 'assets/logo2.png', {
      'Basketball': 20,
      'Football': 15,
      'Swimming': 18,
      'Tennis': 16,
      'Cricket': 14
    }),
    Team('Team C', 'assets/logo3.png', {
      'Basketball': 18,
      'Football': 17,
      'Swimming': 15,
      'Tennis': 19,
      'Cricket': 13
    }),
    Team('Team D', 'assets/logo4.png', {
      'Basketball': 16,
      'Football': 14,
      'Swimming': 14,
      'Tennis': 15,
      'Cricket': 10
    }),
    Team('Team E', 'assets/logo5.png', {
      'Basketball': 12,
      'Football': 10,
      'Swimming': 10,
      'Tennis': 12,
      'Cricket': 8
    }),
  ];

  String selectedSport = 'Basketball';
  bool showOverall = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildToggleButton('Overall', showOverall),
                _buildToggleButton('Sport-wise', !showOverall),
                if (!showOverall)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: DropdownButton<String>(
                      value: selectedSport,
                      underline: const SizedBox(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedSport = value;
                          });
                        }
                      },
                      items: sports.map((sport) {
                        return DropdownMenuItem<String>(
                          value: sport,
                          child: Text(sport),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.blue.shade100,
                        ),
                        columnSpacing: 12,
                        horizontalMargin: 8,
                        columns: _buildColumns(),
                        rows: _buildRows(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isActive) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          showOverall = title == 'Overall';
        });
      },
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: isActive ? Colors.blueAccent : Colors.red.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(
        label: Text(
          'Teams',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      DataColumn(label: Text('Rank')),
      DataColumn(label: Text('Matches Played')),
      DataColumn(label: Text('Matches Won')),
      DataColumn(label: Text('Matches Lost')),
      DataColumn(label: Text('Total Points')),
    ];
  }

  List<DataRow> _buildRows() {
    return teams.map((team) {
      return DataRow(
        cells: [
          DataCell(_buildTeamCell(team)),
          ...List.generate(5, (index) => const DataCell(Text('-'))),
        ],
      );
    }).toList();
  }

  Widget _buildTeamCell(Team team) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(team.logo),
          radius: 20,
        ),
        const SizedBox(width: 8),
        Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class Team {
  final String name;
  final String logo;
  final Map<String, int> scores;

  Team(this.name, this.logo, this.scores);
}
