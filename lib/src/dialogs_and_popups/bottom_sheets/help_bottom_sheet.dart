import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/help_container.dart';

void showHelpBottomSheet(BuildContext context) {
  showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      // scrollControlDisabledMaxHeightRatio: 300,
      barrierColor: Colors.black.withOpacity(0.6),
      context: context,
      builder: (context) {
        return LayoutBuilder(builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *
                  0.8, // max height constraint
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  verticalSpacer(30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        semiBoldText("Help Center", fontSize: 16.sp),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            ConstantString.xMark,
                            package: 'mca_official_flutter_sdk',
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpacer(30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const HelpContainer(),
                  ),
                  verticalSpacer(30.h),
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            semiBoldText(
                              "What is this help center for ?",
                              fontSize: 15.sp,
                              color: CustomColors.darkTextColor,
                            ),
                            verticalSpacer(10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "This Help Center serves as a comprehensive resource, offering essential information, guidance, and support tailored to each page of your process. ",
                                    style: CustomTextStyles.regular(
                                      fontSize: 14.sp,
                                      color: CustomColors.blackTextColor,
                                      height: 1.4,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "for each page, just click on the help",
                                    style: CustomTextStyles.w500(
                                      fontSize: 15.sp,
                                      color: CustomColors.primaryBrandColor(),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: const Divider(
                                color: CustomColors.productBorderColor,
                                thickness: 0.5,
                              ),
                            ),
                            semiBoldText(
                              "Why should I read and understand your privacy guidelines?",
                              fontSize: 15.sp,
                              color: CustomColors.darkTextColor,
                            ),
                            verticalSpacer(10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "Understanding our privacy guidelines is crucial to ensuring a secure and transparent  process.",
                                    style: CustomTextStyles.regular(
                                      fontSize: 14.sp,
                                      color: CustomColors.blackTextColor,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: const Divider(
                                color: CustomColors.productBorderColor,
                                thickness: 0.5,
                              ),
                            ),
                            semiBoldText(
                              "How do I report technical issues or bugs?",
                              fontSize: 15.sp,
                              color: CustomColors.darkTextColor,
                            ),
                            verticalSpacer(10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "If you encounter any technical issues or bugs during your inspection , please contact our support team at",
                                    style: CustomTextStyles.regular(
                                      fontSize: 14.sp,
                                      color: CustomColors.blackTextColor,
                                      height: 1.4,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " support@mycover.ai.com ",
                                    style: CustomTextStyles.w500(
                                      fontSize: 15.sp,
                                      color: CustomColors.primaryBrandColor(),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: const Divider(
                                color: CustomColors.productBorderColor,
                                thickness: 0.5,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSpacer(MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          );
        });
      });
}
