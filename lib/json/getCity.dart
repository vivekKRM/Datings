class GetCity {
  late int status;
  late String message;
  late List<City> cities;

  GetCity({
    required this.status,
    required this.message,
    required this.cities
  });

   GetCity.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['cities'] != null) {
      cities = <City>[];
      json['cities'].forEach((v) {
        cities.add(City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.cities != null) {
      data['cities'] = cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  late String locationId;
  late String name;

  City({
    required this.locationId,
    required this.name,
  });

  City.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['name'] = this.name;
    return data;
  }
}
