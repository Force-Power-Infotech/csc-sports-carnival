import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:rpgl/bases/api/ownerLogin.dart';
import 'package:rpgl/bases/api/tokenStorage.dart';
import 'package:rpgl/bases/webservice.dart';

class PushnotficationAPI {
  String? status;
  String? message;

  PushnotficationAPI({this.status, this.message});

  PushnotficationAPI.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }

  static Future<PushnotficationAPI> pushnotification() async {
    String? memberId;
    String? token = TokenStorage.fcmToken;
    if (token != null) {
      log(token);
    } else {
      log('Token is null');
    }
    try {
      // Try to retrieve the OwnerLoginAPI data locally
      final ownerLoginAPI = await OwnerLoginAPI.readDataLocally();
      if (ownerLoginAPI != null) {
        // Extract member ID from the retrieved data
        memberId = ownerLoginAPI.participantData?.memberId;
      } else {
        print("OwnerLoginAPI data not found locally");
      }
    } catch (e) {
      print("Error retrieving OwnerLoginAPI data: $e");
    }

    // Construct the URL
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.pn}?reg_id=$token");
    final request = http.MultipartRequest('POST', url);
    print(url);

    // Add memberId to the request fields if it exists
    if (memberId != null) {
      request.fields.addAll({'memberid': memberId});
    }

    // Send the request
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    log(responseString);

    // Parse and return the response
    return PushnotficationAPI.fromJson(jsonDecode(responseString));
  }
}
