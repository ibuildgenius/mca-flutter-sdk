class ProviderModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? country;
  final String? companyName;
  final String? companyTradingName;
  final String? companyAbbreviation;
  final String? companyAddress;
  final String? salesEmail;
  final String? claimSupportEmail;
  final String? inspectionSupportEmail;
  final bool? isOnboarded;
  final DateTime? dateOnboarded;
  final String? verificationType;
  final String? verificationImages;
  final String? verificationNumber;
  final String? bvnNumber;
  final String? businessType;
  final String? claimEmail;
  final String? businessEmail;
  final String? supportEmail;
  final bool? active;
  final String? bankAccountId;
  final String? ownerId;
  final String? walletDeficitLimit;
  final int? maxInspectionRetries;
  final String? insuranceType;
  final String? identifier;
  final DateTime? lastWeeklyReport;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? productCategoryId;
  final String? providerId;
  final String? providerUrl;
  final String? logo;
  String? brandColorPrimary;
  final String? icon;

  ProviderModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.companyName,
    required this.companyTradingName,
    required this.companyAbbreviation,
    required this.companyAddress,
    required this.salesEmail,
    required this.claimSupportEmail,
    required this.inspectionSupportEmail,
    required this.isOnboarded,
    required this.dateOnboarded,
    required this.verificationType,
    required this.verificationImages,
    required this.verificationNumber,
    required this.bvnNumber,
    required this.businessType,
    required this.claimEmail,
    required this.businessEmail,
    required this.supportEmail,
    required this.active,
    required this.bankAccountId,
    required this.ownerId,
    required this.walletDeficitLimit,
    required this.maxInspectionRetries,
    required this.insuranceType,
    required this.identifier,
    required this.lastWeeklyReport,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.productCategoryId,
    required this.providerId,
    required this.providerUrl,
    required this.logo,
    required this.icon,
    required this.brandColorPrimary,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      country: json['country'],
      companyName: json['company_name'],
      companyTradingName: json['company_trading_name'],
      companyAbbreviation: json['company_abbreviation'],
      companyAddress: json['company_address'],
      salesEmail: json['sales_email'],
      claimSupportEmail: json['claim_support_email'],
      inspectionSupportEmail: json['inspection_support_email'],
      isOnboarded: json['isOnboarded'],
      dateOnboarded: json['dateOnboarded'] != null
          ? DateTime.parse(json['dateOnboarded'])
          : null,
      verificationType: json['verification_type'],
      verificationImages: json['verification_images'],
      verificationNumber: json['verification_number'],
      bvnNumber: json['bvn_number'],
      businessType: json['business_type'],
      claimEmail: json['claim_email'],
      businessEmail: json['business_email'],
      supportEmail: json['support_email'],
      active: json['active'],
      bankAccountId: json['bank_account_id'],
      ownerId: json['owner_id'],
      walletDeficitLimit: json['wallet_deficit_limit'],
      maxInspectionRetries: json['max_inspection_retries'],
      insuranceType: json['insurance_type'],
      identifier: json['identifier'],
      lastWeeklyReport: json['last_weekly_report'] != null
          ? DateTime.parse(json['last_weekly_report'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      productCategoryId: json['products.product_category_id'],
      providerId: json['products.provider_id'],
      providerUrl: json['products.provider_url'],
      logo: json['logo'],
      icon: json['icon'],

      brandColorPrimary: json['brand_color_primary'],
      // settings.logo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'country': country,
      'company_name': companyName,
      'company_trading_name': companyTradingName,
      'company_abbreviation': companyAbbreviation,
      'company_address': companyAddress,
      'sales_email': salesEmail,
      'claim_support_email': claimSupportEmail,
      'inspection_support_email': inspectionSupportEmail,
      'isOnboarded': isOnboarded,
      'dateOnboarded': dateOnboarded?.toIso8601String(),
      'verification_type': verificationType,
      'verification_images': verificationImages,
      'verification_number': verificationNumber,
      'bvn_number': bvnNumber,
      'business_type': businessType,
      'claim_email': claimEmail,
      'business_email': businessEmail,
      'support_email': supportEmail,
      'active': active,
      'bank_account_id': bankAccountId,
      'owner_id': ownerId,
      'wallet_deficit_limit': walletDeficitLimit,
      'max_inspection_retries': maxInspectionRetries,
      'insurance_type': insuranceType,
      'identifier': identifier,
      'last_weekly_report': lastWeeklyReport?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'products.product_category_id': productCategoryId,
      'products.provider_id': providerId,
      'products.provider_url': providerUrl,
      'logo': logo,
      'icon': icon,
      'brand_color_primary': brandColorPrimary,
    };
  }
}
