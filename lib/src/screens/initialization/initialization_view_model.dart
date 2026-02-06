// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_categories_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/models/sdk_initialization_response.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_init_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/sdk_error_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/welcome_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_init_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_details/product_details_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/gridview_product_list/gridview_product_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/gridview_product_list/gridview_provider_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/listview_product_list/listview_product_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/listview_product_list/listview_provider_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';

import '../../data/view_model/base_change_notifier.dart';

class InitViewModel extends BaseChangeNotifier {
  Future<void> initialiseSdk(WidgetRef ref, BuildContext context,
      {bool redirectError = true}) async {
    try {
      final res = await initRepository.initialiseSdk();

      if (res.responseCode == 1) {
        SdkInitializationResponse data =
            SdkInitializationResponse.fromJson(res.data);

        ref.read(initResponseProvider.notifier).state = data;

        data.productCategories?.sort((a, b) {
          if (a.name == null && b.name == null) return 0;
          if (a.name == null) return 1;
          if (b.name == null) return -1;
          return a.name!.compareTo(b.name!);
        });
        ref.read(productCategoriesProvider.notifier).state =
            data.productCategories ?? [];

        ref.read(businessDetailsProvider.notifier).state = data.businessDetails;
        Global.brandColorPrimary = data.businessDetails?.brandColorPrimary;
        Global.businessDetails = data.businessDetails;
        // Global.isDefaultLogo = data.businessDetails?.isDefaultLogo ?? true;

        // await navigationHandler.pushReplacement(const WelcomeScreen());

        /////IMPRTANT HEREEE
        ///
        ///
        ///
        ///
        notifyListeners();

        if (Global.productId.length == 1) {
          final res = await productRepository.getProductDetails(
            categoryId: data.productCategories?[0].id ?? "",
            // providerId: providerId,
          );

          if (res.responseCode == 1) {
            List<ProductDetailsModel>? products = res.data["products"] != null
                ? (res.data["products"] as List)
                    .map((e) => ProductDetailsModel.fromJson(e))
                    .toList()
                : [];
            products.sort((a, b) {
              if (a.name == null && b.name == null) return 0;
              if (a.name == null) return 1;
              if (b.name == null) return -1;
              return a.name!.compareTo(b.name!);
            });

            ref.read(selectedProductCategoryProvider.notifier).state =
                data.productCategories?[0];
            if (products.isNotEmpty) {
              ref.read(selectedProductDetailsProvider.notifier).state =
                  products[0];

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      // title: title,

                      productDetails: products[0],
                    ),
                    settings: const RouteSettings(
                        arguments: ConstantString.initialScreenKey),
                  ));
            }
          } else {
            CustomToast.showErrorMessage(context, res.errors.toString());
          }

          // ..
          // } else {
          //   // Navigator.pushReplacement(context,
          //   //     MaterialPageRoute(builder: (context) => const WelcomeScreen()));
          // navigationHandler.pushReplacementNamed(WelcomeScreen.routeName);
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => const WelcomeScreen()));
        }

        if (Global.productCategory != null) {
          String productCategoryText =
              getProductCategoryText(Global.productCategory!);
          ProductCategoriesModel? filteredCategories =
              (data.productCategories ?? [])
                  .where((category) =>
                      category.name?.toLowerCase() ==
                      productCategoryText.toLowerCase())
                  .firstOrNull;
          if (filteredCategories == null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                  settings: const RouteSettings(
                      arguments: ConstantString.initialScreenKey),
                ));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Global.businessDetails?.layout?.toLowerCase() ==
                              SdkLayout.grid.getName
                          ? GridViewProviderListScreen(
                              categoryid: filteredCategories.id ?? "",
                              productCategory: filteredCategories,
                            )
                          : ListViewProviderListScreen(
                              categoryid: filteredCategories.id ?? "",
                              productCategory: filteredCategories,
                            ),
                  settings: const RouteSettings(
                      arguments: ConstantString.initialScreenKey),
                ));
          }
        } else {
          Global.transactionType == TransactionType.purchase
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ref
                                .watch(initResponseProvider)
                                ?.businessDetails
                                ?.layout
                                ?.toLowerCase() ==
                            SdkLayout.grid.getName
                        ? const GridViewProductListScreen()
                        : const ListViewProductListScreen(),
                    settings: const RouteSettings(
                        arguments: ConstantString.initialScreenKey),
                  ))
              : Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                    settings: const RouteSettings(
                        arguments: ConstantString.initialScreenKey),
                  ));
        }
        // ..

        // navigationHandler.pushReplacementNamed(WelcomeScreen.routeName);

        // return data;
      } else {
        CustomToast.showErrorMessage(
          context,
          res.errors.toString(),
        );
        if (redirectError) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SDKErrorScreen(
                  error: res.errors
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', ''),

                  // title: title,
                ),
                settings: const RouteSettings(
                    arguments: ConstantString.initialScreenKey),
              ));
        }

        // Dialogs.showErrorMessage(res.errors.toString());
        // localCache.removeFromLocalCache(ConstantString.dashboardData);
        // GenericDialog()
        //     .showSimplePopup(type: InfoBoxType.warning, content: res.message);
      }

      /////IMPRTANT HEREEE
      ///
      ///
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // Dialogs.showErrorMessage(e.toString());
    }
    // Dialogs.showErrorMessage("Failed to initialize, Please try again");
  }

  Future<void> initialiseInspectionSdk(WidgetRef ref, BuildContext context,
      {bool redirectError = true}) async {
    try {
      final res = await initRepository.initialiseSdk();

      if (res.responseCode == 1) {
        SdkInitializationResponse data =
            SdkInitializationResponse.fromJson(res.data);

        ref.read(initResponseProvider.notifier).state = data;

        data.productCategories?.sort((a, b) {
          if (a.name == null && b.name == null) return 0;
          if (a.name == null) return 1;
          if (b.name == null) return -1;
          return a.name!.compareTo(b.name!);
        });
        ref.read(productCategoriesProvider.notifier).state =
            data.productCategories ?? [];

        ref.read(businessDetailsProvider.notifier).state = data.businessDetails;
        Global.brandColorPrimary = data.businessDetails?.brandColorPrimary;
        Global.businessDetails = data.businessDetails;

        notifyListeners();

        if (StringUtils.isNullOrEmpty(Global.policyId)) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SDKErrorScreen(
                  error: "Policy Id cannot be null",

                  // title: title,
                ),
                settings: const RouteSettings(
                    arguments: ConstantString.initialScreenKey),
              ));
        } else {
          final policyRes =
              await claimRepository.getPolicyById(Global.policyId);

          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const InspectionInitScreen(),
          //       settings: const RouteSettings(
          //           arguments: ConstantString.initialScreenKey),
          //     ));

          if (policyRes.responseCode == 1) {
            PolicyModel policy = PolicyModel.fromJson(policyRes.data['policy']);
            final productRes = await productRepository.getProductDetailsById(
                productId: policy.productId ?? "");
            ProductDetailsModel productDetails =
                ProductDetailsModel.fromJson(productRes.data['products'][0]);

            if (productDetails.inspectable != false ||
                (productDetails.routeName ?? "")
                    .toLowerCase()
                    .contains('third-party')) {
              if ((productDetails.productCategory?.name ?? "").toLowerCase() ==
                  'gadget') {
                Global.gadgetType = getGadgetType(policy.meta['payload']
                        ['device_type']
                    .toString()
                    .toLowerCase());
              }
              log('nnn ${productDetails.productCategory?.name}');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InspectionInitScreen(
                      productCategory:
                          ((productDetails.productCategory?.name ?? "")
                                      .toLowerCase() ==
                                  'gadget')
                              ? ProductCategory.gadget
                              : ProductCategory.auto,
                    ),
                    settings: const RouteSettings(
                        arguments: ConstantString.initialScreenKey),
                  ));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SDKErrorScreen(
                      error: "This product is not inspectable",

                      // title: title,
                    ),
                    settings: const RouteSettings(
                        arguments: ConstantString.initialScreenKey),
                  ));
            }
            // if(policyRes.)
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SDKErrorScreen(
                    error: policyRes.errors.toString(),

                    // title: title,
                  ),
                  settings: const RouteSettings(
                      arguments: ConstantString.initialScreenKey),
                ));
          }
        }
      } else {
        CustomToast.showErrorMessage(
          context,
          res.errors.toString(),
        );
        if (redirectError) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SDKErrorScreen(
                  error: res.errors
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', ''),

                  // title: title,
                ),
                settings: const RouteSettings(
                    arguments: ConstantString.initialScreenKey),
              ));
        }
      }
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
    }
  }

  Future<void> initialiseClaimSdk(WidgetRef ref, BuildContext context,
      {bool redirectError = true}) async {
    try {
      final res = await initRepository.initialiseSdk();

      if (res.responseCode == 1) {
        SdkInitializationResponse data =
            SdkInitializationResponse.fromJson(res.data);

        ref.read(initResponseProvider.notifier).state = data;

        data.productCategories?.sort((a, b) {
          if (a.name == null && b.name == null) return 0;
          if (a.name == null) return 1;
          if (b.name == null) return -1;
          return a.name!.compareTo(b.name!);
        });
        ref.read(productCategoriesProvider.notifier).state =
            data.productCategories ?? [];

        ref.read(businessDetailsProvider.notifier).state = data.businessDetails;
        Global.brandColorPrimary = data.businessDetails?.brandColorPrimary;
        Global.businessDetails = data.businessDetails;

        notifyListeners();

        if (StringUtils.isNullOrEmpty(Global.policyId) ||
            StringUtils.isNullOrEmpty(Global.policyNumber) ||
            StringUtils.isNullOrEmpty(Global.email)) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SDKErrorScreen(
                  error: StringUtils.isNullOrEmpty(Global.policyId)
                      ? "Policy Id cannot be null"
                      : StringUtils.isNullOrEmpty(Global.policyNumber)
                          ? "Policy Number cannot be null"
                          : "Customer email cannot be null",

                  // title: title,
                ),
                settings: const RouteSettings(
                    arguments: ConstantString.initialScreenKey),
              ));
        } else {
          final res = await claimRepository.getClaimsById(Global.policyId);
          List<ClaimModel> myClaims = [];
          // Handle valid response
          if (res.responseCode == 1) {
            final claimsJson = res.data['claims'] as List<dynamic>? ?? [];
            myClaims = claimsJson.map((e) => ClaimModel.fromJson(e)).toList();
            ref.read(totalClaimableAmountProvider.notifier).state =
                res.data['totalClaimableAmount'];
            ref.read(totalClaimedProvider.notifier).state =
                res.data['totalClaimedAmount'];
            ref.read(totalAvailableClaimAmountProvider.notifier).state =
                res.data['totalAvailableClaimAmount'];
            ref.read(noOfTimeClaimedProvider.notifier).state =
                res.data['claimCount'];
          }

          bool hasOngoingClaim = myClaims.isNotEmpty &&
              myClaims.any(
                (test) => (test.claimStatus ?? '').toLowerCase() != 'paid',
              );
          log('has an ${hasOngoingClaim}');
          if (myClaims.isNotEmpty && hasOngoingClaim == true) {
            log('lolll');

            ClaimViewModel.initWhoAmI().navigateToTrackClaimInfo(
                ref: ref,
                context: context,
                claimId: Global.claimId,
                email: Global.email ?? '');
            // ClaimViewModel.initWhoAmI().navigateToTrackClaims(
            //     ref: ref, context: context, policyId: Global.policyId);
          } else {
            log('smmmsm');
            ClaimViewModel.initWhoAmI().getClaimsById(
              ref: ref,
              context: context,
              email: Global.email ?? "",
              policyNumber: Global.policyNumber ?? "",
            );

            // Global.navigatorKey.currentState?.pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => const ClaimInitScreen(),
            //   ),
            // );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClaimInitScreen()));
          }
        }
      } else {
        CustomToast.showErrorMessage(
          context,
          res.errors.toString(),
        );
        if (redirectError) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SDKErrorScreen(
                  error: res.errors
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', ''),

                  // title: title,
                ),
                settings: const RouteSettings(
                    arguments: ConstantString.initialScreenKey),
              ));
        }
      }
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
    }
  }
}

class CustomerInitConfig extends BaseChangeNotifier {
  Future<void> initialiseDefaultConfig(
    WidgetRef ref,
    BuildContext context,
  ) async {
    try {
      final dat = await customerInitUIConfig.fallbackConfig();

      if (dat.responseCode == 1) {
        SdkInitializationResponse data =
            SdkInitializationResponse.fromJson(dat.data);
        ref.read(initResponseFallBackProvider.notifier).state = data;

        ref.watch(businessFallBackDetailsProvider.notifier).state =
            data.businessDetails;
        // Global.brandColorPrimary = data.businessDetails?.brandColorPrimary;
        Global.businessDetailsFallback = data.businessDetails;
      }
    } catch (e, stacktrace) {
      log('Error initializing default config: $e');
      debugPrint(stacktrace.toString());
    }
  }
}

final totalClaimableAmountProvider = StateProvider<int?>((ref) => null);
final totalClaimedProvider = StateProvider<int?>((ref) => null);
final totalAvailableClaimAmountProvider = StateProvider<int?>((ref) => null);
final noOfTimeClaimedProvider = StateProvider<int?>((ref) => null);
