class MetaModel {
  final String? price;
  final String? expiry;
  final String? period;
  final String? benefitDesc;
  final String? benefit;
  final String? payoutType;
  final String? document;
  final String? terms;
  final String? warranty;
  final String? features;

  MetaModel({
    required this.price,
    required this.expiry,
    required this.period,
    required this.benefitDesc,
    required this.benefit,
    required this.payoutType,
    required this.document,
    required this.terms,
    required this.warranty,
    required this.features,
  });

  factory MetaModel.fromJson(json) {
    return MetaModel(
      price: json['price'],
      expiry: json['expiry'],
      period: json['period'],
      benefitDesc: json['benefit_desc'],
      benefit: json['benefit'],
      payoutType: json['payout_type'],
      document: json['document'],
      terms: json['terms'],
      warranty: json['warranty'],
      features: json['features'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'expiry': expiry,
      'period': period,
      'benefit_desc': benefitDesc,
      'benefit': benefit,
      'payout_type': payoutType,
      'document': document,
      'terms': terms,
      'warranty': warranty,
      'features': features,
    };
  }
}
