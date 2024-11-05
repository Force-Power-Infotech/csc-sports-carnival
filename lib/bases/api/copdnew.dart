import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class CopdnewAPI {
  String? processSts;
  String? processMsg;
  List<SportsDetails>? sportsDetails;

  CopdnewAPI({this.processSts, this.processMsg, this.sportsDetails});

  CopdnewAPI.fromJson(Map<String, dynamic> json) {
    processSts = json['process_sts'];
    processMsg = json['process_msg'];
    if (json['sports_details'] != null) {
      sportsDetails = <SportsDetails>[];
      json['sports_details'].forEach((v) {
        sportsDetails!.add(new SportsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_sts'] = this.processSts;
    data['process_msg'] = this.processMsg;
    if (this.sportsDetails != null) {
      data['sports_details'] =
          this.sportsDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<CopdnewAPI> pdflist() async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.copd_api}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    request.fields.addAll({'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    return CopdnewAPI.fromJson(jsonDecode(responseString));
  }
}

class SportsDetails {
  String? sportsName;
  String? sportsLogo;
  String? webview;

  SportsDetails({this.sportsName, this.sportsLogo, this.webview});

  SportsDetails.fromJson(Map<String, dynamic> json) {
    sportsName = json['sports_name'];
    sportsLogo = json['sports_logo'];
    webview = json['webview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sports_name'] = this.sportsName;
    data['sports_logo'] = this.sportsLogo;
    data['webview'] = this.webview;
    return data;
  }
}
