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
      backgroundColor: AppThemes.getBackground(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Captains & Teams',
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
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : hasError ||
                          (teamAndParticipantsDetails?.groups?.isEmpty ?? true)
                      ? Container(
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
                        )
                      : Column(
                          children: teamAndParticipantsDetails?.groups?.values
                                  .expand((group) => group)
                                  .map((team) {
                                return Container(
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16),
                                    elevation: 8,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TeamSplashScreen(
                                              imageUrl: team.theImageLink ?? '',
                                              teamId: team.id ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12.0),
                                              bottomLeft: Radius.circular(12.0),
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey[300],
                                              child: Image.network(
                                                team.theImageLink ?? '',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Center(
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey[400],
                                                      child: const Icon(
                                                          Icons.image,
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    team.team ?? 'Team Name',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    team.owners ?? 'owners',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
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
                              }).toList() ??
                              [],
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
