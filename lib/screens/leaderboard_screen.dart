import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/leaderboard.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:async';

class LeaderboardScreen extends StatefulWidget {
  final String sponsorImageUrl; // This can be a file path or URL

  const LeaderboardScreen({super.key, required this.sponsorImageUrl});
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedGroup = "";
  final ScrollController _scrollController = ScrollController();
  // late Timer _timer;
  Map<String, LeaderboardDataSource> _dataSources = {};
  bool _isLoading = true;
  final bool _isSponsorVisible = true;

  @override
  void initState() {
    super.initState();
    // _startAutoScroll();
    _fetchLeaderboardData();
  }

  @override
  void dispose() {
    // _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // void _startAutoScroll() {
  //   _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
  //     if (_scrollController.hasClients) {
  //       double maxScrollExtent = _scrollController.position.maxScrollExtent;
  //       double currentScrollPosition = _scrollController.position.pixels;
  //       double nextScrollPosition = currentScrollPosition + 100;

  //       if (nextScrollPosition >= maxScrollExtent) {
  //         nextScrollPosition = 0;
  //       }

  //       _scrollController.animateTo(
  //         nextScrollPosition,
  //         duration: const Duration(seconds: 1),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }

  Future<void> _fetchLeaderboardData() async {
    try {
      LeaderBoard leaderboard = await LeaderBoard.leaderboardlist();

      if (leaderboard.leaderboardDetails != null) {
        final leaderboardDetails = leaderboard.leaderboardDetails!;

        setState(() {
          _dataSources = {}; // Clear previous data sources

          leaderboardDetails.groups.forEach((groupName, groupData) {
            _dataSources[groupName] = LeaderboardDataSource(
                LeaderboardDetails(groups: {groupName: groupData}));
          });

          if (_dataSources.isNotEmpty) {
            selectedGroup =
                _dataSources.keys.first; // Set initial selected group
          }

          _isLoading = false;
        });
      } else {
        print("Leaderboard details are null");
      }
    } catch (e) {
      print("Failed to load leaderboard data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = 8; // Number of columns
    final columnWidth = screenWidth / (columnCount * 1.2);

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   title: const Text('Leaderboard', style: TextStyle(color: Colors.white)),
      //   backgroundColor: AppThemes.getBackground(),
      // ),
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Column(
              children: [
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: _dataSources.keys.map((groupName) {
                //       return Padding(
                //         padding: const EdgeInsets.only(right: 16.0),
                //         child: ElevatedButton(
                //           onPressed: () {
                //             setState(() {
                //               selectedGroup = groupName;
                //             });
                //           },
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: selectedGroup == groupName
                //                 ? AppThemes.getBackground()
                //                 : Colors.white,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8.0),
                //             ),
                //             padding:
                //                 const EdgeInsets.symmetric(horizontal: 16.0),
                //           ),
                //           child: Text(
                //             groupName,
                //             style: TextStyle(
                //               color: selectedGroup == groupName
                //                   ? Colors.white
                //                   : AppThemes.getBackground(),
                //             ),
                //           ),
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                SfDataGrid(
                  source: _dataSources[selectedGroup] ??
                      LeaderboardDataSource(LeaderboardDetails(
                          groups: {})), // Fallback to an empty data source
                  columnWidthMode: ColumnWidthMode.fill,
                  // SfDataGrid columns definition
                  columns: [
                    GridColumn(
                      columnName: 'team',
                      label: Container(
                        padding: const EdgeInsets.all(4.0),
                        alignment: Alignment.centerLeft,
                        color: Colors.black,
                        child: const Row(
                          children: [
                            SizedBox(width: 4),
                            Text('Team', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      // width: 3.0 * columnWidth,
                    ),
                    GridColumn(
                      columnName: 'mp',
                      label: Container(
                        padding: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Text('R',
                            style: TextStyle(color: Colors.white)),
                      ),
                      width: columnWidth,
                    ),
                    GridColumn(
                      columnName: 'mw',
                      label: Container(
                        padding: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Text('MP',
                            style: TextStyle(color: Colors.white)),
                      ),
                      width: columnWidth,
                    ),
                    GridColumn(
                      columnName: 'ml',
                      label: Container(
                        padding: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Text('MW',
                            style: TextStyle(color: Colors.white)),
                      ),
                      width: columnWidth,
                    ),
                    GridColumn(
                      columnName: 'tp',
                      label: Container(
                        padding: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Text('ML',
                            style: TextStyle(color: Colors.white)),
                      ),
                      width: columnWidth,
                    ),
                    GridColumn(
                      columnName: 'nrr',
                      label: Container(
                        padding: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Text('TP',
                            style: TextStyle(color: Colors.white)),
                      ),
                      width: columnWidth,
                    ),
                    GridColumn(
                      columnName: 'mt',
                      label: Container(
                        padding: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Text('NRR',
                            style: TextStyle(color: Colors.white)),
                      ),
                      width: columnWidth,
                    ),
                  ],

                  controller: DataGridController(),
                  verticalScrollController: _scrollController,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  color: Colors.grey[400],
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // R - Rank
                      // MP - Matches Played
                      // MW	- Matches Won
                      // ML - Matches Lost
                      // TP - Total Points
                      // NRR - Net Run Rate

                      Text('R - Rank'),
                      Text('MP - Matches Played'),
                      Text('MW - Matches Won'),
                      Text('ML - Matches Lost'),
                      Text('TP - Total Points'),
                      Text('NRR - Net Run Rate'),
                    ],
                  ),
                ),
                // Container(
                //   height: 200,
                //   width: double.infinity,
                //   color: widget.sponsorImageUrl != null &&
                //           widget.sponsorImageUrl.isNotEmpty
                //       ? Colors.grey
                //       : Colors.grey[300],
                //   child: widget.sponsorImageUrl != null &&
                //           widget.sponsorImageUrl.isNotEmpty
                //       ? Image.network(
                //           widget.sponsorImageUrl,
                //           fit: BoxFit.cover,
                //         )
                //       : null,
                // ),
              ],
            ),
    );
  }
}

class LeaderboardDataSource extends DataGridSource {
  LeaderboardDataSource(this._leaderboardDetails) {
    _buildDataGridRows();
  }

  final LeaderboardDetails _leaderboardDetails;
  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRows() {
    _leaderboardDetails.groups.forEach((groupName, groupData) {
      _dataGridRows.addAll(groupData.map<DataGridRow>((data) {
        return DataGridRow(cells: [
          DataGridCell<String>(
              columnName: 'team', value: "${data.team},${data.teamImage}"),
          DataGridCell<String>(
              columnName: 'r', value: data.noresult.toString()),
          DataGridCell<String>(columnName: 'mp', value: data.played.toString()),
          DataGridCell<String>(columnName: 'mw', value: data.won.toString()),
          DataGridCell<String>(columnName: 'ml', value: data.lost.toString()),
          DataGridCell<String>(columnName: 'tp', value: data.points.toString()),
          DataGridCell<String>(
              columnName: 'nrr', value: data.netDifference.toString()),
          // DataGridCell<String>(columnName: 'tp', value: data.points.toString()),
        ]);
      }).toList());
    });
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((cell) {
      if (cell.columnName == 'team') {
        String teamName = cell.value.toString().split(',').first;
        String teamImage = cell.value.toString().split(',').last;

        return Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                teamName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        );
      } else {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: Text(cell.value.toString()),
        );
      }
    }).toList());
  }
}
