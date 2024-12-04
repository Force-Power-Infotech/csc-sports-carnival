import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LeaderboardTable extends StatelessWidget {
  final List<GridColumn> columns;
  final DataGridSource dataSource;
  final String title;
  final bool showBorders;

  const LeaderboardTable({
    Key? key,
    required this.columns,
    required this.dataSource,
    this.title = "Leaderboard",
    this.showBorders = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8), // Margin around the table
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(16), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Soft shadow color
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SfDataGrid(
              source: dataSource,
              columns: columns,
              gridLinesVisibility: showBorders
                  ? GridLinesVisibility.horizontal
                  : GridLinesVisibility.none,
              headerGridLinesVisibility: showBorders
                  ? GridLinesVisibility.both
                  : GridLinesVisibility.none,
            ),
          ),
        ],
      ),
    );
  }
}
