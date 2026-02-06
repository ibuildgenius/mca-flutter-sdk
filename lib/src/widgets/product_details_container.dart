import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/utils/color_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_image_network.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class ProductDetailsContainer extends StatelessWidget {
  final bool isWhiteBg;
  // final String productName, periodOfCover, formattedPrice, price;
  // final ProviderLiteModel? provider;
  // final bool isDynamicPrice;
  // final ProductCategoriesModel productCategory;
  const ProductDetailsContainer({
    super.key,
    // required this.productName,
    // required this.periodOfCover,
    // required this.formattedPrice,
    // required this.price,
    // required this.provider,
    // required this.isDynamicPrice,
    // required this.productCategory,
    this.isWhiteBg = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var provider = ref.watch(selectedProductDetailsProvider)?.provider;
      return Container(
        decoration: BoxDecoration(
            color: isWhiteBg
                ? CustomColors.whiteColor
                : CustomColors.backBorderColor,
            borderRadius: BorderRadius.circular(2.r),
            border: const Border(
                bottom: BorderSide(
              color: CustomColors.productBorderColor,
              width: 0.2,
            ))),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 15.w,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // IconContainer(
                    //   icon: IconUtils.getIcon(ref
                    //           .watch(selectedProductCategoryProvider)
                    //           // productCategory
                    //           ?.name ??
                    //       ""),
                    // ),
                    // horizontalSpacer(10.w),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            height: 33,
                            width: 33,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorUtils.getColorFromHex(provider
                                            ?.brandColorPrimary ??
                                        provider?.settings?.brandColorPrimary)
                                    .withOpacity(0.5),
                                width: 4.13,
                              ),

                              // color: Colors.red,
                            ),
                            child: Center(
                                child: provider == null ||
                                        StringUtils.isNullOrEmpty(
                                            provider.icon ??
                                                provider.settings?.icon)
                                    ? semiBoldText(
                                        StringUtils.getFirstCharCapitalized(
                                            provider?.companyName),
                                        fontSize: 13.sp,
                                        color: CustomColors.blackColor,
                                      )
                                    : customImagenetwork(
                                        imageUrl: provider.icon ??
                                            provider.settings!.icon!,
                                        loaderWidget: regularText(
                                            provider.companyName ?? "",
                                            fontSize: 13.sp,
                                            color: CustomColors.greyTextColor),
                                        // fit: BoxFit.cover,
                                        height: 17.h,
                                      )

                                // kk semiBoldText(
                                //   StringUtils.getFirstCharCapitalized(provider?.companyName),
                                //   fontSize: 13.sp,
                                //   color: CustomColors.blackColor,
                                // ),
                                ),
                          ),
                          horizontalSpacer(10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                semiBoldText(
                                  ref
                                          .watch(selectedProductDetailsProvider)
                                          ?.name ??
                                      "",
                                  fontSize: 14.sp,
                                ),
                                Row(
                                  children: [
                                    provider == null
                                        ? const SizedBox.shrink()
                                        : mediumText(provider.companyName ?? "",
                                            fontSize: 12.sp,
                                            color: CustomColors.greyTextColor)
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    // .
                    // productName,

                    // Expanded(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       semiBoldText(
                    //         ref.watch(selectedProductDetailsProvider)?.name ??
                    //             "",

                    //         // .
                    //         // productName,
                    //         fontSize: 14.sp,
                    //       ),
                    //       verticalSpacer(3.h),
                    //       Row(
                    //         children: [
                    //           regularText("by; ",
                    //               fontSize: 13.sp,
                    //               color: CustomColors.greyTextColor),
                    //           horizontalSpacer(3.w),
                    //           ref
                    //                       .watch(selectedProductDetailsProvider)
                    //                       ?.provider ==
                    //                   null
                    //               ? const SizedBox.shrink()
                    //               :

                    //               // ref
                    //               //             .watch(
                    //               //                 selectedProductDetailsProvider)
                    //               //             ?.provider
                    //               //             ?.settings
                    //               //             ?.logo ==
                    //               //         null

                    //               StringUtils.isNullOrEmpty(ref
                    //                       .watch(selectedProductDetailsProvider)
                    //                       ?.provider
                    //                       ?.settings
                    //                       ?.logo)
                    //                   ? regularText(
                    //                       ref
                    //                               .watch(
                    //                                   selectedProductDetailsProvider)
                    //                               ?.provider
                    //                               ?.companyName ??
                    //                           "",
                    //                       fontSize: 13.sp,
                    //                       color: CustomColors.greyTextColor)
                    //                   : customImagenetwork(
                    //                       imageUrl: ref
                    //                           .watch(
                    //                               selectedProductDetailsProvider)!
                    //                           .provider!
                    //                           .settings!
                    //                           .logo!,
                    //                       fit: BoxFit.cover,
                    //                       loaderWidget: ShimmerLoader(
                    //                         height: 15.h,
                    //                         width: 50,
                    //                       ),
                    //                       height: 15.h,
                    //                     )

                    //           //  Image.network(
                    //           //     height: 15.h,
                    //           //     ref
                    //           //         .watch(
                    //           //             selectedProductDetailsProvider)!
                    //           //         .provider!
                    //           //         .settings!
                    //           //         .logo!,
                    //           //     fit: BoxFit.cover,
                    //           //     // package: 'mca_official_flutter_sdk',
                    //           //   ),
                    //           // Image.asset(
                    //           //   height: 15.h,
                    //           //   mockProviderProductLists[1].imageUrl,
                    //           //   fit: BoxFit.cover,
                    //           //   package: 'mca_official_flutter_sdk',
                    //           // ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              horizontalSpacer(5.w),
              Column(
                children: [
                  ref.watch(selectedProductDetailsProvider)?.isDynamicPricing ==
                          true
                      ? semiBoldText(
                          "${StringUtils.getProductPrice(ref.watch(selectedProductDetailsProvider)?.price ?? "", ref.watch(selectedProductDetailsProvider)?.isDynamicPricing ?? false)} / ${StringUtils.getProviderPeriodOfCover(
                            ref
                                    .watch(selectedProductDetailsProvider)
                                    ?.coverPeriod ??
                                "",
                          )}",
                          fontSize: 14.sp,
                          color: CustomColors.primaryBrandColor(),
                        )
                      : RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '₦ ',
                                style: TextStyle(
                                  fontFamily: "",
                                  package: 'mca_official_flutter_sdk',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: CustomColors.primaryBrandColor(),
                                ),
                              ),
                              TextSpan(
                                text:
                                    //     "${StringUtils.getProductPrice(ref.watch(selectedProductDetailsProvider)?.price ?? "", ref.watch(selectedProductDetailsProvider)?.isDynamicPricing ?? false)} / ${StringUtils.getProviderPeriodOfCover(
                                    //   ref
                                    //           .watch(selectedProductDetailsProvider)
                                    //           ?.coverPeriod ??
                                    //       "",
                                    // )}",
                                    "${StringUtils.formatPriceWithComma(ref.watch(selectedProductDetailsProvider)?.price ?? "")} / ${StringUtils.getProviderPeriodOfCover(
                                  ref
                                          .watch(selectedProductDetailsProvider)
                                          ?.coverPeriod ??
                                      "",
                                )}",
                                style: CustomTextStyles.semiBold(
                                  fontSize: 14.sp,
                                  color: CustomColors.primaryBrandColor(),
                                ),
                              )
                            ],
                          ),
                        ),
                  // semiBoldText(
                  //   "5% / Annum",
                  //   fontSize: 14.sp,
                  //   color: CustomColors.primaryGreenColor,
                  // ),
                  verticalSpacer(5.h),
                  // (false)
                  //     ? Container(
                  //         height: 20,
                  //         decoration: BoxDecoration(
                  //             color: CustomColors.discountBgColor,
                  //             borderRadius: BorderRadius.circular(2.r)),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               regularText("30% discount",
                  //                   fontSize: 12.sp,
                  //                   color: CustomColors.blackColor),
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

                        //  title:
                        //                   "${widget.productCategory.name ?? ""} Insurance",
                        //               productName: ref
                        //                       .watch(
                        //                           productListProvider)?[index]
                        //                       .name ??
                        //                   "",
                        //               provider: ref
                        //                   .watch(productListProvider)?[index]
                        //                   .provider,
                        //               keyBenefits: ref
                        //                   .watch(productListProvider)?[index]
                        //                   .keyBenefits,
                        //               howToClaim: ref
                        //                   .watch(productListProvider)?[index]
                        //                   .howToClaim,
                        //               howItWorks: ref
                        //                   .watch(productListProvider)?[index]
                        //                   .howItWorks,
                        //               productDetails: ref
                        //                   .watch(productListProvider)?[index],
                        //               fullBenefits: ref
                        //                   .watch(productListProvider)?[index]
                        //                   .fullBenefits,
                        //               productCategory: widget.productCategory,
                        //               formattedPrice: StringUtils.getProductPrice(
                        //                   ref
                        //                           .watch(productListProvider)?[
                        //                               index]
                        //                           .price ??
                        //                       "",
                        //                   ref
                        //                           .watch(productListProvider)?[
                        //                               index]
                        //                           .isDynamicPricing ??
                        //                       false),
                        //               periodOfCover:
                        //                   StringUtils.getProviderPeriodOfCover(
                        //                 ref
                        //                         .watch(
                        //                             productListProvider)?[index]
                        //                         .coverPeriod ??
                        //                     "",
                        //               ),
                        //               price: ref
                        //                       .watch(
                        //                           productListProvider)?[index]
                        //                       .price ??
                        //                   "",
                        //               isDynamicPrice: ref
                        //                       .watch(
                        //                           productListProvider)?[index]
                        //                       .isDynamicPricing ??
                        //                   false,