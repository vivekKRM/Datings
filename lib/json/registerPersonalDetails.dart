class RegisterPersonalDetails {
  late String? user_id;
  late int status;
  late String message;

  RegisterPersonalDetails({
    required this.status,
    required this.message,
    required this.user_id,
  });

   RegisterPersonalDetails.fromJson(Map<String, dynamic> json) {
      user_id = json['user_id'] ?? '';
      status = json['status'];
      message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (user_id != null) {
      data['user_id'] = user_id;
    }
    return data;
  }
}