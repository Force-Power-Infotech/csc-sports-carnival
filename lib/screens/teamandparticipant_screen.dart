import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/schedule.dart';
import 'package:rpgl/bases/api/show_all_participants.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/screens/participant_screen.dart';
import 'package:rpgl/widgets/MatchCard.dart';

class TeamAndParticipantScreen extends StatefulWidget {
  final String imageUrl; // This can be a file path or URL
  final String teamId; // This can be a file path or URL

  const TeamAndParticipantScreen(
      {super.key, required this.imageUrl, required this.teamId});
  @override
  _TeamAndParticipantScreenState createState() =>
      _TeamAndParticipantScreenState();
}

class _TeamAndParticipantScreenState extends State<TeamAndParticipantScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isAppBarExpanded = _scrollController.hasClients &&
            _scrollController.offset < (200 - kToolbarHeight);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Updated to match the number of tabs
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: AppThemes.getBackground(),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                    Container(
                      color: _isAppBarExpanded
                          ? Colors.black.withOpacity(0.5)
                          : Colors.white,
                    ),
                  ],
                ),
                title: const Text(
                  'Team & Participant',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 56),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: ColoredBox(
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: AppThemes.getBackground(),
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.getBackground()),
                    unselectedLabelStyle: const TextStyle(fontSize: 16),
                    tabs: [
                      const Tab(text: 'Members'),
                      const Tab(text: 'Schedule'),
                      const Tab(text: 'Results'),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  // Members Tab
                  MembersTab(
                    teamId: widget.teamId,
                    teamImage: widget.imageUrl,
                  ),
                  // Schedule Tab
                  ScheduleTab(
                    teamId: widget.teamId,
                  ),
                  // Results Tab
                  ResultTab(
                    teamId: widget.teamId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultTab extends StatefulWidget {
  final String teamId; // Add teamId as a parameter

  const ResultTab({Key? key, required this.teamId}) : super(key: key);

  @override
  State<ResultTab> createState() => _ResultTabState();
}

class _ResultTabState extends State<ResultTab> {
  List<Group> matches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      // Fetch data from API
      ScheduleAPI scheduleAPI = await ScheduleAPI.matchlist();

      List<Group> allMatches = [];

      // Check if scheduleAndResultsDetails is available and fetch matches
      if (scheduleAPI.scheduleAndResultsDetails != null) {
        // Extract matches from the groups map
        scheduleAPI.scheduleAndResultsDetails!.groups?.forEach((key, value) {
          allMatches.addAll(value); // Add all matches from each group
        });
      } else {
        print('No ScheduleAndResultsDetails data found.');
      }

      // Debugging: Print the collected matches
      print(
          'All matches: ${allMatches.map((match) => match.toJson()).toList()}');

      // Filter matches by team ID using widget.teamId
      matches = allMatches
          .where((match) =>
              match.team1Id == widget.teamId || match.team2Id == widget.teamId)
          .toList();

      // Debugging: Print the filtered matches
      print(
          'Filtered matches: ${matches.map((match) => match.toJson()).toList()}');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors here
      print('Error fetching matches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.black));
    }

    if (matches.isEmpty) {
      return const Center(
          child: Text('No matches found for the selected team.'));
    }

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return MatchCard(
          matchNo: match.id!,
          // matchName: match.groupName!, // Uncomment if matchName is needed
          logoA: match.team1ImageUrl!,
          teamA: match.team1!,
          logoB: match.team2ImageUrl!,
          teamB: match.team2!,
          date: match.date!,
          time: match.time!,
          sportsName: match.sportsName!,
          showResult: true,
          result:
              match.results ?? 'No result available', // Provide a default value
        );
      },
    );
  }
}

class ScheduleTab extends StatefulWidget {
  final String teamId; // Add teamId as a parameter

  const ScheduleTab({Key? key, required this.teamId}) : super(key: key);

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  List<Group> matches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      // Fetch data from API
      ScheduleAPI scheduleAPI = await ScheduleAPI.matchlist();

      List<Group> allMatches = [];

      // Check if scheduleAndResultsDetails is available and fetch matches
      if (scheduleAPI.scheduleAndResultsDetails != null) {
        // Extract matches from the groups map
        scheduleAPI.scheduleAndResultsDetails!.groups?.forEach((key, value) {
          allMatches.addAll(value); // Add all matches from each group
        });
      } else {
        print('No ScheduleAndResultsDetails data found.');
      }

      // Debugging: Print the collected matches
      print(
          'All matches: ${allMatches.map((match) => match.toJson()).toList()}');

      // Filter matches by team ID using widget.teamId
      matches = allMatches
          .where((match) =>
              match.team1Id == widget.teamId || match.team2Id == widget.teamId)
          .toList();

      // Debugging: Print the filtered matches
      print(
          'Filtered matches: ${matches.map((match) => match.toJson()).toList()}');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors here
      print('Error fetching matches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.black));
    }

    if (matches.isEmpty) {
      return const Center(
          child: Text('No matches found for the selected team.'));
    }

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return MatchCard(
          matchNo: match.id!,
          // matchName: match.groupName!, // Uncomment if matchName is needed
          logoA: match.team1ImageUrl!,
          teamA: match.team1!,
          logoB: match.team2ImageUrl!,
          teamB: match.team2!,
          date: match.date!,
          time: match.time!,
          sportsName: match.sportsName!,
        );
      },
    );
  }
}

class MembersTab extends StatefulWidget {
  final String teamId; // This can be a file path or URL
  final String teamImage; // This can be a file path or URL

  const MembersTab({super.key, required this.teamId, required this.teamImage});
  @override
  _MembersTabState createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  late Future<ShowAllParticipantsAPI> futureParticipants;

  @override
  void initState() {
    super.initState();
    futureParticipants = ShowAllParticipantsAPI.leaderboardlist();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<ShowAllParticipantsAPI>(
        future: futureParticipants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.allParticipantDetails!.isEmpty) {
            return const Center(child: Text('No participants found.'));
          } else {
            // Filter participants by teamId
            final filteredParticipants = snapshot.data!.allParticipantDetails!
                .where((participant) => participant.teamId == widget.teamId)
                .toList();

            if (filteredParticipants.isEmpty) {
              return const Center(
                  child: Text('No participants found for this team.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Table header
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppThemes.getBackground()),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'SP',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppThemes.getBackground()),
                      ),
                    ),
                    // Expanded(
                    //   child: Text(
                    //     'TG',
                    //     style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //         color: AppThemes.getBackground()),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: Text(
                    //     'A',
                    //     style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //         color: AppThemes.getBackground()),
                    //   ),
                    // ),
                  ],
                ),
                const Divider(thickness: 2),
                // Table rows
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredParticipants.length,
                    itemBuilder: (context, index) {
                      final participant = filteredParticipants[index];
                      return PlayerRows(
                        name: participant.participantName ?? 'Unknown',
                        image: participant.participantImage ?? '',
                        sports: participant.sports?.isNotEmpty == true
                            ? participant.sports!
                            : ['No sports'],
                        // score: participant.totalGames ?? '0',
                        // minutesPlayed: participant.achievements ?? '0',
                        teamImage: widget.teamImage,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class PlayerRows extends StatefulWidget {
  final String name;
  final String image;
  final String teamImage;
  final List<String> sports;
  // final String score;
  // final String minutesPlayed;

  const PlayerRows({
    super.key,
    required this.name,
    required this.image,
    required this.sports,
    // required this.score,
    // required this.minutesPlayed,
    required this.teamImage,
  });

  @override
  State<PlayerRows> createState() => _PlayerRowsState();
}

class _PlayerRowsState extends State<PlayerRows> with TickerProviderStateMixin {
  bool showSportsName = false;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late List<AnimationController> _staggeredControllers;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _staggeredControllers = List.generate(
      widget.sports.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + index * 100),
        vsync: this,
      ),
    );

    _staggeredAnimations = _staggeredControllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      );
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _staggeredControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => setState(() {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ProfilePage(
      //               teamImage: '${widget.teamImage}',
      //               participantImage: '${widget.image}',
      //             )),
      //   );
      // }),
      onLongPress: () {
        setState(() {
          showSportsName = !showSportsName;
          if (showSportsName) {
            _controller.forward();
            for (var controller in _staggeredControllers) {
              controller.forward();
            }
          } else {
            _controller.reverse();
            for (var controller in _staggeredControllers) {
              controller.reverse();
            }
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: widget.image.isNotEmpty
                            ? NetworkImage(widget.image)
                            : null,
                        child: widget.image.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 24,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ...List.generate(
                          widget.sports
                              .take(3)
                              .where((sport) => sport.isNotEmpty)
                              .length,
                          (index) {
                            return Positioned(
                              left: index * 20.0,
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.sports,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        if (widget.sports.length > 3)
                          Positioned(
                            left: 60.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '+${widget.sports.length - 3}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     widget.score,
                //     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                //   ),
                // ),
                // Expanded(
                //   child: Text(
                //     widget.minutesPlayed,
                //     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                //   ),
                // ),
              ],
            ),
            // Animated Sports dropdown
            SizeTransition(
              sizeFactor: _heightAnimation,
              axis: Axis.vertical,
              axisAlignment: -1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.sports.asMap().entries.map((entry) {
                    int index = entry.key;
                    String sport = entry.value;
                    return FadeTransition(
                      opacity: _staggeredAnimations[index],
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(_staggeredAnimations[index]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: sport == 'No sports'
                                  ? Colors.red
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              sport,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
