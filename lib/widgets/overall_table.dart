import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/overall_leaderboard.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OverallTable extends StatefulWidget {
  const OverallTable({Key? key}) : super(key: key);

  @override
  State<OverallTable> createState() => _OverallTableState();
}

class _OverallTableState extends State<OverallTable> {
  late Future<OverallLeaderboard> _futureLeaderboard;

  @override
  void initState() {
    super.initState();
    _futureLeaderboard = OverallLeaderboard.fetchOverallLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OverallLeaderboard>(
      future: _futureLeaderboard,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final leaderboardValues = snapshot.data!.leaderboardValues ?? [];
          final sportsMap = _transformLeaderboardData(leaderboardValues);

          return Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.3),
              //     spreadRadius: 3,
              //     blurRadius: 6,
              //     offset: const Offset(0, 3),
              //   ),
              // ],
            ),
            child: SfDataGrid(
              source: SportsDataSource(sportsMap),
              gridLinesVisibility: GridLinesVisibility.none,
              headerGridLinesVisibility: GridLinesVisibility.none,
              headerRowHeight: 80, // Increase header height
              rowHeight: 60, // Increase row height for better readability
              columns: [
                GridColumn(
                  columnName: 'sports_name',
                  // width: 180, // Adjust width for "Sport" column
                  label: _buildHeaderCell('Sport'),
                ),
                ...sportsMap.values.first.entries.map((teamEntry) {
                  final teamName = teamEntry.key;
                  final teamImage = teamEntry.value['image'] ?? '';
                  return GridColumn(
                    columnName: teamName,
                    width: 140, // Adjust column width
                    label: _buildTeamHeader(teamName, teamImage),
                  );
                }).toList(),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Map<String, Map<String, Map<String, String>>> _transformLeaderboardData(
      List<LeaderboardValues> leaderboardValues) {
    final sportsMap = <String, Map<String, Map<String, String>>>{};

    for (var leaderboard in leaderboardValues) {
      for (var sport in leaderboard.sportsDetails ?? []) {
        final sportName = sport.sportsName ?? '';
        final teamName = leaderboard.teamName ?? '';
        final teamImage = leaderboard.teamImage ?? '';
        final sportsValue = sport.sportsValue ?? '';

        sportsMap.putIfAbsent(sportName, () => {});
        sportsMap[sportName]![teamName] = {
          'value': sportsValue,
          'image': teamImage,
        };
      }
    }

    return sportsMap;
  }

  Widget _buildHeaderCell(String title) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTeamHeader(String teamName, String teamImageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppThemes.getBackground(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18, // Increased size
                backgroundImage: teamImageUrl.isNotEmpty
                    ? NetworkImage(teamImageUrl)
                    : const AssetImage('assets/placeholder.png')
                        as ImageProvider,
                onBackgroundImageError: (_, __) {},
              ),
              Text(
                teamName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SportsDataSource extends DataGridSource {
  final Map<String, Map<String, Map<String, String>>> sportsMap;

  SportsDataSource(this.sportsMap) {
    dataGridRows = sportsMap.entries.map((entry) {
      final sportName = entry.key;
      final teamValues = entry.value;

      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'sports_name', value: sportName),
          ...teamValues.entries.map((teamEntry) {
            return DataGridCell<String>(
              columnName: teamEntry.key,
              value: teamEntry.value['value'], // Extract sportsValue
            );
          }).toList(),
        ],
      );
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridCell? getCell(DataGridRow row, String columnName) {
    return row.getCells().firstWhere((cell) => cell.columnName == columnName);
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'sports_name') {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dataGridCell.value ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(dataGridCell.value ?? ''),
          );
        }
      }).toList(),
    );
  }
}
