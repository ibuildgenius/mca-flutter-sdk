import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_first_form_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/gadget/gadget_claim_first_form_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/third_party_claim_form_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/plan_details_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/date_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/thousands_seperator.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

import '../initialization/initialization_view_model.dart';

class ConfirmPolicyInfoScreen extends StatefulHookConsumerWidget {
  final PolicyModel policy;
  final ProductDetailsModel productDetails;

  const ConfirmPolicyInfoScreen({
    super.key,
    required this.policy,
    required this.productDetails,
  });

  @override
  ConsumerState<ConfirmPolicyInfoScreen> createState() =>
      _ConfirmPolicyInfoScreenState();
}

class _ConfirmPolicyInfoScreenState
    extends ConsumerState<ConfirmPolicyInfoScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  int? getCoverPeriodInMonths(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return null;
    if (endDate.isBefore(startDate)) return 0;

    int yearDiff = endDate.year - startDate.year;
    int monthDiff = endDate.month - startDate.month;
    int totalMonths = (yearDiff * 12) + monthDiff;

    // Adjust if end day is earlier than start day
    if (endDate.day < startDate.day) {
      totalMonths -= 1;
    }

    return totalMonths;
  }

  @override
  Widget build(BuildContext context) {
    final coverPeriod = getCoverPeriodInMonths(
      widget.policy.startDate,
      widget.policy.expirationDate,
    );
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // verticalSpacer(10),
                    semiBoldText(
                      "Confirm policy info",
                      fontSize: 20,
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: PlanExpandableContainer(
                                title: "Policy Holder info.",
                                isExpanded: true,
                                expandedHeight: 210,
                                fontSize: 16,
                                titleColor: CustomColors.primaryBrandColor(),
                                child: Column(
                                  children: [
                                    verticalSpacer(5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            regularText(
                                              "Name",
                                              fontSize: 14,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              // widget.purchaseDetails.payload?.data
                                              //         ?.email ??
                                              "${widget.policy.firstName ?? ""} ${widget.policy.lastName ?? ""}",
                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            regularText(
                                              "Email",
                                              fontSize: 13,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              // widget.purchaseDetails.payload?.data
                                              //         ?.phone ??
                                              //     widget.purchaseDetails.payload?.data
                                              //         ?.phoneNumber ??
                                              widget.policy.email ?? "",
                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    verticalSpacer(20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            regularText(
                                              "Phone number",
                                              fontSize: 14,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              // widget.purchaseDetails.payload?.data
                                              //         ?.lastName ??
                                              widget.policy.phone ?? "",
                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            regularText(
                                              "Date of birth",
                                              fontSize: 13,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              // widget.policy.dob ?? "",
                                              CustomDateUtils.convertStringDate(
                                                  widget.policy.dob ??
                                                      "2024-25-07"),
                                              // DateFormat('d\'th\' MMMM yyyy')
                                              //     .format(
                                              //   DateTime.parse(
                                              //       widget.policy.dob ??
                                              //           "2024-25-07"),
                                              // ),
                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: PlanExpandableContainer(
                                title: "Transaction details",
                                fontSize: 16,
                                titleColor: CustomColors.primaryBrandColor(),
                                child: Column(
                                  children: [
                                    verticalSpacer(5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            regularText(
                                              "Plan",
                                              fontSize: 14,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              // widget.purchaseDetails.payload?.data
                                              //         ?.email ??
                                              widget.policy.product?.name ?? "",
                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            regularText(
                                              "Policy number",
                                              fontSize: 13,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              // widget.purchaseDetails.payload?.data
                                              //         ?.phone ??
                                              //     widget.purchaseDetails.payload?.data
                                              //         ?.phoneNumber ??
                                              widget.policy
                                                      .meta["policy_number"] ??
                                                  "",
                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    verticalSpacer(20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            regularText(
                                              "Purchase date",
                                              fontSize: 14,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              // widget.purchaseDetails.payload?.data
                                              //         ?.lastName ??

                                              // DateFormat('d\'th\' MMMM yyyy')
                                              //     .format(
                                              //         widget.policy.startDate ??
                                              //             DateTime.now()),
                                              CustomDateUtils.convertDate(
                                                  widget.policy.startDate ??
                                                      DateTime.now()),

                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            regularText(
                                              "Expiry date",
                                              fontSize: 13,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              CustomDateUtils.convertDate(widget
                                                      .policy.expirationDate ??
                                                  DateTime.now()),
                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    verticalSpacer(20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            regularText(
                                              "Period of Cover",
                                              fontSize: 14,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            semiBoldText(
                                              coverPeriod == null
                                                  ? "N/A"
                                                  : '$coverPeriod Month${coverPeriod == 1 ? "" : "s"}',
                                              fontSize: 14,
                                              color:
                                                  CustomColors.blackTextColor,
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            regularText(
                                              "Premium",
                                              fontSize: 13,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(4),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: '₦',
                                                    style: TextStyle(
                                                      fontFamily: "",
                                                      package:
                                                          'mca_official_flutter_sdk',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color: CustomColors
                                                          .blackTextColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: StringUtils
                                                        .formatPriceWithComma(
                                                      widget.policy.geniusPrice
                                                          .toString(),
                                                    ),
                                                    style: CustomTextStyles
                                                        .semiBold(
                                                      fontSize: 14,
                                                      color: CustomColors
                                                          .blackTextColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                            // semiBoldText(
                                            //   // widget.purchaseDetails.payload?.data
                                            //   //         ?.firstName ??
                                            //   widget.policy.marketPrice
                                            //           .toString() ??
                                            //       "",
                                            //       ..
                                            //   fontSize: 14,
                                            //   color:
                                            //       CustomColors.blackTextColor,
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (widget.policy.meta["vehicle_make"] != null)
                              VehicleDetail(widget: widget),
                            if (widget.policy.meta['device_make'] != null)
                              DeviceDetail(widget: widget),
                            ClaimsDetail(
                              widget: widget,
                            )
                          ],
                        ),
                      ),
                    ),
                    verticalSpacer(10),
                    CustomButton(
                      title: "Continue",
                      onTap: () {
                        if (((widget.productDetails.productCategory?.name
                                ?.toLowerCase()) ==
                            'gadget')) {
                          Global.gadgetType = getGadgetType(widget
                              .policy.meta['payload']['device_type']
                              .toString()
                              .toLowerCase());

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GadgetClaimFirstFormScreen(
                                  policy: widget.policy,
                                ),
                              ));
                        } else if ((widget.policy.product?.routeName ?? "")
                            .toLowerCase()
                            .contains('comprehensive')) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClaimFirstFormScreen(
                                  policy: widget.policy,
                                ),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThirdPartyClaimFormScreen(
                                  policy: widget.policy,
                                ),
                              ));
                        }
                      },
                    ),
                    verticalSpacer(25),
                    const PoweredByFooter()
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class VehicleDetail extends StatelessWidget {
  const VehicleDetail({
    super.key,
    required this.widget,
  });

  final ConfirmPolicyInfoScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: PlanExpandableContainer(
        title: "Vehicle details",
        // expandedHeight: 210,
        fontSize: 16,
        titleColor: CustomColors.primaryBrandColor(),
        child: Column(
          children: [
            verticalSpacer(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    regularText(
                      "Vehicle name",
                      fontSize: 14,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    semiBoldText(
                      '${widget.policy.meta["vehicle_make"] ?? ""} '
                              '${widget.policy.meta["vehicle_model"] ?? ""} '
                              '${widget.policy.meta["year_of_manufacture"] ?? ""}'
                          .trim(),
                      fontSize: 14,
                      color: CustomColors.blackTextColor,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    regularText(
                      "Policy number",
                      fontSize: 13,
                      color: CustomColors.greyTextColor,
                    ),
                    //    verticalSpacer(4),
                    SizedBox(
                      width: 100.w,
                      child: semiBoldText(
                        overflow: TextOverflow.ellipsis,
                        // widget.purchaseDetails.payload?.data
                        //         ?.phone ??
                        //     widget.purchaseDetails.payload?.data
                        //         ?.phoneNumber ??
                        widget.policy.meta["policy_number"] ?? "",
                        fontSize: 14,
                        color: CustomColors.blackTextColor,
                      ),
                    )
                  ],
                ),
              ],
            ),
            verticalSpacer(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    regularText(
                      "Plate number",
                      fontSize: 14,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    semiBoldText(
                      // widget.purchaseDetails.payload?.data
                      //         ?.lastName ??
                      widget.policy.meta["registration_number"] ?? "",
                      fontSize: 14,
                      color: CustomColors.blackTextColor,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    regularText(
                      "Chassis number",
                      fontSize: 13,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    semiBoldText(
                      // widget.purchaseDetails.payload?.data
                      //         ?.firstName ??
                      widget.policy.meta["chassis_number"] ?? "",
                      fontSize: 14,
                      color: CustomColors.blackTextColor,
                    ),
                  ],
                ),
              ],
            ),
            verticalSpacer(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    regularText(
                      "Engine number",
                      fontSize: 14,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    semiBoldText(
                      // widget.purchaseDetails.payload?.data
                      //         ?.lastName ??
                      widget.policy.meta["engine_number"] ?? "",
                      fontSize: 14,
                      color: CustomColors.blackTextColor,
                    )
                  ],
                ),
                const Spacer()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceDetail extends ConsumerWidget {
  const DeviceDetail({super.key, required this.widget});

  final ConfirmPolicyInfoScreen widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: PlanExpandableContainer(
        title: "Gadget details",
        // expandedHeight: 210,
        fontSize: 16,
        titleColor: CustomColors.primaryBrandColor(),
        child: Column(
          children: [
            verticalSpacer(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    regularText(
                      "Gadget type",
                      fontSize: 14,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    semiBoldText(
                      '${widget.policy.meta["device_type"] ?? ""}'.trim(),
                      fontSize: 14,
                      color: CustomColors.blackTextColor,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    regularText(
                      "Gadget brand",
                      fontSize: 13,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    semiBoldText(
                      widget.policy.meta["device_make"] ?? "",
                      fontSize: 14,
                      color: CustomColors.blackTextColor,
                    )
                  ],
                ),
              ],
            ),
            verticalSpacer(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    regularText(
                      "Gadget model",
                      fontSize: 14,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    semiBoldText(
                      // widget.purchaseDetails.payload?.data
                      //         ?.lastName ??
                      widget.policy.meta["device_model"] ?? "",
                      fontSize: 14,
                      color: CustomColors.blackTextColor,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.policy.meta["gadget_type"] != null) ...[
                      regularText(
                        "IMEI number",
                        fontSize: 13,
                        color: CustomColors.greyTextColor,
                      ),
                      verticalSpacer(4),
                      semiBoldText(
                        widget.policy.meta['payload']["imei_number"],
                        fontSize: 14,
                        color: CustomColors.blackTextColor,
                      ),
                    ],
                    if (widget.policy.meta['device_type'] != null) ...[
                      regularText(
                        'Serial number',
                        fontSize: 13,
                        color: CustomColors.greyTextColor,
                      ),
                      verticalSpacer(4),
                      semiBoldText(
                        widget.policy.meta["device_serial_number"] ?? "",
                        fontSize: 14,
                        color: CustomColors.blackTextColor,
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClaimsDetail extends ConsumerWidget {
  const ClaimsDetail({super.key, required this.widget});

  final ConfirmPolicyInfoScreen widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalClaimable = ref.watch(totalClaimableAmountProvider);
    final totalClaimed = ref.watch(totalClaimedProvider);
    final availableAmount = ref.watch(totalAvailableClaimAmountProvider);
    final numberOfTimeClaimed = ref.watch(noOfTimeClaimedProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: PlanExpandableContainer(
        title: "Claims details",
        // expandedHeight: 210,
        fontSize: 16,
        titleColor: CustomColors.primaryBrandColor(),
        child: Column(
          children: [
            verticalSpacer(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    regularText(
                      "Total claimable amount",
                      fontSize: 14,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '₦',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            color: CustomColors.toastGreenColor,
                          ),
                        ),
                        semiBoldText(
                          "${availableAmount.withCommas}",
                          fontSize: 12.sp,
                          color: CustomColors.toastGreenColor,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    regularText(
                      "Total claimed",
                      fontSize: 13,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    Row(
                      children: [
                        Text(
                          '₦',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            color: CustomColors.blackTextColor,
                          ),
                        ),
                        semiBoldText(
                          '$totalClaimed',
                          fontSize: 14,
                          color: CustomColors.blackTextColor,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            verticalSpacer(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    regularText(
                      "Total Available claim amount",
                      fontSize: 14,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    Row(
                      children: [
                        Text(
                          '₦',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            color: CustomColors.orangeColor,
                          ),
                        ),
                        semiBoldText(
                          "${availableAmount.withCommas}",
                          fontSize: 14,
                          color: CustomColors.orangeColor,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    regularText(
                      "No. of time claimed",
                      fontSize: 13,
                      color: CustomColors.greyTextColor,
                    ),
                    verticalSpacer(4),
                    semiBoldText(
                      '${numberOfTimeClaimed} times',
                      fontSize: 12,
                      color: CustomColors.purple500Color,
                    ),
                  ],
                ),
              ],
            ),
            verticalSpacer(20),
          ],
        ),
      ),
    );
  }
}
