import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/additioinal_information_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/offer_settlement_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/repair_estimate_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/upload_third_party_document_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_init_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class TrackClaimsScreen extends StatefulHookConsumerWidget {
  final ClaimModel claim;
  final ProductCategory? productCategory;

  const TrackClaimsScreen(
      {super.key, required this.claim, this.productCategory});

  @override
  ConsumerState<TrackClaimsScreen> createState() => _TrackClaimsScreenState();
}

class _TrackClaimsScreenState extends ConsumerState<TrackClaimsScreen> {
  // final formKey = GlobalKey<FormBuilderState>();
  // String? selectedIncidentType;
  // String? selectedDate;
  // String? selectedTime;
  // List<String>? selectedDamageType;
  // bool showFirstform = true;
  // //  String? selectedIncidentType;
  // // String? selectedDate;
  // // String? selectedTime;
  // // List<String>? selectedDamageType;
  // int value = 0;
  // String? incidentLocation;
  // String? thirdPhoneNumber;

  // String? whatHappened;

  @override
  Widget build(BuildContext context) {
    print(widget.productCategory);
    final statusTimeline = widget.claim.vehicleClaimMeta?["status_time_line"] ??
        widget.claim.gadgetClaimMeta?["status_time_line"] ??
        [];
    var item = widget.claim.vehicleClaimMeta;
    return PopScope(
      canPop: false,
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
          children: [
            verticalSpacer(20),
            CustomAppbar(
              // showHelp: true,
              showLogo: false,
              showBackButton: true,
              onBackTap: Navigator.canPop(context)
                  ? () {
                      Navigator.pop(context);
                    }
                  : null,
              // logoUrl: ref.watch(businessDetailsProvider)?.logo,
            ),
            semiBoldText(
              "Track claim",
              fontSize: 20,
            ),
            verticalSpacer(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                // height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: CustomColors.backBorderColor,
                ),
                child: Stack(
                  children: [
                    if (widget.productCategory == ProductCategory.auto)
                      AutoHeader(widget: widget)
                    else
                      GadgetHeader(widget: widget),
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
                          child: SvgPicture.asset(
                            widget.productCategory == ProductCategory.auto
                                ? ConstantString.carImage
                                : ConstantString.gadgetsIcon,
                            height: 60,
                            package: 'mca_official_flutter_sdk',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpacer(57.h),
            if (widget.claim.vehicleClaimMeta == null &&
                widget.claim.gadgetClaimMeta == null)
              const Expanded(child: SizedBox.shrink())
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: statusTimeline.length,
                      itemBuilder: (context, index) {
                        final step = statusTimeline[index];
                        return Column(
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: index != 0,
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, right: 5, left: 10),
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
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 22,
                                  color: CustomColors.primaryBrandColor(),
                                ),
                                horizontalSpacer(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    semiBoldText(
                                      step["name"],
                                      fontSize: 14.sp,
                                      color: CustomColors.primaryBrandColor(),
                                    ),
                                    verticalSpacer(5),
                                    regularText(
                                      step["time_stamp"],
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
              ),
            verticalSpacer(60.h),
            if (widget.claim.claimType == 'Gadget') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        widget.claim.claimStatus?.toLowerCase() ==
                                getClaimStatusDescription(ClaimStatus.declined)
                                    .toLowerCase()
                            ? semiBoldText("Claim Declined",
                                color: CustomColors.redColor)
                            : const SizedBox.shrink(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.claim.claimStatus?.toLowerCase() ==
                                        getClaimStatusDescription(ClaimStatus.pending)
                                            .toLowerCase()
                                    ? (widget.claim.policy?.product?.routeName ?? "")
                                            .toLowerCase()
                                            .contains('third-party')
                                        ? ConstantString.uploadDocument
                                        : ConstantString.conductInspectionClaim
                                    : widget.claim.claimStatus?.toLowerCase() ==
                                            getClaimStatusDescription(
                                                    ClaimStatus.approved)
                                                .toLowerCase()
                                        ? ConstantString.estimateClaimRepairs
                                        : widget.claim.claimStatus
                                                    ?.toLowerCase() ==
                                                getClaimStatusDescription(
                                                        ClaimStatus.offerSent)
                                                    .toLowerCase()
                                            ? ConstantString.respondToOffer
                                            : widget.claim.claimStatus
                                                        ?.toLowerCase() ==
                                                    getClaimStatusDescription(
                                                            ClaimStatus.declined)
                                                        .toLowerCase()
                                                ? ConstantString.inspectionDeclinedText
                                                : "Your claim is under review. Once your claim has been approved, you will be notified via email.",
                                style: CustomTextStyles.regular(
                                  fontSize: 13.sp,
                                  color: CustomColors.blackTextColor,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // item['incident_type'] == 'Theft' &&
                        //         widget.claim.claimStatus?.toLowerCase() ==
                        //             getClaimStatusDescription(
                        //                 ClaimStatus.pending)
                        //     ? SizedBox()
                        //     :
                        widget.claim.claimStatus?.toLowerCase() ==
                                    getClaimStatusDescription(
                                            ClaimStatus.pending)
                                        .toLowerCase() ||
                                widget.claim.claimStatus?.toLowerCase() ==
                                    getClaimStatusDescription(
                                            ClaimStatus.approved)
                                        .toLowerCase() ||
                                widget.claim.claimStatus?.toLowerCase() ==
                                    getClaimStatusDescription(
                                            ClaimStatus.offerSent)
                                        .toLowerCase() ||
                                widget.claim.claimStatus?.toLowerCase() ==
                                    getClaimStatusDescription(
                                            ClaimStatus.declined)
                                        .toLowerCase() ||
                                widget.claim.claimStatus?.toLowerCase() ==
                                    getClaimStatusDescription(
                                            ClaimStatus.requestedAdditionalInfo)
                                        .toLowerCase() ||
                                widget.claim.claimStatus ==
                                    'Requested additional information'
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Global.policyId = widget.claim.policyId ??
                                        Global.policyId;
                                    Global.claimId = widget.claim.id ?? "";
                                    Global.claim = widget.claim;
                                    if (widget.claim.claimStatus
                                            ?.toLowerCase() ==
                                        getClaimStatusDescription(
                                                ClaimStatus.approved)
                                            .toLowerCase()) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RepairEstimateScreen(
                                                    claim: widget.claim,
                                                  )));
                                    } else if (widget.claim.claimStatus
                                            ?.toLowerCase() ==
                                        'Requested additional information'
                                            .toLowerCase()) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdditionalInformationScreen(
                                                    claim: widget.claim,
                                                  )));
                                    } else if (widget.claim.claimStatus
                                            ?.toLowerCase() ==
                                        getClaimStatusDescription(
                                                ClaimStatus.offerSent)
                                            .toLowerCase()) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OfferSettlementScreen(
                                            claim: widget.claim,
                                          ),
                                        ),
                                      );
                                    } else if ((widget.claim.policy?.product
                                                ?.routeName ??
                                            "")
                                        .toLowerCase()
                                        .contains('third-party')) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UploadThirdPartyDocumentScreen(
                                                    claim: widget.claim,
                                                  )));
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InspectionInitScreen(
                                                    productCategory:
                                                        widget.productCategory,
                                                    claim: widget.claim,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: CustomColors.primaryBrandColor(),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        // vertical: 15,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.claim.claimStatus ==
                                                    'Requested additional information'
                                                ? 'Submit additional information'
                                                : widget.claim.claimStatus ==
                                                        getClaimStatusDescription(
                                                            ClaimStatus
                                                                .requestedAdditionalInfo)
                                                    ? 'Submit additional info'
                                                    : widget.claim
                                                                .claimStatus ==
                                                            getClaimStatusDescription(
                                                                ClaimStatus
                                                                    .approved)
                                                        ? "Estimate repair"
                                                        : widget.claim
                                                                    .claimStatus
                                                                    ?.toLowerCase() ==
                                                                getClaimStatusDescription(
                                                                        ClaimStatus
                                                                            .offerSent)
                                                                    .toLowerCase()
                                                            ? "Respond to offer"
                                                            : widget.claim
                                                                        .claimStatus
                                                                        ?.toLowerCase() ==
                                                                    getClaimStatusDescription(ClaimStatus.declined)
                                                                        .toLowerCase()
                                                                ? "Re-conduct inspection"
                                                                : (widget.claim.policy?.product?.routeName ??
                                                                            "")
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            'third-party')
                                                                    ? "Upload Document"
                                                                    : "Conduct Inspection",
                                            style: CustomTextStyles.regular(
                                              fontSize: 14,
                                              color: CustomColors.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                ),
              ),
            ] else
              item['incident_type'] == 'Theft' &&
                      widget.claim.claimStatus == 'Pending'
                  // widget.claim.claimStatus?.toLowerCase() ==
                  //     getClaimStatusDescription(ClaimStatus.pending)
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              widget.claim.claimStatus?.toLowerCase() ==
                                      getClaimStatusDescription(
                                              ClaimStatus.declined)
                                          .toLowerCase()
                                  ? semiBoldText("Claim Declined",
                                      color: CustomColors.redColor)
                                  : const SizedBox.shrink(),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.claim.claimStatus?.toLowerCase() ==
                                              getClaimStatusDescription(ClaimStatus.pending)
                                                  .toLowerCase()
                                          ? (widget.claim.policy?.product?.routeName ?? "")
                                                  .toLowerCase()
                                                  .contains('third-party')
                                              ? ConstantString.uploadDocument
                                              : ConstantString
                                                  .conductInspectionClaim
                                          : widget.claim.claimStatus
                                                      ?.toLowerCase() ==
                                                  getClaimStatusDescription(
                                                          ClaimStatus.approved)
                                                      .toLowerCase()
                                              ? ConstantString
                                                  .estimateClaimRepairs
                                              : widget.claim.claimStatus
                                                          ?.toLowerCase() ==
                                                      getClaimStatusDescription(ClaimStatus.offerSent)
                                                          .toLowerCase()
                                                  ? ConstantString
                                                      .respondToOffer
                                                  : widget.claim.claimStatus
                                                              ?.toLowerCase() ==
                                                          getClaimStatusDescription(ClaimStatus.declined)
                                                              .toLowerCase()
                                                      ? ConstantString
                                                          .inspectionDeclinedText
                                                      : "Your claim is under review. Once your claim has been approved, you will be notified via email.",
                                      style: CustomTextStyles.regular(
                                        fontSize: 13.sp,
                                        color: CustomColors.blackTextColor,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              item['incident_type'] == 'Theft' &&
                                      widget.claim.claimStatus?.toLowerCase() ==
                                          getClaimStatusDescription(
                                              ClaimStatus.pending)
                                  ? const SizedBox()
                                  : widget.claim.claimStatus?.toLowerCase() ==
                                              getClaimStatusDescription(
                                                      ClaimStatus.pending)
                                                  .toLowerCase() ||
                                          widget.claim.claimStatus?.toLowerCase() ==
                                              getClaimStatusDescription(
                                                      ClaimStatus.approved)
                                                  .toLowerCase() ||
                                          widget.claim.claimStatus
                                                  ?.toLowerCase() ==
                                              getClaimStatusDescription(
                                                      ClaimStatus.offerSent)
                                                  .toLowerCase() ||
                                          widget.claim.claimStatus
                                                  ?.toLowerCase() ==
                                              getClaimStatusDescription(
                                                      ClaimStatus.declined)
                                                  .toLowerCase() ||
                                          widget.claim.claimStatus ==
                                              'Requested additional information'
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Global.policyId =
                                                  widget.claim.policyId ??
                                                      Global.policyId;
                                              Global.claimId =
                                                  widget.claim.id ?? "";
                                              Global.claim = widget.claim;
                                              print(
                                                  'smmms ${widget.claim.claimStatus}');
                                              if (widget.claim.claimStatus
                                                      ?.toLowerCase() ==
                                                  getClaimStatusDescription(
                                                          ClaimStatus.approved)
                                                      .toLowerCase()) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RepairEstimateScreen(
                                                              claim:
                                                                  widget.claim,
                                                            )));
                                              }
                                              ///////
                                              else if (widget.claim.claimStatus
                                                      ?.toLowerCase() ==
                                                  'Requested additional information'
                                                      .toLowerCase()) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdditionalInformationScreen(
                                                              claim:
                                                                  widget.claim,
                                                            )));
                                              }
                                              ////
                                              else if (widget.claim.claimStatus
                                                      ?.toLowerCase() ==
                                                  getClaimStatusDescription(
                                                          ClaimStatus.offerSent)
                                                      .toLowerCase()) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OfferSettlementScreen(
                                                      claim: widget.claim,
                                                    ),
                                                  ),
                                                );
                                              } else if ((widget
                                                          .claim
                                                          .policy
                                                          ?.product
                                                          ?.routeName ??
                                                      "")
                                                  .toLowerCase()
                                                  .contains('third-party')) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UploadThirdPartyDocumentScreen(
                                                              claim:
                                                                  widget.claim,
                                                            )));
                                              } else {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            InspectionInitScreen(
                                                              productCategory:
                                                                  widget
                                                                      .productCategory,
                                                              claim:
                                                                  widget.claim,
                                                            )));
                                              }
                                            },
                                            child: Container(
                                              height: 38,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: CustomColors
                                                    .primaryBrandColor(),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  // vertical: 15,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.claim.claimStatus ==
                                                              'Requested additional information'
                                                          ? 'Submit additional information'
                                                          : widget.claim
                                                                      .claimStatus ==
                                                                  getClaimStatusDescription(
                                                                      ClaimStatus
                                                                          .approved)
                                                              ? "Estimate of repair"
                                                              : widget.claim
                                                                          .claimStatus
                                                                          ?.toLowerCase() ==
                                                                      getClaimStatusDescription(ClaimStatus
                                                                              .offerSent)
                                                                          .toLowerCase()
                                                                  ? "Respond to offer"
                                                                  : widget.claim
                                                                              .claimStatus
                                                                              ?.toLowerCase() ==
                                                                          getClaimStatusDescription(ClaimStatus.declined)
                                                                              .toLowerCase()
                                                                      ? "Re-conduct inspection"
                                                                      : (widget.claim.policy?.product?.routeName ?? "")
                                                                              .toLowerCase()
                                                                              .contains('third-party')
                                                                          ? "Upload Document"
                                                                          : "Conduct Inspection",
                                                      style: CustomTextStyles
                                                          .regular(
                                                        fontSize: 14,
                                                        color: CustomColors
                                                            .whiteColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    ),
            verticalSpacer(60.h),
            const PoweredByFooter(),
            verticalSpacer(5),
          ],
        )),
      ),
    );
  }
}

class AutoHeader extends StatelessWidget {
  const AutoHeader({super.key, required this.widget});

  final TrackClaimsScreen widget;

  @override
  Widget build(BuildContext context) {
    final make = widget.claim.policy?.meta["vehicle_make"] ?? "";
    final model = widget.claim.policy?.meta["vehicle_model"] ?? "";
    final year = widget.claim.policy?.meta["year_of_manufacture"] ?? "";

    final vehicleInfo =
        [make, model, year].where((e) => e.isNotEmpty).join(" ");
    return Padding(
      padding: const EdgeInsets.only(
        right: 100.0,
        left: 20,
        top: 10,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          regularText(
            "Vehicle name",
            fontSize: 13,
            color: CustomColors.greyTextColor,
          ),
          verticalSpacer(2),
          semiBoldText(
            vehicleInfo ?? "",
            fontSize: 14,
            color: CustomColors.primaryBrandColor(),
          ),
          verticalSpacer(10),
          regularText(
            "Plate number",
            fontSize: 13,
            color: CustomColors.greyTextColor,
          ),
          verticalSpacer(2),
          semiBoldText(
            widget.claim.policy?.meta["registration_number"] ?? "",
            fontSize: 14,
            color: CustomColors.primaryBrandColor(),
          ),
        ],
      ),
    );
  }
}

class GadgetHeader extends StatelessWidget {
  const GadgetHeader({
    super.key,
    required this.widget,
  });

  final TrackClaimsScreen widget;

  @override
  Widget build(BuildContext context) {
    final devideType = widget.claim.policy?.meta["device_type"];
    final imeiNumber = widget.claim.policy?.meta['payload']["imei"];
    final deviceModl = widget.claim.policy?.meta["device_model"];
    return Padding(
      padding: const EdgeInsets.only(
        right: 100.0,
        left: 20,
        top: 10,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          regularText(
            "Gadget name",
            fontSize: 13,
            color: CustomColors.greyTextColor,
          ),
          verticalSpacer(2),
          semiBoldText(
            '$devideType $deviceModl',
            fontSize: 14,
            color: CustomColors.primaryBrandColor(),
          ),
          verticalSpacer(10),
          regularText(
            "IMEI number",
            fontSize: 13,
            color: CustomColors.greyTextColor,
          ),
          verticalSpacer(2),
          semiBoldText(
            imeiNumber ?? "",
            fontSize: 14,
            color: CustomColors.primaryBrandColor(),
          ),
        ],
      ),
    );
  }
}

class PendingEstimateCard extends StatelessWidget {
  const PendingEstimateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF0), // light cream background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            "Pending Estimate of Repair",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          const Text.rich(
            TextSpan(
              text: "Kindly submit this within the next ",
              style: TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: "24 hours",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ", as any submissions beyond this timeframe will render the claim invalid.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Countdown Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TimeBox(value: "0", label: "Days"),
              _TimeBox(value: "23", label: "Hours"),
              _TimeBox(value: "50", label: "Minutes"),
              _TimeBox(value: "20", label: "Seconds"),
            ],
          ),
          const SizedBox(height: 20),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // handle submit action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF20A36C), // green button
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Submit Estimate of Repair",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

// // final damageTypeProvider = StateProvider<List<String>>((ref) => []);

// final incidentTypeProvider = StateProvider.autoDispose<String?>((ref) => null);
// final dateOfIncidentProvider =
//     StateProvider.autoDispose<String?>((ref) => null);
// final accidentTimeProvider = StateProvider.autoDispose<String?>((ref) => null);

// final damageTypeProvider = StateProvider<List<String>>((ref) => []);

// final thirdPartyDamageTypeProvider = StateProvider<List<String>>((ref) => []);
