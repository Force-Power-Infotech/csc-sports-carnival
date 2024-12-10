import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/sportswise_leaderboard_screen.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SportsWise extends StatefulWidget {
  const SportsWise({Key? key}) : super(key: key);

  @override
  State<SportsWise> createState() => _SportsWiseState();
}

class _SportsWiseState extends State<SportsWise> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _sportsData = [];
  String? _selectedSport;
  List<Map<String, dynamic>> _currentTableData = []; // Initialize to empty list
  List<String> _columns = []; // Initialize columns

  @override
  void initState() {
    super.initState();
    _fetchSportsData();
  }

  Future<void> _fetchSportsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentTableData = []; // Clear current data while loading
      _columns = []; // Clear columns while loading
    });

    try {
      SportsWiselbAPI apiResponse =
          await SportsWiselbAPI.fetchSportswiseeaderboard();

      if (apiResponse.processSts == "YES" && apiResponse.sportsData != null) {
        setState(() {
          _sportsData = apiResponse.sportsData!;
          _selectedSport = _sportsData.first['sports_name']; // Default sport
          _updateTableData(); // Update data for default sport
        });
      } else {
        throw Exception(apiResponse.processMsg ?? "Unknown error");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateTableData() {
    // Find data for the selected sport
    final selectedSportData = _sportsData.firstWhere(
      (sport) => sport['sports_name'] == _selectedSport,
      orElse: () => null,
    );

    if (selectedSportData != null) {
      _currentTableData = selectedSportData['sports_details']
          .map<Map<String, dynamic>>((detail) => {
                'team_name': selectedSportData['team_name'],
                'team_image': selectedSportData['team_image'],
                'sports_name': detail['sports_name'],
                'sports_value': detail['sports_value'] ?? 'N/A',
              })
          .toList();

      // Dynamically extract columns
      if (_currentTableData.isNotEmpty) {
        _columns = _currentTableData.first.keys.toList();
      } else {
        _columns = [];
      }
    } else {
      _currentTableData = [];
      _columns = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text('Error: $_errorMessage'))
                : Column(
                    children: [
                      // Dropdown for selecting sport
                      if (_sportsData.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DropdownButton<String>(
                            value: _selectedSport,
                            isExpanded: true,
                            items: _sportsData
                                .map((sport) => DropdownMenuItem<String>(
                                      value: sport['sports_name'],
                                      child: Text(
                                        sport['sports_name'] ?? '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSport = value;
                                _updateTableData();
                              });
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      // DataGrid for displaying leaderboard
                      Expanded(
                        child: SfDataGrid(
                          source: SportsDataSource(_currentTableData, _columns),
                          columns: _columns
                              .map((column) => GridColumn(
                                    columnName: column,
                                    label: _buildHeaderCell(column),
                                  ))
                              .toList(),
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          headerRowHeight: 60,
                          rowHeight: 50,
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
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

class SportsDataSource extends DataGridSource {
  final List<Map<String, dynamic>> data;
  final List<String> columns;

  SportsDataSource(this.data, this.columns) {
    dataGridRows = data.map<DataGridRow>((item) {
      return DataGridRow(
        cells: columns.map((column) {
          return DataGridCell<String>(
            columnName: column,
            value: item[column]?.toString() ?? '',
          );
        }).toList(),
      );
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}
