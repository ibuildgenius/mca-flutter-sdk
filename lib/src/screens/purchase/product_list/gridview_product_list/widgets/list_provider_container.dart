import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/models/provider_lite_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/color_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_image_network.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/stability_indicator.dart';

class ListProviderContainer extends StatelessWidget {
  final String title, periodOfCover, formattedPrice, price;
  final ProviderLiteModel? provider;
  final ProductDetailsModel? productDetails;
  final bool hasDiscount, isDynamicPrice;

  const ListProviderContainer({
    super.key,
    required this.title,
    required this.provider,
    required this.hasDiscount,
    required this.periodOfCover,
    required this.formattedPrice,
    required this.isDynamicPrice,
    required this.price,
    required this.productDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                height: 33,
                width: 33,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorUtils.getColorFromHex(
                            provider?.brandColorPrimary ??
                                provider?.settings?.brandColorPrimary)
                        .withOpacity(0.5),
                    width: 4.13,
                  ),

                  // color: Colors.red,
                ),
                child: Center(
                    child: provider == null ||
                            StringUtils.isNullOrEmpty(
                                provider?.icon ?? provider?.settings?.icon)
                        ? semiBoldText(
                            StringUtils.getFirstCharCapitalized(
                                provider?.companyName),
                            fontSize: 13.sp,
                            color: CustomColors.blackColor,
                          )
                        : customImagenetwork(
                            imageUrl: provider?.icon ??
                                provider?.settings?.icon ??
                                "",
                            loaderWidget: regularText(
                                provider?.companyName ?? "",
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
                      title,
                      fontSize: 14.sp,
                    ),
                    Row(
                      children: [
                        provider == null
                            ? const SizedBox.shrink()
                            : mediumText(provider?.companyName ?? "",
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
        horizontalSpacer(15.w),
        Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            isDynamicPrice
                ? semiBoldText(
                    "$formattedPrice / $periodOfCover",
                    fontSize: 14.sp,
                    color: CustomColors.blackColor,
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
                            color: CustomColors.blackColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${StringUtils.formatPriceWithComma(price)} / $periodOfCover",
                          style: CustomTextStyles.semiBold(
                            fontSize: 14.sp,
                            color: CustomColors.blackColor,
                          ),
                        )
                      ],
                    ),
                  ),
            // semiBoldText(
            //   "$formattedPrice / $periodOfCover",
            //   fontSize: 14.sp,
            //   color: CustomColors.primaryGreenColor,
            // ),
            // verticalSpacer(5.h),
            Global.businessDetails?.appMode == "test" &&
                    productDetails?.stabilityPercentageTestMode != null
                ? StabilityIndicator(
                    value: productDetails!.stabilityPercentageTestMode!,
                  )

                // Padding(
                //     padding: const EdgeInsets.only(top: 5.0),
                //     child: Row(
                //       children: [
                //         regularText("Stability:  ",
                //             fontSize: 12.sp, color: CustomColors.blackColor),
                //         Container(
                //           height: 20,
                //           decoration: BoxDecoration(
                //               color: CustomColors.discountBgColor,
                //               borderRadius: BorderRadius.circular(10.r)),
                //           child: Padding(
                //             padding:
                //                 const EdgeInsets.symmetric(horizontal: 5.0),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 const Icon(
                //                   Icons.circle,
                //                   size: 7,
                //                 ),
                //                 horizontalSpacer(4),
                //                 regularText("30%",
                //                     fontSize: 12.sp,
                //                     color: CustomColors.blackColor),
                //               ],
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   )
                : const SizedBox.shrink(),

            // (true)
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
            //                   fontSize: 12.sp, color: CustomColors.blackColor),
            //             ],
            //           ),
            //         ),
            //       )
            //     : const SizedBox(
            //         height: 20,
            //       ),
          ],
        ),
        horizontalSpacer(10.w),
        SvgPicture.asset(
          ConstantString.chevronRight,
          package: 'mca_official_flutter_sdk',
        ),
      ],
    );
  }
}
