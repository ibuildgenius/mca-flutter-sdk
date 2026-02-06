class PolicyCustomerModel {
  final String? dob;
  final int? city;
  final String? phone;
  final int? state;
  final String? gender;
  final String? address;
  final int? country;
  final String? lastName;
  final String? relation;
  final String? firstName;
  final int? maritalStatus;

  PolicyCustomerModel({
    this.dob,
    this.city,
    this.phone,
    this.state,
    this.gender,
    this.address,
    this.country,
    this.lastName,
    this.relation,
    this.firstName,
    this.maritalStatus,
  });

  factory PolicyCustomerModel.fromJson(Map<String, dynamic> json) {
    return PolicyCustomerModel(
      dob: json['dob'] as String?,
      city: json['city'] as int?,
      phone: json['phone'] as String?,
      state: json['state'] as int?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      country: json['country'] as int?,
      lastName: json['lastName'] as String?,
      relation: json['relation'] as String?,
      firstName: json['firstName'] as String?,
      maritalStatus: json['maritalStatus'] as int?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'dob': dob,
      'city': city,
      'phone': phone,
      'state': state,
      'gender': gender,
      'address': address,
      'country': country,
      'lastName': lastName,
      'relation': relation,
      'firstName': firstName,
      'maritalStatus': maritalStatus,
    };
  }
}
