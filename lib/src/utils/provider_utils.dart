import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';

class ProviderUtils {
  static void resetAllProviders(WidgetRef ref) {
    ref.read(paymentOptionProvider.notifier).state = PaymentOption.gateway;
    ref.read(publicKeyProvider.notifier).state = null;
    ref.read(onCompleteProvider.notifier).state = null;
    ref.read(onCloseProvider.notifier).state = null;
    ref.read(isContactFieldsEditableProvider.notifier).state = true;
    ref.read(initResponseProvider.notifier).state = null;
    ref.read(productCategoriesProvider.notifier).state = [];
    ref.read(businessDetailsProvider.notifier).state = null;

    // Filter
    ref.read(filterFromNairaProvider.notifier).state = null;
    ref.read(filterToNairaProvider.notifier).state = null;
    ref.read(filterFromPercentProvider.notifier).state = null;
    ref.read(filterToPercentProvider.notifier).state = null;

    // FormFields
    ref.read(formDataProvider.notifier).state =
        Map<String, dynamic>.from(Global.form);
    ref.read(urlFormDataProvider.notifier).state = {};
    ref.read(imageListProvider.notifier).state = [];
    ref.read(imagePlaceholderProvider.notifier).state = {};
    ref.read(productPriceProvider.notifier).state = 0;
    ref.read(autoValidateProvider.notifier).state = false;
    ref.read(selectedBankProvider.notifier).state = null;

    // Selected Product
    ref.read(selectedProductCategoryProvider.notifier).state = null;
    ref.read(selectedProductDetailsProvider.notifier).state = null;

    // Global Item Pair
    ref.read(globalItemListProvider.notifier).state = [];
    ref.read(globalItemPairProvider.notifier).state = {};

    // Error Validation
    ref.read(formErrorsProvider.notifier).state = {};
    ref.read(shouldValidateImageplusDrop.notifier).state = false;
  }

  static void resetAllFormProviders(WidgetRef ref) {
    // FormFields
    ref.read(formDataProvider.notifier).state =
        Map<String, dynamic>.from(Global.form);
    ref.read(urlFormDataProvider.notifier).state = {};
    ref.read(imageListProvider.notifier).state = [];
    ref.read(imagePlaceholderProvider.notifier).state = {};
    ref.read(productPriceProvider.notifier).state = 0;
    ref.read(autoValidateProvider.notifier).state = false;
    ref.read(selectedBankProvider.notifier).state = null;

    // Global Item Pair
    ref.read(globalItemListProvider.notifier).state = [];
    ref.read(globalItemPairProvider.notifier).state = {};

    // Error Validation
    ref.read(formErrorsProvider.notifier).state = {};
    ref.read(shouldValidateImageplusDrop.notifier).state = false;
  }

  static void resetVerificationProviders(WidgetRef ref) {
    ref.read(verificationStepProvider.notifier).state = CarVerificationStep.frontSidePreCapture;
    ref.read(verifiedCountProvider.notifier).state = 0;
    ref.read(retryCountProvider.notifier).state = 0;
    ref.read(selectedImageFileProvider.notifier).state = null;
    ref.read(animationControllerProvider.notifier).state = null;
    ref.read(vehicleImageUrlProvider.notifier).state = {};
    ref.read(vehicleImageProvider.notifier).state = {};
    ref.read(gadgetImageProvider.notifier).state = {};
  }
}
