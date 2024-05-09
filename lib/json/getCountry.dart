class GetCountry {
  late int status;
  late String message;
  late List<Country> country;

  GetCountry({
    required this.status,
    required this.message,
    required this.country
  });

   GetCountry.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['countries'] != null) {
      country = <Country>[];
      json['countries'].forEach((v) {
        country.add(Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.country != null) {
      data['countries'] = country.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Country {
  late String locationId;
  late String name;

  Country({
    required this.locationId,
    required this.name,
  });

  Country.fromJson(Map<String, dynamic> json) {
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
