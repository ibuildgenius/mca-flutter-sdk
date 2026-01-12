import 'package:mca_official_flutter_sdk/src/models/product_categories_model.dart';

class PolicyProductModel {
  final String? name;
  final String? description;
  final String? id;
  final bool? inspectable;
  final bool? isDynamicPricing;
  final bool? claimable;
  final String? routeName;
  final String? coverPeriod;
  // ProductCategory? productCategory;
  ProductCategoriesModel? productCategory;

  PolicyProductModel({
     this.name,
     this.description,
     this.id,
     this.inspectable,
     this.isDynamicPricing,
     this.claimable,
     this.routeName,
     this.productCategory,
    this.coverPeriod
  });

  factory PolicyProductModel.fromJson(Map<String, dynamic> json) {
    return PolicyProductModel(
      name: json['name'],
      description: json['description'],
      id: json['id'],
      inspectable: json['inspectable'],
      coverPeriod: json['cover_period'],
      isDynamicPricing: json['is_dynamic_pricing'],
      claimable: json['claimable'],
      routeName: json['route_name'],
      productCategory: json['product_category'] != null
          ? ProductCategoriesModel.fromJson(json['product_category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'id': id,
      'inspectable': inspectable,
      'is_dynamic_pricing': isDynamicPricing,
      'claimable': claimable,
      'route_name': routeName,
      'product_category': productCategory?.toJson(),
    };
  }
}
