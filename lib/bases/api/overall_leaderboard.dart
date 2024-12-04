import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class OverallLeaderboard {
  String? processSts;
  String? processMsg;
  List<LeaderboardValues>? leaderboardValues;

  OverallLeaderboard(
      {this.processSts, this.processMsg, this.leaderboardValues});

  OverallLeaderboard.fromJson(Map<String, dynamic> json) {
    processSts = json['process_sts'];
    processMsg = json['process_msg'];
    if (json['leaderboard_values'] != null) {
      leaderboardValues = <LeaderboardValues>[];
      json['leaderboard_values'].forEach((v) {
        leaderboardValues!.add(new LeaderboardValues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_sts'] = this.processSts;
    data['process_msg'] = this.processMsg;
    if (this.leaderboardValues != null) {
      data['leaderboard_values'] =
          this.leaderboardValues!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<OverallLeaderboard> fetchOverallLeaderboard() async {
    Uri url =
        Uri.parse("${Webservice.rootURL}${Webservice.leaderboard_overall_api}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    request.fields.addAll({'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print('OverallLeaderboard response: ${responseString}');
    return OverallLeaderboard.fromJson(jsonDecode(responseString));
  }
}

class LeaderboardValues {
  String? teamName;
  String? teamImage;
  List<SportsDetails>? sportsDetails;

  LeaderboardValues({this.teamName, this.sportsDetails});

  LeaderboardValues.fromJson(Map<String, dynamic> json) {
    teamName = json['team_name'];
    teamImage = json['team_image'];
    if (json['sports_details'] != null) {
      sportsDetails = <SportsDetails>[];
      json['sports_details'].forEach((v) {
        sportsDetails!.add(new SportsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_name'] = this.teamName;
    data['team_image'] = this.teamImage;
    if (this.sportsDetails != null) {
      data['sports_details'] =
          this.sportsDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SportsDetails {
  String? sportsName;
  String? sportsValue;

  SportsDetails({this.sportsName, this.sportsValue});

  SportsDetails.fromJson(Map<String, dynamic> json) {
    sportsName = json['sports_name'];
    sportsValue = json['sports_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sports_name'] = this.sportsName;
    data['sports_value'] = this.sportsValue;
    return data;
  }
}
