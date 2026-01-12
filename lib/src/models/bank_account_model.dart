class BankAccountModel {
  final String? accountNumber;
  final String? accountName;
  final int? bankId;

  BankAccountModel({
    required this.accountNumber,
    required this.accountName,
    required this.bankId,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      accountNumber: json['account_number'],
      accountName: json['account_name'],
      bankId: json['bank_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_id': bankId,
    };
  }
}
