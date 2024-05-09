class GetShippingCompany {
  late int status;
  late String message;
  late List<Shipping> company;

  GetShippingCompany({
    required this.status,
    required this.message,
    required this.company
  });

   GetShippingCompany.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['data'] != null) {
      company = <Shipping>[];
      json['data'].forEach((v) {
        company.add(Shipping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.company != null) {
      data['data'] = company.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shipping {
  late String locationId;
  late String name;
  late String status;

  Shipping({
    required this.locationId,
    required this.name,
    required this.status,
  });

  Shipping.fromJson(Map<String, dynamic> json) {
    locationId = json['seajob_id'];
    name = json['seajob_company'];
    status = json['seajob_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_id'] = this.locationId;
    data['seajob_company'] = this.name;
    data['seajob_status'] = this.status;
    return data;
  }
}
