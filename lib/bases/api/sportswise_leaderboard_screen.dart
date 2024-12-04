import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class SportsWiselbAPI {
  String? processSts;
  String? processMsg;
  List<SportsData>? sportsData;

  SportsWiselbAPI({this.processSts, this.processMsg, this.sportsData});

  SportsWiselbAPI.fromJson(Map<String, dynamic> json) {
    processSts = json['process_sts'];
    processMsg = json['process_msg'];
    if (json['sports_data'] != null) {
      sportsData = <SportsData>[];
      json['sports_data'].forEach((v) {
        sportsData!.add(new SportsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_sts'] = this.processSts;
    data['process_msg'] = this.processMsg;
    if (this.sportsData != null) {
      data['sports_data'] = this.sportsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<SportsWiselbAPI> fetchOverallLeaderboard() async {
    Uri url =
        Uri.parse("${Webservice.rootURL}${Webservice.leaderboard_overall_api}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    request.fields.addAll({'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print('SportsWise response: ${responseString}');
    return SportsWiselbAPI.fromJson(jsonDecode(responseString));
  }
}

class SportsData {
  String? sportsName;
  List<Groups>? groups;

  SportsData({this.sportsName, this.groups});

  SportsData.fromJson(Map<String, dynamic> json) {
    sportsName = json['sports_name'];
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(new Groups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sports_name'] = this.sportsName;
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Groups {
  String? groupName;
  List<Teams>? teams;

  Groups({this.groupName, this.teams});

  Groups.fromJson(Map<String, dynamic> json) {
    groupName = json['group_name'];
    if (json['teams'] != null) {
      teams = <Teams>[];
      json['teams'].forEach((v) {
        teams!.add(new Teams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_name'] = this.groupName;
    if (this.teams != null) {
      data['teams'] = this.teams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teams {
  String? teamName;
  String? rank;
  String? matchesPlayed;
  String? matchesWon;
  String? matchesLost;
  String? totalPoints;
  String? legsWon;

  Teams(
      {this.teamName,
      this.rank,
      this.matchesPlayed,
      this.matchesWon,
      this.matchesLost,
      this.totalPoints,
      this.legsWon});

  Teams.fromJson(Map<String, dynamic> json) {
    teamName = json['team_name'];
    rank = json['rank'];
    matchesPlayed = json['matches_played'];
    matchesWon = json['matches_won'];
    matchesLost = json['matches_lost'];
    totalPoints = json['total_points'];
    legsWon = json['legs_won'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_name'] = this.teamName;
    data['rank'] = this.rank;
    data['matches_played'] = this.matchesPlayed;
    data['matches_won'] = this.matchesWon;
    data['matches_lost'] = this.matchesLost;
    data['total_points'] = this.totalPoints;
    data['legs_won'] = this.legsWon;
    return data;
  }
}
