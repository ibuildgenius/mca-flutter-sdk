import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
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

class GridProviderContainer extends StatelessWidget {
  final String title, periodOfCover, formattedPrice, price;
  final ProviderLiteModel? provider;
  final bool hasDiscount, isDynamicPrice;
  final ProductDetailsModel? productDetails;

  const GridProviderContainer({
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
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: CustomColors.productBorderColor,
        width: 0.6,
      )),
      child: Padding(
        padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
                          imageUrl:
                              provider?.icon ?? provider?.settings?.icon ?? "",
                          loaderWidget: regularText(provider?.companyName ?? "",
                              fontSize: 13.sp,
                              color: CustomColors.greyTextColor),
                          // fit: BoxFit.cover,
                          height: 16.h,
                        )

                  // kk semiBoldText(
                  //   StringUtils.getFirstCharCapitalized(provider?.companyName),
                  //   fontSize: 13.sp,
                  //   color: CustomColors.blackColor,
                  // ),
                  ),
            ),
            verticalSpacer(10),
            semiBoldText(
              title,
              fontSize: 14.sp,
            ),
            Row(
              children: [
                provider == null
                    ? const SizedBox.shrink()
                    : mediumText(provider?.companyName ?? "",
                        fontSize: 12.sp, color: CustomColors.greyTextColor)
              ],
            ),
            const Spacer(
              flex: 2,
            ),
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
            Global.businessDetails?.appMode == "test" &&
                    productDetails?.stabilityPercentageLiveMode != null
                ? StabilityIndicator(
                    value: productDetails!.stabilityPercentageLiveMode!,
                  )
                : const SizedBox(
                    height: 20,
                  ),
            const Spacer(
              flex: 1,
            ),
            // (hasDiscount)
            //     ? Padding(
            //         padding: const EdgeInsets.only(bottom: 10.0),
            //         child: Container(
            //           height: 20,
            //           decoration: BoxDecoration(
            //               color: CustomColors.discountBgColor,
            //               borderRadius: BorderRadius.circular(3.r)),
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 regularText("30% discount",
            //                     fontSize: 12.sp,
            //                     color: CustomColors.blackColor),
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //     : const SizedBox(
            //         height: 20,
            //       ),
          ],
        ),
      ),
    );
  }
}
