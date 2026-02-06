import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';

class IconContainer extends StatelessWidget {
  final String icon;
  final double diameter;
  const IconContainer({
    super.key,
    required this.icon,
    this.diameter = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter.sp,
      width: diameter.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: CustomColors.primaryBrandColor().withOpacity(0.08),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(
              CustomColors.primaryBrandColor(), BlendMode.srcIn),
          //changeCOlor
          // color: CustomColors.primaryBrandColor(),
          package: 'mca_official_flutter_sdk',
        ),
      ),
    );
  }
}
