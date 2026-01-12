import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/product_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';

void showAdvancedFilterBottomSheet(
  BuildContext context,
  WidgetRef ref,
  GlobalKey<FormBuilderState> formKey, {
  required ProductViewModel productVM,
  required String categoryid,
  String? providerId,
  // required String productName,
  // required String periodOfCover,
  // required String formattedPrice,
  // required String price,
  // ProviderLiteModel? provider,
  // required bool isDynamicPrice,
  String? keyBenefits,
  String? okText,
  String? cancelText,
  Color? iconColor,
  Widget? customIcon,
  Function()? onOkPressed,
  Function()? onCancelPressed,
  bool isDismissible = true,
  bool enableDrag = false,
  bool showButton = false,
}) {
  showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      // barrierColor: Colors.white,

      context: context,
      builder: (context) {
        return PopScope(
          canPop: isDismissible ? false : true,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
          child: FormBuilder(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  verticalSpacer(30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      semiBoldText("Filter by: ", fontSize: 16.sp),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          ConstantString.xMark,
                          package: 'mca_official_flutter_sdk',
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(30.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Price from ",
                                    style: CustomTextStyles.semiBold(
                                      fontSize: 14.sp,
                                      color: CustomColors.blackTextColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '(₦)',
                                    style: TextStyle(
                                      fontFamily: "",
                                      package: 'mca_official_flutter_sdk',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: CustomColors.blackTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpacer(10),
                            customFilterTextField(
                              "nairaPriceFrom",
                              hintText: "3,000",
                              isNumber: true,
                              isCurrency: true,
                              initialValue: StringUtils.formatPriceWithComma(
                                  ref.watch(filterFromNairaProvider)),
                              prefix: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '₦',
                                    style: TextStyle(
                                      fontFamily: "",
                                      package: 'mca_official_flutter_sdk',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: CustomColors.greyTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      horizontalSpacer(10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Price to ",
                                    style: CustomTextStyles.semiBold(
                                      fontSize: 14.sp,
                                      color: CustomColors.blackTextColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '(₦)',
                                    style: TextStyle(
                                      fontFamily: "",
                                      package: 'mca_official_flutter_sdk',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: CustomColors.blackTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpacer(10),
                            customFilterTextField(
                              "nairaPriceTo",
                              hintText: "15,000",
                              isNumber: true,
                              isCurrency: true,
                              initialValue: StringUtils.formatPriceWithComma(
                                  ref.watch(filterToNairaProvider)),
                              prefix: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '₦',
                                    style: TextStyle(
                                      fontFamily: "",
                                      package: 'mca_official_flutter_sdk',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: CustomColors.greyTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(50.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            semiBoldText(
                              "Price from (%)",
                              fontSize: 14.sp,
                              color: CustomColors.blackTextColor,
                            ),
                            verticalSpacer(10),
                            customFilterTextField(
                              "percentPriceFrom",
                              hintText: "1.00",
                              isNumber: true,
                              initialValue:
                                  ref.watch(filterFromPercentProvider),
                              prefix: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  semiBoldText(
                                    "%",
                                    fontSize: 14.sp,
                                    color: CustomColors.greyTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      horizontalSpacer(10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            semiBoldText(
                              "Price to (%)",
                              fontSize: 14.sp,
                              color: CustomColors.blackTextColor,
                            ),
                            verticalSpacer(10),
                            customFilterTextField(
                              "percentPriceTo",
                              hintText: "5.00",
                              isNumber: true,
                              initialValue: ref.watch(filterToPercentProvider),
                              prefix: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  semiBoldText(
                                    "%",
                                    fontSize: 14.sp,
                                    color: CustomColors.greyTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(50),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          title: "Cancel",
                          buttonColor: CustomColors.dividerGreyColor,
                          textColor: CustomColors.backTextColor,
                          fontSize: 14.sp,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      horizontalSpacer(10.w),
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          title: "Filter",
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            final nairaPriceFrom = formKey
                                .currentState?.fields['nairaPriceFrom']?.value;
                            final nairaPriceTo = formKey
                                .currentState?.fields['nairaPriceTo']?.value;

                            final percentPriceFrom = formKey.currentState
                                ?.fields['percentPriceFrom']?.value;
                            final percentPriceTo = formKey
                                .currentState?.fields['percentPriceTo']?.value;

                            if (StringUtils.isNullOrEmpty(nairaPriceFrom) &&
                                StringUtils.isNullOrEmpty(nairaPriceTo) &&
                                StringUtils.isNullOrEmpty(percentPriceFrom) &&
                                StringUtils.isNullOrEmpty(percentPriceTo)) {
                              Navigator.pop(context);
                            } else {
                              final validate = formKey.currentState?.validate();

                              if (validate == true) {
                                formKey.currentState?.save();
                                ref
                                        .read(filterFromNairaProvider.notifier)
                                        .state =
                                    StringUtils.isNullOrEmpty(nairaPriceFrom)
                                        ? null
                                        : nairaPriceFrom.replaceAll(",", "");

                                ref.read(filterToNairaProvider.notifier).state =
                                    StringUtils.isNullOrEmpty(nairaPriceTo)
                                        ? null
                                        : nairaPriceTo.replaceAll(",", "");

                                ref
                                    .read(filterFromPercentProvider.notifier)
                                    .state = StringUtils.isNullOrEmpty(
                                        percentPriceFrom)
                                    ? null
                                    : percentPriceFrom.replaceAll(",", "");

                                ref
                                        .read(filterToPercentProvider.notifier)
                                        .state =
                                    StringUtils.isNullOrEmpty(percentPriceTo)
                                        ? null
                                        : percentPriceTo.replaceAll(",", "");

                                ref.read(productListProvider.notifier).state =
                                    null;
                                productVM.getProductDetails(
                                    categoryid: categoryid,
                                    providerId: [providerId ?? ""],
                                    ref: ref,
                                    context: context);
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(MediaQuery.of(context).padding.bottom + 30),
                ],
              ),
            ),
          ),
        );
      });
}
