class SingleSeamanResponse {
  late num status;
  late String message;
  late Result? user;

  SingleSeamanResponse(
      {required this.status, required this.message, required this.user});

  SingleSeamanResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    user = json['userdata'] != null ? new Result.fromJson(json['userdata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['userdata'] = this.user?.toJson();
    }
    return data;
  }
}

class Result {
  late String id;
  late String bookid;
  late String issueauth;
  late String sbnumber;
  late String expirydate;
  late String other;

  Result({
    required this.id,
    required this.bookid,
    required this.issueauth,
    required this.sbnumber,
    required this.expirydate,
    required this.other,
 
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['seajob_user_id'] ?? '';
    bookid = json['seajob_id'] ?? '';
    issueauth = json['seajob_sb_issue_authority'] ?? '';
    sbnumber = json['seajob_sb_number'] ?? '';
    expirydate = json['seajob_sb_expiry_date'] ?? '';
    other = json['seajob_sb_other_ia'] ?? '';
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_user_id'] = id;
    data['seajob_id'] = bookid;
    data['seajob_sb_issue_authority'] = issueauth;
    data['seajob_sb_number'] = sbnumber;
    data['seajob_sb_expiry_date'] = expirydate;
    data['seajob_sb_other_ia'] = other;
    return data;
  }
}
