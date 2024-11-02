import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/participantapi.dart';
import 'package:rpgl/bases/themes.dart';

class SquadScreen extends StatelessWidget {
  final int fieldCount;
  final String teamid;

  SquadScreen({required this.fieldCount, required this.teamid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: FutureBuilder<ParticipantAPI>(
          future: ParticipantAPI.participantlist(teamid, 'cricket'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.black);
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
        padding: const EdgeInsets.all(16.0),
        child: SquadForm(fieldCount: fieldCount, teamid: teamid),
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
  List<String?> _selectedRoles = []; // Store the selected role for each player
  ParticipantAPI? participantData;
  List<String> availablePlayers = [];
  List<String> subheadings = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchParticipantData();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.fieldCount; i++) {
      _controllers.add(TextEditingController());
      _selectedRoles.add(null); // Initialize each role as null
    }
  }

  Future<void> _fetchParticipantData() async {
    ParticipantAPI data =
        await ParticipantAPI.participantlist(widget.teamid, 'cricket');
    setState(() {
      participantData = data;
      availablePlayers = List<String>.from(data.playerNames ?? []);
      subheadings = [
        data.subheading1 ?? 'Batsman Name',
        data.subheading2 ?? 'Bowler Name',
        data.subheading3 ?? 'Allrounder Name',
        data.subheading4 ?? 'Wicket Keeper Name'
      ];
    });
  }

  Widget _buildField(String label, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return availablePlayers.where((String option) {
                      return option.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          );
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      _controllers[index].text = selection;
                      availablePlayers.remove(selection);
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      controller: textController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: label,
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a player name'
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.red),
                onSelected: (String selectedSubheading) {
                  setState(() {
                    _selectedRoles[index] =
                        selectedSubheading; // Update role for this player
                  });
                },
                itemBuilder: (BuildContext context) {
                  return subheadings.map((String subheading) {
                    return PopupMenuItem<String>(
                      value: subheading,
                      child: Text(subheading),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (participantData != null) ...[
              for (int i = 0; i < widget.fieldCount; i++)
                _buildField('Player ${i + 1}', i),
            ],
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 40.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.red.shade700,
                  elevation: 2,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Collect structured player data with name and selected role
                    List<Map<String, String>> squadData = [];

                    for (int i = 0; i < widget.fieldCount; i++) {
                      String playerName = _controllers[i].text;
                      String? playerRole = _selectedRoles[i] ?? 'Unknown';

                      if (playerName.isNotEmpty) {
                        squadData.add({
                          'name': playerName,
                          'role':
                              playerRole, // Map player name to selected role
                        });
                      }
                    }

                    print(squadData); // Print to console for verification

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Squad Data Saved')),
                    );
                  }
                },
                child: const Text(
                  'Save Squad',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
