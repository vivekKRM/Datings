class SeaExperienceResponse {
  late num status;
  late String message;
  late List<Result?> user;

  SeaExperienceResponse(
      {required this.status, required this.message, required this.user});

  SeaExperienceResponse.fromJson(Map<String, dynamic> json) {
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
  late String Datingrank;
  late String companyname;
  late String shiptype;
  late String tonnage;
  late String mainengine;
  late String bhp;
  late String joindate;
  late String leavedate;
  late String shipname;
  late String rankname;
  late String certname;

  Result({
    required this.id,
    required this.Datingid,
    required this.Datingrank,
    required this.companyname,
    required this.shiptype,
    required this.tonnage,
    required this.mainengine,
    required this.bhp,
    required this.joindate,
    required this.leavedate,
    required this.shipname,
    required this.rankname,
    required this.certname,
 
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['seajob_user_id'] ?? '';
    Datingid = json['seajob_id'] ?? '';
    Datingrank = json['seajob_exp_rank'] ?? '';
    companyname = json['seajob_comp_name'] ?? '';
    shiptype = json['seajob_ship_type'] ?? '';
    tonnage = json['seajob_tonnage'] ?? '';
    mainengine = json['seajob_main_engine'] ?? '';
    bhp = json['seajob_bhp'] ?? '';
    joindate = json['seajob_join_date'] ?? '';
    leavedate = json['seajob_leave_date'] ?? '';
    shipname = json['seajob_ship_name'] ?? '';
    rankname = json['seajob_exp_rank_name'] ?? '';
    certname = json['seajob_cert_name'] ?? '';
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_user_id'] = id;
    data['seajob_id'] = Datingid;
    data['seajob_exp_rank'] = Datingrank;
    data['seajob_comp_name'] = companyname;
    data['seajob_ship_type'] = shiptype;
    data['seajob_tonnage'] = tonnage;
    data['seajob_main_engine'] = mainengine;
    data['seajob_bhp'] = bhp;
    data['seajob_join_date'] = joindate;
    data['seajob_leave_date'] = leavedate;
    data['seajob_ship_name'] = shipname;
    data['seajob_exp_rank_name'] = rankname;
    data['seajob_cert_name'] = certname;
    return data;
  }
}
