import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/plan_details_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ConfirmAdditionalInfoScreen extends StatefulHookConsumerWidget {
  final ClaimModel claim;
  final List<AdditionalInfo> additionalInfo;

  const ConfirmAdditionalInfoScreen(
      {super.key, required this.claim, required this.additionalInfo});

  @override
  ConsumerState<ConfirmAdditionalInfoScreen> createState() =>
      _ConfirmAdditionalInfoScreenState();
}

class _ConfirmAdditionalInfoScreenState
    extends ConsumerState<ConfirmAdditionalInfoScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final List<AdditionalInfo> textBased = widget.additionalInfo
        .where((text) => text.type?.toLowerCase() == 'text')
        .toList();
    final List<AdditionalInfo> fileBased = widget.additionalInfo
        .where((text) => text.type?.toLowerCase() == 'file')
        .toList();

    final claimVM = ref.watch(claimVmProvider);
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,

      body: SafeArea(
          child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            verticalSpacer(20),
            CustomAppbar(
              // showHelp: true,
              showLogo: false,
              showBackButton: true,
              onBackTap: Navigator.canPop(context)
                  ? () => Navigator.pop(context)
                  : null,
              // logoUrl: ref.watch(businessDetailsProvider)?.logo,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // verticalSpacer(10),
                    semiBoldText(
                      "Confirm following",
                      fontSize: 20,
                    ),

                    if (textBased.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: PlanExpandableContainer(
                          title: "Additional information.( Text based)",
                          isExpanded: true,
                          expandedHeight: 210,
                          fontSize: 16,
                          titleColor: CustomColors.primaryBrandColor(),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // prevent nested scroll
                            crossAxisCount: 2,
                            // ✅ exactly two items per row
                            mainAxisSpacing: 16,
                            // vertical spacing
                            crossAxisSpacing: 20,
                            // horizontal spacing
                            childAspectRatio: 3,
                            // adjust to make them look balanced
                            children: textBased.asMap().entries.map((value) {
                              final keyValue = value.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularText(
                                    keyValue.label ?? '',
                                    fontSize: 14,
                                    color: CustomColors.greyTextColor,
                                  ),
                                  verticalSpacer(4),
                                  semiBoldText(
                                    "${keyValue.data}",
                                    fontSize: 14,
                                    color: CustomColors.blackTextColor,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    verticalSpacer(10),
                    if (fileBased.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: PlanExpandableContainer(
                          title: "Additional information.( File based)",
                          isExpanded: true,
                          fontSize: 16,
                          titleColor: CustomColors.primaryBrandColor(),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // prevent nested scroll
                            crossAxisCount: 2,
                            // ✅ exactly two items per row
                            mainAxisSpacing: 16,
                            // vertical spacing
                            crossAxisSpacing: 60.w,
                            // horizontal spacing
                            childAspectRatio: 3,
                            // adjust to make them look balanced

                            children: fileBased.asMap().entries.map((value) {
                              final keyValue = value.value;
                              return Column(
                                children: [
                                  regularText(
                                    keyValue.label ?? '',
                                    fontSize: 14,
                                    color: CustomColors.greyTextColor,
                                  ),
                                  verticalSpacer(4),
                                  Row(
                                    children: [
                                      SvgPicture.asset(ConstantString.receipt),
                                      semiBoldText(
                                        keyValue.description ?? '',
                                        fontSize: 14,
                                        color: CustomColors.blackTextColor,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const InstructionBuilder(),
                  verticalSpacer(40.h),
                  CustomButton(
                    title: "Continue",
                    onTap: () {
                      claimVM.submitAdditionalInfo(
                          ref: ref,
                          context: context,
                          additionalInfo: widget.additionalInfo);
                    },
                  ),
                  verticalSpacer(25),
                  const PoweredByFooter(),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class InstructionBuilder extends StatelessWidget {
  const InstructionBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.w),
      height: 54.h,
      width: 340.w,
      decoration: BoxDecoration(
          color: CustomColors.purple50Color,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(ConstantString.infoCircle),
          SizedBox(
            width: 300.w,
            child: regularText(
                'Please ensure you confirm the following claim details before submitting',
                fontSize: 12.sp,
                softWrap: true,
                color: CustomColors.blackTextColor),
          )
        ],
      ),
    );
  }
}
