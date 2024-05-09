class GetCompany {
  late int status;
  late String message;
  late List<Company> company;

  GetCompany({
    required this.status,
    required this.message,
    required this.company
  });

   GetCompany.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['company_data'] != null) {
      company = <Company>[];
      json['company_data'].forEach((v) {
        company.add(Company.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.company != null) {
      data['company_data'] = company.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
  late String locationId;
  late String name;
  late int status;

  Company({
    required this.locationId,
    required this.name,
    required this.status,
  });

  Company.fromJson(Map<String, dynamic> json) {
    locationId = json['seajob_id'];
    name = json['seajob_company_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seajob_id'] = this.locationId;
    data['seajob_company_name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
