// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/purchase_initialization_response.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/payment_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/animated_progress_bar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/payment_details_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class PaymentProcessingScreen extends StatefulHookConsumerWidget {
  final PurchaseinitializationModel purchaseDetails;
  final PaymentMethod paymentMethod;
  const PaymentProcessingScreen({
    super.key,
    required this.purchaseDetails,
    required this.paymentMethod,
  });

  @override
  ConsumerState<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState
    extends ConsumerState<PaymentProcessingScreen> {
  PaymentMethod selectedOption = PaymentMethod.transfer;
  static const int totalTimeInSeconds = 1800; // 10 minutes
  int remainingTimeInSeconds = totalTimeInSeconds;
  late Timer timer;
  late String displayText;

  @override
  void initState() {
    super.initState();
    displayText = widget.paymentMethod == PaymentMethod.transfer
        ? "Copy details"
        : "Copy USSD code";
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTimeInSeconds > 0) {
          remainingTimeInSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentVM = ref.watch(paymentProvider);
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
          verticalSpacer(10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: const PaymentDetailsContainer(),
          ),
          verticalSpacer(40),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 42.h,
                            width: 42.w,
                            decoration: BoxDecoration(
                              color: CustomColors.lightGreenBgColor.withOpacity(
                                0.15,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                ConstantString.sentGreenIcon,
                                package: 'mca_official_flutter_sdk',
                              ),
                            ),
                          ),
                          verticalSpacer(7),
                          mediumText(
                            "Sent",
                            fontSize: 14.sp,
                            color: CustomColors.progressGreenTextColor,
                          )
                        ],
                      ),
                      horizontalSpacer(10),
                      Expanded(
                          child: Column(
                        children: [
                          verticalSpacer(14),
                          const AnimatedProgressBar(),
                          verticalSpacer(10),
                          mediumText(
                            formatTime(remainingTimeInSeconds),
                            color: remainingTimeInSeconds > 600
                                ? CustomColors.progressGreenTextColor
                                : remainingTimeInSeconds > 300
                                    ? CustomColors.orangeColor
                                    : CustomColors.redExitColor,
                            fontSize: 16.sp,
                          ),
                        ],
                      )),
                      horizontalSpacer(10),
                      Column(
                        children: [
                          Container(
                            height: 42.h,
                            width: 42.w,
                            decoration: BoxDecoration(
                              color:
                                  CustomColors.lightOrangeBgColor.withOpacity(
                                0.15,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                ConstantString.receivedIcon,
                                package: 'mca_official_flutter_sdk',
                              ),
                            ),
                          ),
                          verticalSpacer(7),
                          mediumText(
                            "Received",
                            fontSize: 14.sp,
                            color: CustomColors.blackColor,
                          )
                        ],
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // height: 185,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.backBorderColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border:
                              Border.all(color: Colors.transparent, width: 0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  regularText(
                                    "Paying to",
                                    fontSize: 12.sp,
                                    color: CustomColors.greyTextColor,
                                  ),
                                ],
                              ),
                              verticalSpacer(10.h),
                              semiBoldText(
                                  widget.paymentMethod == PaymentMethod.transfer
                                      ? widget.purchaseDetails.bank ?? ""
                                      : ref
                                              .watch(selectedBankProvider)
                                              ?.bankName ??
                                          "",
                                  fontSize: 15.sp,
                                  color: CustomColors.blackTextColor),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await Clipboard.setData(
                                        ClipboardData(
                                          text: widget.paymentMethod ==
                                                  PaymentMethod.transfer
                                              ? widget.purchaseDetails
                                                      .accountNumber ??
                                                  ""
                                              : widget.purchaseDetails
                                                      .paymentCode ??
                                                  "",
                                        ),
                                      );
                                      CustomToast.showToastMessage(
                                          context,
                                          widget.paymentMethod ==
                                                  PaymentMethod.transfer
                                              ? "Account number copied to clipboard"
                                              : "USSD code copied to clipboard",
                                          ToastStatus.success);
                                    },
                                    child: Row(
                                      children: [
                                        semiBoldText(
                                            widget.paymentMethod ==
                                                    PaymentMethod.transfer
                                                ? widget.purchaseDetails
                                                        .accountNumber ??
                                                    ""
                                                : widget.purchaseDetails
                                                        .paymentCode ??
                                                    "",
                                            fontSize: 16.sp,
                                            color: CustomColors
                                                .primaryBrandColor()),
                                        horizontalSpacer(5),
                                        const Icon(
                                          Icons.copy,
                                          size: 12,
                                          color: CustomColors.greyTextColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: paymentVM.isLoading
                                        ? null
                                        : () {
                                            paymentVM.verifyPayment(
                                              reference: widget.purchaseDetails
                                                      .reference ??
                                                  "",
                                              ref: ref,
                                              context: context,
                                              paymentMethod:
                                                  widget.paymentMethod,
                                              purchaseDetails:
                                                  widget.purchaseDetails,
                                              redirect: false,
                                            );
                                          },
                                    child: Row(
                                      children: [
                                        paymentVM.isLoading
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: SpinKitFadingCircle(
                                                    color: CustomColors
                                                        .primaryBrandColor(),
                                                    size: 20.0,
                                                  ),
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                ConstantString.reconfirmIcon,
                                                package:
                                                    'mca_official_flutter_sdk',
                                              ),
                                        horizontalSpacer(5),
                                        mediumText(
                                          "Re-Confirm",
                                          fontSize: 16.sp,
                                          color: CustomColors.formTitleColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpacer(5),
                              const Divider(
                                color: CustomColors.lightDividerColor,
                              ),
                              verticalSpacer(10),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    ConstantString.roundInfoOutlined,
                                    package: 'mca_official_flutter_sdk',
                                  ),
                                ],
                              ),
                              verticalSpacer(20),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "Please wait for us to confirm your payment. Don't close this SDK window while we check your transaction. If there's any delay, contact our support team at ",
                                      style: CustomTextStyles.regular(
                                        fontSize: 14.sp,
                                        color: CustomColors.lightBlackColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "support@mycover.ai. ",
                                      style: CustomTextStyles.semiBold(
                                        fontSize: 14.sp,
                                        color: CustomColors.primaryBrandColor(),
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
                  ),
                  const Expanded(child: SizedBox()),

                  verticalSpacer(8.sp),

                  const PoweredByFooter(),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
