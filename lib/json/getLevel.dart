import 'dart:ffi';

class GetLevel {
  late int status;
  late String message;
  late List<Levels> levels;

  GetLevel({
    required this.status,
    required this.message,
    required this.levels
  });

   GetLevel.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['level'] != null) {
      levels = <Levels>[];
      json['level'].forEach((v) {
        levels.add(Levels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.levels != null) {
      data['level'] = levels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Levels {
  late int locationId;
  late String name;

  Levels({
    required this.locationId,
    required this.name,
  });

  Levels.fromJson(Map<String, dynamic> json) {
    locationId = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.locationId;
    data['name'] = this.name;
    return data;
  }
}
