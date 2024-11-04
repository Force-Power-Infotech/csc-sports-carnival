import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class OwnerLoginAPI {
  String? processStatus;
  String? processMessage;
  String? oTP;
  String? memberType;
  String? adminStatus;
  String? participantImage;
  ParticipantData? participantData;
  String? showMatchInLive;
  String? bothTeamParticipantSet;
  String? myTeamAdminName;
  String? scoreUpdateWeblink;
  String? accessibleMessage;

  OwnerLoginAPI(
      {this.processStatus,
      this.processMessage,
      this.oTP,
      this.memberType,
      this.adminStatus,
      this.participantImage,
      this.participantData,
      this.showMatchInLive,
      this.bothTeamParticipantSet,
      this.myTeamAdminName,
      this.scoreUpdateWeblink,
      this.accessibleMessage});

  OwnerLoginAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    oTP = json['OTP'];
    memberType = json['member_type'];
    adminStatus = json['admin_status'];
    participantImage = json['participant_image'];
    participantData = json['participant_data'] != null
        ? ParticipantData.fromJson(
            Map<String, dynamic>.from(json['participant_data']))
        : null;

    showMatchInLive = json['show_match_in_live'];
    bothTeamParticipantSet = json['both_team_participant_set'];
    myTeamAdminName = json['my_team_admin_name'];
    scoreUpdateWeblink = json['score_update_weblink'];
    accessibleMessage = json['accessible_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    data['OTP'] = oTP;
    data['member_type'] = memberType;
    data['admin_status'] = adminStatus;
    data['participant_image'] = participantImage;
    if (participantData != null) {
      data['participant_data'] = participantData!.toJson();
    }
    data['show_match_in_live'] = showMatchInLive;
    data['both_team_participant_set'] = bothTeamParticipantSet;
    data['my_team_admin_name'] = myTeamAdminName;
    data['score_update_weblink'] = scoreUpdateWeblink;
    data['accessible_message'] = accessibleMessage;
    return data;
  }

  static Future<OwnerLoginAPI> ownerlist(String phonenumber) async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.ws_main_login_v2}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    request.fields.addAll({
      'leagueid': Webservice.appNickname,
      'username': phonenumber,
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return OwnerLoginAPI.fromJson(jsonDecode(responseString));
  }

// Save data locally in Hive
  static Future<void> saveDataLocally(OwnerLoginAPI ownerLoginAPI) async {
    final box = await Hive.openBox('ownerLoginAPI');
    await box.put('ownerLoginAPI', ownerLoginAPI.toJson());
  }

// Read data locally from Hive
  static Future<OwnerLoginAPI?> readDataLocally() async {
    final box = await Hive.openBox('ownerLoginAPI');
    final ownerLoginAPI = box.get('ownerLoginAPI');
    if (ownerLoginAPI == null) return null;

    // Ensure that the data is deserialized correctly
    return OwnerLoginAPI.fromJson(Map<String, dynamic>.from(ownerLoginAPI));
  }

  static Future<void> deleteAllData() async {
    final box = await Hive.openBox('ownerLoginAPI');
    await box.clear(); // This will delete all data from the box
  }
}

class ParticipantData {
  String? processStatus;
  String? processMessage;
  String? teamImage;
  String? todaysMatch;
  String? memberId;
  String? teamName;
  String? memberName;
  String? gameId;
  String? matchId;
  String? opponentTeamName;
  String? opponentParticipantName1;
  String? opponentParticipantName2;
  String? loggedTeamParticipantNames;
  String? memberType;
  String? adminStatus;
  String? teamId;

  ParticipantData(
      {this.processStatus,
      this.processMessage,
      this.teamImage,
      this.todaysMatch,
      this.memberId,
      this.teamName,
      this.memberName,
      this.gameId,
      this.matchId,
      this.opponentTeamName,
      this.opponentParticipantName1,
      this.opponentParticipantName2,
      this.loggedTeamParticipantNames,
      this.memberType,
      this.adminStatus,
      this.teamId});

  ParticipantData.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    teamImage = json['team_image'];
    todaysMatch = json['todays_match'];
    memberId = json['member_id'];
    teamName = json['team_name'];
    memberName = json['member_name'];
    gameId = json['game_id'];
    matchId = json['match_id'];
    opponentTeamName = json['opponent_team_name'];
    opponentParticipantName1 = json['opponent_participant_name_1'];
    opponentParticipantName2 = json['opponent_participant_name_2'];
    loggedTeamParticipantNames = json['logged_team_participant_names'];
    memberType = json['member_type'];
    adminStatus = json['admin_status'];
    teamId = json['team_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    data['team_image'] = teamImage;
    data['todays_match'] = todaysMatch;
    data['member_id'] = memberId;
    data['team_name'] = teamName;
    data['member_name'] = memberName;
    data['game_id'] = gameId;
    data['match_id'] = matchId;
    data['opponent_team_name'] = opponentTeamName;
    data['opponent_participant_name_1'] = opponentParticipantName1;
    data['opponent_participant_name_2'] = opponentParticipantName2;
    data['logged_team_participant_names'] = loggedTeamParticipantNames;
    data['member_type'] = memberType;
    data['admin_status'] = adminStatus;
    data['team_id'] = teamId;
    return data;
  }
}
