import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class DeleteAccountAPI {
  String? processStatus;
  String? processMessage;

  DeleteAccountAPI({this.processStatus, this.processMessage});

  DeleteAccountAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    return data;
  }

  static Future<DeleteAccountAPI> deleteaccount(String memberid) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.del_acc_api}?member_id=${memberid}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    request.fields.addAll({'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    return DeleteAccountAPI.fromJson(jsonDecode(responseString));
  }
}
