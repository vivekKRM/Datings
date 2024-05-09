class ProfileExperienceResponse {
  late num status;
  late String message;
  late List<Result?> user;

  ProfileExperienceResponse(
      {required this.status, required this.message, required this.user});

  ProfileExperienceResponse.fromJson(Map<String, dynamic> json) {
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
  late String rank;
  late String year;
  late String month;
  late String day;
  late String rankname;
  late String jobprofile;

  Result({
    required this.rank,
    required this.year,
    required this.month,
    required this.day,
    required this.rankname,
    required this.jobprofile,
  });

  Result.fromJson(Map<String, dynamic> json) {
    rank = json['rank'] ?? '';
    year = json['year'] ?? '';
    month = json['month'] ?? '';
    day = json['day'] ?? '';
    rankname = json['rank_name'] ?? '';  
    jobprofile = json['job_profile'] ?? '';  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = rank;
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['rank_name'] = rankname;
    data['job_profile'] = jobprofile;
    return data;
  }
}
