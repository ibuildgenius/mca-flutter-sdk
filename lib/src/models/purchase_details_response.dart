class PurchaseDetailsResponseModel {
  String? id;
  String? appMode;
  String? reference;
  String? transactionId;
  String? businessId;
  String? paymentOption;
  String? paymentChannel;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool processed;
  final bool inspected;
  final bool inspectable;
  final bool verified;

  final PurchaseDetailsPayload? payload;

  PurchaseDetailsResponseModel({
    required this.id,
    required this.appMode,
    required this.reference,
    required this.transactionId,
    required this.businessId,
    required this.paymentOption,
    required this.paymentChannel,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.processed,
    required this.inspected,
    required this.inspectable,
    required this.verified,
    required this.payload,
  });

  factory PurchaseDetailsResponseModel.fromJson(json) {
    return PurchaseDetailsResponseModel(
      id: json['id'],
      appMode: json['app_mode'],
      reference: json['reference'],
      transactionId: json['transaction_id'],
      businessId: json['business_id'],
      paymentOption: json['payment_option'],
      paymentChannel: json['payment_channel'],
      processed: json['processed'],
      inspected: json['inspected'],
      inspectable: json['inspectable'],
      verified: json['verified'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at']),
      payload: json['payload'] == null
          ? null
          : PurchaseDetailsPayload.fromJson(json['payload']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_mode': appMode,
      'reference': reference,
      'transaction_id': transactionId,
      'business_id': businessId,
      'payment_option': paymentOption,
      'payment_channel': paymentChannel,
      'processed': processed,
      'inspected': inspected,
      'inspectable': inspectable,
      'verified': verified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'payload': payload?.toJson(),
    };
  }
}

class PurchaseDetailsPayload {
  String? route;
  String? currency;
  String? productId;
  num? amount;

  final PurchasePayloadData? data;

  PurchaseDetailsPayload({
    required this.route,
    required this.currency,
    required this.productId,
    required this.amount,
    required this.data,
  });

  factory PurchaseDetailsPayload.fromJson(json) {
    return PurchaseDetailsPayload(
      route: json['route'],
      currency: json['currency'],
      productId: json['product_id'],
      amount: json['amount'],
      data: json['data'] == null
          ? null
          : PurchasePayloadData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'route': route,
      'currency': currency,
      'product_id': productId,
      'amount': amount,
      'data': data?.toJson(),
    };
  }
}

class PurchasePayloadData {
  String? email;
  String? phone;
  String? lastName;
  String? firstName;
  String? productId;
  String? phoneNumber;

  String? vehicleCategory;
  String? dateOfBirth;
  int? vehicleCost;

  PurchasePayloadData({
    required this.email,
    required this.phone,
    required this.lastName,
    required this.firstName,
    required this.productId,
    required this.phoneNumber,
    required this.vehicleCategory,
    required this.dateOfBirth,
    required this.vehicleCost,
  });

  factory PurchasePayloadData.fromJson(json) {
    return PurchasePayloadData(
      email: json['email'],
      phone: json['phone'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      productId: json['product_id'],
      phoneNumber: json['phone_number'],
      vehicleCategory: json['vehicle_category'],
      dateOfBirth: json['date_of_birth'],
      vehicleCost: json['vehicle_cost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'last_name': lastName,
      'first_name': firstName,
      'product_id': productId,
      'phone_number': phoneNumber,
      'vehicle_category': vehicleCategory,
      'date_of_birth': dateOfBirth,
      'vehicle_cost': vehicleCost,
    };
  }
}
