import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/participantapi.dart';

class SquadScreen extends StatelessWidget {
  final int fieldCount;
  final String teamid;

  SquadScreen({required this.fieldCount, required this.teamid});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: FutureBuilder<ParticipantAPI>(
          future: ParticipantAPI.participantlist(teamid, 'cricket'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.white);
            }
            return Text(
              snapshot.data?.sportsHeadingName ?? 'Squad Selection',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MatchDetailsCard(),
              const SizedBox(height: 10),
              SquadForm(fieldCount: fieldCount, teamid: teamid),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Match Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Team A vs Team B',
            style: TextStyle(
                color: Colors.grey.shade300, fontSize: screenWidth * 0.035),
          ),
          const SizedBox(height: 4),
          Text(
            'Date: Oct 30, 2024 | Time: 3:00 PM',
            style: TextStyle(
                color: Colors.grey.shade300, fontSize: screenWidth * 0.035),
          ),
        ],
      ),
    );
  }
}

class SelectedSubheadingsCount extends StatelessWidget {
  final Map<String, int> roleCounts;

  SelectedSubheadingsCount({required this.roleCounts});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.02, horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: roleCounts.entries.map((entry) {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.value}',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SquadForm extends StatefulWidget {
  final int fieldCount;
  final String teamid;

  SquadForm({required this.fieldCount, required this.teamid});

  @override
  _SquadFormState createState() => _SquadFormState();
}

class _SquadFormState extends State<SquadForm> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _controllers = [];
  List<String?> _selectedRoles = [];
  ParticipantAPI? participantData;
  List<String> availablePlayers = [];
  List<String> subheadings = [];
  Map<String, int> roleCounts = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchParticipantData();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.fieldCount; i++) {
      _controllers.add(TextEditingController());
      _selectedRoles.add(null);
    }
  }

  Future<void> _fetchParticipantData() async {
    ParticipantAPI data =
        await ParticipantAPI.participantlist(widget.teamid, 'cricket');
    setState(() {
      participantData = data;
      availablePlayers = List<String>.from(data.playerNames ?? []);
      subheadings = [
        data.subheading1 ?? 'Batsman',
        data.subheading2 ?? 'Bowler',
        data.subheading3 ?? 'Allrounder',
        data.subheading4 ?? 'Wicket Keeper',
      ];
      for (var subheading in subheadings) {
        roleCounts[subheading] = 0;
      }
    });
  }

  Widget _buildPlayerRow(String label, int index) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              // image: const DecorationImage(
              //   image: AssetImage('assets/images/player_placeholder.png'),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  availablePlayers.isNotEmpty
                      ? availablePlayers[index % availablePlayers.length]
                      : label,
                  style: TextStyle(
                      color: Colors.black, fontSize: screenWidth * 0.04),
                ),
                if (_selectedRoles[index] != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.01,
                      horizontal: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87, // Dark background color
                      borderRadius: BorderRadius.circular(8), // Rounded edges
                    ),
                    child: Text(
                      _selectedRoles[index]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                  )
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String selectedRole) {
              setState(() {
                _selectedRoles[index] = selectedRole;
              });
            },
            itemBuilder: (BuildContext context) {
              return subheadings.map((String role) {
                return PopupMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList();
            },
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: const CircleBorder(),
                minimumSize: Size(screenWidth * 0.12,
                    screenWidth * 0.12), // Adjusts the size of the circle
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SelectedSubheadingsCount(roleCounts: roleCounts),
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.fieldCount,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildPlayerRow('Player ${index + 1}', index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
