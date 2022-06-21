// To parse this parsedJson data, do
//
//     final responseModel = responseModelfromJson(parsedJsonString);

import 'package:meta/meta.dart';
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


  factory ResponseModel.fromJson(Map<String, dynamic> parsedJson) => ResponseModel(
    responseCode: parsedJson["responseCode"],
    responseText: parsedJson["responseText"],
    data: Data.fromJson(parsedJson["data"]),
  );

}

class Data {
  Data({
    required this.businessDetails,
    required this.productDetails,
  });

  BusinessDetails businessDetails;
  List<ProductDetail> productDetails;


  factory Data.fromJson(Map<String, dynamic> parsedJson) => Data(
    businessDetails: BusinessDetails.fromJson(parsedJson["businessDetails"]),
    productDetails: List<ProductDetail>.from(parsedJson["productDetails"].map((x) => ProductDetail.fromJson(x))),
  );

}

class BusinessDetails {
  BusinessDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.state,
    required this.officeAddress,
    required this.distributorType,
    required this.tradingName,
    required this.distributorCategory,
    required this.certifiedApplicationForm,
    required this.certificateOfBusinessName,
    required this.rcNumber,
    required this.distributorVerified,
    required this.individualVerificationType,
    required this.verificationNumber,
    required this.bvnNumber,
    required this.individualVerified,
    required this.businessIndustry,
    required this.businessDescription,
    required this.staffStrength,
    required this.businessName,
    required this.businessPhoneNumber,
    required this.businessEmail,
    required this.supportEmail,
    required this.registrationType,
    required this.website,
    required this.socialHandles,
    required this.active,
    required this.isKycSubmitted,
    required this.createdAt,
    required this.updatedAt,
    required this.walletId,
    required this.walletDeficitLimit,
    required this.ownerId,
    required this.directorFirstName,
    required this.directorLastName,
    required this.directorEmail,
    required this.directorPhoneNumber,
    required this.directorBvn,
    required this.directorVerificationType,
    required this.directorVerificationNumber,
    required this.directorDateOfBirth,
    required this.directorAddress,
    required this.countryOfBusinessOwner,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String country;
  String state;
  String officeAddress;
  dynamic distributorType;
  String tradingName;
  String distributorCategory;
  dynamic certifiedApplicationForm;
  dynamic certificateOfBusinessName;
  dynamic rcNumber;
  bool distributorVerified;
  String individualVerificationType;
  String verificationNumber;
  String bvnNumber;
  bool individualVerified;
  String businessIndustry;
  String businessDescription;
  String staffStrength;
  String businessName;
  String businessPhoneNumber;
  String businessEmail;
  String supportEmail;
  String registrationType;
  String website;
  List<String> socialHandles;
  bool active;
  bool isKycSubmitted;
  String createdAt;
  String updatedAt;
  String walletId;
  String walletDeficitLimit;
  String ownerId;
  dynamic directorFirstName;
  dynamic directorLastName;
  dynamic directorEmail;
  dynamic directorPhoneNumber;
  dynamic directorBvn;
  dynamic directorVerificationType;
  dynamic directorVerificationNumber;
  dynamic directorDateOfBirth;
  dynamic directorAddress;
  String countryOfBusinessOwner;


  factory BusinessDetails.fromJson(Map<String, dynamic> parsedJson) => BusinessDetails(
    id: parsedJson["id"],
    firstName: parsedJson["first_name"],
    lastName: parsedJson["last_name"],
    email: parsedJson["email"],
    phoneNumber: parsedJson["phone_number"],
    country: parsedJson["country"],
    state: parsedJson["state"],
    officeAddress: parsedJson["office_address"],
    distributorType: parsedJson["distributor_type"],
    tradingName: parsedJson["trading_name"],
    distributorCategory: parsedJson["distributor_category"],
    certifiedApplicationForm: parsedJson["certified_application_form"],
    certificateOfBusinessName: parsedJson["certificate_of_business_name"],
    rcNumber: parsedJson["rc_number"],
    distributorVerified: parsedJson["distributor_verified"],
    individualVerificationType: parsedJson["individual_verification_type"],
    verificationNumber: parsedJson["verification_number"],
    bvnNumber: parsedJson["bvn_number"],
    individualVerified: parsedJson["individual_verified"],
    businessIndustry: parsedJson["business_industry"],
    businessDescription: parsedJson["business_description"],
    staffStrength: parsedJson["staff_strength"],
    businessName: parsedJson["business_name"],
    businessPhoneNumber: parsedJson["business_phone_number"],
    businessEmail: parsedJson["business_email"],
    supportEmail: parsedJson["support_email"],
    registrationType: parsedJson["registration_type"],
    website: parsedJson["website"],
    socialHandles: List<String>.from(parsedJson["social_handles"].map((x) => x)),
    active: parsedJson["active"],
    isKycSubmitted: parsedJson["is_kyc_submitted"],
    createdAt: parsedJson["created_at"].toString(),
    updatedAt: parsedJson["updated_at"].toString(),
    walletId: parsedJson["wallet_id"],
    walletDeficitLimit: parsedJson["wallet_deficit_limit"],
    ownerId: parsedJson["owner_id"],
    directorFirstName: parsedJson["director_first_name"],
    directorLastName: parsedJson["director_last_name"],
    directorEmail: parsedJson["director_email"],
    directorPhoneNumber: parsedJson["director_phone_number"],
    directorBvn: parsedJson["director_bvn"],
    directorVerificationType: parsedJson["director_verification_type"],
    directorVerificationNumber: parsedJson["director_verification_number"],
    directorDateOfBirth: parsedJson["director_date_of_birth"],
    directorAddress: parsedJson["director_address"],
    countryOfBusinessOwner: parsedJson["country_of_business_owner"],
  );

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
    required this.meta,
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
  Meta meta;
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


  factory ProductDetail.fromJson(Map<String, dynamic> parsedJson) => ProductDetail(
    id: parsedJson["id"],
    name: parsedJson["name"],
    productCategoryId: parsedJson["product_category_id"],
    providerId: parsedJson["provider_id"],
    keyBenefits: parsedJson["key_benefits"],
    fullBenefits: List<FullBenefit>.from(parsedJson["full_benefits"].map((x) => FullBenefit.fromJson(x))),
    description: parsedJson["description"],
    productCategory: ProductCategory.fromJson(parsedJson["productCategory"]),
    meta: Meta.fromJson(parsedJson["meta"]),
    prefix: parsedJson["prefix"],
    routeName: parsedJson["route_name"],
    renewable: parsedJson["renewable"],
    claimable: parsedJson["claimable"],
    inspectable: parsedJson["inspectable"],
    certificateable: parsedJson["certificateable"],
    isDynamicPricing: parsedJson["is_dynamic_pricing"],
    price: parsedJson["price"],
    distributorCommissionPercentage: parsedJson["distributor_commission_percentage"],
    mcaCommissionPercentage: parsedJson["mca_commission_percentage"],
    coverPeriod: parsedJson["cover_period"],
    active: parsedJson["active"],
    createdAt: parsedJson["created_at"].toString(),
    updatedAt: parsedJson["updated_at"].toString(),
    formFields: List<FormField>.from(parsedJson["form_fields"].map((x) => FormField.fromJson(x))),
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
    required this.fullDescription,
    required this.dataType,
    required this.inputType,
    required this.required,
    required this.errorMsg,
    required this.dataSource,
    required this.dataUrl,
    required this.meta,
    required this.min,
    required this.max,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String productId;
  String formFieldId;
  String description;
  String name;
  String label;
  String fullDescription;
  String dataType;
  String inputType;
  bool required;
  String errorMsg;
  String dataSource;
  String dataUrl;
  dynamic meta;
  int min;
  dynamic max;
  String createdAt;
  String updatedAt;



  factory FormField.fromJson(Map<String, dynamic> parsedJson) => FormField(
    id: parsedJson["id"],
    productId: parsedJson["product_id"],
    formFieldId: parsedJson["form_field_id"],
    description: parsedJson["description"],
    name: parsedJson["name"],
    label: parsedJson["label"],
    fullDescription: parsedJson["full_description"],
    dataType: parsedJson["data_type"],
    inputType: parsedJson["input_type"],
    required: parsedJson["required"],
    errorMsg: parsedJson["error_msg"],
    dataSource: parsedJson["data_source"],
    dataUrl: parsedJson["data_url"],
    meta: parsedJson["meta"],
    min: parsedJson["min"],
    max: parsedJson["max"],
    createdAt: parsedJson["created_at"].toString(),
    updatedAt: parsedJson["updated_at"].toString(),
  );

}




class FullBenefit {
  FullBenefit({
    required this.name,
    required this.description,
  });

  String name;
  String description;


  factory FullBenefit.fromJson(Map<String, dynamic> parsedJson) => FullBenefit(
    name: parsedJson["name"],
    description: parsedJson["description"],
  );

}

class Meta {
  Meta({
    required this.productId,
    required this.subClassId,
    required this.productName,
    required this.sectionType,
    required this.subClassName,
  });

  String productId;
  String subClassId;
  String productName;
  String sectionType;
  String subClassName;


  factory Meta.fromJson(Map<String, dynamic> parsedJson) => Meta(
    productId: parsedJson["productId"],
    subClassId: parsedJson["subClassId"],
    productName: parsedJson["productName"],
    sectionType: parsedJson["sectionType"],
    subClassName: parsedJson["subClassName"],
  );

 
}

class ProductCategory {
  ProductCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String name;
  String createdAt;
  String updatedAt;


  factory ProductCategory.fromJson(Map<String, dynamic> parsedJson) => ProductCategory(
    id: parsedJson["id"],
    name: parsedJson["name"],
    createdAt: parsedJson["created_at"].toString(),
    updatedAt: parsedJson["updated_at"].toString(),
  );

}

