import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class LoadingSideContainer extends StatelessWidget {
  const LoadingSideContainer({
    super.key,
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
          RichText(
            text: TextSpan(
              style: CustomTextStyles.semiBold(
                // height: 1.8,
                fontSize: 21,
                color: CustomColors.whiteColor,
              ),
              children: [
                TextSpan(
                  text: "Verifying ",
                  style: CustomTextStyles.semiBold(
                    // height: 1.8,
                    fontSize: 21,
                    color: CustomColors.primaryBrandColor(),
                  ),
                ),
                const TextSpan(
                  text: "Vehicle Image",
                ),
                // const TextSpan(
                //   text: "View",
                // ),
              ],
            ),
          ),
          // const Expanded(child: SizedBox()),
          verticalSpacer(30),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.whiteColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SpinKitFadingCircle(
                color: CustomColors.primaryBrandColor(),
                size: 35.0,
              ),
            ),
          ),
          verticalSpacer(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: regularText(
              "Hold on while we verify your image",
              textAlign: TextAlign.center,
              fontSize: 16.5,
              color: CustomColors.whiteColor,
            ),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                const Expanded(
                  child: CustomButton(
                    title: "Re capture",
                    buttonColor: CustomColors.whiteColor,
                    textColor: CustomColors.backTextColor,
                    fontSize: 15,
                    borderRadius: 8,
                  ),
                ),
                horizontalSpacer(10),
                const Expanded(
                  child: CustomButton(
                    title: "Verify",
                    fontSize: 15,
                    borderRadius: 8,
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
