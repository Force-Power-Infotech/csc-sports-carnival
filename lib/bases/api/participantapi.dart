import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class ParticipantAPI {
  String? processSts;
  String? processMsg;
  String? sportsHeadingName;
  String? sportsName;
  String? leagueid;
  String? subheading1;
  String? subheading2;
  String? subheading3;
  String? subheading4;
  List<String>? playerNames;

  ParticipantAPI(
      {this.processSts,
      this.processMsg,
      this.sportsHeadingName,
      this.sportsName,
      this.leagueid,
      this.subheading1,
      this.subheading2,
      this.subheading3,
      this.subheading4,
      this.playerNames});

  ParticipantAPI.fromJson(Map<String, dynamic> json) {
    processSts = json['process_sts'];
    processMsg = json['process_msg'];
    sportsHeadingName = json['sports_heading_name'];
    sportsName = json['sports_name'];
    leagueid = json['leagueid'];
    subheading1 = json['subheading1'];
    subheading2 = json['subheading2'];
    subheading3 = json['subheading3'];
    subheading4 = json['subheading4'];
    playerNames = (json['player_names'] != null)
        ? List<String>.from(json['player_names'])
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_sts'] = this.processSts;
    data['process_msg'] = this.processMsg;
    data['sports_heading_name'] = this.sportsHeadingName;
    data['sports_name'] = this.sportsName;
    data['leagueid'] = this.leagueid;
    data['subheading1'] = this.subheading1;
    data['subheading2'] = this.subheading2;
    data['subheading3'] = this.subheading3;
    data['subheading4'] = this.subheading4;
    data['player_names'] = this.playerNames;
    return data;
  }

  static Future<ParticipantAPI> participantlist(
      String teamid, String sportsname) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.update_perticipant_for_game_v2}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    request.fields.addAll({
      'leagueid': Webservice.appNickname,
      'sports_name': sportsname,
      'team_id': teamid,
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print('Response: $responseString'); // Print the response to debug

    return ParticipantAPI.fromJson(jsonDecode(responseString));
  }
}
