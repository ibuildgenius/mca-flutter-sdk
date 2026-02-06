import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

import '../constants/custom_colors.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final String? routeName;
  final Color? textColor;
  final bool isLoading;
  final bool isBoldTitle;
  final bool borderButton;
  final double? width, height;
  final void Function()? onTap;
  final Color? buttonColor;
  final double? fontSize;

  const CustomOutlinedButton({
    super.key,
    required this.title,
    this.routeName,
    this.onTap,
    this.isLoading = false,
    this.isBoldTitle = true,
    this.borderButton = false,
    this.width,
    this.height,
    this.buttonColor,
    this.textColor = CustomColors.whiteColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : onTap ??
              () {
                // Navigator.pushNamed(context, routeName!);
                // Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
      child: Container(
        height: height ?? 56,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: onTap == null || isLoading
              ? buttonColor == null
                  ? CustomColors.primaryBrandColor().withOpacity(0.6)
                  :
                  // :buttonColor!.withOpacity(0.5) :

                  buttonColor!.withOpacity(0.5)
              : buttonColor ?? CustomColors.primaryBrandColor(),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mediumText(
              title,
              fontSize: fontSize ?? 16.sp,
              color: textColor,
            ),
            isLoading
                ? Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: SpinKitFadingCircle(
                        color: textColor ?? CustomColors.whiteColor,
                        size: 25.0,
                      ),

                      // CircularProgressIndicator(
                      //   color: textColor,
                      // ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        )),
      ),
    );
  }
}
