import 'package:mca_official_flutter_sdk/src/models/form_field_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_categories_model.dart';
import 'package:mca_official_flutter_sdk/src/models/provider_lite_model.dart';

class ProductDetailsModel {
  String? id;
  String? name;
  String? keyBenefits;
  String? description;
  // dynamic meta;
  String? prefix;
  String? routeName;
  bool? renewable;
  bool? claimable;
  bool? inspectable;
  bool? certificateable;
  bool? isDynamicPricing;
  String? price;
  String? coverPeriod;
  bool? active;
  double? stabilityPercentageTestMode;
  double? stabilityPercentageLiveMode;
  String? howItWorks;
  String? howToClaim;
  String? businessHowItWorks;
  String? businessHowToClaim;
  String? fullBenefits;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? productCategoryId;
  String? providerId;
  ProviderLiteModel? provider;
  ProductCategoriesModel? productCategory;
  // ProductCategory? productCategory;
  List<FormFieldModel>? formFields;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.keyBenefits,
    required this.description,
    // required this.meta,
    required this.prefix,
    required this.routeName,
    required this.renewable,
    required this.claimable,
    required this.inspectable,
    required this.certificateable,
    required this.isDynamicPricing,
    required this.price,
    required this.coverPeriod,
    required this.active,
    required this.stabilityPercentageTestMode,
    required this.stabilityPercentageLiveMode,
    required this.howItWorks,
    required this.howToClaim,
    required this.fullBenefits,
    required this.businessHowItWorks,
    required this.businessHowToClaim,
    required this.createdAt,
    required this.updatedAt,
    required this.productCategoryId,
    required this.providerId,
    required this.provider,
    required this.productCategory,
    // required this.productCategory,
    required this.formFields,
  });

  factory ProductDetailsModel.fromJson(json) {
    return ProductDetailsModel(
      id: json['id'],
      name: json['name'],
      keyBenefits: json['key_benefits'],
      description: json['description'],
      // meta: (json['meta']),
      prefix: json['prefix'],
      routeName: json['route_name'],
      renewable: json['renewable'],
      claimable: json['claimable'],
      inspectable: json['inspectable'],
      certificateable: json['certificateable'],
      isDynamicPricing: json['is_dynamic_pricing'],
      price: json['price'],
      coverPeriod: json['cover_period'],
      active: json['active'],
      stabilityPercentageTestMode:
          json['stability_percentage_test_mode'].toDouble(),
      stabilityPercentageLiveMode:
          json['stability_percentage_live_mode'].toDouble(),
      howItWorks: json['how_it_works'],
      howToClaim: json['how_to_claim'],
      fullBenefits:
          json['full_benefits'] is String ? json['full_benefits'] : null,

      businessHowItWorks: json['business_how_it_works'],
      businessHowToClaim: json['business_how_to_claim'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      productCategoryId: json['product_category_id'],
      providerId: json['provider_id'],
      provider: ProviderLiteModel.fromJson(json['provider']),
      // productCategory: ProductCategory.fromJson(json['productCategory']),
      formFields: (json['form_fields'] != null &&
              (json['form_fields'] as List).isNotEmpty)
          ? (json['form_fields'] as List)
              .map((e) => FormFieldModel.fromJson(e))
              .toList()
          : [],
      productCategory: json['productCategory'] != null
          ? ProductCategoriesModel.fromJson(json['productCategory'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'key_benefits': keyBenefits,
      'description': description,
      // 'meta': meta,
      'prefix': prefix,
      'route_name': routeName,
      'renewable': renewable,
      'claimable': claimable,
      'inspectable': inspectable,
      'certificateable': certificateable,
      'is_dynamic_pricing': isDynamicPricing,
      'price': price,
      'cover_period': coverPeriod,
      'active': active,
      'stability_percentage_test_mode': stabilityPercentageTestMode,
      'stability_percentage_live_mode': stabilityPercentageLiveMode,
      'how_it_works': howItWorks,
      'how_to_claim': howToClaim,

      'full_benefits': fullBenefits,
      'business_how_it_works': businessHowItWorks,
      'business_how_to_claim': businessHowToClaim,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'product_category_id': productCategoryId,
      'provider_id': providerId,
      // 'provider': provider.toJson(),
      // 'productCategory': productCategory.toJson(),
      'product_category': productCategory?.toJson(),
      'form_fields': formFields?.map((field) => field.toJson()).toList(),
    };
  }
}
