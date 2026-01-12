import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_init_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ClaimSubmittedScreen extends StatefulHookConsumerWidget {
  final ClaimModel claim;
  final ClaimModel? detailedClaim;
  final ProductCategory? productCategory;

  final ClaimSubmissionStep submissionStep;

  const ClaimSubmittedScreen({
    super.key,
    required this.claim,
    this.productCategory,
    this.detailedClaim,
    this.submissionStep = ClaimSubmissionStep.claimLodged,
  });

  @override
  ConsumerState<ClaimSubmittedScreen> createState() => _ClaimSubmittedScreen();
}

class _ClaimSubmittedScreen extends ConsumerState<ClaimSubmittedScreen> {
  PaymentMethod selectedOption = PaymentMethod.transfer;

  @override
  Widget build(BuildContext context) {
    final claimVm = ref.watch(claimVmProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        // appBar: AppBar(
        //   leading: GestureDetector( onTap: (){
        //     Navigator.pop(context);
        //   },
        //     child: Icon(Icons.arrow_back)),
        // ),
        // backgroundColor: CustomColors.whiteColor,
        body: SafeArea(
            child: Column(
          children: [
            verticalSpacer(20.h),
            CustomAppbar(
              showBackButton: false,
              showLogo: false,
              onBackTap: Navigator.canPop(context)
                  ? () => Navigator.pop(context)
                  : null,
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
                    widget.submissionStep == ClaimSubmissionStep.repairEstimate
                        ? verticalSpacer(20.h)
                        : verticalSpacer(40.h),

                    widget.submissionStep == ClaimSubmissionStep.offerRejected
                        ? Center(
                            child: SvgPicture.asset(
                              ConstantString.rejectOfferIcon,
                              package: 'mca_official_flutter_sdk',
                            ),
                          )
                        : Expanded(
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
                    widget.submissionStep == ClaimSubmissionStep.offerRejected
                        ? const Spacer()
                        : const SizedBox.shrink(),
                    widget.submissionStep == ClaimSubmissionStep.offerRejected
                        ? Column(
                            children: [
                              Center(
                                child: semiBoldText(
                                  "Claim Rejected",
                                  fontSize: 16.sp,
                                  color: CustomColors.blackColor,
                                ),
                              ),
                              verticalSpacer(20.h),
                              Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: CustomTextStyles.regular(
                                      fontSize: 15,
                                      color: CustomColors.greyTextColor,
                                      // textAlign: TextAlign.center,
                                      height: 1.5,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: "You rejected offer of ",
                                      ),
                                      const TextSpan(
                                        text: '₦',
                                        style: TextStyle(
                                          fontFamily: "",
                                          package: 'mca_official_flutter_sdk',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: CustomColors.greyTextColor,
                                        ),
                                      ),
                                      widget.claim.claimType == 'Gadget'
                                          ? TextSpan(
                                              text:
                                                  "${(StringUtils.formatPriceWithComma(widget.claim.claimAmount ?? ""))} for your gadget claim",
                                            )
                                          : TextSpan(
                                              text:
                                                  "${(StringUtils.formatPriceWithComma(widget.claim.claimAmount ?? ""))} for your Auto Claim on  ${((widget.detailedClaim?.policy?.meta["vehicle_model"]) + " " + (widget.detailedClaim?.policy?.meta["vehicle_model"] ?? "") + " " + (widget.detailedClaim?.policy?.meta["year_of_manufacture"] ?? ""))}",
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : widget.submissionStep ==
                                    ClaimSubmissionStep.repairEstimate ||
                                widget.submissionStep ==
                                    ClaimSubmissionStep.theft
                            ? Column(
                                children: [
                                  Center(
                                    child: semiBoldText(
                                      "Submission Successfully",
                                      fontSize: 16.sp,
                                      color: CustomColors.primaryBrandColor(),
                                    ),
                                  ),
                                  verticalSpacer(20.h),
                                  Center(
                                    child: regularText(
                                      "Great ! Your claim details have been received and an email has been sent to your inbox. For easy claim tracking click the button below to track your claim.",
                                      fontSize: 14,
                                      color: CustomColors.greyTextColor,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                            : widget.submissionStep ==
                                        ClaimSubmissionStep
                                            .thirdPartyClaimLodged ||
                                    widget.submissionStep ==
                                        ClaimSubmissionStep.thirdPartyInspected
                                ? Column(
                                    children: [
                                      Center(
                                        child: semiBoldText(
                                          "Your claim has been submitted!",
                                          fontSize: 16.sp,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ),
                                      verticalSpacer(20.h),
                                      Center(
                                        child: regularText(
                                          "Great news! Your claim has been successfully lodged. Click on the upload document button to proceed with your claim.",
                                          fontSize: 14,
                                          color: CustomColors.greyTextColor,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )
                                : widget.submissionStep ==
                                        ClaimSubmissionStep.offerAccepted
                                    ? Column(
                                        children: [
                                          Center(
                                            child: semiBoldText(
                                              "Congratulations, offer accepted",
                                              fontSize: 18,
                                              color: CustomColors
                                                  .primaryBrandColor(),
                                            ),
                                          ),
                                          verticalSpacer(20.h),
                                          Center(
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: CustomTextStyles.regular(
                                                  fontSize: 15,
                                                  color: CustomColors
                                                      .greyTextColor,
                                                  // textAlign: TextAlign.center,
                                                  height: 1.5,
                                                ),
                                                children: [
                                                  const TextSpan(
                                                    text:
                                                        "Great! You have accepted the offer. ",
                                                  ),
                                                  const TextSpan(
                                                    text: '₦',
                                                    style: TextStyle(
                                                      fontFamily: "",
                                                      package:
                                                          'mca_official_flutter_sdk',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      color: CustomColors
                                                          .greyTextColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${(StringUtils.formatPriceWithComma(widget.claim.offerAmount ?? ""))} will be transferred to the provided account, and an email has been dispatched to your inbox. To conveniently track your claim, simply click the button below",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),

                    verticalSpacer(30),
                    widget.submissionStep ==
                                ClaimSubmissionStep.offerAccepted ||
                            widget.submissionStep ==
                                ClaimSubmissionStep.offerRejected ||
                            widget.submissionStep ==
                                ClaimSubmissionStep.thirdPartyInspected ||
                            widget.submissionStep == ClaimSubmissionStep.theft
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 22,
                                      color: CustomColors.primaryBrandColor(),
                                    ),
                                    horizontalSpacer(10),
                                    regularText(
                                      "Claim Lodged",
                                      fontSize: 13.5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, right: 5, left: 10),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Dash(
                                        direction: Axis.vertical,
                                        length: 40,
                                        dashLength: 4,
                                        dashThickness: 2,
                                        dashGap: 2,
                                        dashColor:
                                            CustomColors.primaryBrandColor()
                                                .withOpacity(0.6),
                                      );
                                    }),
                                  ),
                                ),
                                Row(
                                  children: [
                                    widget.submissionStep ==
                                                ClaimSubmissionStep
                                                    .repairEstimate ||
                                            widget.submissionStep ==
                                                ClaimSubmissionStep
                                                    .thirdPartyClaimLodged
                                        ? Icon(
                                            Icons.check_circle,
                                            size: 22,
                                            color: CustomColors
                                                .primaryBrandColor(),
                                          )
                                        : Container(
                                            width: 23,
                                            height: 23,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              // Adjusted border radius for the smaller container
                                              color:
                                                  CustomColors.dividerGreyColor,
                                            ),
                                            child: Center(
                                              child: semiBoldText(
                                                "2",
                                              ),
                                            ),
                                          ),
                                    horizontalSpacer(10),
                                    regularText(
                                      widget.submissionStep ==
                                              ClaimSubmissionStep
                                                  .thirdPartyClaimLodged
                                          ? "Third party information"
                                          : "Post - loss inspection",
                                      fontSize: 13.5,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, right: 5, left: 10),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Dash(
                                        direction: Axis.vertical,
                                        length: 40,
                                        dashLength: 4,
                                        dashThickness: 2,
                                        dashGap: 2,
                                        dashColor:
                                            CustomColors.primaryBrandColor()
                                                .withOpacity(0.6),
                                      );
                                    }),
                                  ),
                                ),
                                Row(
                                  children: [
                                    widget.submissionStep ==
                                            ClaimSubmissionStep.repairEstimate
                                        ? Icon(
                                            Icons.check_circle,
                                            size: 22,
                                            color: CustomColors
                                                .primaryBrandColor(),
                                          )
                                        : Container(
                                            width: 23,
                                            height: 23,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              // Adjusted border radius for the smaller container
                                              color:
                                                  CustomColors.dividerGreyColor,
                                            ),
                                            child: Center(
                                              child: semiBoldText(
                                                "3",
                                              ),
                                            ),
                                          ),
                                    horizontalSpacer(10),
                                    regularText(
                                      widget.submissionStep ==
                                              ClaimSubmissionStep
                                                  .thirdPartyClaimLodged
                                          ? "Upload claim documents"
                                          : "Estimate of repair",
                                      fontSize: 13.5,
                                    )
                                  ],
                                ),
                                widget.submissionStep ==
                                        ClaimSubmissionStep.repairEstimate
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 5,
                                                  left: 10),
                                              child: LayoutBuilder(builder:
                                                  (context, constraints) {
                                                return Dash(
                                                  direction: Axis.vertical,
                                                  length: 40,
                                                  dashLength: 4,
                                                  dashThickness: 2,
                                                  dashGap: 2,
                                                  dashColor: CustomColors
                                                          .primaryBrandColor()
                                                      .withOpacity(0.6),
                                                );
                                              }),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 23,
                                                height: 23,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  // Adjusted border radius for the smaller container
                                                  color: CustomColors
                                                      .dividerGreyColor,
                                                ),
                                                child: Center(
                                                  child: semiBoldText(
                                                    "4",
                                                  ),
                                                ),
                                              ),
                                              horizontalSpacer(10),
                                              regularText(
                                                "Review Claim",
                                                fontSize: 13.5,
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink()
                              ]),
                    // verticalSpacer(2),

                    widget.submissionStep ==
                            ClaimSubmissionStep.thirdPartyInspected
                        ? Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "Your claim is under review. Once your claim has been approved, you will be notified via email.",
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
                          )
                        : const SizedBox.shrink(),

                    const Expanded(flex: 2, child: SizedBox()),
                    Row(
                      children: [
                        widget.submissionStep ==
                                    ClaimSubmissionStep.repairEstimate ||
                                widget.submissionStep ==
                                    ClaimSubmissionStep.offerAccepted ||
                                widget.submissionStep ==
                                    ClaimSubmissionStep.offerRejected ||
                                widget.submissionStep ==
                                    ClaimSubmissionStep.thirdPartyInspected ||
                                widget.submissionStep ==
                                    ClaimSubmissionStep.theft
                            ? const SizedBox.shrink()
                            : Expanded(
                                child: CustomButton(
                                  title: "Do this later",
                                  buttonColor: CustomColors.dividerGreyColor,
                                  textColor: CustomColors.backTextColor,
                                  fontSize: 13.sp,
                                  onTap: () {
                                    MyCoverAI.exitSDK(context);
                                  },
                                ),
                              ),
                        horizontalSpacer(10.w),
                        Expanded(
                          child: CustomButton(
                              title: widget.submissionStep ==
                                          ClaimSubmissionStep.repairEstimate ||
                                      widget.submissionStep ==
                                          ClaimSubmissionStep.offerAccepted ||
                                      widget.submissionStep ==
                                          ClaimSubmissionStep.offerRejected ||
                                      widget.submissionStep ==
                                          ClaimSubmissionStep
                                              .thirdPartyInspected ||
                                      widget.submissionStep ==
                                          ClaimSubmissionStep.theft
                                  ? "Track Claim"
                                  : widget.submissionStep ==
                                          ClaimSubmissionStep
                                              .thirdPartyClaimLodged
                                      ? "Upload Document"
                                      : "Conduct Inspection",
                              fontSize: 13.sp,
                              isLoading: claimVm.isLoading,
                              onTap:
                                  //  selectedOption == PaymentMethod.transfer
                                  //     ?
                                  () async {
                                // paymentVM.verifyPayment(
                                //     reference: widget.purchaseDetails.reference ?? "",
                                //     ref: ref,
                                //     context: context);

                                // ProviderUtils.resetAllProviders(ref);
                                // ProviderUtils.resetVerificationProviders(ref);
                                Global.policyId =
                                    widget.claim.policyId ?? Global.policyId;
                                Global.claimId = widget.claim.id ?? "";
                                Global.claim = widget.claim;
                                if (widget.submissionStep ==
                                        ClaimSubmissionStep.repairEstimate ||
                                    widget.submissionStep ==
                                        ClaimSubmissionStep.offerAccepted ||
                                    widget.submissionStep ==
                                        ClaimSubmissionStep.offerRejected ||
                                    widget.submissionStep ==
                                        ClaimSubmissionStep.theft ||
                                    widget.submissionStep ==
                                        ClaimSubmissionStep
                                            .thirdPartyInspected) {
                                  await claimVm.navigateToTrackClaimInfo(
                                      ref: ref,
                                      context: context,
                                      email: widget.claim.claimOwnerEmail ?? '',
                                      claimId: widget.claim.id ?? "");
                                  // await claimVm.navigateToTrackClaims(
                                  //     ref: ref,
                                  //     context: context,
                                  //     policyId: widget.claim.policyId ?? "");
                                } else if (widget.submissionStep ==
                                    ClaimSubmissionStep.thirdPartyClaimLodged) {
                                  await claimVm.navigateToUploadDocument(
                                      ref: ref,
                                      context: context,
                                      email: widget.claim.claimOwnerEmail ?? '',
                                      claimId: widget.claim.id ?? "");
                                  // await claimVm.navigateToUploadDocument(
                                  //     ref: ref,
                                  //     context: context,

                                  //     policyId: widget.claim.policyId ?? "");
                                } else {
                                
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InspectionInitScreen(
                                                claim: widget.claim,
                                                productCategory:
                                                    widget.productCategory,
                                              )));
                                }
                              }
                              // : null,
                              ),
                        ),
                      ],
                    ),

                    verticalSpacer(20.h),
                    widget.submissionStep ==
                                ClaimSubmissionStep.offerRejected ||
                            widget.submissionStep ==
                                ClaimSubmissionStep.thirdPartyInspected
                        ? const Spacer()
                        : const SizedBox.shrink(),
                    const PoweredByFooter(),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
