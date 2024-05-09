class GetCourse {
  late int status;
  late String message;
  late List<Courses> courses;

  GetCourse({
    required this.status,
    required this.message,
    required this.courses
  });

   GetCourse.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses.add(Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.courses != null) {
      data['courses'] = courses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  late String seajob_id;
  late String seajob_status;
  late String seajob_name;
  late String sort;

  Courses({
    required this.seajob_status,
    required this.seajob_name,
    required this.seajob_id,
    required this.sort,
  });

  Courses.fromJson(Map<String, dynamic> json) {
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
