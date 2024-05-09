class GetRank {
  late int status;
  late String message;
  late List<Ranks> ranks;

  GetRank({
    required this.status,
    required this.message,
    required this.ranks
  });

   GetRank.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['ranks'] != null) {
      ranks = <Ranks>[];
      json['ranks'].forEach((v) {
        ranks.add(Ranks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.ranks != null) {
      data['ranks'] = ranks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ranks {
  late String seajob_id;
  late String seajob_status;
  late String certificate_name;
  late String sort;

  Ranks({
    required this.seajob_status,
    required this.certificate_name,
    required this.seajob_id,
    required this.sort,
  });

  Ranks.fromJson(Map<String, dynamic> json) {
    seajob_id = json['seajob_id'];
    seajob_status = json['seajob_status'];
    certificate_name = json['certificate_name'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_id'] = this.seajob_id;
    data['seajob_status'] = this.seajob_status;
     data['certificate_name'] = this.certificate_name;
    data['sort'] = this.sort;

    return data;
  }
}
