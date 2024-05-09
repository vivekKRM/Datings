class DangerousCargoResponse {
  late num status;
  late String message;
  late List<Result?> user;

  DangerousCargoResponse(
      {required this.status, required this.message, required this.user});

  DangerousCargoResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    if (json['data'] != null) {
      user = <Result?>[];
      json['data'].forEach((v) {
        user.add(Result?.fromJson(v));
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

class Result {
  late String id;
  late String Datingid;
  late String tank1;
  late String level1;
  late String enddate1;
  late String tank2;
  late String level2;
  late String enddate2;
  late String tank3;
  late String level3;
  late String enddate3;

  Result({
    required this.id,
    required this.Datingid,
    required this.tank1,
    required this.level1,
    required this.enddate1,
    required this.tank2,
    required this.level2,
    required this.enddate2,
    required this.tank3,
    required this.level3,
    required this.enddate3,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['seajob_user'] ?? '';
    Datingid = json['seajob_id'] ?? '';
    tank1 = json['seajob_tank_1'] ?? '';
    level1 = json['seajob_level_1'] ?? '';
    enddate1 = json['seajob_end_date_1'] ?? '';
    tank2 = json['seajob_tank_2'] ?? '';
    level2 = json['seajob_level_2'] ?? '';
    enddate2 = json['seajob_end_date_2'] ?? '';
    tank3 = json['seajob_tank_3'] ?? '';
    level3 = json['seajob_level_3'] ?? '';
    enddate3 = json['seajob_end_date_3'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_user'] = id;
    data['seajob_id'] = Datingid;
    data['seajob_tank_1'] = tank1;
    data['seajob_level_1'] = level1;
    data['seajob_end_date_1'] = enddate1;
    data['seajob_tank_2'] = tank2;
    data['seajob_level_2'] = level2;
    data['seajob_end_date_2'] = enddate2;
    data['seajob_tank_3'] = tank3;
    data['seajob_level_3'] = level3;
    data['seajob_end_date_3'] = enddate3;
    return data;
  }
}
