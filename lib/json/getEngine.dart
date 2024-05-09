class GetEngine {
  late int status;
  late String message;
  late List<Engines> engines;

  GetEngine({
    required this.status,
    required this.message,
    required this.engines
  });

   GetEngine.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['engine'] != null) {
      engines = <Engines>[];
      json['engine'].forEach((v) {
        engines.add(Engines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.engines != null) {
      data['engine'] = engines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Engines {
  late String seajob_id;
  late String seajob_status;
  late String seajob_engine;
  late String sort;

  Engines({
    required this.seajob_status,
    required this.seajob_engine,
    required this.seajob_id,
    required this.sort,
  });

  Engines.fromJson(Map<String, dynamic> json) {
    seajob_id = json['seajob_id'];
    seajob_status = json['seajob_status'];
    seajob_engine = json['seajob_engine'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_id'] = this.seajob_id;
    data['seajob_status'] = this.seajob_status;
     data['seajob_engine'] = this.seajob_engine;
    data['sort'] = this.sort;

    return data;
  }
}
