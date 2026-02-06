class CustomerDetails {
  final String? id;
  final String? appMode;
  final String? firstName;
  final String? businessId;
  final String? userId;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? country;
  final String? gender;
  final String? title;
  final String? dateOfBirth;
  final String? stateOfResidence;
  final String? city;
  final String? address;
  final String? identityVerification;
  final String? verificationType;
  final String? faceImage;
  final bool? isKycComplete;
  final bool? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  CustomerDetails({
    required this.id,
    required this.appMode,
    required this.firstName,
    required this.businessId,
    required this.userId,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.gender,
    required this.title,
    required this.dateOfBirth,
    required this.stateOfResidence,
    required this.city,
    required this.address,
    required this.identityVerification,
    required this.verificationType,
    required this.faceImage,
    required this.isKycComplete,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      id: json['id'],
      appMode: json['app_mode'],
      firstName: json['first_name'],
      businessId: json['business_id'],
      userId: json['user_id'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      country: json['country'],
      gender: json['gender'],
      title: json['title'],
      dateOfBirth: json['date_of_birth'],
      stateOfResidence: json['state_of_residence'],
      city: json['city'],
      address: json['address'],
      identityVerification: json['identity_verification'],
      verificationType: json['verification_type'],
      faceImage: json['face_image'],
      isKycComplete: json['is_kyc_complete'],
      active: json['active'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_mode': appMode,
      'first_name': firstName,
      'business_id': businessId,
      'user_id': userId,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'country': country,
      'gender': gender,
      'title': title,
      'date_of_birth': dateOfBirth,
      'state_of_residence': stateOfResidence,
      'city': city,
      'address': address,
      'identity_verification': identityVerification,
      'verification_type': verificationType,
      'face_image': faceImage,
      'is_kyc_complete': isKycComplete,
      'active': active,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
