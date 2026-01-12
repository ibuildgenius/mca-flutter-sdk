import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class StartSideContainer extends StatelessWidget {
  final InspectionType inspectionType;
  final dynamic step;

  //HELP
  final void Function() onTap;
  const StartSideContainer({
    super.key,
    required this.inspectionType,
    required this.step,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      color: CustomColors.transGray100Color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpacer(
            MediaQuery.of(context).padding.top + 15,
          ),
          RichText(
            text: TextSpan(
              style: CustomTextStyles.semiBold(
                // height: 1.8,
                fontSize: 21,
                color: CustomColors.whiteColor,
              ),
              children: [
                TextSpan(
                  text: inspectionType == InspectionType.gadget
                      ? "Device "
                      : "Vehicle ",
                ),
                TextSpan(
                  text: "${getSideName(step)} View ",
                  style: CustomTextStyles.semiBold(
                    // height: 1.8,
                    fontSize: 21,
                    color: CustomColors.primaryBrandColor(),
                  ),
                ),
                // const TextSpan(
                //   text: "View",
                // ),
              ],
            ),
          ),
          verticalSpacer(10),
          mediumText(
            inspectionType == InspectionType.gadget
                ? "Snap Device ${getSideName(step)} View"
                : "Snap Vehicle ${getSideName(step)} View",
            fontSize: 16,
            color: CustomColors.whiteColor,
          ),
          verticalSpacer(30),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                getSideImage(step),
                fit: BoxFit.cover,
                package: 'mca_official_flutter_sdk',
              ),
            ),
          ),
          verticalSpacer(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              children: [
                Visibility(
                  visible: step == CarVerificationStep.frontSidePreCapture,
                  child: Expanded(
                    child: CustomButton(
                      title: "Go back",
                      buttonColor: CustomColors.whiteColor,
                      textColor: CustomColors.backTextColor,
                      fontSize: 15,
                      borderRadius: 10,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                horizontalSpacer(10.w),
                Expanded(
                  child: CustomButton(
                    title: "Start",
                    onTap: onTap,
                    fontSize: 15,
                    borderRadius: 10,
                  ),
                ),
              ],
            ),
          ),
          verticalSpacer(MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }
}
