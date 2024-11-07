import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class SponsorsAPI {
  String? processSts;
  String? processMsg;
  List<SponsorsDetails>? sponsorsDetails;

  SponsorsAPI({this.processSts, this.processMsg, this.sponsorsDetails});

  SponsorsAPI.fromJson(Map<String, dynamic> json) {
    processSts = json['process_sts'];
    processMsg = json['process_msg'];
    if (json['sponsors_details'] != null) {
      sponsorsDetails = <SponsorsDetails>[];
      json['sponsors_details'].forEach((v) {
        sponsorsDetails!.add(SponsorsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_sts'] = processSts;
    data['process_msg'] = processMsg;
    if (sponsorsDetails != null) {
      data['sponsors_details'] =
          sponsorsDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<SponsorsAPI> sponsorslist() async {
    Uri url =
        Uri.parse("${Webservice.rootURL}${Webservice.show_sponsors_details}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    request.fields.addAll({'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    return SponsorsAPI.fromJson(jsonDecode(responseString));
  }
}

class SponsorsDetails {
  String? id;
  String? ordering;
  String? sponsor;
  String? image;
  String? encodedImageData;
  String? thumbnail;
  String? website;
  String? contactNo;
  String? description;
  String? contactName;
  String? designation;
  String? type;
  String? type1;
  String? phone;
  String? companyProfile;
  String? sponsorType;

  SponsorsDetails(
      {this.id,
      this.ordering,
      this.sponsor,
      this.image,
      this.encodedImageData,
      this.thumbnail,
      this.website,
      this.contactNo,
      this.description,
      this.contactName,
      this.designation,
      this.type,
      this.type1,
      this.phone,
      this.companyProfile,
      this.sponsorType});

  SponsorsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ordering = json['ordering'];
    sponsor = json['sponsor'];
    image = json['image'];
    encodedImageData = json['encoded_image_data'];
    thumbnail = json['thumbnail'];
    website = json['website'];
    contactNo = json['contact_no'];
    description = json['description'];
    contactName = json['contact_name'];
    designation = json['designation'];
    type = json['type'];
    type1 = json['type1'];
    phone = json['phone'];
    companyProfile = json['company_profile'];
    sponsorType = json['sponsor_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ordering'] = ordering;
    data['sponsor'] = sponsor;
    data['image'] = image;
    data['encoded_image_data'] = encodedImageData;
    data['thumbnail'] = thumbnail;
    data['website'] = website;
    data['contact_no'] = contactNo;
    data['description'] = description;
    data['contact_name'] = contactName;
    data['designation'] = designation;
    data['type'] = type;
    data['type1'] = type1;
    data['phone'] = phone;
    data['company_profile'] = companyProfile;
    data['sponsor_type'] = sponsorType;
    return data;
  }
}
