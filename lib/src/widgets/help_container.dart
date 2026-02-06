import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class HelpContainer extends StatelessWidget {
  const HelpContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Container(
        decoration: BoxDecoration(
            color: CustomColors.backBorderColor,
            borderRadius: BorderRadius.circular(8.r),
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
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: semiBoldText(
                    "Welcome to our help Center",
                    fontSize: 18.sp,
                    color: CustomColors.darkTextColor,
                  ),
                ),
              ),
              horizontalSpacer(20.w),
              Image.asset(
                ConstantString.headphoneImage,
                height: 50,
                package: 'mca_official_flutter_sdk',
              )
            ],
          ),
        ),
      );
    });
  }
}
