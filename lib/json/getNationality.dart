class GetNationality {
  late int status;
  late String message;
  late List<Nationality> nationality;

  GetNationality({
    required this.status,
    required this.message,
    required this.nationality
  });

   GetNationality.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['nationality'] != null) {
      nationality = <Nationality>[];
      json['nationality'].forEach((v) {
        nationality.add(Nationality.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.nationality != null) {
      data['nationality'] = nationality.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nationality {
  late String name;

  Nationality({
    required this.name,
  });

  Nationality.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
