class PersonalResponse {
  late num status;
  late String message;
  late Result? user;

  PersonalResponse(
      {required this.status, required this.message, required this.user});

  PersonalResponse.fromJson(Map<String, dynamic> json) {
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
  late String user;
  late String rpassword;
  late String first_name;
  late String middle_name;
  late String last_name;
  late String address;
  late String zipcode;
  late String city;
  late String cityName;
  late String state;
  late String stateName;
  late String country;
  late String countryName;
  late String phone;
  late String mobile;
  late String mobile2;
  late String whatts;
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
  late String pcountry;
  late String mcountry;
  late String m2country;
  late String wcountry;

  Result({
    required this.id,
    required this.user,
    required this.rpassword,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.address,
    required this.zipcode,
    required this.city,
    required this.whatts,
    required this.cityName,
    required this.state,
    required this.stateName,
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
    required this.pcountry,
    required this.mcountry,
    required this.m2country,
    required this.wcountry,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['seajob_id'] ?? 0;
    // oldid = json['oldid'] ?? '';
    user = json['seajob_user'] ?? '';
    rpassword = json['seajob_pwd'] ?? '';
    first_name = json['seajob_first_name'] ?? '';
    middle_name = json['seajob_middle_name'] ?? '';
    last_name = json['seajob_last_name'] ?? '';
    address = json['seajob_address'] ?? '';
    zipcode = json['seajob_zipcode'] ?? '';
    city = json['seajob_city'] ?? '';
    state = json['seajob_state'] ?? '';
    country = json['seajob_country'] ?? '';
    cityName = json['seajob_city_name'] ?? '';
    stateName = json['seajob_state_name'] ?? '';
    countryName = json['seajob_country_name'] ?? '';
    phone = json['seajob_phone'] ?? '';
    whatts = json['whatsapp_number'] ?? '';
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
    pcountry = json['seajob_phone_country'] ?? '';
    mcountry = json['seajob_mobile_country'] ?? '';
    m2country = json['seajob_mobile2_country'] ?? '';
    wcountry = json['seajob_whatsapp_country'] ?? '';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_id'] = id;
    data['seajob_user'] = user;
    data['seajob_pwd'] = rpassword;
    data['seajob_first_name'] = first_name;
    data['seajob_middle_name'] = middle_name;
    data['seajob_last_name'] = last_name;
    data['seajob_address'] = address;
    data['whatsapp_number'] = whatts;
    data['seajob_zipcode'] = zipcode;
    data['seajob_city'] = city;
    data['seajob_state'] = state;
    data['seajob_country'] = country;
    data['seajob_city_name'] = cityName;
    data['seajob_state_name'] = stateName;
    data['seajob_country_name'] = countryName;
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
    data['seajob_phone_country'] = pcountry;
    data['seajob_mobile_country'] = mcountry;
    data['seajob_mobile2_country'] = m2country;
    data['seajob_whatsapp_country'] = wcountry;
    return data;
  }
}
