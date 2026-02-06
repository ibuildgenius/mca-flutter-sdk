class UssdProviderModel {
  String? provider;
  String? bankName;
  String? type;

  UssdProviderModel({
    required this.provider,
    required this.bankName,
    required this.type,
  });

  factory UssdProviderModel.fromJson(json) {
    return UssdProviderModel(
      provider: json['provider'],
      bankName: json['bank_name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'bank_name': bankName,
      'type': type,
    };
  }
}
