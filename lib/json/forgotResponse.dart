class ForgotResponse {
  late int status;
  late String message;

  ForgotResponse({
    required this.status,
    required this.message,
  });

   ForgotResponse.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}