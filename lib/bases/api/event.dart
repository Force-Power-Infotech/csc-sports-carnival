import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class EventAPI {
  String? processStatus;
  String? processMessage;
  List<EventDetails>? eventDetails;

  EventAPI({this.processStatus, this.processMessage, this.eventDetails});

  EventAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['event_details'] != null) {
      eventDetails = <EventDetails>[];
      json['event_details'].forEach((v) {
        eventDetails!.add(new EventDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    if (this.eventDetails != null) {
      data['event_details'] =
          this.eventDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<EventAPI> eventlist() async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.event_list}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    // request.fields.addAll({'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    log('EventAPI response: ${responseString}');

    return EventAPI.fromJson(jsonDecode(responseString));
  }
}

class EventDetails {
  String? eventid;
  String? eventname;
  String? eventscope;
  String? eventtype;
  String? eventtypeid;
  String? eventhost;
  String? eventhostemail;
  String? eventstartdate;
  String? eventenddate;
  String? chapterid;
  String? chaptername;
  String? areaid;
  String? areaname;
  String? regionid;
  String? regionname;
  String? eventimage;
  String? eventthumbnailimage;
  String? venue;
  String? date;
  String? time;
  String? dateForHeading;
  String? appImageSmall;
  String? appImageMain;
  List<EventButtonArray>? eventButtonArray;
  String? eventLink;

  EventDetails(
      {this.eventid,
      this.eventname,
      this.eventscope,
      this.eventtype,
      this.eventtypeid,
      this.eventhost,
      this.eventhostemail,
      this.eventstartdate,
      this.eventenddate,
      this.chapterid,
      this.chaptername,
      this.areaid,
      this.areaname,
      this.regionid,
      this.regionname,
      this.eventimage,
      this.eventthumbnailimage,
      this.venue,
      this.date,
      this.time,
      this.dateForHeading,
      this.appImageSmall,
      this.appImageMain,
      this.eventButtonArray,
      this.eventLink});

  EventDetails.fromJson(Map<String, dynamic> json) {
    eventid = json['eventid'];
    eventname = json['eventname'];
    eventscope = json['eventscope'];
    eventtype = json['eventtype'];
    eventtypeid = json['eventtypeid'];
    eventhost = json['eventhost'];
    eventhostemail = json['eventhostemail'];
    eventstartdate = json['eventstartdate'];
    eventenddate = json['eventenddate'];
    chapterid = json['chapterid'];
    chaptername = json['chaptername'];
    areaid = json['areaid'];
    areaname = json['areaname'];
    regionid = json['regionid'];
    regionname = json['regionname'];
    eventimage = json['eventimage'];
    eventthumbnailimage = json['eventthumbnailimage'];
    venue = json['venue'];
    date = json['date'];
    time = json['time'];
    dateForHeading = json['date_for_heading'];
    appImageSmall = json['app_image_small'];
    appImageMain = json['app_image_main'];
    if (json['event_button_array'] != null) {
      eventButtonArray = <EventButtonArray>[];
      json['event_button_array'].forEach((v) {
        eventButtonArray!.add(new EventButtonArray.fromJson(v));
      });
    }
    eventLink = json['event_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventid'] = this.eventid;
    data['eventname'] = this.eventname;
    data['eventscope'] = this.eventscope;
    data['eventtype'] = this.eventtype;
    data['eventtypeid'] = this.eventtypeid;
    data['eventhost'] = this.eventhost;
    data['eventhostemail'] = this.eventhostemail;
    data['eventstartdate'] = this.eventstartdate;
    data['eventenddate'] = this.eventenddate;
    data['chapterid'] = this.chapterid;
    data['chaptername'] = this.chaptername;
    data['areaid'] = this.areaid;
    data['areaname'] = this.areaname;
    data['regionid'] = this.regionid;
    data['regionname'] = this.regionname;
    data['eventimage'] = this.eventimage;
    data['eventthumbnailimage'] = this.eventthumbnailimage;
    data['venue'] = this.venue;
    data['date'] = this.date;
    data['time'] = this.time;
    data['date_for_heading'] = this.dateForHeading;
    data['app_image_small'] = this.appImageSmall;
    data['app_image_main'] = this.appImageMain;
    if (this.eventButtonArray != null) {
      data['event_button_array'] =
          this.eventButtonArray!.map((v) => v.toJson()).toList();
    }
    data['event_link'] = this.eventLink;
    return data;
  }
}

class EventButtonArray {
  String? displayText;
  String? weblink;
  List<EventAttainArr>? eventAttainArr;

  EventButtonArray({this.displayText, this.weblink, this.eventAttainArr});

  EventButtonArray.fromJson(Map<String, dynamic> json) {
    displayText = json['display_text'];
    weblink = json['weblink'];
    if (json['event_attain_arr'] != null) {
      eventAttainArr = <EventAttainArr>[];
      json['event_attain_arr'].forEach((v) {
        eventAttainArr!.add(new EventAttainArr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_text'] = this.displayText;
    data['weblink'] = this.weblink;
    if (this.eventAttainArr != null) {
      data['event_attain_arr'] =
          this.eventAttainArr!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventAttainArr {
  String? attainingDisplayText;

  EventAttainArr({this.attainingDisplayText});

  EventAttainArr.fromJson(Map<String, dynamic> json) {
    attainingDisplayText = json['attaining_display_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attaining_display_text'] = this.attainingDisplayText;
    return data;
  }
}
