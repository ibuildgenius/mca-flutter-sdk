// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/insurance_provider_response_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/models/provider_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import '../../../data/view_model/base_change_notifier.dart';

final productProvider =
    ChangeNotifierProvider.autoDispose<ProductViewModel>((ref) {
  return ProductViewModel.initWhoAmI();
});

class ProductViewModel extends BaseChangeNotifier {
  bool _isloading;

  ProductViewModel.initWhoAmI() : _isloading = false;
  ProductViewModel.profile() : _isloading = false;

  bool get isLoading => _isloading;

  set isLoading(bool isloading) {
    _isloading = isloading;
    notifyListeners();
  }

  Future<void> getAllInsuranceProviders({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      final res = await productRepository.getAllInsuranceProviders();

      if (res.responseCode == 1) {
        InsuranceProviderResponse data =
            InsuranceProviderResponse.fromJson(res.data);
        data.providers?.sort((a, b) {
          if (a.companyName == null && b.companyName == null) return 0;
          if (a.companyName == null) return 1;
          if (b.companyName == null) return -1;
          return a.companyName!.compareTo(b.companyName!);
        });
        // for (var i = 0; i < 20; i++) {
        //   print(i);
        // }

        ref.read(allProviderListProvider.notifier).state = data.providers
            ?.where(
                (element) => !StringUtils.isNullOrEmpty(element.companyName))
            .toList();
      } else {
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
      // Dialogs.showErrorMessage(e.toString());
    }
  }

  Future<void> getInsuranceProviders({
    required String categoryid,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      getProductDetails(
          categoryid: categoryid,
          ref: ref,
          context: context,
          providerId: ref.watch(selectedproductProviderListProvider));

      final res = await productRepository.getInsuranceProviders(
        categoryid,
        // providerIds: ref.watch(selectedproductProviderListProvider),
      );

      if (res.responseCode == 1) {
        InsuranceProviderResponse data =
            InsuranceProviderResponse.fromJson(res.data);
        data.providers?.sort((a, b) {
          if (a.companyName == null && b.companyName == null) return 0;
          if (a.companyName == null) return 1;
          if (b.companyName == null) return -1;
          return a.companyName!.compareTo(b.companyName!);
        });

        ref.read(productProviderListProvider.notifier).state = data.providers;
      } else {
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
      // Dialogs.showErrorMessage(e.toString());
    }
  }

  Future<void> getProductDetails(
      {required String categoryid,
      List<String>? providerId,
      required WidgetRef ref,
      required BuildContext context}) async {
    try {
      final res = await productRepository.getProductDetails(
        categoryId: categoryid,
        providerIds:
            providerId ?? ref.watch(selectedproductProviderListProvider),
        priceStaticFrom: ref.watch(filterFromNairaProvider),
        priceStaticTo: ref.watch(filterToNairaProvider),
        priceDynamicFrom: ref.watch(filterFromPercentProvider),
        priceDynamicTo: ref.watch(filterToPercentProvider),
      );

      if (res.responseCode == 1) {
        // List<ProductDetailsModel>? products = res.data["products"]
        //     .map((map) => ProductDetailsModel.fromJson(map))
        //     .toList();

        List<ProductDetailsModel> products = (res.data["products"] as List?)
                ?.where((e) => e != null)
                .map((e) => ProductDetailsModel.fromJson(e))
                .toList() ??
            [];

        // List<ProductDetailsModel>? products = res.data["products"] != null
        //     ? (res.data["products"] as List)
        //         .map((e) => ProductDetailsModel.fromJson(e))
        //         .toList()
        //     : [];
        products.sort((a, b) {
          if (a.name == null && b.name == null) return 0;
          if (a.name == null) return 1;
          if (b.name == null) return -1;
          return a.name!.compareTo(b.name!);
        });

        ref.read(productListProvider.notifier).state = products;
      } else {
        CustomToast.showErrorMessage(context, res.errors.toString());
        // Dialogs.showErrorMessage(res.errors.toString());
      }
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
    }
  }
}

final allProviderListProvider =
    StateProvider<List<ProviderModel>?>((ref) => null);

final productProviderListProvider =
    StateProvider<List<ProviderModel>?>((ref) => null);

final selectedproductProviderListProvider =
    StateProvider<List<String>>((ref) => []);
final selectedAllprovidersProvider = StateProvider<bool>((ref) => true);
final productListProvider =
    StateProvider<List<ProductDetailsModel>?>((ref) => null);

final tempSelectedproductProviderListProvider =
    StateProvider<List<String>>((ref) => []);

final tempSelectedAllprovidersProvider = StateProvider<bool>((ref) => true);
