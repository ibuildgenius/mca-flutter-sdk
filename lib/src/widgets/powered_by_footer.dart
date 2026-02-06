import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class PoweredByFooter extends StatelessWidget {
  const PoweredByFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (Global.businessDetails?.isWatermark == null ||
            Global.businessDetails?.isWatermark == true)
        ? Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(ConstantString.poweredIcon,
                    package: 'mca_official_flutter_sdk'),
                horizontalSpacer(5),
                mediumText(
                  "Powered by",
                  fontSize: 14,
                  color: CustomColors.greyTextColor,
                ),
                horizontalSpacer(5),
                Image.asset(ConstantString.myCoverLogoWithText,
                    height: 20, package: 'mca_official_flutter_sdk'),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
