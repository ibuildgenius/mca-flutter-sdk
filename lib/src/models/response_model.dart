import 'dart:convert';

class ResponseModel {
  ResponseModel({
    required this.responseCode,
    required this.responseText,
    required this.data,
  });

  int responseCode;
  String responseText;
  Data data;


  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    responseCode: json["responseCode"],
    responseText: json["responseText"],
    data: Data.fromJson(json["data"]),
  );


}

class Data {
  Data({
    required this.businessDetails,
    required this.productDetails,
  });

  BusinessDetails businessDetails;
  List<ProductDetail> productDetails;


  factory Data.fromJson(Map<String, dynamic> json) => Data(
    businessDetails: BusinessDetails.fromJson(json["businessDetails"]),
    productDetails: List<ProductDetail>.from(json["productDetails"].map((x) => ProductDetail.fromJson(x))),
  );

}

class BusinessDetails {
  BusinessDetails({
    required this.id,
    required this.tradingName,
    required this.businessName,
  });

  String id;
  String tradingName;
  String businessName;

  factory BusinessDetails.fromRawJson(String str) => BusinessDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessDetails.fromJson(Map<String, dynamic> json) => BusinessDetails(
    id: json["id"],
    tradingName: json["trading_name"],
    businessName: json["business_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "trading_name": tradingName,
    "business_name": businessName,
  };
}

class ProductDetail {
  ProductDetail({
    required this.id,
    required this.name,
    required this.productCategoryId,
    required this.providerId,
    required this.keyBenefits,
    required this.fullBenefits,
    required this.description,
    required this.productCategory,
    required this.prefix,
    required this.routeName,
    required this.renewable,
    required this.claimable,
    required this.inspectable,
    required this.certificateable,
    required this.isDynamicPricing,
    required this.price,
    required this.distributorCommissionPercentage,
    required this.mcaCommissionPercentage,
    required this.coverPeriod,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.formFields,
  });

  String id;
  String name;
  String productCategoryId;
  String providerId;
  String keyBenefits;
  List<FullBenefit> fullBenefits;
  String description;
  ProductCategory productCategory;
  String prefix;
  String routeName;
  bool renewable;
  bool claimable;
  bool inspectable;
  bool certificateable;
  bool isDynamicPricing;
  String price;
  String distributorCommissionPercentage;
  String mcaCommissionPercentage;
  dynamic coverPeriod;
  bool active;
  String createdAt;
  String updatedAt;
  List<FormField> formFields;



  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
    id: json["id"],
    name: json["name"],
    productCategoryId: json["product_category_id"],
    providerId: json["provider_id"],
    keyBenefits: json["key_benefits"],
    fullBenefits: List<FullBenefit>.from(json["full_benefits"].map((x) => FullBenefit.fromJson(x))),
    description: json["description"],
    productCategory: ProductCategory.fromJson(json["productCategory"]),
    prefix: json["prefix"],
    routeName: json["route_name"],
    renewable: json["renewable"],
    claimable: json["claimable"],
    inspectable: json["inspectable"],
    certificateable: json["certificateable"],
    isDynamicPricing: json["is_dynamic_pricing"],
    price: json["price"],
    distributorCommissionPercentage: json["distributor_commission_percentage"],
    mcaCommissionPercentage: json["mca_commission_percentage"],
    coverPeriod: json["cover_period"],
    active: json["active"],
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
    formFields: List<FormField>.from(json["form_fields"].map((x) => FormField.fromJson(x))),
  );

}

class FormField {
  FormField({
    required this.id,
    required this.productId,
    required this.formFieldId,
    required this.description,
    required this.name,
    required this.label,
    required this.position,
    required this.fullDescription,
    required this.dataType,
    required this.inputType,
    required this.required,
    required this.errorMsg,
    required this.dataSource,
    required this.dataUrl,
    // required this.meta,
    required this.min,
    required this.max,
    required this.minMaxConstraint,
    required this.createdAt,
    required this.updatedAt,
    required this.formField,
  });

  String id;
  String productId;
  String formFieldId;
  String description;
  String name;
  String label;
  int? position;
  String fullDescription;
  String dataType;
  String inputType;
  bool? required;
  String errorMsg;
  String dataSource;
  String dataUrl;
  // dynamic meta;
  String min;
  String max;
  String minMaxConstraint;
  String createdAt;
  String updatedAt;
  ProductCategory? formField;



  factory FormField.fromJson(Map<String, dynamic> parseJson) => FormField(
    id: parseJson["id"].toString(),
    productId: parseJson["product_id"].toString(),
    formFieldId: parseJson["form_field_id"].toString(),
    description: parseJson["description"].toString(),
    name: parseJson["name"].toString(),
    label: parseJson["label"].toString(),
    position: parseJson["position"],
    fullDescription: parseJson["full_description"].toString(),
    dataType: parseJson["data_type"].toString(),
    inputType: parseJson["input_type"].toString(),
    required: parseJson["required"],
    errorMsg: parseJson["error_msg"].toString(),
    dataSource: parseJson["data_source"].toString(),
    dataUrl: parseJson["data_url"] ?? null.toString(),
    // meta: parseJson["meta"],
    min: parseJson["min"] ?? null.toString(),
    max: parseJson["max"].toString(),
    minMaxConstraint: parseJson["min_max_constraint"].toString(),
    createdAt: parseJson["created_at"].toString(),
    updatedAt: parseJson["updated_at"].toString(),
    formField: ProductCategory.fromJson(parseJson["form_field"]),
  );

}



class ProductCategory {
  ProductCategory({
    required this.id,
    required this.name,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String name;
  String label;
  String createdAt;
  String updatedAt;


  factory ProductCategory.fromJson(Map<String, dynamic> parseJson) => ProductCategory(
    id: parseJson["id"].toString(),
    name: parseJson["name"].toString(),
    label: parseJson["label"].toString(),
    createdAt: parseJson["created_at"].toString(),
    updatedAt: parseJson["updated_at"].toString(),
  );

}


class FullBenefit {
  FullBenefit({
    required this.name,
    required this.description,
  });

  String name;
  String description;


  factory FullBenefit.fromJson(Map<String, dynamic> json) => FullBenefit(
    name: json["name"].toString(),
    description: json["description"].toString(),
  );


}


