
class ViewedCompany {
  late num status;
  late String message;
  late List<Result>? user;

  ViewedCompany(
      {required this.status, required this.message, required this.user});

  ViewedCompany.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
     if (json['data'] != null) {
      user = <Result>[];
      json['data'].forEach((v) {
        user?.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['data'] = user?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Result {
  final String companyname;
  final String date;
 

  Result({
    required this.companyname,
    required this.date,
    
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      companyname: json['company'],
      date: json['viewdate'],
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': companyname,
      'viewdate': date,
      
    };
  }
}