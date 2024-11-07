import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/show_team_and_participants_details.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/screens/team_splash_screen.dart';

class OwnersAndTeamsScreen extends StatefulWidget {
  @override
  _OwnersAndTeamsScreenState createState() => _OwnersAndTeamsScreenState();
}

class _OwnersAndTeamsScreenState extends State<OwnersAndTeamsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = true;
  TeamAndParticipantsDetails? teamAndParticipantsDetails;
  bool isLoading = true;
  bool hasError = false;

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
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        hasError = true;
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
          SliverPadding(
            padding: const EdgeInsets.only(top: 0.0),
            sliver: isLoading
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : hasError ||
                        (teamAndParticipantsDetails?.groups?.isEmpty ?? true)
                    ? SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off,
                                  size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                hasError
                                    ? 'Connection Error'
                                    : 'No Data Available',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                hasError
                                    ? 'Please check your internet connection and try again.'
                                    : 'There are currently no team and participant details to show.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
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
                                                  backgroundColor:
                                                      Colors.grey[400],
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
