class ProductCategoriesModel {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final int? productCount;

  ProductCategoriesModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.productCount,
  });

  factory ProductCategoriesModel.fromJson(json) {
    return ProductCategoriesModel(
      id: json['id'],
      name: json['name'],
      productCount: json['product_count'] == null
          ? null
          : int.tryParse(json['product_count'].toString()),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'product_count': productCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
