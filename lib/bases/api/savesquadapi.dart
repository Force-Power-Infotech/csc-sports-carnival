class SaveSquadAPI {
  String? processSts;
  String? processMsg;

  SaveSquadAPI({this.processSts, this.processMsg});

  SaveSquadAPI.fromJson(Map<String, dynamic> json) {
    processSts = json['process_sts'];
    processMsg = json['process_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_sts'] = this.processSts;
    data['process_msg'] = this.processMsg;
    return data;
  }
}
