class AcademicResponse {
  late num status;
  late String message;
  late List<Result?> user;

  AcademicResponse(
      {required this.status, required this.message, required this.user});

  AcademicResponse.fromJson(Map<String, dynamic> json) {
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
  late String id;
  late String Datingid;
  late String education;
  late String board;
  late String year;
  late String percentage;

  Result({
    required this.id,
    required this.Datingid,
    required this.education,
    required this.board,
    required this.year,
    required this.percentage,
 
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['seajob_user_id'] ?? '';
    Datingid = json['seajob_id'] ?? '';
    education = json['seajob_education'] ?? '';
    board = json['seajob_board'] ?? '';
    year = json['seajob_year'] ?? '';
    percentage = json['seajob_percentage'] ?? '';
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_user_id'] = id;
    data['seajob_id'] = Datingid;
    data['seajob_education'] = education;
    data['seajob_board'] = board;
    data['seajob_year'] = year;
    data['seajob_percentage'] = percentage;
    return data;
  }
}
