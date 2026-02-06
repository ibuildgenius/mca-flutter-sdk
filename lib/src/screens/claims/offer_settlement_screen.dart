import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/generic_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/privacy_policy_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/accept_offer_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/form_validator.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class OfferSettlementScreen extends StatefulHookConsumerWidget {
  final ClaimModel claim;
  const OfferSettlementScreen({
    super.key,
    required this.claim,
  });

  @override
  ConsumerState<OfferSettlementScreen> createState() =>
      _OfferSettlementScreenState();
}

class _OfferSettlementScreenState extends ConsumerState<OfferSettlementScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  int? amount;
  File? selectedInvoice;
  bool _isChecked = false;
  String? comment;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final claimVM = ref.watch(claimVmProvider);
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            verticalSpacer(20),
            CustomAppbar(
              // showHelp: true,
              showLogo: false,
              showBackButton: false,
              onBackTap: Navigator.canPop(context)
                  ? () => Navigator.pop(context)
                  : null,
              // logoUrl: ref.watch(businessDetailsProvider)?.logo,
            ),
            semiBoldText(
              "Settlement of offer",
              fontSize: 20,
            ),
            verticalSpacer(20),
            Expanded(
              // height: MediaQuery.of(context).size.height - 250,
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  // height: 100,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: CustomColors.backBorderColor,
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 100.0,
                                          left: 10,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            verticalSpacer(10),
                                            // semiBoldText(
                                            //   "Settlement of offer",
                                            //   fontSize: 16,
                                            // ),
                                            // verticalSpacer(10),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "Following the submission of all claim sustaining documents in respects of your vehicle accidental damage claim. We are pleased to communicate our settlement offer as stated below",
                                                    style: CustomTextStyles
                                                        .regular(
                                                      fontSize: 14,
                                                      color: CustomColors
                                                          .formTitleColor,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            verticalSpacer(6),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            //HELP
                                            shape: BoxShape.circle,
                                            // color: CustomColors.lightBlackColor,
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              ConstantString.invoiceImg,
                                              height: 60,
                                              package:
                                                  'mca_official_flutter_sdk',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                verticalSpacer(30),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(5),
                                  child: Container(
                                    width: double.infinity,
                                    // height: 46,
                                    decoration: BoxDecoration(
                                      color: CustomColors.backBorderColor,
                                      border: Border.all(
                                          color: CustomColors.dividerGreyColor,
                                          width: 0.8),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            // SvgPicture.asset(
                                            //   selectedInvoice == null
                                            //       ? ConstantString
                                            //           .uploadInvoice
                                            //       : ConstantString
                                            //           .deleteInvoice,
                                            //   package:
                                            //       'mca_official_flutter_sdk',
                                            // ),
                                            // verticalSpacer(5),
                                            // selectedInvoice == null
                                            //     ? RichText(
                                            //         text: TextSpan(
                                            //           children: [
                                            //             TextSpan(
                                            //               text: "Click ",
                                            //               style:
                                            //                   CustomTextStyles
                                            //                       .w500(
                                            //                 fontSize: 15,
                                            //                 color: CustomColors
                                            //                     .primaryBrandColor(),
                                            //                 height: 1.4,
                                            //               ),
                                            //             ),
                                            //             TextSpan(
                                            //               text:
                                            //                   "to upload Repair Invoice",
                                            //               style:
                                            //                   CustomTextStyles
                                            //                       .regular(
                                            //                 fontSize: 14.5,
                                            //                 color: CustomColors
                                            //                     .blackTextColor,
                                            //                 height: 1.2,
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       )
                                            //     : regularText(
                                            //         selectedInvoice?.path ??
                                            //             "",
                                            //         fontSize: 14.5,
                                            //         textAlign:
                                            //             TextAlign.center,
                                            //         color: CustomColors
                                            //             .primaryBrandColor(),
                                            //       ),

                                            //// Degdg

                                            ///
                                            Column(
                                              children: [
                                                verticalSpacer(5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        regularText(
                                                          "Provider",
                                                          fontSize: 14,
                                                          color: CustomColors
                                                              .greyTextColor,
                                                        ),
                                                        verticalSpacer(4),
                                                        semiBoldText(
                                                          widget
                                                                  .claim
                                                                  .policy
                                                                  ?.provider
                                                                  ?.companyName ??
                                                              "",
                                                          fontSize: 14,
                                                          color: CustomColors
                                                              .blackTextColor,
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        regularText(
                                                          "Policy number",
                                                          fontSize: 13,
                                                          color: CustomColors
                                                              .greyTextColor,
                                                        ),
                                                        verticalSpacer(4),
                                                        semiBoldText(
                                                          widget.claim.policy
                                                                      ?.meta[
                                                                  "policy_number"] ??
                                                              "",
                                                          fontSize: 14,
                                                          color: CustomColors
                                                              .blackTextColor,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                verticalSpacer(20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        regularText(
                                                          "Betterment deduction",
                                                          fontSize: 14,
                                                          color: CustomColors
                                                              .greyTextColor,
                                                        ),
                                                        verticalSpacer(4),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                text: '₦',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "",
                                                                  package:
                                                                      'mca_official_flutter_sdk',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
                                                                  color: CustomColors
                                                                      .blackTextColor,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: StringUtils
                                                                    .formatPriceWithComma(
                                                                        widget.claim.bettermentDeductionAmount ??
                                                                            ""),
                                                                style:
                                                                    CustomTextStyles
                                                                        .semiBold(
                                                                  fontSize: 14,
                                                                  color: CustomColors
                                                                      .blackTextColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        regularText(
                                                          "Less 10% policy excess",
                                                          fontSize: 13,
                                                          color: CustomColors
                                                              .greyTextColor,
                                                        ),
                                                        verticalSpacer(4),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                text: '₦',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "",
                                                                  package:
                                                                      'mca_official_flutter_sdk',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
                                                                  color: CustomColors
                                                                      .blackTextColor,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: StringUtils
                                                                    .formatPriceWithComma(
                                                                        widget.claim.excessDeductionAmount ??
                                                                            ""),
                                                                style:
                                                                    CustomTextStyles
                                                                        .semiBold(
                                                                  fontSize: 14,
                                                                  color: CustomColors
                                                                      .blackTextColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            verticalSpacer(20),
                                            const Divider(
                                              color:
                                                  CustomColors.dividerGreyColor,
                                            ),

                                            verticalSpacer(10),

                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        mediumText(
                                                          "Net offer",
                                                          fontSize: 14,
                                                          color: CustomColors
                                                              .primaryBrandColor(),
                                                        ),
                                                        verticalSpacer(4),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                text: '₦',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "",
                                                                  package:
                                                                      'mca_official_flutter_sdk',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15,
                                                                  color: CustomColors
                                                                      .blackTextColor,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: StringUtils
                                                                    .formatPriceWithComma(
                                                                        widget.claim.offerAmount ??
                                                                            ""),
                                                                style:
                                                                    CustomTextStyles
                                                                        .semiBold(
                                                                  fontSize: 15,
                                                                  color: CustomColors
                                                                      .blackTextColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                verticalSpacer(10),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                verticalSpacer(40),
                              ],
                            ),
                          ),
                          // const Spacer(),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // hor(10.w),
                                SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: Checkbox(
                                    checkColor: CustomColors.whiteColor,
                                    activeColor:
                                        CustomColors.primaryBrandColor(),
                                    side: const BorderSide(
                                        color: CustomColors.checkBoxBorderColor,
                                        width: 2),
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                                horizontalSpacer(10),
                                SizedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'I have Read and  Understood  the ',
                                      style: CustomTextStyles.regular(
                                        fontSize: 14,
                                        color: CustomColors.blackTextColor,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: 'Terms of offer',
                                            style: CustomTextStyles.regular(
                                              fontSize: 14,
                                              color: CustomColors
                                                  .primaryBrandColor(),
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                showPrivacyPolicyBottomSheet(
                                                    context,
                                                    title: "Privacy Condition");
                                              })
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          verticalSpacer(30),

                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CustomButton(
                                  title: "Reject offer",
                                  buttonColor: CustomColors.dividerGreyColor,
                                  textColor: CustomColors.backTextColor,
                                  fontSize: 14,
                                  onTap: () {
                                    showGenericBottomSheet(context,
                                        // isLoading: claimVM.isLoading,
                                        // horizontalPadding: 5,
                                        isDismissible: true,
                                        okBbuttonColor:
                                            CustomColors.redExitColor,
                                        title: "Reject Offer",
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              verticalSpacer(15),
                                              regularText(
                                                "Please provide rejection reason",
                                                color: CustomColors.blackColor,
                                                fontSize: 15,
                                              ),
                                              verticalSpacer(15),
                                              customFormTextField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                'whatHappened',
                                                title: null,
                                                hintText:
                                                    "Type rejection reason",
                                                maxLines: 3,
                                                validator: CustomValidator
                                                    .howDidItHappen,
                                                onChanged: (value) {
                                                  setState(() {
                                                    comment = value;
                                                  });
                                                  
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        okText: "Reject Offer",
                                        onOkPressed: () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                       
                                        await claimVM.rejectClaimOffer(
                                            ref: ref,
                                            context: context,
                                            claim: widget.claim,
                                            comment: comment ?? "");
                                      }
                                    });

                                    // StringUtils.isNullOrEmpty(comment)
                                    //     ? null
                                    //     : () async {
                                    //         log('hhhh');
                                    //         // await claimVM.rejectClaimOffer(
                                    //         //     ref: ref,
                                    //         //     context: context,
                                    //         //     claim: widget.claim,
                                    //         //     comment: comment ?? "");
                                    //       });

                                    // showGenericBottomSheet(context,
                                    //     title: "Do this later",
                                    //     showBackButton: false,
                                    //     okText: "Ok, continue",
                                    //     onOkPressed: () {
                                    //   Navigator.of(context)
                                    //       .popUntil((route) => route.isFirst);
                                    // }, child: const RepairEstimateWidget());
                                  },
                                ),
                              ),
                              horizontalSpacer(10),
                              Expanded(
                                child: CustomButton(
                                  title: "Accept offer",
                                  fontSize: 14,
                                  onTap: !_isChecked
                                      ? null
                                      : () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AcceptOfferScreen(
                                                        claim: widget.claim,
                                                        banks: ref.watch(
                                                            bankListProvider),
                                                      )));
                                        },
                                  // fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          verticalSpacer(20),
                          const PoweredByFooter(),
                          verticalSpacer(
                              MediaQuery.of(context).padding.bottom + 10)
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      )),
    );
  }
}
