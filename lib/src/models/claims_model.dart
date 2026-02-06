import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/models/customer_details_model.dart';

class ClaimModel {
  String? id;
  String? appMode;
  String? claimDescription;
  String? claimOwner;
  String? claimOwnerFirstName;
  String? claimOwnerLastName;
  String? declineReason;
  String? claimOwnerEmail;
  String? claimOwnerPhoneNumber;
  dynamic vehicleClaimMeta;
  dynamic gadgetClaimMeta;
  dynamic creditLifeClaimMeta;
  dynamic travelClaimMeta;
  String? claimType;
  String? claimAmount;
  String? estimateAmount;
  String? offerAmount;
  String? bettermentDeductionAmount;
  String? excessDeductionAmount;
  String? incidentDate;
  String? claimStatus;
  String? claimInvoiceUrl;
  String? offerFormUrl;
  int? inspectionCount;
  int? inspectionRetries;
  bool? isApproved;
  String? rejectionComment;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? productId;
  String? customerId;
  String? distributorId;
  String? claimId;
  String? providerId;
  String? policyId;
  String? inspectionId;
  CustomerDetails? customer;
  PolicyProvider? provider;
  PolicyProductModel? product;
  PolicyDistributor? distributor;
  PolicyModel? policy;
  dynamic inspection;
  dynamic comments;

  /// ✅ New field
  List<AdditionalInfo>? additionalInfo;

  ClaimModel({
    this.id,
    this.appMode,
    this.claimDescription,
    this.claimOwner,
    this.claimOwnerFirstName,
    this.claimOwnerLastName,
    this.declineReason,
    this.claimOwnerEmail,
    this.claimOwnerPhoneNumber,
    this.vehicleClaimMeta,
    this.gadgetClaimMeta,
    this.creditLifeClaimMeta,
    this.travelClaimMeta,
    this.claimType,
    this.claimAmount,
    this.estimateAmount,
    this.offerAmount,
    this.bettermentDeductionAmount,
    this.excessDeductionAmount,
    this.incidentDate,
    this.claimStatus,
    this.claimInvoiceUrl,
    this.offerFormUrl,
    this.inspectionCount,
    this.inspectionRetries,
    this.isApproved,
    this.rejectionComment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.productId,
    this.customerId,
    this.distributorId,
    this.claimId,
    this.providerId,
    this.policyId,
    this.inspectionId,
    this.customer,
    this.provider,
    this.product,
    this.distributor,
    this.policy,
    this.inspection,
    this.comments,
    this.additionalInfo, // ✅ added
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      id: json['id'],
      appMode: json['app_mode'],
      claimDescription: json['claim_description'],
      claimOwner: json['claim_owner'],
      claimOwnerFirstName: json['claim_owner_first_name'],
      claimOwnerLastName: json['claim_owner_last_name'],
      declineReason: json['decline_reason'],
      claimOwnerEmail: json['claim_owner_email'],
      claimOwnerPhoneNumber: json['claim_owner_phone_number'],
      vehicleClaimMeta: json['vehicle_claim_meta'],
      gadgetClaimMeta: json['gadget_claim_meta'],
      creditLifeClaimMeta: json['credit_life_claim_meta'],
      travelClaimMeta: json['travel_claim_meta'],
      claimType: json['claim_type'],
      claimAmount: json['claim_amount'],
      estimateAmount: json['estimate_amount']?.toString(),
      offerAmount: json['offer_amount'],
      bettermentDeductionAmount: json['betterment_deduction_amount'],
      excessDeductionAmount: json['excess_deduction_amount'],
      incidentDate: json['incident_date'],
      claimStatus: json['claim_status'],
      claimInvoiceUrl: json['claim_invoice_url'],
      offerFormUrl: json['offer_form_url'],
      inspectionCount: json['inspection_count'],
      inspectionRetries: json['inspection_retries'],
      isApproved: json['is_approved'],
      rejectionComment: json['rejection_comment'],
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
      distributorId: json['distributor_id'],
      claimId: json['claim_id'],
      providerId: json['provider_id'],
      policyId: json['policy_id'],
      inspectionId: json['inspection_id'],
      customer: json['customer'] != null
          ? CustomerDetails.fromJson(json['customer'])
          : null,
      provider: json['provider'] != null
          ? PolicyProvider.fromJson(json['provider'])
          : null,
      product: json['product'] != null
          ? PolicyProductModel.fromJson(json['product'])
          : null,
      distributor: json['distributor'] != null
          ? PolicyDistributor.fromJson(json['distributor'])
          : null,
      policy:
      json['policy'] != null ? PolicyModel.fromJson(json['policy']) : null,
      inspection: json['inspection'],
      comments: json['comments'],
      additionalInfo: json['additional_info'] != null
          ? (json['additional_info'] as List)
          .map((e) => AdditionalInfo.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_mode': appMode,
      'claim_description': claimDescription,
      'claim_owner': claimOwner,
      'claim_owner_first_name': claimOwnerFirstName,
      'claim_owner_last_name': claimOwnerLastName,
      'decline_reason': declineReason,
      'claim_owner_email': claimOwnerEmail,
      'claim_owner_phone_number': claimOwnerPhoneNumber,
      'vehicle_claim_meta': vehicleClaimMeta,
      'gadget_claim_meta': gadgetClaimMeta,
      'credit_life_claim_meta': creditLifeClaimMeta,
      'travel_claim_meta': travelClaimMeta,
      'claim_type': claimType,
      'claim_amount': claimAmount,
      'estimate_amount': estimateAmount,
      'offer_amount': offerAmount,
      'betterment_deduction_amount': bettermentDeductionAmount,
      'excess_deduction_amount': excessDeductionAmount,
      'incident_date': incidentDate,
      'claim_status': claimStatus,
      'claim_invoice_url': claimInvoiceUrl,
      'offer_form_url': offerFormUrl,
      'inspection_count': inspectionCount,
      'inspection_retries': inspectionRetries,
      'is_approved': isApproved,
      'rejection_comment': rejectionComment,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'product_id': productId,
      'customer_id': customerId,
      'distributor_id': distributorId,
      'claim_id': claimId,
      'provider_id': providerId,
      'policy_id': policyId,
      'inspection_id': inspectionId,
      'customer': customer?.toJson(),
      'provider': provider?.toJson(),
      'product': product?.toJson(),
      'distributor': distributor?.toJson(),
      'policy': policy?.toJson(),
      'inspection': inspection?.toJson(),
      'comments': comments,
      'additional_info':
      additionalInfo?.map((info) => info.toJson()).toList(), // ✅
    };
  }
}

/// New model for additional_info
class AdditionalInfo {
  final String? id;
  final dynamic data;
  final String? type;
  final String? label;
  final String? userType;
  final String? description;

  AdditionalInfo({
    this.id,
    this.data,
    this.type,
    this.label,
    this.userType,
    this.description,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      id: json['id'],
      data: json['data'],
      type: json['type'],
      label: json['label'],
      userType: json['user_type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'type': type,
      'label': label,
      'user_type': userType,
      'description': description,
    };
  }

  /// ✅ copyWith method
  AdditionalInfo copyWith({
    String? id,
    dynamic data,
    String? type,
    String? label,
    String? userType,
    String? description,
  }) {
    return AdditionalInfo(
      id: id ?? this.id,
      data: data ?? this.data,
      type: type ?? this.type,
      label: label ?? this.label,
      userType: userType ?? this.userType,
      description: description ?? this.description,
    );
  }
}




// class ClaimModel {
//   String? id;
//   String? appMode;
//   String? claimDescription;
//   String? claimOwner;
//   String? claimOwnerFirstName;
//   String? claimOwnerLastName;
//   String? declineReason;
//   String? claimOwnerEmail;
//   String? claimOwnerPhoneNumber;
//   dynamic vehicleClaimMeta;
//   dynamic gadgetClaimMeta;
//   dynamic creditLifeClaimMeta;
//   dynamic travelClaimMeta;
//   String? claimType;
//   String? claimAmount;
//   String? estimateAmount;
//   String? offerAmount;
//   String? bettermentDeductionAmount;
//   String? excessDeductionAmount;
//   String? incidentDate;
//   String? claimStatus;
//   String? claimInvoiceUrl;
//   String? offerFormUrl;
//   int? inspectionCount;
//   int? inspectionRetries;
//   bool? isApproved;
//   String? rejectionComment;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   DateTime? deletedAt;
//   String? productId;
//   String? customerId;
//   String? distributorId;
//   String? claimId;
//   String? providerId;
//   String? policyId;
//   String? inspectionId;
//   CustomerDetails? customer;
//   PolicyProvider? provider;
//   PolicyProductModel? product;
//   PolicyDistributor? distributor;
//   PolicyModel? policy;
//   dynamic inspection;
//   dynamic comments;
//
//   ClaimModel({
//     this.id,
//     this.appMode,
//     this.claimDescription,
//     this.claimOwner,
//     this.claimOwnerFirstName,
//     this.claimOwnerLastName,
//     this.declineReason,
//     this.claimOwnerEmail,
//     this.claimOwnerPhoneNumber,
//     this.vehicleClaimMeta,
//     this.gadgetClaimMeta,
//     this.creditLifeClaimMeta,
//     this.travelClaimMeta,
//     this.claimType,
//     this.claimAmount,
//     this.estimateAmount,
//     this.offerAmount,
//     this.bettermentDeductionAmount,
//     this.excessDeductionAmount,
//     this.incidentDate,
//     this.claimStatus,
//     this.claimInvoiceUrl,
//     this.offerFormUrl,
//     this.inspectionCount,
//     this.inspectionRetries,
//     this.isApproved,
//     this.rejectionComment,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.productId,
//     this.customerId,
//     this.distributorId,
//     this.claimId,
//     this.providerId,
//     this.policyId,
//     this.inspectionId,
//     this.customer,
//     this.provider,
//     this.product,
//     this.distributor,
//     this.policy,
//     this.inspection,
//     this.comments,
//   });
//
//   factory ClaimModel.fromJson(Map<String, dynamic> json) {
//     return ClaimModel(
//       id: json['id'],
//       appMode: json['app_mode'],
//       claimDescription: json['claim_description'],
//       claimOwner: json['claim_owner'],
//       claimOwnerFirstName: json['claim_owner_first_name'],
//       claimOwnerLastName: json['claim_owner_last_name'],
//       declineReason: json['decline_reason'],
//       claimOwnerEmail: json['claim_owner_email'],
//       claimOwnerPhoneNumber: json['claim_owner_phone_number'],
//       vehicleClaimMeta: json['vehicle_claim_meta'],
//       gadgetClaimMeta: json['gadget_claim_meta'],
//       creditLifeClaimMeta: json['credit_life_claim_meta'],
//       travelClaimMeta: json['travel_claim_meta'],
//       claimType: json['claim_type'],
//       claimAmount: json['claim_amount'],
//       estimateAmount: json['estimate_amount'].toString(),
//       offerAmount: json['offer_amount'],
//       bettermentDeductionAmount: json['betterment_deduction_amount'],
//       excessDeductionAmount: json['excess_deduction_amount'],
//       incidentDate: json['incident_date'],
//       claimStatus: json['claim_status'],
//       claimInvoiceUrl: json['claim_invoice_url'],
//       offerFormUrl: json['offer_form_url'],
//       inspectionCount: json['inspection_count'],
//       inspectionRetries: json['inspection_retries'],
//       isApproved: json['is_approved'],
//       rejectionComment: json['rejection_comment'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//       updatedAt: json['updated_at'] != null
//           ? DateTime.parse(json['updated_at'])
//           : null,
//       deletedAt: json['deleted_at'] != null
//           ? DateTime.parse(json['deleted_at'])
//           : null,
//       productId: json['product_id'],
//       customerId: json['customer_id'],
//       distributorId: json['distributor_id'],
//       claimId: json['claim_id'],
//       providerId: json['provider_id'],
//       policyId: json['policy_id'],
//       inspectionId: json['inspection_id'],
//       customer: json['customer'] != null
//           ? CustomerDetails.fromJson(json['customer'])
//           : null,
//       provider: json['provider'] != null
//           ? PolicyProvider.fromJson(json['provider'])
//           : null,
//       product: json['product'] != null
//           ? PolicyProductModel.fromJson(json['product'])
//           : null,
//       distributor: json['distributor'] != null
//           ? PolicyDistributor.fromJson(json['distributor'])
//           : null,
//       policy:
//           json['policy'] != null ? PolicyModel.fromJson(json['policy']) : null,
//       inspection: json['inspection'],
//       comments: json['comments'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'app_mode': appMode,
//       'claim_description': claimDescription,
//       'claim_owner': claimOwner,
//       'claim_owner_first_name': claimOwnerFirstName,
//       'claim_owner_last_name': claimOwnerLastName,
//       'decline_reason': declineReason,
//       'claim_owner_email': claimOwnerEmail,
//       'claim_owner_phone_number': claimOwnerPhoneNumber,
//       'vehicle_claim_meta': vehicleClaimMeta,
//       'gadget_claim_meta': gadgetClaimMeta,
//       'credit_life_claim_meta': creditLifeClaimMeta,
//       'travel_claim_meta': travelClaimMeta,
//       'claim_type': claimType,
//       'claim_amount': claimAmount,
//       'estimate_amount': estimateAmount,
//       'offer_amount': offerAmount,
//       'betterment_deduction_amount': bettermentDeductionAmount,
//       'excess_deduction_amount': excessDeductionAmount,
//       'incident_date': incidentDate,
//       'claim_status': claimStatus,
//       'claim_invoice_url': claimInvoiceUrl,
//       'offer_form_url': offerFormUrl,
//       'inspection_count': inspectionCount,
//       'inspection_retries': inspectionRetries,
//       'is_approved': isApproved,
//       'rejection_comment': rejectionComment,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//       'deleted_at': deletedAt?.toIso8601String(),
//       'product_id': productId,
//       'customer_id': customerId,
//       'distributor_id': distributorId,
//       'claim_id': claimId,
//       'provider_id': providerId,
//       'policy_id': policyId,
//       'inspection_id': inspectionId,
//       'customer': customer?.toJson(),
//       'provider': provider?.toJson(),
//       'product': product?.toJson(),
//       'distributor': distributor?.toJson(),
//       'policy': policy?.toJson(),
//       'inspection': inspection?.toJson(),
//       'comments': comments,
//     };
//   }
// }
