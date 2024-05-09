
class SingleShipping {
  late num status;
  late String message;
  late Result? user;

  SingleShipping(
      {required this.status, required this.message, required this.user});

  SingleShipping.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    user = json['data'] != null ? new Result.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['data'] = this.user?.toJson();
    }
    return data;
  }
}


class Result {
  final String companyname;
  final String address;
  final String phone;
  final String url;
  final String email;
  final String Datingaddress;

  Result({
    required this.companyname,
    required this.address,
    required this.phone,
    required this.url,
    required this.email,
    required this.Datingaddress,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      companyname: json['seajob_company'],
      address: json['seajob_address'],
      phone: json['seajob_phone'],
      url: json['seajob_url'],
      email: json['seajob_email'],
      Datingaddress: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seajob_company': companyname,
      'seajob_address': address,
      'seajob_phone': phone,
      'seajob_url': url,
      'seajob_email': email,
      'address': Datingaddress,
    };
  }
}