// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_image_network.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/shimmer_loader.dart';

class PaymentDetailsContainer extends StatelessWidget {
  // final String productName, periodOfCover, formattedPrice, price;
  /////
  // final ProviderLiteModel? provider;
  // final ProductDetailsModel? productDetails;

  ////
  // final int premiumPrice;
  // final ProductCategoriesModel productCategory;
  const PaymentDetailsContainer({
    super.key,
    // required this.premiumPrice,
    // required this.periodOfCover,
    // required this.formattedPrice,
    // required this.price,
    // required this.provider,
    // required this.productDetails,
    // required this.productCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Container(
        decoration: BoxDecoration(
            color: CustomColors.lightPrimaryBrandColor(),
            borderRadius: BorderRadius.circular(3.r),
            border: Border(
                bottom: BorderSide(
              color: CustomColors.primaryBrandColor(),
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
                    //   icon: IconUtils.getIcon(productCategory.name ?? ""),
                    // ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          semiBoldText(
                            // productName ??
                            ref.watch(selectedProductDetailsProvider)?.name ??
                                "",
                            fontSize: 14.sp,
                          ),
                          verticalSpacer(3.h),
                          Row(
                            children: [
                              regularText("by ",
                                  fontSize: 13.sp,
                                  color: CustomColors.greyTextColor),
                              horizontalSpacer(3.w),
                              ref
                                          .watch(selectedProductDetailsProvider)
                                          ?.provider ==
                                      null
                                  ? const SizedBox.shrink()
                                  : StringUtils.isNullOrEmpty(ref
                                          .watch(selectedProductDetailsProvider)
                                          ?.provider
                                          ?.settings
                                          ?.logo)
                                      ? regularText(
                                          ref
                                                  .watch(
                                                      selectedProductDetailsProvider)
                                                  ?.provider
                                                  ?.companyName ??
                                              "",
                                          fontSize: 13.sp,
                                          color: CustomColors.greyTextColor)
                                      : customImagenetwork(
                                          imageUrl: ref
                                              .watch(
                                                  selectedProductDetailsProvider)!
                                              .provider!
                                              .settings!
                                              .logo!,
                                          fit: BoxFit.cover,
                                          loaderWidget: const ShimmerLoader(
                                            height: 15,
                                            width: 50,
                                          ),
                                          height: 15,
                                        )

                              //  Image.network(
                              //     height: 15.h,
                              //     ref
                              //         .watch(
                              //             selectedProductDetailsProvider)!
                              //         .provider!
                              //         .settings!
                              //         .logo!,
                              //     fit: BoxFit.cover,
                              //     // package: 'mca_official_flutter_sdk',
                              //   ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: ref.watch(productPriceProvider).toString(),
                        ),
                      );
                      CustomToast.showToastMessage(context,
                          "Amount copied successfully", ToastStatus.success);
                    },
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Pay  ",
                                style: CustomTextStyles.regular(
                                  fontSize: 12.sp,
                                  color: CustomColors.blackColor,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "NGN ${StringUtils.formatPriceWithComma(ref.watch(productPriceProvider).toString())}",
                                style: CustomTextStyles.semiBold(
                                  fontSize: 15.sp,
                                  color: CustomColors.primaryBrandColor(),
                                ),
                              )
                            ],
                          ),
                        ),
                        horizontalSpacer(5),
                        const Icon(
                          Icons.copy,
                          size: 12,
                          color: CustomColors.greyTextColor,
                        ),
                      ],
                    ),
                  ),
                  verticalSpacer(5.h),
                  regularText(
                    Global.email ?? "",
                    fontSize: 12.sp,
                    color: CustomColors.blackColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
