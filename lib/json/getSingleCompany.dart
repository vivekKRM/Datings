
class SingleCompany {
  late num status;
  late String message;
  late Result? user;

  SingleCompany(
      {required this.status, required this.message, required this.user});

  SingleCompany.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    user = json['company_data'] != null ? new Result.fromJson(json['company_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['company_data'] = this.user?.toJson();
    }
    return data;
  }
}


class Result {
  final String DatingId;
  final String jobpostId;
  final String DatingCompId;
  final String DatingCompanyName;
  final String DatingCreated;
  final String DatingDesc;

  Result({
    required this.DatingId,
    required this.jobpostId,
    required this.DatingCompId,
    required this.DatingCompanyName,
    required this.DatingCreated,
    required this.DatingDesc,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      DatingId: json['seajob_id'],
      jobpostId: json['jobpost_id'],
      DatingCompId: json['seajob_comp_id'],
      DatingCompanyName: json['company_name'],
      DatingCreated: json['seajob_create_on'],
      DatingDesc: json['apply_rank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seajob_id': DatingId,
      'jobpost_id': jobpostId,
      'seajob_comp_id': DatingCompId,
      'company_name': DatingCompanyName,
      'seajob_create_on': DatingCreated,
      'apply_rank': DatingDesc,
    };
  }
}