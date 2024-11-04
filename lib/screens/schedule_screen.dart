import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/schedule.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/bases/webservice.dart';
import 'package:rpgl/widgets/MatchCard.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  List<String> options = []; // This will be updated with API data
  List<List<Map<String, String>>> matches = [];
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }

  Future<void> _fetchScheduleData() async {
    try {
      ScheduleAPI scheduleAPI = await ScheduleAPI.matchlist();
      if (scheduleAPI.scheduleAndResultsDetails?.groups != null) {
        List<String> fetchedOptions = [];
        List<List<Map<String, String>>> fetchedMatches = [];

        scheduleAPI.scheduleAndResultsDetails?.groups
            ?.forEach((groupName, groupList) {
          fetchedOptions.add(groupName);
          List<Map<String, String>> groupMatches = groupList.map((group) {
            return {
              'matchNo': group.id ?? '',
              'teamA': group.team1 ?? '',
              'logoA': group.team1ImageUrl ?? '',
              'teamB': group.team2 ?? '',
              'logoB': group.team2ImageUrl ?? '',
              'date': group.date ?? '',
              'time': group.time ?? '',
              'sports_name': group.sportsName ?? '',
            };
          }).toList();
          fetchedMatches.add(groupMatches);
        });

        setState(() {
          options = fetchedOptions;
          matches = fetchedMatches;
          _isLoading = false; // Data has been fetched
        });
      }
    } catch (e) {
      print('Error fetching schedule data: $e');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule',
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
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black, // Black loader color
                ),
              )
            : Column(
                children: [
                  SizedBox(
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
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: _selectedIndex == index
                                  ? Border(
                                      bottom: BorderSide(
                                        color: AppThemes.getBackground(),
                                        width: 2.0,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                options[index],
                                style: TextStyle(
                                  color: _selectedIndex == index
                                      ? AppThemes.getBackground()
                                      : Colors.black,
                                  fontWeight: _selectedIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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
                        return ListView.builder(
                          itemCount: matches[index].length,
                          itemBuilder: (context, matchIndex) {
                            final match = matches[index][matchIndex];
                            return MatchCard(
                              matchNo: match['matchNo']!,
                              logoA: match['logoA']!,
                              teamA: match['teamA']!,
                              logoB: match['logoB']!,
                              teamB: match['teamB']!,
                              date: match['date']!,
                              time: match['time']!,
                              sportsName: match['sports_name']!,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
