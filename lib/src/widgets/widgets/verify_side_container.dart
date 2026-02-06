import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class VerifySideContainer extends StatelessWidget {
  //HELP
  final dynamic step;
  final InspectionType inspectionType;
  final void Function()? onReCaptureTap;
  final void Function()? onVerifyTap;
  const VerifySideContainer({
    super.key,
    required this.onReCaptureTap,
    required this.onVerifyTap,
    required this.step,
    required this.inspectionType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      color: CustomColors.transGray100Color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          getVerificationStage(step) == VerificationStage.failed
              ? semiBoldText(
                  "Wrong vehicle view",
                  fontSize: 21,
                  color: CustomColors.toastRedColor,
                )
              : RichText(
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
                        text: "${getSideName(step)}  View ",
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
          inspectionType == InspectionType.gadget
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, top: 10),
                  child: mediumText(
                    "Confirm Device ${getSideName(step).toLowerCase()} View",
                    textAlign: TextAlign.center,
                    fontSize: 16.5,
                    color: CustomColors.whiteColor,
                  ),
                )
              : const SizedBox.shrink(),
          const Expanded(child: SizedBox()),
          getVerificationStage(step) == VerificationStage.failed
              ? Column(
                  children: [
                    regularText(
                      "Not a valid car image",
                      fontSize: 14,
                      color: CustomColors.toastRedColor,
                    ),
                    verticalSpacer(10),
                    SizedBox(
                      height: 80,
                      child: Image.asset(
                        getSideImage(step),
                        fit: BoxFit.cover,
                        package: 'mca_official_flutter_sdk',
                      ),
                    ),
                    verticalSpacer(10),
                    RichText(
                      text: TextSpan(
                        style: CustomTextStyles.regular(
                          // height: 1.8,
                          fontSize: 16,
                          color: CustomColors.whiteColor,
                        ),
                        children: [
                          const TextSpan(
                            text: "You have to recapture ",
                          ),
                          TextSpan(
                            text: "${getSideName(step)}  View ",
                            style: CustomTextStyles.w500(
                              // height: 1.8,
                              fontSize: 16,
                              color: CustomColors.primaryBrandColor(),
                            ),
                          ),
                          // const TextSpan(
                          //   text: "View",
                          // ),
                        ],
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: regularText(
                    inspectionType == InspectionType.gadget
                        ? "Confirm Device ${getSideName(step).toLowerCase()}  view to proceed"
                        : "Confirm Vehicle ${getSideName(step).toLowerCase()}  view to move to the next Vehicle view",
                    textAlign: TextAlign.center,
                    fontSize:
                        inspectionType == InspectionType.gadget ? 15 : 16.5,
                    color: CustomColors.whiteColor,
                  ),
                ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Re capture",
                    buttonColor: CustomColors.whiteColor,
                    textColor: CustomColors.backTextColor,
                    fontSize: 15,
                    borderRadius: 8,
                    onTap: onReCaptureTap,
                  ),
                ),
                horizontalSpacer(10),
                Visibility(
                  visible:
                      getVerificationStage(step) != VerificationStage.failed,
                  child: Expanded(
                    child: CustomButton(
                      title: "Verify",
                      onTap:
                          getVerificationStage(step) == VerificationStage.failed
                              ? null
                              : onVerifyTap,
                      fontSize: 15,
                      borderRadius: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
