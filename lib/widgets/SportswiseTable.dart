import 'package:flutter/material.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SportsWise extends StatefulWidget {
  const SportsWise({Key? key}) : super(key: key);

  @override
  State<SportsWise> createState() => _SportsWiseState();
}

class _SportsWiseState extends State<SportsWise> {
  String _selectedSport = 'Football'; // Default selected sport

  // Demo sports data
  final Map<String, List<Map<String, dynamic>>> sportsData = {
    'Football': [
      {'Club': 'Team A', 'Points': 25, 'Wins': 8, 'Losses': 2, 'Draws': 1},
      {'Club': 'Team B', 'Points': 18, 'Wins': 5, 'Losses': 3, 'Draws': 3},
      {'Club': 'Team C', 'Points': 12, 'Wins': 3, 'Losses': 6, 'Draws': 2},
    ],
    'Basketball': [
      {'Club': 'Team X', 'Points': 30, 'Wins': 10, 'Losses': 0, 'Draws': 0},
      {'Club': 'Team Y', 'Points': 22, 'Wins': 7, 'Losses': 3, 'Draws': 0},
      {'Club': 'Team Z', 'Points': 15, 'Wins': 5, 'Losses': 5, 'Draws': 0},
    ],
    'Cricket': [
      {'Club': 'Team Alpha', 'Points': 40, 'Wins': 10, 'Losses': 2, 'Draws': 0},
      {'Club': 'Team Beta', 'Points': 32, 'Wins': 8, 'Losses': 4, 'Draws': 0},
      {'Club': 'Team Gamma', 'Points': 20, 'Wins': 5, 'Losses': 6, 'Draws': 1},
    ],
  };

  late SportsDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = SportsDataSource(sportsData[_selectedSport]!);
  }

  void _updateTable(String sport) {
    setState(() {
      _selectedSport = sport;
      _dataSource = SportsDataSource(sportsData[sport]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Dropdown for selecting sport
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: _selectedSport,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: Icon(Icons.arrow_drop_down,
                      color: AppThemes.getBackground()),
                  items: sportsData.keys
                      .map((sport) => DropdownMenuItem<String>(
                            value: sport,
                            child: Text(
                              sport,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateTable(value);
                    }
                  },
                ),
              ),
            ),
            // Buttons for Groups and Teams
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Groups button action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.getBackground(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Group A'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Teams button action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.getBackground(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Group B'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // DataGrid for displaying leaderboard
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SfDataGrid(
                      source: _dataSource,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      headerRowHeight: 60,
                      rowHeight: 50,
                      columns: [
                        GridColumn(
                          columnName: 'Club',
                          label: _buildHeaderCell('Club'),
                        ),
                        GridColumn(
                          columnName: 'Points',
                          label: _buildHeaderCell('Points'),
                        ),
                        GridColumn(
                          columnName: 'Wins',
                          label: _buildHeaderCell('Wins'),
                        ),
                        GridColumn(
                          columnName: 'Losses',
                          label: _buildHeaderCell('Losses'),
                        ),
                        GridColumn(
                          columnName: 'Draws',
                          label: _buildHeaderCell('Draws'),
                        ),
                      ],
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

  Widget _buildHeaderCell(String title) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppThemes.getBackground(),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class SportsDataSource extends DataGridSource {
  final List<Map<String, dynamic>> data;

  SportsDataSource(this.data) {
    dataGridRows = data.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Club', value: item['Club']),
        DataGridCell<int>(columnName: 'Points', value: item['Points']),
        DataGridCell<int>(columnName: 'Wins', value: item['Wins']),
        DataGridCell<int>(columnName: 'Losses', value: item['Losses']),
        DataGridCell<int>(columnName: 'Draws', value: item['Draws']),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}
