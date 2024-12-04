import 'package:flutter/material.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/widgets/LeaderboardTable.dart';
import 'package:rpgl/widgets/SportswiseTable.dart';
import 'package:rpgl/widgets/overall_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LeaderboardScreen extends StatefulWidget {
  final String sponsorImageUrl;

  const LeaderboardScreen({super.key, required this.sponsorImageUrl});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedView = "Overall"; // Default view
  bool _isLoading = true;

  late Map<String, List<LeaderboardRow>> _overallData;
  late Map<String, List<LeaderboardRow>> _sportsWiseData;

  @override
  void initState() {
    super.initState();
    _fetchDemoLeaderboardData();
  }

  void _fetchDemoLeaderboardData() {
    _overallData = {
      "Cricket": [
        LeaderboardRow(
          team: "Team Alpha",
          teamImage: "alpha.png",
          played: 5,
          won: 3,
          lost: 2,
          points: 6,
          noresult: 0,
          netDifference: 0.5,
        ),
        LeaderboardRow(
          team: "Team Beta",
          teamImage: "beta.png",
          played: 5,
          won: 4,
          lost: 1,
          points: 8,
          noresult: 0,
          netDifference: 1.2,
        ),
      ],
      "Football": [
        LeaderboardRow(
          team: "Team Gamma",
          teamImage: "gamma.png",
          played: 5,
          won: 2,
          lost: 3,
          points: 4,
          noresult: 0,
          netDifference: -0.8,
        ),
      ],
    };

    _sportsWiseData = {
      "Group A": [
        LeaderboardRow(
          team: "Team Alpha",
          teamImage: "alpha.png",
          played: 5,
          won: 3,
          lost: 2,
          points: 6,
          noresult: 0,
          netDifference: 0.5,
        ),
      ],
    };

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton("Overall"),
        _buildToggleButton("Sports-wise"),
      ],
    );
  }

  Widget _buildToggleButton(String view) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedView = view;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedView == view ? Colors.black : Colors.white,
          side: const BorderSide(color: Colors.black, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(
          view,
          style: TextStyle(
            color: selectedView == view ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOverallTable() {
    return OverallTable();
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSportsWiseTable() {
    return SportsWise();
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
            'Leaderboard',
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildToggleButtons(),
                    ),
                    // const SizedBox(height: 16),
                    Expanded(
                      child: selectedView == "Overall"
                          ? _buildOverallTable()
                          : _buildSportsWiseTable(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class LeaderboardRow {
  final String team;
  final String teamImage;
  final int played;
  final int won;
  final int lost;
  final int points;
  final double noresult;
  final double netDifference;

  LeaderboardRow({
    required this.team,
    required this.teamImage,
    required this.played,
    required this.won,
    required this.lost,
    required this.points,
    required this.noresult,
    required this.netDifference,
  });
}

class LeaderboardDataSource extends DataGridSource {
  final Map<String, List<LeaderboardRow>> data;
  List<DataGridRow> _rows = [];

  LeaderboardDataSource(this.data) {
    // Build rows for the data grid
    _rows = data.entries
        .expand((entry) => entry.value.map((row) => DataGridRow(cells: [
              DataGridCell(columnName: 'sport', value: entry.key),
              DataGridCell(columnName: 'team', value: row.team),
              DataGridCell(columnName: 'played', value: row.played),
              DataGridCell(columnName: 'won', value: row.won),
              DataGridCell(columnName: 'lost', value: row.lost),
              DataGridCell(columnName: 'points', value: row.points),
              DataGridCell(columnName: 'noresult', value: row.noresult),
              DataGridCell(
                  columnName: 'netDifference', value: row.netDifference),
            ])))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}
