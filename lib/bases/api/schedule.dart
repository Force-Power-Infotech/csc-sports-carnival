import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class ScheduleAPI {
  String? processSts;
  String? processMsg;
  ScheduleAndResultsDetails? scheduleAndResultsDetails;
  List<ChallengerRound>? challengerRound;
  List<FinalRound>? finalRound;

  ScheduleAPI(
      {this.processSts,
      this.processMsg,
      this.scheduleAndResultsDetails,
      this.challengerRound,
      this.finalRound});

  ScheduleAPI.fromJson(Map<String, dynamic> json) {
    processSts = json['process_sts'];
    processMsg = json['process_msg'];
    scheduleAndResultsDetails = json['schedule_and_results_details'] != null
        ? ScheduleAndResultsDetails.fromJson(
            json['schedule_and_results_details'])
        : null;
    if (json['challenger_round'] != null) {
      challengerRound = <ChallengerRound>[];
      json['challenger_round'].forEach((v) {
        challengerRound!.add(ChallengerRound.fromJson(v));
      });
    }
    if (json['final_round'] != null) {
      finalRound = <FinalRound>[];
      json['final_round'].forEach((v) {
        finalRound!.add(FinalRound.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['process_sts'] = processSts;
    data['process_msg'] = processMsg;
    if (scheduleAndResultsDetails != null) {
      data['schedule_and_results_details'] =
          scheduleAndResultsDetails!.toJson();
    }
    if (challengerRound != null) {
      data['challenger_round'] =
          challengerRound!.map((v) => v.toJson()).toList();
    }
    if (finalRound != null) {
      data['final_round'] = finalRound!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<ScheduleAPI> matchlist() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.show_schedule_and_results_details_new}");
    final request = http.MultipartRequest('POST', url);
    print(url);

    request.fields.addAll({'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return ScheduleAPI.fromJson(jsonDecode(responseString));
  }
}

class ScheduleAndResultsDetails {
  Map<String, List<Group>>? groups;

  ScheduleAndResultsDetails({this.groups});

  ScheduleAndResultsDetails.fromJson(Map<String, dynamic> json) {
    groups = {};
    json.forEach((key, value) {
      groups![key] = (value as List).map((v) => Group.fromJson(v)).toList();
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (groups != null) {
      groups!.forEach((key, value) {
        data[key] = value.map((v) => v.toJson()).toList();
      });
    }
    return data;
  }
}

class Group {
  String? id;
  String? date;
  String? time;
  String? sportsName;
  String? groupName;
  String? teams;
  String? team1Id;
  String? team1;
  String? team1ImageUrl;
  String? team2Id;
  String? team2;
  String? team2ImageUrl;
  String? results;
  String? scoreBoard;
  String? winnerName;
  String? text1;
  String? text2;
  String? buttonStatus;
  String? imageName;
  String? location;
  ResultData? resultData;

  Group(
      {this.id,
      this.date,
      this.time,
      this.groupName,
      this.teams,
      this.team1Id,
      this.team1,
      this.team1ImageUrl,
      this.team2Id,
      this.team2,
      this.team2ImageUrl,
      this.results,
      this.scoreBoard,
      this.winnerName,
      this.text1,
      this.text2,
      this.buttonStatus,
      this.imageName,
      this.sportsName,
      this.location,
      this.resultData});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    groupName = json['group_name'];
    teams = json['teams'];
    team1Id = json['team1_id'];
    team1 = json['team1'];
    team1ImageUrl = json['team1_image_url'];
    team2Id = json['team2_id'];
    team2 = json['team2'];
    team2ImageUrl = json['team2_image_url'];
    results = json['results'];
    scoreBoard = json['score_board'];
    winnerName = json['winner_name'];
    text1 = json['text1'];
    text2 = json['text2'];
    buttonStatus = json['button_status'];
    imageName = json['image_name'];
    sportsName = json['sports_name'];
    location = json['location'];
    resultData = json['result_data'] != null
        ? ResultData.fromJson(json['result_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['date'] = date;
    data['time'] = time;
    data['group_name'] = groupName;
    data['teams'] = teams;
    data['team1_id'] = team1Id;
    data['team1'] = team1;
    data['team1_image_url'] = team1ImageUrl;
    data['team2_id'] = team2Id;
    data['team2'] = team2;
    data['team2_image_url'] = team2ImageUrl;
    data['results'] = results;
    data['score_board'] = scoreBoard;
    data['winner_name'] = winnerName;
    data['text1'] = text1;
    data['text2'] = text2;
    data['button_status'] = buttonStatus;
    data['image_name'] = imageName;
    data['sports_name'] = sportsName;
    data['location'] = location;
    if (resultData != null) {
      data['result_data'] = resultData!.toJson();
    }
    return data;
  }
}

class ResultData {
  Map<String, Game>? games;

  ResultData({this.games});

  ResultData.fromJson(Map<String, dynamic> json) {
    games = {};
    json.forEach((key, value) {
      games![key] = Game.fromJson(value);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (games != null) {
      games!.forEach((key, value) {
        data[key] = value.toJson();
      });
    }
    return data;
  }
}

class Game {
  String? team1Participants;
  String? team1Score;
  String? team2Participants;
  String? team2Score;
  String? historyWebLink;

  Game(
      {this.team1Participants,
      this.team1Score,
      this.team2Participants,
      this.team2Score,
      this.historyWebLink});

  Game.fromJson(Map<String, dynamic> json) {
    team1Participants = json['team_1_participants'];
    team1Score = json['team_1_score'];
    team2Participants = json['team_2_participants'];
    team2Score = json['team_2_score'];
    historyWebLink = json['history_web_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['team_1_participants'] = team1Participants;
    data['team_1_score'] = team1Score;
    data['team_2_participants'] = team2Participants;
    data['team_2_score'] = team2Score;
    data['history_web_link'] = historyWebLink;
    return data;
  }
}

class ChallengerRound extends Group {
  ChallengerRound(
      {id,
      date,
      time,
      groupName,
      teams,
      team1Id,
      team1,
      team1ImageUrl,
      team2Id,
      team2,
      team2ImageUrl,
      results,
      scoreBoard,
      winnerName,
      text1,
      text2,
      imageName,
      resultData})
      : super(
            id: id,
            date: date,
            time: time,
            groupName: groupName,
            teams: teams,
            team1Id: team1Id,
            team1: team1,
            team1ImageUrl: team1ImageUrl,
            team2Id: team2Id,
            team2: team2,
            team2ImageUrl: team2ImageUrl,
            results: results,
            scoreBoard: scoreBoard,
            winnerName: winnerName,
            text1: text1,
            text2: text2,
            imageName: imageName,
            resultData: resultData);

  ChallengerRound.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class FinalRound extends Group {
  FinalRound(
      {id,
      date,
      time,
      groupName,
      teams,
      team1Id,
      team1,
      team1ImageUrl,
      team2Id,
      team2,
      team2ImageUrl,
      results,
      scoreBoard,
      winnerName,
      text1,
      text2,
      imageName,
      resultData})
      : super(
            id: id,
            date: date,
            time: time,
            groupName: groupName,
            teams: teams,
            team1Id: team1Id,
            team1: team1,
            team1ImageUrl: team1ImageUrl,
            team2Id: team2Id,
            team2: team2,
            team2ImageUrl: team2ImageUrl,
            results: results,
            scoreBoard: scoreBoard,
            winnerName: winnerName,
            text1: text1,
            text2: text2,
            imageName: imageName,
            resultData: resultData);

  FinalRound.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
