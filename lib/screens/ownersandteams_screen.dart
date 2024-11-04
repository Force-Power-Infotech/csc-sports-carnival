import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/show_team_and_participants_details.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/screens/team_splash_screen.dart';
import 'package:rpgl/screens/teamandparticipant_screen.dart';
import 'package:rpgl/bases/webservice.dart';

class OwnersAndTeamsScreen extends StatefulWidget {
  @override
  _OwnersAndTeamsScreenState createState() => _OwnersAndTeamsScreenState();
}

class _OwnersAndTeamsScreenState extends State<OwnersAndTeamsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = true;
  String? selectedGroup;
  TeamAndParticipantsDetails? teamAndParticipantsDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isAppBarExpanded = _scrollController.hasClients &&
            _scrollController.offset < (200 - kToolbarHeight);
      });
    });
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      teamAndParticipantsDetails =
          await TeamAndParticipantsDetails.leaderboardlist();
      setState(() {
        selectedGroup = teamAndParticipantsDetails?.groups?.keys.first;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppThemes.getBackground(),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://calcuttaswimmingclub.com/wp-content/uploads/2023/07/WhatsApp-Image-2023-07-31-at-12.59.55-PM-2.jpeg',
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                  Container(
                    color: _isAppBarExpanded
                        ? AppThemes.getBackground().withOpacity(0.5)
                        : AppThemes.getBackground(),
                  ),
                ],
              ),
              title: const Text(
                'Captains & Teams',
                style: TextStyle(color: Colors.white),
              ),
              titlePadding: const EdgeInsets.all(16),
              centerTitle: true,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // SliverPersistentHeader(
          // delegate: _SearchAndButtonHeaderDelegate(
          //   selectedGroup: selectedGroup,
          //   onSelectGroup: (groupName) {
          //     setState(() {
          //       selectedGroup = groupName;
          //     });
          //   },
          //   groups: teamAndParticipantsDetails?.groups?.keys.toList() ?? [],
          // ),

          //   pinned: true,
          // ),
          // SliverPadding(
          //   padding:
          //       const EdgeInsets.only(top: 0.0), // Adjust this value as needed
          //   sliver: isLoading
          //       ? const SliverToBoxAdapter(
          //           child: Center(child: CircularProgressIndicator()),
          //         )
          //       : SliverList(
          //           delegate: SliverChildBuilderDelegate(
          //             (BuildContext context, int index) {
          //               var group = teamAndParticipantsDetails
          //                       ?.groups?[selectedGroup] ??
          //                   [];
          //               var team = group[index];
          //               return Container(
          //                 // color: Colors.white,
          //                 child: Card(
          //                   margin: const EdgeInsets.symmetric(
          //                       vertical: 8.0, horizontal: 16),
          //                   elevation: 4,
          //                   child: InkWell(
          //                     onTap: () {
          //                       Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                           builder: (context) => TeamSplashScreen(
          //                             imageUrl: '${team.theImageLink}',
          //                             teamId: '${team.id}',
          //                           ),
          //                         ),
          //                       );
          //                     },
          //                     child: Row(
          //                       children: [
          //                         ClipRRect(
          //                           borderRadius: const BorderRadius.only(
          //                             topLeft: Radius.circular(16.0),
          //                             bottomLeft: Radius.circular(16.0),
          //                           ),
          //                           child: Container(
          //                             width: 100,
          //                             height: 100,
          //                             color: Colors.grey[300],
          //                             child: Image.network(
          //                               team.theImageLink ?? '',
          //                               fit: BoxFit.cover,
          //                               errorBuilder:
          //                                   (context, error, stackTrace) {
          //                                 return Center(
          //                                   child: CircleAvatar(
          //                                     backgroundColor: Colors.grey[400],
          //                                     child: const Icon(Icons.image,
          //                                         color: Colors.white),
          //                                   ),
          //                                 );
          //                               },
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(12.0),
          //                             child: Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   team.team ?? 'Team Name',
          //                                   style: const TextStyle(
          //                                     fontSize: 14,
          //                                     fontWeight: FontWeight.bold,
          //                                     color: Colors.black,
          //                                   ),
          //                                   textAlign: TextAlign.center,
          //                                 ),
          //                                 const SizedBox(height: 4),
          //                                 Text(
          //                                   team.owners ?? 'Owner Name',
          //                                   style: TextStyle(
          //                                     fontSize: 14,
          //                                     color: Colors.grey[900],
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             },
          //             childCount: teamAndParticipantsDetails
          //                     ?.groups?[selectedGroup]?.length ??
          //                 0,
          //           ),
          //         ),
          // ),
          SliverPadding(
            padding:
                const EdgeInsets.only(top: 0.0), // Adjust this value as needed
            sliver: isLoading
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        // Combine all teams from each group into a single list
                        var allTeams = teamAndParticipantsDetails
                                ?.groups?.values
                                .expand((group) => group)
                                .toList() ??
                            [];
                        var team = allTeams[index];

                        return Container(
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeamSplashScreen(
                                      imageUrl: team.theImageLink ?? '',
                                      teamId: team.id ?? '',
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      bottomLeft: Radius.circular(16.0),
                                    ),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: Image.network(
                                        team.theImageLink ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey[400],
                                              child: const Icon(Icons.image,
                                                  color: Colors.white),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            team.team ?? 'Team Name',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            team.owners ?? 'Owner Name',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[900],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      // Use the combined list length as the child count
                      childCount: teamAndParticipantsDetails?.groups?.values
                              .expand((group) => group)
                              .length ??
                          0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndButtonHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String? selectedGroup;
  final ValueChanged<String> onSelectGroup;
  final List<String> groups;

  _SearchAndButtonHeaderDelegate({
    required this.selectedGroup,
    required this.onSelectGroup,
    required this.groups,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // color: Colors.red,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: groups
          //         .map((groupName) => Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //               child: _buildButton(groupName),
          //             ))
          //         .toList(),
          //   ),
          // ),
        ],
      ),
    );
  }

  ElevatedButton _buildButton(String groupName) {
    return ElevatedButton(
      onPressed: () {
        onSelectGroup(groupName);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedGroup == groupName
            ? AppThemes.getBackground()
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      child: Text(
        groupName,
        style: TextStyle(
          color: selectedGroup == groupName
              ? Colors.white
              : AppThemes.getBackground(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 140.0;

  @override
  double get minExtent => 140.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
