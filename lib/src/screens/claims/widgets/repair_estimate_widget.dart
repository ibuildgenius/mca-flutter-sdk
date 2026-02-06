import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class RepairEstimateWidget extends StatelessWidget {
  const RepairEstimateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpacer(20),
        regularText(
          "We understand you may not have a valid mechanic at the moment for an estimate of repair.",
          color: CustomColors.formTitleColor,
          fontSize: 15,
        ),
        verticalSpacer(10),
        RichText(
          // textAlign: TextAlign.center,

          text: TextSpan(
            children: [
              TextSpan(
                text: "Note ",
                style: CustomTextStyles.regular(
                  fontSize: 14,
                  color: CustomColors.orangeColor,
                  height: 1.45,
                ),
              ),
              TextSpan(
                text:
                    ": Kindly submit this within the next 30 days, as any submissions beyond this time trame will render the claim invalid.",
                style: CustomTextStyles.regular(
                  color: CustomColors.formTitleColor,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        verticalSpacer(30),
      ],
    );
  }
}
