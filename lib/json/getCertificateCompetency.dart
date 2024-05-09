class CertificateCompetencyResponse {
  late num status;
  late String message;
  late List<Result?> user;

  CertificateCompetencyResponse(
      {required this.status, required this.message, required this.user});

  CertificateCompetencyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    if (json['userdata'] != null) {
      user = <Result?>[];
      json['userdata'].forEach((v) {
        user.add(Result?.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
   if (this.user != null) {
      data['userdata'] = user.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class Result {
  late String id;
  late int Datingid;
  late String indosnu;
  late String certificatenumber;
  late String certificatetype;
  late String issueauth;
  late String issuedate;
  late String expirydate;
  late String otherissueauth;
  late String certificatename;

  Result({
    required this.id,
    required this.Datingid,
    required this.indosnu,
    required this.certificatenumber,
    required this.certificatetype,
    required this.issueauth,
    required this.issuedate,
    required this.expirydate,
    required this.otherissueauth,
    required this.certificatename,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['seajob_user_id'] ?? '';
    Datingid = json['seajob_id'] ?? '';
    indosnu = json['seajob_indosno'] ?? '';
    certificatenumber = json['seajob_cert_number'] ?? '';
    certificatetype = json['seajob_cert_type'] ?? '';
    issueauth = json['seajob_cert_issue_authority'] ?? '';
    issuedate = json['seajob_cert_issue_date'] ?? '';
    expirydate = json['seajob_cert_expiry_date'] ?? '';
    otherissueauth = json['seajob_cert_other_issue_authority'] ?? '';
    certificatename = json['seajob_cert_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_user_id'] = id;
    data['seajob_id'] = Datingid;
    data['seajob_indosno'] = indosnu;
    data['seajob_cert_number'] = certificatenumber;
    data['seajob_cert_type'] = certificatetype;
    data['seajob_cert_issue_authority'] = issueauth;
    data['seajob_cert_issue_date'] = issuedate;
    data['seajob_cert_expiry_date'] = expirydate;
    data['seajob_cert_other_issue_authority'] = otherissueauth;
    data['seajob_cert_name'] = certificatename;
    return data;
  }
}
