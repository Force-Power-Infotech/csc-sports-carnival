import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/schedule.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/widgets/MatchCard.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  List<String> options = []; // Updated with API data
  List<List<Map<String, String>>> matches = [];
  bool _isLoading = true;
  bool _fetchError = false;

  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }

  Future<void> _fetchScheduleData() async {
    setState(() {
      _isLoading = true;
      _fetchError = false;
    });
    try {
      ScheduleAPI scheduleAPI = await ScheduleAPI.matchlist();
      if (scheduleAPI.scheduleAndResultsDetails?.groups != null) {
        List<String> fetchedOptions = [];
        List<List<Map<String, String>>> fetchedMatches = [];

        scheduleAPI.scheduleAndResultsDetails?.groups
            ?.forEach((groupName, groupList) {
          fetchedOptions.add(groupName);
          List<Map<String, String>> groupMatches = groupList
              .map((group) {
                return {
                  'matchNo': group.id ?? '',
                  'teamA': group.team1 ?? '',
                  'logoA': group.team1ImageUrl ?? '',
                  'teamB': group.team2 ?? '',
                  'logoB': group.team2ImageUrl ?? '',
                  'date': group.date ?? '',
                  'time': group.time ?? '',
                  'result': group.results ?? '',
                };
              })
              .where((match) =>
                  match['result']?.isNotEmpty ??
                  false) // Filter out matches with null/empty results
              .toList();
          fetchedMatches.add(groupMatches);
        });

        setState(() {
          options = fetchedOptions;
          matches = fetchedMatches;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching schedule data: $e');
      setState(() {
        _isLoading = false;
        _fetchError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Results',
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
              child: CircularProgressIndicator(color: Colors.black),
            )
          : _fetchError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error,
                          color: Colors.redAccent, size: 60),
                      const SizedBox(height: 10),
                      const Text(
                        'Failed to load results.',
                        style: TextStyle(fontSize: 18, color: Colors.redAccent),
                      ),
                      TextButton(
                        onPressed: _fetchScheduleData,
                        child: const Text('Retry'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                )
              : options.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.grey, size: 60),
                          SizedBox(height: 10),
                          Text(
                            'No Results Available',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                    _pageController.animateToPage(
                                      index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == index
                                          ? AppThemes.getBackground()
                                              .withOpacity(0.8)
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: _selectedIndex == index
                                          ? [
                                              BoxShadow(
                                                color: AppThemes.getBackground()
                                                    .withOpacity(0.3),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    child: Center(
                                      child: Text(
                                        options[index],
                                        style: TextStyle(
                                          color: _selectedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            itemCount: matches.length,
                            itemBuilder: (context, index) {
                              final groupMatches = matches[index];
                              return groupMatches.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.sports_soccer,
                                            color: Colors.grey.shade400,
                                            size: 80,
                                          ),
                                          const SizedBox(height: 20),
                                          const Text(
                                            'No results for now.',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Stay tuned! Results will be updated soon.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: _fetchScheduleData,
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                              backgroundColor:
                                                  AppThemes.getBackground(),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text(
                                              'Refresh',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: groupMatches.length,
                                      itemBuilder: (context, matchIndex) {
                                        final match = groupMatches[matchIndex];
                                        return MatchCard(
                                          matchNo: match['matchNo']!,
                                          logoA: match['logoA']!,
                                          teamA: match['teamA']!,
                                          logoB: match['logoB']!,
                                          teamB: match['teamB']!,
                                          date: match['date']!,
                                          time: match['time']!,
                                          sportsName: match['sportsName'] ?? '',
                                          showResult: true,
                                          result: match['result']!,
                                          location: match['location'] ?? '',
                                        );
                                      },
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }
}
