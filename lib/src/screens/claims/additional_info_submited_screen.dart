import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class AdditionalInfoSubmittedScreen extends StatefulHookConsumerWidget {
  final ClaimModel claim;

  const AdditionalInfoSubmittedScreen({
    super.key,
    required this.claim,
  });

  @override
  ConsumerState<AdditionalInfoSubmittedScreen> createState() =>
      _AdditionalInfoSubmittedScreen();
}

class _AdditionalInfoSubmittedScreen
    extends ConsumerState<AdditionalInfoSubmittedScreen> {
  PaymentMethod selectedOption = PaymentMethod.transfer;

  @override
  Widget build(BuildContext context) {
    final claimVm = ref.watch(claimVmProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
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

                    Column(
                      children: [
                        Center(
                          child: semiBoldText(
                            "Additional details successfully sent",
                            fontSize: 16.sp,
                            color: CustomColors.primaryBrandColor(),
                          ),
                        ),
                        verticalSpacer(20.h),
                        Center(
                          child: regularText(
                            "Your additional information has been successfully submitted.",
                            fontSize: 14,
                            color: CustomColors.greyTextColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    const Expanded(flex: 2, child: SizedBox()),
                    CustomButton(
                        title: "Track Claim",
                        fontSize: 13.sp,
                        isLoading: claimVm.isLoading,
                        onTap: () async {
                          Global.policyId =
                              widget.claim.policyId ?? Global.policyId;
                          Global.claimId = widget.claim.id ?? "";
                          Global.claim = widget.claim;
                          //  Global.email = widget.claim;
                          await claimVm.navigateToTrackClaimInfo(
                              ref: ref,
                              context: context,
                              email: widget.claim.claimOwnerEmail ?? '',
                              claimId: widget.claim.id ?? "");
                          // await claimVm.navigateToTrackClaims(
                          //     ref: ref,
                          //     context: context,
                          //     // claimId: widget.claim.id ?? '',
                          //     // email: ,
                          //     policyId: widget.claim.policyId ?? "");
                        }),

                    verticalSpacer(20.h),

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
