import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class VersionCheckAPI {
  String? processStatus;
  String? processMessage;
  String? currentAppVersion;
  String? mandatory;
  String? homescreenFullPopupImageLink;
  String? appLiveScoreViewType;

  VersionCheckAPI(
      {this.processStatus,
      this.processMessage,
      this.currentAppVersion,
      this.mandatory,
      this.homescreenFullPopupImageLink,
      this.appLiveScoreViewType});

  VersionCheckAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    currentAppVersion = json['current_app_version'];
    mandatory = json['mandatory'];
    homescreenFullPopupImageLink = json['homescreen_full_popup_image_link'];
    appLiveScoreViewType = json['app_live_score_view_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    data['current_app_version'] = this.currentAppVersion;
    data['mandatory'] = this.mandatory;
    data['homescreen_full_popup_image_link'] =
        this.homescreenFullPopupImageLink;
    data['app_live_score_view_type'] = this.appLiveScoreViewType;
    return data;
  }

// Inside the VersionCheckAPI class
  static Future<VersionCheckAPI> versioncheck() async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.versionCheck}");
    final request = http.MultipartRequest('POST', url);
    print(url);

    // Set device_type based on the platform
    String deviceType = Platform.isAndroid ? 'ANDROID' : 'IOS';
    request.fields.addAll(
        {'device_type': deviceType, 'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return VersionCheckAPI.fromJson(jsonDecode(responseString));
  }
}
