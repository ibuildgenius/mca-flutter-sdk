import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/inspection_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class InspectionSuccessScreenScreen extends StatefulHookConsumerWidget {
  final InspectionModel inspection;

  const InspectionSuccessScreenScreen({super.key, required this.inspection});

  @override
  ConsumerState<InspectionSuccessScreenScreen> createState() =>
      _InspectionSuccessScreenScreenState();
}

class _InspectionSuccessScreenScreenState
    extends ConsumerState<InspectionSuccessScreenScreen> {
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
                      Global.transactionType == TransactionType.claim
                          ? "Claim Successfully Submitted"
                          : "Inspection Successful",
                      fontSize: 16.sp,
                      color: CustomColors.primaryBrandColor(),
                    ),
                  ),
                  verticalSpacer(30.h),
                  Center(
                    child: regularText(
                      Global.transactionType == TransactionType.claim
                          ? "Great! Your inspection has concluded successfully. Please check your email for the inspection's preview and summary."
                          : "Your insurance policy has been activated. Check your email for further information about your policy.",
                      fontSize: Global.transactionType == TransactionType.claim
                          ? 15
                          : 16,
                      color: CustomColors.blackTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Global.transactionType == TransactionType.claim
                      ? Column(
                          children: [
                            verticalSpacer(30),
                            Container(
                              decoration: BoxDecoration(
                                  color: CustomColors.lightOrangeColor,
                                  border: Border.all(
                                    width: 0.4,
                                    color: CustomColors.orangeColor,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 10,
                                ),
                                child: Column(
                                  children: [
                                    RichText(
                                      // textAlign: TextAlign.center,

                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Note: ",
                                            style: CustomTextStyles.w500(
                                              fontSize: 14.sp,
                                              color:
                                                  CustomColors.blackTextColor,
                                              height: 1.6,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "Your claim is currently under review. Our team is carefully assessing all the details to ensure a thorough evaluation. Once your claim has been approved, you will receive a notification via email with further instructions and information on the next steps",
                                            style: CustomTextStyles.regular(
                                              fontSize: 13.sp,
                                              color:
                                                  CustomColors.blackTextColor,
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),

                  const Expanded(flex: 2, child: SizedBox()),
                  CustomButton(
                      title: Global.transactionType == TransactionType.claim
                          ? "Done"
                          : "Close",
                      onTap:
                          //  selectedOption == PaymentMethod.transfer
                          //     ?

                          () {
                        MyCoverAI.exitSDK(context);
                
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
