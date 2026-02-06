import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/plan_details_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/provider_filter_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/product_categories_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/gridview_product_list/widgets/grid_provider_container.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/product_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/icon_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_image_network.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/icon_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/shimmer_loader.dart';

class GridViewProviderListScreen extends StatefulHookConsumerWidget {
  final String categoryid;
  final ProductCategoriesModel productCategory;
  const GridViewProviderListScreen({
    super.key,
    required this.categoryid,
    required this.productCategory,
  });

  @override
  ConsumerState<GridViewProviderListScreen> createState() =>
      _GridViewProviderListScreenState();
}

class _GridViewProviderListScreenState
    extends ConsumerState<GridViewProviderListScreen> {
  int selectedProvider = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(productProviderListProvider.notifier).state = null;
      ref.read(productListProvider.notifier).state = null;

      ref.read(filterFromNairaProvider.notifier).state = null;

      ref.read(filterToNairaProvider.notifier).state = null;

      ref.read(filterFromPercentProvider.notifier).state = null;

      ref.read(filterToPercentProvider.notifier).state = null;

      await ref.watch(productProvider).getInsuranceProviders(
            categoryid: widget.categoryid,
            ref: ref,
            context: context,
          );
    });
  }

  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final productVM = ref.watch(productProvider);
    final productProviders = ref.watch(productProviderListProvider);
    final selectedProviders = ref.watch(selectedproductProviderListProvider);

    // Filter the productProviders based on selectedProviders
    final filteredProviders = selectedProviders.isEmpty
        ? productProviders
        : productProviders?.where((provider) {
            return selectedProviders.contains(provider.id);
          }).toList();

    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              verticalSpacer(20.h),
              CustomAppbar(
                popTwice: false,
                onBackTap: Navigator.canPop(context)
                    ? () {
                        // setState(() {
                        //   selectedProvider = 0;
                        // });
                        ref.read(selectedAllprovidersProvider.notifier).state =
                            true;
                        ref.read(productProviderListProvider.notifier).state =
                            null;
                        ref.read(productListProvider.notifier).state = null;
                        ref
                            .read(selectedproductProviderListProvider.notifier)
                            .state = [];
                        Navigator.pop(context);
                      }
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpacer(10.h),

                      semiBoldText(
                        "Select product",
                        fontSize: 20.sp,
                      ),
                      verticalSpacer(20.h),
                      Row(children: [
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredProviders == null
                                  ? 3
                                  : (filteredProviders.length) + 1,

                              //////HERE
                              // ref
                              //             .watch(productProviderListProvider)

                              //              ==
                              //         null
                              //     ? 3
                              //     :

                              //     (ref
                              //                 .watch(
                              //                     productProviderListProvider)
                              //                 ?.length ??
                              //             0) +
                              //         1,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Center(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: GestureDetector(
                                    onTap: index == 0
                                        ? () => setState(() {
                                              selectedProvider = index;
                                              ref
                                                  .read(productListProvider
                                                      .notifier)
                                                  .state = null;
                                              productVM.getProductDetails(
                                                  categoryid: widget.categoryid,
                                                  ref: ref,
                                                  context: context);
                                            })
                                        : () async {
                                            setState(() {
                                              selectedProvider = index;
                                            });
                                            ref
                                                .read(productListProvider
                                                    .notifier)
                                                .state = null;
                                            productVM.getProductDetails(
                                                categoryid: widget.categoryid,
                                                providerId: [
                                                  ref
                                                          .watch(productProviderListProvider)?[
                                                              index - 1]
                                                          .id ??
                                                      ""
                                                ],
                                                ref: ref,
                                                context: context);
                                          },
                                    child: Container(
                                      height: 80.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                        border: Border.all(
                                          color: selectedProvider == index
                                              ? CustomColors.primaryBrandColor()
                                              : CustomColors.dividerGreyColor,
                                        ),
                                      ),
                                      child: ref.watch(
                                                  productProviderListProvider) ==
                                              null
                                          ? ShimmerLoader(
                                              color: CustomColors
                                                  .primaryBrandColor(),
                                            )
                                          : (index == 0)
                                              // ref
                                              //             .watch(productProviderListProvider)?[
                                              //                 index]
                                              //             .companyName
                                              //             ?.toLowerCase() ==
                                              //         "all"
                                              ? Center(
                                                  child: mediumText(
                                                    "All",
                                                    fontSize: 16.sp,
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // ref
                                                    //             .watch(productProviderListProvider)?[
                                                    //                 index - 1]
                                                    //             .logo ==
                                                    //         null

                                                    StringUtils.isNullOrEmpty(ref
                                                            .watch(productProviderListProvider)?[
                                                                index - 1]
                                                            .icon)
                                                        ? semiBoldText(
                                                            ref
                                                                    .watch(productProviderListProvider)?[
                                                                        index -
                                                                            1]
                                                                    .companyName?[0] ??
                                                                "",
                                                            fontSize: 16)
                                                        : SizedBox(
                                                            height: 25,
                                                            child: customImagenetwork(
                                                              imageUrl: ref
                                                                      .watch(productProviderListProvider)?[
                                                                          index -
                                                                              1]
                                                                      .icon ??
                                                                  "",
                                                              // height: 40,
                                                              loaderWidget:
                                                                  semiBoldText(
                                                                      ref.watch(productProviderListProvider)?[index - 1].companyName?[
                                                                              0] ??
                                                                          "",
                                                                      fontSize:
                                                                          16),
                                                              fit: BoxFit.cover,
                                                            )

                                                            //  Image.network(
                                                            //   ref
                                                            //           .watch(productProviderListProvider)?[
                                                            //               index - 1]
                                                            //           .logo ??
                                                            //       "",
                                                            //   fit: BoxFit.cover,
                                                            //   // package:
                                                            //   //     'mca_official_flutter_sdk',
                                                            // ),
                                                            ),
                                                    verticalSpacer(8.h),
                                                    regularText(
                                                        ref
                                                                .watch(productProviderListProvider)?[
                                                                    index - 1]
                                                                .companyName ??
                                                            "",
                                                        fontSize: 11.sp,
                                                        textAlign:
                                                            TextAlign.center)
                                                  ],
                                                ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // (ref.watch(productProviderListProvider)?.length ?? 0) >=
                        //         3
                        //     ?
                        (ref.watch(productProviderListProvider) == null)
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  ref
                                      .read(
                                          tempSelectedproductProviderListProvider
                                              .notifier)
                                      .state = List.from(ref.read(
                                          selectedproductProviderListProvider) ??
                                      []);
                                  ref
                                          .read(tempSelectedAllprovidersProvider
                                              .notifier)
                                          .state =
                                      ref.read(selectedAllprovidersProvider);

                                  showProviderFilterBottomSheet(
                                    context,
                                    ref,
                                    productVM: productVM,
                                    categoryid: widget.categoryid,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                        border: Border.all(
                                          color: CustomColors.dividerGreyColor,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          (filteredProviders?.length ?? 0) >=
                                                      3 &&
                                                  (selectedProviders.isEmpty) &&
                                                  (((filteredProviders
                                                                  ?.length ??
                                                              0) -
                                                          3) >
                                                      0)
                                              ? mediumText(
                                                  '+ ${(filteredProviders?.length ?? 0) - 3}',
                                                  fontSize: 15.sp,
                                                )
                                              : const SizedBox.shrink(),
                                          mediumText(
                                            "View",
                                            fontSize: 14.sp,
                                            color: CustomColors
                                                .primaryBrandColor(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        // : const SizedBox.shrink(),
                      ]),
                      verticalSpacer(35.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconContainer(
                                icon: IconUtils.getIcon(
                                    widget.productCategory.name ?? ""),
                              ),
                              horizontalSpacer(10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  semiBoldText(
                                    "${widget.productCategory.name ?? ""} Insurance",
                                    color: CustomColors.primaryBrandColor(),
                                    fontSize: 14.sp,
                                  ),
                                  regularText(
                                      "${ref.watch(productListProvider)?.length ?? 0} products",
                                      fontSize: 13.sp,
                                      color: CustomColors.greyTextColor),
                                ],
                              )
                            ],
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     showAdvancedFilterBottomSheet(
                          //       context,
                          //       ref,
                          //       formKey,
                          //       productVM: productVM,
                          //       categoryid: widget.categoryid,
                          //       providerId: selectedProvider == 0
                          //           ? null
                          //           : ref
                          //               .watch(productProviderListProvider)?[
                          //                   selectedProvider - 1]
                          //               .id,
                          //     );
                          //   },
                          //   child: Container(
                          //     height: 40.h,
                          //     decoration: BoxDecoration(
                          //         color: CustomColors.backBorderColor,
                          //         border: Border.all(
                          //           color: CustomColors.dividerGreyColor,
                          //           width: 0.8,
                          //         )),
                          //     child: Padding(
                          //       padding: EdgeInsets.symmetric(
                          //         horizontal: 5.w,
                          //       ),
                          //       child: Row(
                          //         children: [
                          //           Center(
                          //             child: SvgPicture.asset(
                          //                 ConstantString.filterIcon,
                          //                 package: 'mca_official_flutter_sdk'),
                          //           ),
                          //           horizontalSpacer(5.w),
                          //           regularText("Advanced filter",
                          //               fontSize: 13.sp,
                          //               color: CustomColors.greyTextColor),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      verticalSpacer(35.h),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.only(bottom: 20.h),
                          shrinkWrap: true,

                          // clipBehavior: ,// Set to true to enable scrolling in ListView
                          // physics:
                          //     const NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                2, // Set to 2 to display items in pairs
                            childAspectRatio:
                                1, // Set aspect ratio to 1 to maintain square shape
                            crossAxisSpacing: 12.w,
                            // // Set spacing between columns
                            mainAxisSpacing:
                                MediaQuery.of(context).size.width * 0.049,
                          ),
                          itemCount:
                              ref.watch(productProviderListProvider) == null
                                  ? 3
                                  : ref.watch(productListProvider)?.length,
                          // itemCount: 1,
                          itemBuilder: (context, index) {
                            return ref.watch(productListProvider) == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: CustomColors.productBorderColor,
                                      width: 0.6,
                                    )),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 25.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.w),
                                            child: const ShimmerLoader(),
                                          ),
                                          verticalSpacer(10.h),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 60.w),
                                            child: const ShimmerLoader(
                                              height: 8,
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.w),
                                            child: const ShimmerLoader(),
                                          ),
                                          verticalSpacer(10.h),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 60.w),
                                            child: const ShimmerLoader(
                                              height: 8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(selectedProductCategoryProvider
                                              .notifier)
                                          .state = widget.productCategory;
////Helpp
                                      ref
                                              .read(
                                                  selectedProductDetailsProvider
                                                      .notifier)
                                              .state =
                                          ref.watch(
                                              productListProvider)?[index];

                                      showPlanDetailsBottomSheet(
                                        context,
                                        // title:
                                        //     "${widget.productCategory.name ?? ""} Insurance",
                                        // productName: ref
                                        //         .watch(productListProvider)?[index]
                                        //         .name ??
                                        //     "",
                                        // provider: ref
                                        //     .watch(productListProvider)?[index]
                                        //     .provider,
                                        // keyBenefits: ref
                                        //     .watch(productListProvider)?[index]
                                        //     .keyBenefits,
                                        // howToClaim: ref
                                        //     .watch(productListProvider)?[index]
                                        //     .howToClaim,
                                        // howItWorks: ref
                                        //     .watch(productListProvider)?[index]
                                        //     .howItWorks,
                                        // fullBenefits: ref
                                        //     .watch(productListProvider)?[index]
                                        //     .fullBenefits,
                                        productDetails: ref
                                            .watch(productListProvider)?[index],
                                        // formattedPrice: StringUtils.getProductPrice(
                                        //     ref
                                        //             .watch(
                                        //                 productListProvider)?[index]
                                        //             .price ??
                                        //         "",
                                        //     ref
                                        //             .watch(
                                        //                 productListProvider)?[index]
                                        //             .isDynamicPricing ??
                                        //         false),
                                        productCategory: widget.productCategory,
                                        // periodOfCover:
                                        //     StringUtils.getProviderPeriodOfCover(
                                        //   ref
                                        //           .watch(
                                        //               productListProvider)?[index]
                                        //           .coverPeriod ??
                                        //       "",
                                        // ),
                                        // price: ref
                                        //         .watch(productListProvider)?[index]
                                        //         .price ??
                                        //     "",
                                        // isDynamicPrice: ref
                                        //         .watch(productListProvider)?[index]
                                        //         .isDynamicPricing ??
                                        //     false,
                                      );
                                    },
                                    child: GridProviderContainer(
                                      productDetails: ref
                                          .watch(productListProvider)?[index],
                                      title: ref
                                              .watch(
                                                  productListProvider)?[index]
                                              .name ??
                                          "",
                                      provider: ref
                                          .watch(productListProvider)?[index]
                                          .provider,
                                      hasDiscount: false,
                                      formattedPrice: StringUtils.getProductPrice(
                                          ref
                                                  .watch(productListProvider)?[
                                                      index]
                                                  .price ??
                                              "",
                                          ref
                                                  .watch(productListProvider)?[
                                                      index]
                                                  .isDynamicPricing ??
                                              false),
                                      periodOfCover:
                                          StringUtils.getProviderPeriodOfCover(
                                        ref
                                                .watch(
                                                    productListProvider)?[index]
                                                .coverPeriod ??
                                            "",
                                      ),
                                      price: ref
                                              .watch(
                                                  productListProvider)?[index]
                                              .price ??
                                          "",
                                      isDynamicPrice: ref
                                              .watch(
                                                  productListProvider)?[index]
                                              .isDynamicPricing ??
                                          false,
                                      // mockProviderProductLists[0].hasDiscount,
                                    ),
                                  );
                          },
                        ),
                      ),

                      // CustomButton(
                      //   title: "Continue",
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
