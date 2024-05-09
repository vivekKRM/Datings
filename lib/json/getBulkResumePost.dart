class GetBulkResumePost {
  late num status;
  late String message;
  late List<Result?> user;

  GetBulkResumePost(
      {required this.status, required this.message, required this.user});

  GetBulkResumePost.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    if (json['company'] != null) {
      user = <Result?>[];
      json['company'].forEach((v) {
        user.add(Result?.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
   if (this.user != null) {
      data['company'] = user.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class Result {
  late String seajob_id;
  late String seajob_name;

  Result({
    required this.seajob_name,
    required this.seajob_id,
  });

  Result.fromJson(Map<String, dynamic> json) {
    seajob_id = json['id'];
    seajob_name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.seajob_id;
    data['name'] = this.seajob_name;

    return data;
  }
}
