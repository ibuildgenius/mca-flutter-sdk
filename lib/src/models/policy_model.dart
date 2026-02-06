import 'package:mca_official_flutter_sdk/src/models/policy_customer_model.dart';
import 'package:mca_official_flutter_sdk/src/models/policy_distributor_model.dart';
import 'package:mca_official_flutter_sdk/src/models/policy_product_model.dart';
import 'package:mca_official_flutter_sdk/src/models/policy_provider.dart';
import 'package:mca_official_flutter_sdk/src/models/policy_purchase_model.dart';

class PolicyModel {
  final String? id;
  final String? appMode;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? dob;
  final String? productCategoryId;
  final DateTime? activationDate;
  final DateTime? startDate;
  final DateTime? expirationDate;
  final num? marketPrice;
  final num? geniusPrice;
  final num? profit;
  final dynamic meta;
  final dynamic history;
  final bool? active;
  final bool? submittedToProvider;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? productId;
  final String? customerId;
  final String? buyerId;
  final String? distributorId;
  final String? providerId;
  final String? purchaseId;
  final PolicyCustomerModel? customer;
  final PolicyProductModel? product;
  final PolicyDistributor? distributor;
  final PolicyProvider? provider;
  final PolicyPurchase? purchase;
  final List<dynamic>? inspections;

  PolicyModel({
    this.id,
    this.appMode,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.dob,
    this.productCategoryId,
    this.activationDate,
    this.startDate,
    this.expirationDate,
    this.marketPrice,
    this.geniusPrice,
    this.profit,
    this.meta,
    this.history,
    this.active,
    this.submittedToProvider,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.productId,
    this.customerId,
    this.buyerId,
    this.distributorId,
    this.providerId,
    this.purchaseId,
    this.customer,
    this.product,
    this.distributor,
    this.provider,
    this.purchase,
    this.inspections,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id'],
      appMode: json['app_mode'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      productCategoryId: json['product_category_id'],
      activationDate: json['activation_date'] != null
          ? DateTime.parse(json['activation_date'])
          : null,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      expirationDate: json['expiration_date'] != null
          ? DateTime.parse(json['expiration_date'])
          : null,
      marketPrice: json['market_price'],
      geniusPrice: json['genius_price'],
      profit: json['profit'],
      meta: json['meta'],
      history: json['history'],
      active: json['active'],
      submittedToProvider: json['submitted_to_provider'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      productId: json['product_id'],
      customerId: json['customer_id'],
      buyerId: json['buyer_id'],
      distributorId: json['distributor_id'],
      providerId: json['provider_id'],
      purchaseId: json['purchase_id'],
      customer: json['customer'] != null
          ? PolicyCustomerModel.fromJson(json['customer'])
          : null,
      product: json['product'] != null
          ? PolicyProductModel.fromJson(json['product'])
          : null,
      distributor: json['distributor'] != null
          ? PolicyDistributor.fromJson(json['distributor'])
          : null,
      provider: json['provider'] != null
          ? PolicyProvider.fromJson(json['provider'])
          : null,
      purchase: json['purchase'] != null
          ? PolicyPurchase.fromJson(json['purchase'])
          : null,
      inspections: json['inspections'] != null
          ? List<dynamic>.from(json['inspections'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_mode': appMode,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'dob': dob,
      'product_category_id': productCategoryId,
      'activation_date': activationDate?.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'expiration_date': expirationDate?.toIso8601String(),
      'market_price': marketPrice,
      'genius_price': geniusPrice,
      'profit': profit,
      'meta': meta.toJson(),
      'active': active,
      'submitted_to_provider': submittedToProvider,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt,
      'product_id': productId,
      'customer_id': customerId,
      'buyer_id': buyerId,
      'distributor_id': distributorId,
      'provider_id': providerId,
      'purchase_id': purchaseId,
      'customer': customer?.toJson(),
      'product': product?.toJson(),
      'distributor': distributor?.toJson(),
      'provider': provider?.toJson(),
      'purchase': purchase?.toJson(),
      'inspections': inspections,
    };
  }
}
