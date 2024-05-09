class GetRanks {
  late int status;
  late String message;
  late List<Rankers> ranks;

  GetRanks({
    required this.status,
    required this.message,
    required this.ranks
  });

   GetRanks.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['ranks'] != null) {
      ranks = <Rankers>[];
      json['ranks'].forEach((v) {
        ranks.add(Rankers.fromJson(v));
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

class Rankers {
  late String seajob_id;
  late String seajob_status;
  late String seajob_rank;
  late String sort;

  Rankers({
    required this.seajob_status,
    required this.seajob_rank,
    required this.seajob_id,
    required this.sort,
  });

  Rankers.fromJson(Map<String, dynamic> json) {
    seajob_id = json['seajob_id'];
    seajob_status = json['seajob_status'];
    seajob_rank = json['seajob_rank'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_id'] = this.seajob_id;
    data['seajob_status'] = this.seajob_status;
     data['seajob_rank'] = this.seajob_rank;
    data['sort'] = this.sort;

    return data;
  }
}
