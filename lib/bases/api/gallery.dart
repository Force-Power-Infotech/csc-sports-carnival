import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rpgl/bases/webservice.dart';

class GalleryAPI {
  String? processStatus;
  String? processMessage;
  List<AlbumListList>? albumListList;

  GalleryAPI({this.processStatus, this.processMessage, this.albumListList});

  GalleryAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['album_list_list'] != null) {
      albumListList = <AlbumListList>[];
      json['album_list_list'].forEach((v) {
        albumListList!.add(new AlbumListList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    if (this.albumListList != null) {
      data['album_list_list'] =
          this.albumListList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlbumListList {
  String? albumId;
  String? albumName;
  String? albumYearMonth;
  String? albumYearMonthShowText;
  String? albumImageLink;
  String? theLink;

  AlbumListList(
      {this.albumId,
      this.albumName,
      this.albumYearMonth,
      this.albumYearMonthShowText,
      this.albumImageLink,
      this.theLink});

  AlbumListList.fromJson(Map<String, dynamic> json) {
    albumId = json['album_id'];
    albumName = json['album_name'];
    albumYearMonth = json['album_year_month'];
    albumYearMonthShowText = json['album_year_month_show_text'];
    albumImageLink = json['album_image_link'];
    theLink = json['the_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['album_id'] = this.albumId;
    data['album_name'] = this.albumName;
    data['album_year_month'] = this.albumYearMonth;
    data['album_year_month_show_text'] = this.albumYearMonthShowText;
    data['album_image_link'] = this.albumImageLink;
    data['the_link'] = this.theLink;
    return data;
  }

  static Future<GalleryAPI> pdflist() async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.ws_show_gallery}");
    final request = http.MultipartRequest('POST', url);
    print(url);
    // request.fields.addAll({'leagueid': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    return GalleryAPI.fromJson(jsonDecode(responseString));
  }
}
