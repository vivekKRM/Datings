class ApplyJobResponse {
  late num status;
  late String message;
  late Result? user;

   ApplyJobResponse(
      {required this.status, required this.message, required this.user});

  ApplyJobResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    user = json['userdata'] != null ? new Result.fromJson(json['userdata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['userdata'] = this.user?.toJson();
    }
    return data;
  }
}


class Result {
  late String from_date;
  late String till_date;
  late List<String> rank;
  late List<String> rank_name;

  Result({
    required this.from_date,
    required this.till_date,
    required this.rank,
    required this.rank_name,

  });

  Result.fromJson(Map<String, dynamic> json) {
    from_date = json['from_date'] ?? '';
    till_date = json['till_date'] ?? '';
    // rank = json['rank'] ?? [''];
    // rank_name = json['rank_name'] ?? [''];   
    rank = (json['rank'] as List<dynamic>?)?.map((dynamic e) => e.toString()).toList() ?? [];
    rank_name = (json['rank_name'] as List<dynamic>?)?.map((dynamic e) => e.toString()).toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from_date'] = from_date;
    data['till_date'] = till_date;
    data['rank'] = rank;
    data['rank_name'] = rank_name;
    return data;
  }
}
