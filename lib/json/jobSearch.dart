class JobSearch {
  late num status;
  late String message;
  late List<Dating?> user;

  JobSearch(
      {required this.status, required this.message, required this.user});

  JobSearch.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    if (json['data'] != null) {
      user = <Dating?>[];
      json['data'].forEach((v) {
        user.add(Dating?.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
   if (this.user != null) {
      data['data'] = user.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class Dating {
  final String DatingId;
  final String id;
  final String jobpostId;
  final String DatingCompId;
  final String DatingCompanyName;
  final String DatingCreated;
  final String DatingDesc;

  Dating({
    required this.DatingId,
    required this.id,
    required this.jobpostId,
    required this.DatingCompId,
    required this.DatingCompanyName,
    required this.DatingCreated,
    required this.DatingDesc,
  });

  factory Dating.fromJson(Map<String, dynamic> json) {
    return Dating(
      DatingId: json['seajob_id'],
      id: json['id'],
      jobpostId: json['jobpost_id'],
      DatingCompId: json['seajob_comp_id'],
      DatingCompanyName: json['seajob_company_name'],
      DatingCreated: json['seajob_create_on'],
      DatingDesc: json['seajob_job_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seajob_id': DatingId,
      'id': id,
      'jobpost_id': jobpostId,
      'seajob_comp_id': DatingCompId,
      'seajob_company_name': DatingCompanyName,
      'seajob_create_on': DatingCreated,
      'seajob_job_description': DatingDesc,
    };
  }
}