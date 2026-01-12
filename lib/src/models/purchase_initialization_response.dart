class PurchaseinitializationModel {
  String? message;
  String? accountNumber;
  String? bank;
  String? ussdCode;
  String? paymentCode;
  num? amount;
  String? reference;

  PurchaseinitializationModel({
    required this.message,
    required this.accountNumber,
    required this.bank,
    required this.ussdCode,
    required this.paymentCode,
    required this.amount,
    required this.reference,
  });

  factory PurchaseinitializationModel.fromJson(json) {
    return PurchaseinitializationModel(
      message: json['message'],
      accountNumber: json['account_number'],
      bank: json['bank'],
      ussdCode: json['ussd_code'],
      paymentCode: json['payment_code'],
      amount: json['amount'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'account_number': accountNumber,
      'bank': bank,
      'ussd_code': ussdCode,
      'payment_code': paymentCode,
      'amount': amount,
      'reference': reference,
    };
  }
}
