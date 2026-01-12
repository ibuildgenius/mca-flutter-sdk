class PolicyProvider {
  final String? companyName;
  final String? id;

  PolicyProvider({
     this.companyName,
     this.id,
  });

  factory PolicyProvider.fromJson(Map<String, dynamic> json) {
    return PolicyProvider(
      companyName: json['company_name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'id': id,
    };
  }
}
