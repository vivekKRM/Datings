class LoginResponse {
  late num status;
  late String message;
  late String? token;
  late Result? user;

  LoginResponse({required this.status, required this.message,required this.token, required this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    json['token'] != null ?  token = json['token'] : null;
    user = json['user'] != null ? new Result.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
     if (this.token != null) {
       data['token'] = this.token;
     }
    if (this.user != null) {
      data['user'] = this.user?.toJson();
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
  late String state;
  late String country;
  late String phone;
  late String email;
  late String dob;
  late String gender;
  late String mstatus;
  late String term;
  late String user_type;
  late String image;

  Result({required this.id,
    required this.user,
    required this.rpassword,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.address,
    required this.zipcode,
    required this.city,
    required this.state,
    required this.country,
    required this.phone,
    required this.email,
    required this.dob,
    required this.gender,
    required this.mstatus,
    required this.user_type,
    required this.term,
    required this.image,});

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
    phone = json['seajob_phone'] ?? '';
    email = json['seajob_email'] ?? '';
    dob = json['seajob_dob'] ?? '';
    gender = json['seajob_gender'] ?? '';
    mstatus = json['seajob_mstatus'] ?? '';
    user_type = json['seajob_user_type'] ?? '';
    term = json['seajob_term'] ?? '';
    image = json['seajob_image'] ?? '';
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
    data['seajob_zipcode'] = zipcode;
    data['seajob_city'] = city;
    data['seajob_state'] = state;
    data['seajob_country'] = country;
    data['seajob_phone'] = phone;
    data['seajob_email'] = email;
    data['seajob_dob'] = dob;
    data['seajob_gender'] = gender;
    data['seajob_mstatus'] = mstatus;
    data['seajob_user_type'] = user_type;
    data['seajob_term'] = term;
    data['seajob_image'] = image;
    return data;
  }
}
