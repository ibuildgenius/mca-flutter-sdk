import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class AutoInspectionStep1 extends StatelessWidget {
  final PageViewContent content;
  final String imageUrl;
  final String? section1Text,
      section2Text,
      section3text,
      section4Text,
      section5Text,
      section6Text,
      imageTitle;

  const AutoInspectionStep1({
    super.key,
    required this.content,
    required this.imageUrl,
    this.section1Text,
    this.section2Text,
    this.section3text,
    this.section4Text,
    this.section5Text,
    this.section6Text,
    this.imageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        content == PageViewContent.firstAutoPage
            // content == PageViewContent.secondAutoPage
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 7,
                          width: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomColors.blackColor,
                          ),
                        ),
                      ),
                      horizontalSpacer(10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: CustomTextStyles.regular(
                                height: 1.3,
                                fontSize: 17,
                                color: CustomColors.blackTextColor),
                            children: [
                              const TextSpan(
                                text: "Ensure that your browser's ",
                              ),
                              TextSpan(
                                text: "location ",
                                style: CustomTextStyles.w500(
                                    height: 1.3,
                                    fontSize: 17,
                                    color: CustomColors.blackTextColor),
                              ),
                              const TextSpan(
                                text: "and ",
                              ),
                              TextSpan(
                                text: "camera ",
                                style: CustomTextStyles.w500(
                                    height: 1.3,
                                    fontSize: 17,
                                    color: CustomColors.blackTextColor),
                              ),
                              const TextSpan(
                                text: "permission are enabled.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(20.h),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.gray100Color,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Image.asset(
                      ConstantString.iphoneInspectLocation,
                      fit: BoxFit.cover,
                      package: 'mca_official_flutter_sdk',
                    ),
                  ),
                  verticalSpacer(30.h),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.gray100Color,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Image.asset(
                      ConstantString.iphoneInspectInternet,
                      fit: BoxFit.cover,
                      package: 'mca_official_flutter_sdk',
                    ),
                  ),
                  verticalSpacer(40.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 7,
                          width: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomColors.blackColor,
                          ),
                        ),
                      ),
                      horizontalSpacer(10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: CustomTextStyles.regular(
                                height: 1.3,
                                fontSize: 17,
                                color: CustomColors.blackTextColor),
                            children: const [
                              TextSpan(
                                text:
                                    "Ensure a stable internet connection before proceeding with the inspection.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(40),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.backBorderColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: CustomTextStyles.regular(
                              height: 1.3,
                              fontSize: 15,
                              color: CustomColors.blackTextColor),
                          children: [
                            const TextSpan(
                              text:
                                  "If you encounter any technical issues or bugs during your inspection , please contact our support team at ",
                            ),
                            TextSpan(
                              text: "Inspectionsupport@mycover.ai.com",
                              style: CustomTextStyles.regular(
                                height: 1.3,
                                fontSize: 15,
                                color: CustomColors.primaryBrandColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSpacer(30),
                ],
              )
            : content == PageViewContent.secondAutoPage
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: CustomTextStyles.regular(
                                    height: 1.3,
                                    fontSize: 17,
                                    color: CustomColors.blackTextColor),
                                children: [
                                  const TextSpan(
                                    text: "Park your Vehicle in a ",
                                  ),
                                  TextSpan(
                                    text: "well-lit, ",
                                    style: CustomTextStyles.w500(
                                        height: 1.3,
                                        fontSize: 17,
                                        color: CustomColors.blackTextColor),
                                  ),
                                  const TextSpan(
                                    text: "and ",
                                  ),
                                  TextSpan(
                                    text: "spacious area, ",
                                    style: CustomTextStyles.w500(
                                        height: 1.3,
                                        fontSize: 17,
                                        color: CustomColors.blackTextColor),
                                  ),
                                  const TextSpan(
                                    text: "ensuring there are  ",
                                  ),
                                  TextSpan(
                                    text: "no obstructions.",
                                    style: CustomTextStyles.w500(
                                        height: 1.3,
                                        fontSize: 17,
                                        color: CustomColors.blackTextColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpacer(20.h),
                      Container(
                        decoration: BoxDecoration(
                          color: CustomColors.gray100Color,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Image.asset(
                          ConstantString.inspectionWellLit,
                          fit: BoxFit.cover,
                          package: 'mca_official_flutter_sdk',
                        ),
                      ),
                      verticalSpacer(30),
                    ],
                  )
                : content == PageViewContent.thirdAutoPage
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: CustomTextStyles.regular(
                                        height: 1.3,
                                        fontSize: 16,
                                        color: CustomColors.blackTextColor),
                                    children: [
                                      const TextSpan(
                                        text: "Capture images of ",
                                      ),
                                      TextSpan(
                                        text: "all views ",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: "of your vehicle including ",
                                      ),
                                      TextSpan(
                                        text: "internal Views ",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            " (dashboard and back seat ), ensuring it occupies approximately ",
                                      ),
                                      TextSpan(
                                        text: " 80% ",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: "of your camera screen.",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpacer(20.h),
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.gray100Color,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Image.asset(
                              ConstantString.frontViewSample,
                              fit: BoxFit.cover,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                          verticalSpacer(30.h),
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.gray100Color,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Image.asset(
                              ConstantString.leftViewSample,
                              fit: BoxFit.cover,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                          verticalSpacer(30.h),
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.gray100Color,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Image.asset(
                              ConstantString.backViewSample,
                              fit: BoxFit.cover,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                          verticalSpacer(30.h),
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.gray100Color,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Image.asset(
                              ConstantString.rightViewSample,
                              fit: BoxFit.cover,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                          verticalSpacer(40.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: CustomTextStyles.regular(
                                        height: 1.3,
                                        fontSize: 16,
                                        color: CustomColors.blackTextColor),
                                    children: [
                                      const TextSpan(
                                        text: "Take picture of your ",
                                      ),
                                      TextSpan(
                                        text: "Vehicle's ",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color: CustomColors.blackTextColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Dashboard",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ", ensuring it fills about ",
                                      ),
                                      TextSpan(
                                        text: " 80% ",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: "of your camera screen",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpacer(20.h),
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.gray100Color,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Image.asset(
                              ConstantString.dashboardViewSample,
                              fit: BoxFit.cover,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                          verticalSpacer(40.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: CustomTextStyles.regular(
                                        height: 1.3,
                                        fontSize: 16,
                                        color: CustomColors.blackTextColor),
                                    children: [
                                      const TextSpan(
                                        text: "Take picture of your ",
                                      ),
                                      TextSpan(
                                        text: "Vehicle's ",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color: CustomColors.blackTextColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Interior Back view",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ", ensuring it fills about ",
                                      ),
                                      TextSpan(
                                        text: " 80% ",
                                        style: CustomTextStyles.w500(
                                          height: 1.3,
                                          fontSize: 16,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: "of your camera screen",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpacer(20.h),
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.gray100Color,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Image.asset(
                              ConstantString.innerBackViewSample,
                              fit: BoxFit.cover,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                          verticalSpacer(30),
                        ],
                      )
                    : content == PageViewContent.fourthAutoPage
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomColors.backBorderColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 15,
                                  ),
                                  child: Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: CustomTextStyles.regular(
                                              height: 1.3,
                                              fontSize: 15,
                                              color:
                                                  CustomColors.blackTextColor),
                                          children: [
                                            TextSpan(
                                              text: "Note :  ",
                                              style: CustomTextStyles.regular(
                                                height: 1.3,
                                                fontSize: 15,
                                                color: CustomColors.orangeColor,
                                              ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  "Double-check to avoid errors when capturing your chassis number. It consists of ",
                                            ),
                                            TextSpan(
                                              text: "17 digits and letters.",
                                              style: CustomTextStyles.regular(
                                                height: 1.3,
                                                fontSize: 15,
                                                color: CustomColors
                                                    .primaryBrandColor(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      verticalSpacer(15),
                                      Row(
                                        children: [
                                          regularText("see sample below",
                                              fontSize: 15,
                                              color:
                                                  CustomColors.blackTextColor),
                                        ],
                                      ),
                                      verticalSpacer(20),
                                      Image.asset(
                                        ConstantString.chasisNumberSample,
                                        fit: BoxFit.cover,
                                        package: 'mca_official_flutter_sdk',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              verticalSpacer(20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: CustomTextStyles.regular(
                                            height: 1.3,
                                            fontSize: 15,
                                            color: CustomColors.blackTextColor),
                                        children: [
                                          const TextSpan(
                                            text:
                                                "Take picture of your vehicle's ",
                                          ),
                                          TextSpan(
                                            text:
                                                "chassis number ( Vehicle VIN)",
                                            style: CustomTextStyles.w500(
                                              height: 1.3,
                                              fontSize: 15,
                                              color: CustomColors
                                                  .primaryBrandColor(),
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ".",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpacer(20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: CustomTextStyles.regular(
                                            height: 1.3,
                                            fontSize: 15,
                                            color: CustomColors.blackTextColor),
                                        children: const [
                                          TextSpan(
                                            text:
                                                "See different positions of where you can see your chassis number",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpacer(20.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomColors.gray100Color,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.asset(
                                  ConstantString.chasisNumberSample2,
                                  fit: BoxFit.cover,
                                  package: 'mca_official_flutter_sdk',
                                ),
                              ),
                              verticalSpacer(20.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomColors.gray100Color,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.asset(
                                  ConstantString.chasisNumberSample3,
                                  fit: BoxFit.cover,
                                  package: 'mca_official_flutter_sdk',
                                ),
                              ),
                              verticalSpacer(20.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomColors.gray100Color,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.asset(
                                  ConstantString.chasisNumberSample4,
                                  fit: BoxFit.cover,
                                  package: 'mca_official_flutter_sdk',
                                ),
                              ),
                              verticalSpacer(30),
                            ],
                          )
                        : content == PageViewContent.displayTextAndList
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          height: 1.8,
                                          fontSize: 16.sp,
                                          color: CustomColors.gray700Color),
                                      children: [
                                        const TextSpan(
                                          text: "Take picture of your  ",
                                        ),
                                        TextSpan(
                                          text: "Vehicle's ",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColors.blackColor),
                                        ),
                                        TextSpan(
                                          text: "Chassis no.",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColors.greenColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  verticalSpacer(20.h),
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color:
                                                  CustomColors.purple500Color,
                                              width: 1.5),
                                        ),
                                      ),
                                      horizontalSpacer(10.w),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              height: 1.4,
                                              fontSize: 13.sp,
                                              color: CustomColors.gray700Color),
                                          children: [
                                            const TextSpan(
                                              text:
                                                  "You can locate the chassis number on the ",
                                            ),
                                            TextSpan(
                                              text: "front windshield, ",
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color:
                                                      CustomColors.greenColor),
                                            ),
                                            const TextSpan(
                                              text: "or",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalSpacer(20.h),
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color:
                                                  CustomColors.purple500Color,
                                              width: 1.5),
                                        ),
                                      ),
                                      horizontalSpacer(10.w),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              // height: 1.8,

                                              fontSize: 13.sp,
                                              color: CustomColors.gray700Color),
                                          children: [
                                            const TextSpan(
                                              text: "You can find it on the ",
                                            ),
                                            TextSpan(
                                              text: "interior door ",
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color:
                                                      CustomColors.greenColor),
                                            ),
                                            const TextSpan(
                                              text: "of the ",
                                            ),
                                            TextSpan(
                                              text: "driver's side",
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color:
                                                      CustomColors.greenColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      height: 1.8,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                      color: CustomColors.gray700Color),
                                  children: [
                                    TextSpan(
                                      text: content ==
                                              PageViewContent.displayGreenColor
                                          ? "Take picture of your  "
                                          : section1Text,
                                    ),
                                    TextSpan(
                                      text: content ==
                                              PageViewContent.displayGreenColor
                                          ? "Vehicle's "
                                          : section2Text,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: content ==
                                                  PageViewContent
                                                      .displayGreenColor
                                              ? FontWeight.w500
                                              : FontWeight.w700,
                                          color: CustomColors.gray700Color),
                                    ),
                                    TextSpan(
                                      text: section3text,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: content ==
                                                  PageViewContent
                                                      .displayGreenColor
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                          color: content ==
                                                  PageViewContent
                                                      .displayGreenColor
                                              ? CustomColors.greenColor
                                              : CustomColors.gray700Color),
                                    ),
                                    TextSpan(
                                      text: content ==
                                              PageViewContent.displayGreenColor
                                          ? ", ensuring it fills about "
                                          : section4Text,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: content ==
                                                PageViewContent
                                                    .displayGreenColor
                                            ? FontWeight.w400
                                            : FontWeight.w700,
                                        color: content ==
                                                PageViewContent
                                                    .displayGreenColor
                                            ? CustomColors.gray700Color
                                            : CustomColors.gray700Color,
                                      ),
                                    ),
                                    TextSpan(
                                      text: content ==
                                              PageViewContent.displayGreenColor
                                          ? "80% "
                                          : section5Text,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: content ==
                                                  PageViewContent
                                                      .displayGreenColor
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                          color: content ==
                                                  PageViewContent
                                                      .displayGreenColor
                                              ? CustomColors.success500Color
                                              : CustomColors.gray700Color),
                                    ),
                                    TextSpan(
                                      text: content ==
                                              PageViewContent.displayGreenColor
                                          ? "of your camera screen"
                                          : section6Text,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: content ==
                                                  PageViewContent
                                                      .displayGreenColor
                                              ? FontWeight.w400
                                              : FontWeight.w700,
                                          color: content ==
                                                  PageViewContent
                                                      .displayGreenColor
                                              ? CustomColors.gray700Color
                                              : CustomColors.gray700Color),
                                    ),
                                  ],
                                ),
                              ),
        // verticalSpacer(50.h),
        // imageTitle != null
        //     ? Text(
        //         imageTitle!,
        //         style: TextStyle(
        //             color: CustomColors.grayTextColor, fontSize: 16.sp),
        //       )
        //     : const SizedBox.shrink(),
        // verticalSpacer(10.h),
        // Container(
        //   decoration: BoxDecoration(
        //     color: CustomColors.gray100Color,
        //     borderRadius: BorderRadius.circular(12.r),
        //   ),
        //   child: Image.asset(
        //     imageUrl,
        //     fit: BoxFit.cover,
        //     package: 'mca_official_flutter_sdk',
        //   ),
        // ),
      ],
    );
  }
}
