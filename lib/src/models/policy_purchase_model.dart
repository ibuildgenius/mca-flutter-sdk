class PolicyPurchase {
  final String? id;
  final String? total;

  PolicyPurchase({
    this.id,
    this.total,
  });

  factory PolicyPurchase.fromJson(Map<String, dynamic> json) {
    return PolicyPurchase(
      id: json['id'] as String?,
      total: json['total'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total': total,
    };
  }
}
