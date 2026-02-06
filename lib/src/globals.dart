import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/models/business_data_model.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/models/form_data_url_response.dart';
import 'package:mca_official_flutter_sdk/src/models/form_field_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_categories_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/models/sdk_initialization_response.dart';
import 'package:mca_official_flutter_sdk/src/models/ussd_provider_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/environment_config.dart';

enum BuildEnvironment { production, development }

class Global {
  static BuildContext? context;
  static late EnvironmentVariables environmentVariables;
  static List<String> prefixList = [];
  static String instanceId = "";
  static String publicKey = "";
  static String reference = "";
  static String claimId = "";
  static ClaimModel? claim;
  static ProductCategory? productCategory;
  static PaymentOption paymentOption = PaymentOption.gateway;
  static List<String> productId = [];
  static String? brandColorPrimary;
  static String? email;
  static String? phone;
  static Map<String, dynamic> form = {};
  static BusinessDetailsModel? businessDetails;
  static BusinessDetailsModel? businessDetailsFallback;
  static List<UssdProviderModel> ussdProviders = [];
  static bool isContactFieldsEditable = true;
  static bool isTest = true;
  static String policyId = '';
  static String? policyNumber;
  static String? inspectionEmail;
  static String? progress='';
  static String mode = ConstantString.liveMode;
  static TransactionType? transactionType;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GadgetType gadgetType = GadgetType.phone;

  static Function? onComplete = () {
    log("Done");
  };
  static Function? onClose = () {
    log("Done");
  };

  static String inspectionAddress = "";
  static String inspectionLongitude = "";
  static String inspectionLatitude = "";
}

final paymentOptionProvider =
    StateProvider<PaymentOption>((ref) => PaymentOption.gateway);
// final referenceProvider = StateProvider<String?>((ref) => null);
// final transactionTypeProvider =
//     StateProvider<TransactionType>((ref) => TransactionType.purchase);
final publicKeyProvider = StateProvider<String?>((ref) => null);
final onCompleteProvider = StateProvider<Function?>((ref) => null);
final onCloseProvider = StateProvider<Function?>((ref) => null);
final isContactFieldsEditableProvider = StateProvider<bool>((ref) => true);
// final formProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final initResponseProvider = StateProvider<SdkInitializationResponse?>((ref) => null);
final initResponseFallBackProvider = StateProvider<SdkInitializationResponse?>((ref) => null);

final productCategoriesProvider = StateProvider<List<ProductCategoriesModel>>((ref) => []);

final businessDetailsProvider = StateProvider<BusinessDetailsModel?>((ref) => null);
final businessFallBackDetailsProvider = StateProvider<BusinessDetailsModel?>((ref) => null);

//Filter
final filterFromNairaProvider = StateProvider<String?>((ref) => null);
final filterToNairaProvider = StateProvider<String?>((ref) => null);
final filterFromPercentProvider = StateProvider<String?>((ref) => null);
final filterToPercentProvider = StateProvider<String?>((ref) => null);

//FormFIeds
final formDataProvider = StateProvider<Map<String, dynamic>>((ref) {
  return Map<String, dynamic>.from(Global.form);
});
final urlFormDataProvider =
    StateProvider<Map<String, List<FormDataUrlResponse>>>((ref) => {});

final showFullScreenLoaderProvider = StateProvider<bool>((ref) => false);

//This stores all dropdown dependents, so they can refresh onchanged of the dependee
final urlDependentsProvider =
    StateProvider<Map<String, FormFieldModel>>((ref) => {});

final imageListProvider = StateProvider<List<Map<String, File?>>>((ref) => []);
final imagePlaceholderProvider =
    StateProvider<Map<String, String>>((ref) => {});

final productPriceProvider = StateProvider<num>((ref) => 0);

final autoValidateProvider = StateProvider<bool>((ref) => false);

final selectedBankProvider = StateProvider<UssdProviderModel?>((ref) => null);

///Selected Product
final selectedProductCategoryProvider =
    StateProvider<ProductCategoriesModel?>((ref) => null);

final selectedProductDetailsProvider =
    StateProvider<ProductDetailsModel?>((ref) => null);

///Global Item Pair
final globalItemListProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);

final globalItemPairProvider = StateProvider<Map<String, dynamic>>((ref) => {});

//ERROR VALIDATION
final formErrorsProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final shouldValidateImageplusDrop = StateProvider<bool>((ref) => false);
