class BankModel {
  final int? id;
  final String? name;
  final String? slug;
  final String? code;
  final String? longcode;
  // final String? gateway;
  final bool? payWithBank;
  final bool? supportsTransfer;
  final bool? active;
  final String? country;
  final String? currency;
  final String? type;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BankModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.code,
    required this.longcode,
    // required this.gateway,
    required this.payWithBank,
    required this.supportsTransfer,
    required this.active,
    required this.country,
    required this.currency,
    required this.type,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  // ---- equality overrides ----
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BankModel) return false;

    // Primary identity: country+code (bank code is typically unique per country)
    if (country != null &&
        code != null &&
        other.country != null &&
        other.code != null) {
      return country == other.country && code == other.code;
    }

    // Fallbacks if code/country are missing:
    if (id != null && other.id != null) return id == other.id;
    if (slug != null && other.slug != null) return slug == other.slug;

    // Last resort: name+country (not guaranteed unique, but deterministic)
    return name == other.name && country == other.country;
  }

  @override
  int get hashCode {
    if (country != null && code != null) return Object.hash(country, code);
    if (id != null) return id.hashCode;
    if (slug != null) return slug.hashCode;
    return Object.hash(name, country);
  }

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      code: json['code'],
      longcode: json['longcode'],
      // gateway: json['gateway'],
      payWithBank: json['pay_with_bank'],
      supportsTransfer: json['supports_transfer'],
      active: json['active'],
      country: json['country'],
      currency: json['currency'],
      type: json['type'],
      isDeleted: json['is_deleted'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,

      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'code': code,
      'longcode': longcode,
      // 'gateway': gateway,
      'pay_with_bank': payWithBank,
      'supports_transfer': supportsTransfer,
      'active': active,
      'country': country,
      'currency': currency,
      'type': type,
      'is_deleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
