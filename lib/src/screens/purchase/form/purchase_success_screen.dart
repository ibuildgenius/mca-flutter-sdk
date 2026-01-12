import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/policy_model.dart';
import 'package:mca_official_flutter_sdk/src/models/sdk_response.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class PurchaseSuccessScreenScreen extends StatefulHookConsumerWidget {
  final PolicyModel policy;
  const PurchaseSuccessScreenScreen({super.key, required this.policy});

  @override
  ConsumerState<PurchaseSuccessScreenScreen> createState() =>
      _PurchaseSuccessScreenScreenState();
}

class _PurchaseSuccessScreenScreenState
    extends ConsumerState<PurchaseSuccessScreenScreen> {
  PaymentMethod selectedOption = PaymentMethod.transfer;
  @override
  Widget build(BuildContext context) {
    // final paymentVM = ref.watch(paymentProvider);
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          child: Column(
        children: [
          verticalSpacer(20.h),
          CustomAppbar(
            showBackButton: false,
            onBackTap:
                Navigator.canPop(context) ? () => Navigator.pop(context) : null,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // semiBoldText(
                  //   "Select Payment methods",
                  //   fontSize: 20.sp,
                  // ),
                  verticalSpacer(40.h),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Lottie.asset(
                        ConstantString.purchaseSuccessful,
                        // height: 80,
                        // width: 80,
                        animate: true,
                        repeat: true,
                        reverse: false,
                        fit: BoxFit.contain,
                        package: 'mca_official_flutter_sdk',
                      ),
                    ),
                  ),
                  // const Expanded(child: SizedBox()),

                  Center(
                    child: semiBoldText(
                      "Activation Successful",
                      fontSize: 16.sp,
                      color: CustomColors.primaryBrandColor(),
                    ),
                  ),
                  verticalSpacer(30.h),
                  Center(
                    child: regularText(
                      "Your insurance policy has been activated. Check your email for further information about your policy.",
                      fontSize: 16.sp,
                      color: CustomColors.blackTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                  CustomButton(
                      title: "Close",
                      onTap:
                          //  selectedOption == PaymentMethod.transfer
                          //     ?
                          () {
                        SdkResponse response = SdkResponse(
                          status: SdkResponseStatus.success,
                          policyModel: widget.policy,
                          context: context,
                        );
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     MaterialPageRoute(
                        //         builder: (context) => const WelcomeScreen()),
                        //     (Route<dynamic> route) => false);
                        // Navigator.of(context)
                        //     .popUntil((route) => route.isFirst);
                        Navigator.of(context).popUntil((route) {
                          return route.settings.arguments ==
                              ConstantString.initialScreenKey;
                        });
                        Navigator.of(context).pop();
                        Global.onComplete!(response);
                      }
                      // : null,
                      ),
                  verticalSpacer(70.h),
                  const PoweredByFooter(),

                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
