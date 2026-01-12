// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/form_data_url_response.dart';
import 'package:mca_official_flutter_sdk/src/models/policy_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/models/provider_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/purchase_success_screen.dart';
import '../../../data/view_model/base_change_notifier.dart';

final formVmProvider = ChangeNotifierProvider.autoDispose<FormViewModel>((ref) {
  return FormViewModel.initWhoAmI();
});

class FormViewModel extends BaseChangeNotifier {
  bool _isloading;
  bool _isImageUploading;

  FormViewModel.initWhoAmI()
      : _isloading = false,
        _isImageUploading = false;
  FormViewModel.profile()
      : _isloading = false,
        _isImageUploading = false;

  bool get isLoading => _isloading;
  bool get isImageUploading => _isImageUploading;

  set isLoading(bool isloading) {
    _isloading = isloading;
    notifyListeners();
  }

  set isImageUploading(bool isImageUploading) {
    _isImageUploading = isImageUploading;
    notifyListeners();
  }

  Future<bool> getListData({
    required String dataUrl,
    required String fieldName,
    required WidgetRef ref,
    required BuildContext context,
    String? dependsOn,
  }) async {
    try {
      if (dependsOn != null) {
        if (ref.watch(formDataProvider)[dependsOn] == null) {
          return true;
        } else {
          // ref.read(formDataProvider.notifier).state[fieldName] = null;
          FormDataUrlResponse? response = ref
              .watch(urlFormDataProvider)[dependsOn]
              ?.where((field) =>
                  field.name == ref.watch(formDataProvider)[dependsOn])
              .firstOrNull;

          final res = await formRepository.getListData(dataUrl,
              dependsOnId: response?.id);
          if (res.responseCode == 1) {
            ref.read(urlFormDataProvider.notifier).state[fieldName] =
                processResponseData(res.data);
            // res.data;

            return true;
          } else {
            isLoading = false;
            CustomToast.showErrorMessage(context, res.errors.toString());
            return false;
          }
        }
      } else {
        final res = await formRepository.getListData(dataUrl);
        if (res.responseCode == 1) {
          ref.read(urlFormDataProvider.notifier).state[fieldName] =
              processResponseData(res.data);
          // res.data;

          return true;
        } else {
          isLoading = false;
          CustomToast.showErrorMessage(context, res.errors.toString());
          return false;
        }
      }
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
      return false;
    }
  }

  Future<void> fetchProductPrice({
    required String productId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    isLoading = true;
    try {
      final res = await formRepository.fetchProductPrice(
          ref.watch(formDataProvider), productId);
      if (res.responseCode == 1) {
        ref.read(productPriceProvider.notifier).state = res.data["price"];
        isLoading = false;
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
    }
  }

  Future<void> uploadImage({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      if (ref.watch(imageListProvider).isNotEmpty) {
        for (var imageMap in ref.watch(imageListProvider)) {
          for (var entry in imageMap.entries) {
            var key = entry.key; // String
            var file = entry.value; // File?

            final res = await formRepository.uploadFile(file: file!);

            if (res.responseCode == 1) {
              ref.read(formDataProvider.notifier).state[key] =
                  res.data["file_url"];
            } else {
              isLoading = false;
              CustomToast.showErrorMessage(context, res.errors.toString());
              throw Exception('Failed to upload file');
            }
          }
        }
      }
    } catch (e) {
      isLoading = false;
      log(e.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
    }
  }

  Future<String?> uploadSingleImage({
    required String name,
    required File file,
    required WidgetRef ref,
    required BuildContext context,
    String? fileType,
  }) async {
    try {
      isImageUploading = true;
      final res =
          await formRepository.uploadFile(file: file, fileType: fileType);

      if (res.responseCode == 1) {
        isImageUploading = false;
        return res.data["file_url"];
      } else {
        isImageUploading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      isImageUploading = false;
      log(e.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
    }
    return null;
  }

  Future<void> completePurchase({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    isLoading = true;
    try {
      await uploadImage(ref: ref, context: context);

      final res =
          await formRepository.completePurchase(ref.watch(formDataProvider));
      if (res.responseCode == 1) {
        PolicyModel policy = PolicyModel.fromJson(
          res.data,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PurchaseSuccessScreenScreen(policy: policy)));
        isLoading = false;
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
    }
  }

  List<FormDataUrlResponse> processResponseData(List<dynamic> data) {
    if (data.isNotEmpty && data.first is Map) {
      // Process as List<Map>
      return data.map((item) {
        if (item is Map && item.containsKey('name') && item.containsKey('id')) {
          return FormDataUrlResponse(name: item['name'], id: item['id']);
        }
        if (item is Map && item.containsKey('name')) {
          return FormDataUrlResponse(name: item['name'], id: null);
        } else {
          return FormDataUrlResponse(
              name: item.toString(),
              id: null); // Return the map as is if 'name' is not present
        }
      }).toList();
    } else {
      // Return as is if it's a List<String>
      return data.map((item) {
        return FormDataUrlResponse(name: item.toString(), id: null);
      }).toList();
    }
  }

  Future<bool> getMapData({
    required String dataUrl,
    required String fieldName,
    required WidgetRef ref,
    required BuildContext context,
    String? dependsOn,
  }) async {
    try {
      final res = await formRepository.getListData(dataUrl);
      if (res.responseCode == 1) {
        ref.read(urlFormDataProvider.notifier).state[fieldName] =
            processMapResponseData(res.data);

        return true;
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
        return false;
        // }
      }
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
      return false;
    }
  }

  List<FormDataUrlResponse> processMapResponseData(dynamic data) {
    if (data is Map) {
      // Process as Map
      return (data as Map<String, dynamic>).entries.map((entry) {
        return FormDataUrlResponse(name: entry.value, id: entry.key);
      }).toList();
    } else {
      // Return as is if it's a List<String>
      return data.map((item) {
        return FormDataUrlResponse(name: item.toString(), id: null);
      }).toList();
    }
  }

  // Future<void> getProductDetails(
  //     {required String categoryid,
  //     String? providerId,
  //     required WidgetRef ref,
  //     required BuildContext context}) async {
  //   try {
  //     final res = await productRepository.getProductDetails(
  //       categoryId: categoryid,
  //       providerId: providerId,
  //       priceStaticFrom: ref.watch(filterFromNairaProvider),
  //       priceStaticTo: ref.watch(filterToNairaProvider),
  //       priceDynamicFrom: ref.watch(filterFromPercentProvider),
  //       priceDynamicTo: ref.watch(filterToPercentProvider),
  //     );

  //     if (res.responseCode == 1) {
  //       // List<ProductDetailsModel>? products = res.data["products"]
  //       //     .map((map) => ProductDetailsModel.fromJson(map))
  //       //     .toList();

  //       List<ProductDetailsModel>? products = res.data["products"] != null
  //           ? (res.data["products"] as List)
  //               .map((e) => ProductDetailsModel.fromJson(e))
  //               .toList()
  //           : [];
  //       products.sort((a, b) {
  //         if (a.name == null && b.name == null) return 0;
  //         if (a.name == null) return 1;
  //         if (b.name == null) return -1;
  //         return a.name!.compareTo(b.name!);
  //       });

  //       ref.read(productListProvider.notifier).state = products;

  //       // res.data != null
  //       //     ? (res.data as List)
  //       //         .map((e) => ProductDetailsModel.fromJson(e))
  //       //         .toList()
  //       //     : [];

  //       // InsuranceProviderResponse data =
  //       //     InsuranceProviderResponse.fromJson(res.data);

  //       // ref.read(productProviderListProvider.notifier).state = data.providers;
  //     } else {
  //       // Dialogs.showErrorMessage(res.errors.toString());
  //     }
  //   } catch (e, stacktrace) {
  //     log(e.toString());
  //     log(stacktrace.toString());
  //     Dialogs.showErrorMessage(e.toString());
  //   }
  // }
}

final productProviderListProvider =
    StateProvider<List<ProviderModel>?>((ref) => null);
final productListProvider =
    StateProvider<List<ProductDetailsModel>?>((ref) => null);
