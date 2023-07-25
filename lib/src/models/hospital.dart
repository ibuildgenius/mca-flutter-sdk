class Hospital {
  Hospital({
    this.id = 0,
    this.name = '',
    this.location = '',
    this.address = '',
    this.type = 0,
  });

  Hospital.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    address = json['address'];
    type = json['type'];
  }
  int? id;
  String? name;
  String? location;
  String? address;
  int? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['location'] = location;
    map['address'] = address;
    map['type'] = type;
    return map;
  }
}
