class CourseSelectedResponse {
  late num status;
  late String message;
  late List<Result?> user;

  CourseSelectedResponse(
      {required this.status, required this.message, required this.user});

  CourseSelectedResponse.fromJson(Map<String, dynamic> json) {
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
  late String seajob_id;
  late String seajob_status;
  late String seajob_name;
  late int Datingselect;

  Result({
    required this.seajob_status,
    required this.seajob_name,
    required this.seajob_id,
    required this.Datingselect,
  });

  Result.fromJson(Map<String, dynamic> json) {
    seajob_id = json['seajob_id'];
    seajob_status = json['seajob_status'];
    seajob_name = json['seajob_name'];
    Datingselect = json['seajob_select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_id'] = this.seajob_id;
    data['seajob_status'] = this.seajob_status;
    data['seajob_name'] = this.seajob_name;
    data['seajob_select'] = this.Datingselect;

    return data;
  }
}
