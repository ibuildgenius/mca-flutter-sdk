// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/models/provider_model.dart';
import 'package:mca_official_flutter_sdk/src/models/purchase_details_response.dart';
import 'package:mca_official_flutter_sdk/src/models/purchase_initialization_response.dart';
import 'package:mca_official_flutter_sdk/src/models/ussd_provider_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/account_details_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/payment_processing_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/payment_success_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/plan_details_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/select_bank_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import '../../../data/view_model/base_change_notifier.dart';

final paymentProvider =
    ChangeNotifierProvider.autoDispose<PaymentViewModel>((ref) {
  return PaymentViewModel.initWhoAmI();
});

class PaymentViewModel extends BaseChangeNotifier {
  bool _isloading;

  PaymentViewModel.initWhoAmI() : _isloading = false;
  PaymentViewModel.profile() : _isloading = false;

  bool get isLoading => _isloading;

  set isLoading(bool isloading) {
    _isloading = isloading;
    notifyListeners();
  }

  Future<bool> fetchUssdProviders({
    required PaymentMethod paymentMethod,
    String? selectedBankCode,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;

      Global.ussdProviders = await getUssdProviders(ref: ref, context: context);

      isLoading = false;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SelectBankScreen()));

      return true;
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      return false;
    }
  }

  Future<bool> initiateGatewayPurchase({
    required PaymentMethod paymentMethod,
    String? selectedBankCode,
    // required ProviderLiteModel? provider,
    // required ProductDetailsModel? productDetails,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      // if (paymentMethod == PaymentMethod.ussd) {
      //   Global.ussdProviders =
      //       await getUssdProviders(ref: ref, context: context);
      //   ref.read(selectedBankProvider.notifier).state =
      //       Global.ussdProviders.isEmpty ? null : Global.ussdProviders[0];
      // }
      final res = await paymentRepository.initiateGatewayPurchase(
        paymentChannel: paymentMethod == PaymentMethod.ussd
            ? {
                "channel": paymentMethod.getName,
                "bank_code": Global.ussdProviders.isEmpty
                    ? ""
                    : ref.watch(selectedBankProvider)?.type ?? "",
              }
            : {
                "channel": paymentMethod.getName,
              },
        payload: ref.watch(formDataProvider),
      );

      //save the reference somewhere....
      isLoading = false;
      if (res.responseCode == 1) {
        PurchaseinitializationModel data =
            PurchaseinitializationModel.fromJson(res.data);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AccountDetailsScreen(
                      // provider: provider,
                      // productDetails: productDetails,
                      purchaseDetails: data,
                      paymentMethod: paymentMethod,
                    )));
      } else {
        CustomToast.showErrorMessage(context, res.errors.toString());
      }

      return true;
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      return false;
    }
  }

  Future<bool> initiateWalletPurchase({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      final res = await paymentRepository.initiateWalletPurchase(
        payload: ref.watch(formDataProvider),
      );
      if (res.responseCode == 1) {
        final purchaseRes =
            await paymentRepository.getPurchaseInfo(Global.reference);
        final data = PurchaseDetailsResponseModel.fromJson(purchaseRes.data);
        Global.reference = data.reference ?? "";

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        //     (Route<dynamic> route) => false);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PlanDetailsScreen(
                      purchaseDetails: data,
                    )));
      } else {
        CustomToast.showErrorMessage(context, res.errors.toString());
      }

      //save the reference somewhere....
      isLoading = false;

      return true;
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      return false;
    }
  }

  Future<List<UssdProviderModel>> getUssdProviders({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    isLoading = true;
    try {
      final res = await paymentRepository.getUssdProviders();
      if (res.responseCode == 1) {
        List<UssdProviderModel> data = res.data != null
            ? (res.data as List)
                .map((e) => UssdProviderModel.fromJson(e))
                .toList()
            : [];

        isLoading = false;
        return data;
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
        return [];
      }
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
//  CustomToast.showErrorMessage(context, res.errors.toString());
      return [];
    }
  }

  Future<List<UssdProviderModel>> verifyPayment({
    required String reference,
    required WidgetRef ref,
    required BuildContext context,
    required PaymentMethod paymentMethod,
    required PurchaseinitializationModel purchaseDetails,
    bool redirect = true,
  }) async {
    isLoading = true;
    try {
      final res = await paymentRepository.verifyPayment(reference: reference);
      //ADDD RESPONSE CODE 1 TO ALL REQUEST
      if (res.responseCode == 1) {
        final purchaseRes = await paymentRepository.getPurchaseInfo(reference);
        final data = PurchaseDetailsResponseModel.fromJson(purchaseRes.data);
        Global.reference = data.reference ?? "";

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentSuccessScreenScreen(
                      purchaseDetails: data,
                    )));

        isLoading = false;

        return [];
      } else {
        isLoading = false;
        CustomToast.showToastMessage(
            context,
            "We have not received your payment. Hang on, we will keep trying",
            ToastStatus.pending);
        if (redirect) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentProcessingScreen(
                        purchaseDetails: purchaseDetails,
                        paymentMethod: paymentMethod,
                        // purchaseDetails: data,
                      )));
        }
        return [];
      }
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
      return [];
    }
  }

  // void navigateToLastScreenAndPush(BuildContext context) {
  // Function to navigate through the stack and find the last screen
  void navigateToLastScreen(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      Future.delayed(const Duration(milliseconds: 300), () {
        navigateToLastScreen(context);
      });
    } else {
      // Push the new screen when on the last screen
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => newScreen));
    }
  }
}
// }

final productProviderListProvider =
    StateProvider<List<ProviderModel>?>((ref) => null);
final productListProvider =
    StateProvider<List<ProductDetailsModel>?>((ref) => null);



  // Start navigating to the last screen
  // navigateToLastScreen(context);