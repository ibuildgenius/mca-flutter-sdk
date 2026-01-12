import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';

class PageViewContainer extends StatelessWidget {
  final PageViewContent content;
  final String imageUrl;
  final String? section1Text,
      section2Text,
      section3text,
      section4Text,
      section5Text,
      section6Text,
      imageTitle;

  const PageViewContainer({
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
        content == PageViewContent.displayTextAndList
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
                              color: CustomColors.purple500Color, width: 1.5),
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
                              text: "You can locate the chassis number on the ",
                            ),
                            TextSpan(
                              text: "front windshield, ",
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: CustomColors.greenColor),
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
                              color: CustomColors.purple500Color, width: 1.5),
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
                                  color: CustomColors.greenColor),
                            ),
                            const TextSpan(
                              text: "of the ",
                            ),
                            TextSpan(
                              text: "driver's side",
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: CustomColors.greenColor),
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
                      text: content == PageViewContent.displayGreenColor
                          ? "Take picture of your  "
                          : section1Text,
                    ),
                    TextSpan(
                      text: content == PageViewContent.displayGreenColor
                          ? "Vehicle's "
                          : section2Text,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                              content == PageViewContent.displayGreenColor
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                          color: CustomColors.gray700Color),
                    ),
                    TextSpan(
                      text: section3text,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                              content == PageViewContent.displayGreenColor
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                          color: content == PageViewContent.displayGreenColor
                              ? CustomColors.greenColor
                              : CustomColors.gray700Color),
                    ),
                    TextSpan(
                      text: content == PageViewContent.displayGreenColor
                          ? ", ensuring it fills about "
                          : section4Text,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: content == PageViewContent.displayGreenColor
                            ? FontWeight.w400
                            : FontWeight.w700,
                        color: content == PageViewContent.displayGreenColor
                            ? CustomColors.gray700Color
                            : CustomColors.gray700Color,
                      ),
                    ),
                    TextSpan(
                      text: content == PageViewContent.displayGreenColor
                          ? "80% "
                          : section5Text,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                              content == PageViewContent.displayGreenColor
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                          color: content == PageViewContent.displayGreenColor
                              ? CustomColors.success500Color
                              : CustomColors.gray700Color),
                    ),
                    TextSpan(
                      text: content == PageViewContent.displayGreenColor
                          ? "of your camera screen"
                          : section6Text,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                              content == PageViewContent.displayGreenColor
                                  ? FontWeight.w400
                                  : FontWeight.w700,
                          color: content == PageViewContent.displayGreenColor
                              ? CustomColors.gray700Color
                              : CustomColors.gray700Color),
                    ),
                  ],
                ),
              ),
        verticalSpacer(50.h),
        imageTitle != null
            ? Text(
                imageTitle!,
                style: TextStyle(
                    color: CustomColors.grayTextColor, fontSize: 16.sp),
              )
            : const SizedBox.shrink(),
        verticalSpacer(10.h),
        Container(
          decoration: BoxDecoration(
            color: CustomColors.gray100Color,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            package: 'mca_official_flutter_sdk',
          ),
        ),
      ],
    );
  }
}
