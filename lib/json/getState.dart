class GetState {
  late int status;
  late String message;
  late List<GState> states;

  GetState({
    required this.status,
    required this.message,
    required this.states
  });

   GetState.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message'];
      if (json['states'] != null) {
      states = <GState>[];
      json['states'].forEach((v) {
        states.add(GState.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.states != null) {
      data['states'] = states.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GState {
  late String locationId;
  late String name;

  GState({
    required this.locationId,
    required this.name,
  });

  GState.fromJson(Map<String, dynamic> json) {
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
