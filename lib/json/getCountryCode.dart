class GetCountryCode {
  late int status;
  late String message;
  late List<CountryCode> country;

  GetCountryCode({
    required this.status,
    required this.message,
    required this.country
  });

   GetCountryCode.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['countries'] != null) {
      country = <CountryCode>[];
      json['countries'].forEach((v) {
        country.add(CountryCode.fromJson(v));
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

class CountryCode {
  late String locationId;
  late String name;

  CountryCode({
    required this.locationId,
    required this.name,
  });

  CountryCode.fromJson(Map<String, dynamic> json) {
    locationId = json['phonecode'];
    name = json['nicename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phonecode'] = this.locationId;
    data['nicename'] = this.name;
    return data;
  }
}
