class GetShip {
  late int status;
  late String message;
  late List<Ships> ships;

  GetShip({
    required this.status,
    required this.message,
    required this.ships
  });

   GetShip.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['ship'] != null) {
      ships = <Ships>[];
      json['ship'].forEach((v) {
        ships.add(Ships.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.ships != null) {
      data['ship'] = ships.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ships {
  late String seajob_id;
  late String seajob_status;
  late String seajob_name;
  late String sort;

  Ships({
    required this.seajob_status,
    required this.seajob_name,
    required this.seajob_id,
    required this.sort,
  });

  Ships.fromJson(Map<String, dynamic> json) {
    seajob_id = json['seajob_id'];
    seajob_status = json['seajob_status'];
    seajob_name = json['seajob_name'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_id'] = this.seajob_id;
    data['seajob_status'] = this.seajob_status;
     data['seajob_name'] = this.seajob_name;
    data['sort'] = this.sort;

    return data;
  }
}
