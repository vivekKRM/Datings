class PassportResponse {
  late num status;
  late String message;
  late Result? user;

  PassportResponse(
      {required this.status, required this.message, required this.user});

  PassportResponse.fromJson(Map<String, dynamic> json) {
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
  late String nationality;
  late String passportno;
  late String authority;
  late String issuedate;
  late String expirydate;
  late String usvisastatus;
  late String usissuedate;
  late String usexpirydate;
  late String othervisa;
  late String othervisaissuedate;
  late String othervisaexpirydate;
  late String country;
  late String countryName;
  late String phone;
  late String mobile;
  late String mobile2;
  late String email;
  late String dob;
  late String gender;
  late String mstatus;
  late String term;
  late String user_type;
  late String image;
  late String? vdate1;
  late String? vdate2;
  late String? vdate3;
  late String? vname;

  Result({
    required this.id,
    required this.nationality,
    required this.passportno,
    required this.authority,
    required this.issuedate,
    required this.expirydate,
    required this.usvisastatus,
    required this.usissuedate,
    required this.usexpirydate,
    required this.othervisa,
    required this.othervisaissuedate,
    required this.othervisaexpirydate,
    required this.country,
    required this.countryName,
    required this.phone,
    required this.email,
    required this.mobile,
    required this.mobile2,
    required this.vdate1,
    required this.vdate2,
    required this.vdate3,
    required this.vname,
    required this.dob,
    required this.gender,
    required this.mstatus,
    required this.user_type,
    required this.term,
    required this.image,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['seajob_user_id'] ?? '';
    nationality = json['seajob_nationality'] ?? '';
    passportno = json['seajob_passport_no'] ?? '';
    authority = json['seajob_authority'] ?? '';
    issuedate = json['seajob_issue_date'] ?? '';
    expirydate = json['seajob_expiry_date'] ?? '';
    usvisastatus = json['seajob_us_visa_status'] ?? '';
    usissuedate = json['seajob_us_issue_date'] ?? '';
    usexpirydate = json['seajob_us_expiry_date'] ?? '';
    othervisa = json['seajob_other_visa'] ?? '';
    othervisaissuedate = json['seajob_other_visa_issue_date'] ?? '';
    othervisaexpirydate = json['seajob_other_visa_expiry_date'] ?? '';
    phone = json['seajob_phone'] ?? '';
    mobile = json['seajob_mobile'] ?? '';
    mobile2 = json['seajob_mobile2'] ?? '';
    email = json['seajob_email'] ?? '';
    vdate1 = json['vdate1'] ?? '';
    vdate2 = json['vdate2'] ?? '';
    vdate3 = json['vdate3'] ?? '';
    vname = json['vname'] ?? '';
    dob = json['seajob_dob'] ?? '';
    gender = json['seajob_gender'] ?? '';
    mstatus = json['seajob_mstatus'] ?? '';
    user_type = json['seajob_user_type'] ?? '';
    term = json['seajob_term'] ?? '';
    image = json['seajob_image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_user_id'] = id;
    data['seajob_nationality'] = nationality;
    data['seajob_passport_no'] = passportno;
    data['seajob_authority'] = authority;
    data['seajob_issue_date'] = issuedate;
    data['seajob_expiry_date'] = expirydate;
    data['seajob_us_visa_status'] = usvisastatus;
    data['seajob_us_issue_date'] = usissuedate;
    data['seajob_us_expiry_date'] = usexpirydate;
    data['seajob_other_visa'] = othervisa;
    data['seajob_other_visa_issue_date'] = othervisaissuedate;
    data['seajob_other_visa_expiry_date'] = othervisaexpirydate;
    data['seajob_phone'] = phone;
    data['seajob_email'] = email;
    data['vdate1'] = vdate1;
    data['vdate2'] = vdate2;
    data['vdate3'] = vdate3;
    data['vname'] = vname;
    data['seajob_mobile'] = mobile;
    data['seajob_mobile2'] = mobile2;
    data['seajob_dob'] = dob;
    data['seajob_gender'] = gender;
    data['seajob_mstatus'] = mstatus;
    data['seajob_user_type'] = user_type;
    data['seajob_term'] = term;
    data['seajob_image'] = image;
    return data;
  }
}
