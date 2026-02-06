class InspectionModel {
  final String? id;
  final String? appMode;
  final String? inspectionType;
  final String? inspectionStatus;
  final int? inspectionCount;
  final int? inspectionRetries;
  final bool? isApproved;
  final String? policyId;
  final String? customerId;
  final String? providerId;
  final String? productId;
  final String? distributorId;
  final dynamic vehicleInspectionMeta;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final dynamic gadgetInspectionMeta;
  final String? rejectionComment;
  final DateTime? deletedAt;

  InspectionModel({
    required this.id,
    required this.appMode,
    required this.inspectionType,
    required this.inspectionStatus,
    required this.inspectionCount,
    required this.inspectionRetries,
    required this.isApproved,
    required this.policyId,
    required this.customerId,
    required this.providerId,
    required this.productId,
    required this.distributorId,
    this.vehicleInspectionMeta,
    required this.updatedAt,
    required this.createdAt,
    this.gadgetInspectionMeta,
    this.rejectionComment,
    this.deletedAt,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: json['id'],
      appMode: json['app_mode'],
      inspectionType: json['inspection_type'],
      inspectionStatus: json['inspection_status'],
      inspectionCount: json['inspection_count'],
      inspectionRetries: json['inspection_retries'],
      isApproved: json['is_approved'] ?? false,
      policyId: json['policy_id'],
      customerId: json['customer_id'],
      providerId: json['provider_id'],
      productId: json['product_id'],
      distributorId: json['distributor_id'],
      vehicleInspectionMeta: json['vehicle_inspection_meta'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      gadgetInspectionMeta: json['gadget_inspection_meta'],
      rejectionComment: json['rejection_comment'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_mode': appMode,
      'inspection_type': inspectionType,
      'inspection_status': inspectionStatus,
      'inspection_count': inspectionCount,
      'inspection_retries': inspectionRetries,
      'is_approved': isApproved,
      'policy_id': policyId,
      'customer_id': customerId,
      'provider_id': providerId,
      'product_id': productId,
      'distributor_id': distributorId,
      'vehicle_inspection_meta': vehicleInspectionMeta,
      'updated_at': updatedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'gadget_inspection_meta': gadgetInspectionMeta,
      'rejection_comment': rejectionComment,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
