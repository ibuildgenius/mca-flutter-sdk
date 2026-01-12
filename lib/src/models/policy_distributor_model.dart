class PolicyDistributor {
  final String? businessName;
  final String? id;

  PolicyDistributor({
    this.businessName,
    this.id,
  });

  factory PolicyDistributor.fromJson(Map<String, dynamic> json) {
    return PolicyDistributor(
      businessName: json['business_name'],
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'business_name': businessName,
      'id': id,
    };
  }
}
