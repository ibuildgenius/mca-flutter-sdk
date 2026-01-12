// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/models/damaged_area_parts.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/caim_damaged_part.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/plan_details_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/date_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ClaimSummaryScreen extends StatefulHookConsumerWidget {
  final String incidentType;
  final String incidentDate;
  final String incidentTime;
  final List<String> lossType;
  final String incidentLocation;
  final bool isThirdParty;
  final String description;
  final List<String> thirdPartyLossType;
  final String thirdPartyPhoneNumber;
  final String claimType;
  final File? fileLiquidDamage;
  final File? fileDamagedPart;
  final File? fileReceipt;
  final File? policeReport;
  final String? driversLicenseNo;
  final File? driverLicenseFile;

  const ClaimSummaryScreen(
      {super.key,
      required this.incidentType,
      required this.incidentDate,
      required this.incidentTime,
      required this.lossType,
      required this.incidentLocation,
      required this.isThirdParty,
      required this.description,
      required this.thirdPartyLossType,
      required this.thirdPartyPhoneNumber,
      required this.claimType,
      this.fileLiquidDamage,
      this.fileDamagedPart,
      this.fileReceipt,
      this.policeReport,
      this.driverLicenseFile,
      this.driversLicenseNo});

  @override
  ConsumerState<ClaimSummaryScreen> createState() => _ClaimSummaryScreenState();
}

class _ClaimSummaryScreenState extends ConsumerState<ClaimSummaryScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final claimVM = ref.watch(claimVmProvider);

    final List<Damage> damagePart = ref.watch(vehicleDamagesProvider);
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
                      "Confirm the following",
                      fontSize: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            verticalSpacer(25),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 15),
                              decoration: BoxDecoration(
                                color: CustomColors.backBorderColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRect(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    verticalSpacer(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        semiBoldText(
                                          "Claim Summary",
                                          fontSize: 14,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Scrollbar(
                                        // isAlwaysShown: true,
                                        child: Column(
                                          children: [
                                            const Divider(
                                              thickness: 0.4,
                                              color:
                                                  CustomColors.dividerGreyColor,
                                            ),
                                            Column(
                                              children: [
                                                verticalSpacer(5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          regularText(
                                                            "Incident Type",
                                                            fontSize: 14,
                                                            color: CustomColors
                                                                .greyTextColor,
                                                          ),
                                                          verticalSpacer(4),
                                                          semiBoldText(
                                                            // widget.purchaseDetails.payload?.data
                                                            //         ?.email ??
                                                            widget.incidentType,
                                                            fontSize: 14,
                                                            color: CustomColors
                                                                .blackTextColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          regularText(
                                                            "Date",
                                                            fontSize: 13,
                                                            color: CustomColors
                                                                .greyTextColor,
                                                          ),
                                                          verticalSpacer(4),
                                                          semiBoldText(
                                                            CustomDateUtils
                                                                .convertStringDate(
                                                                    widget
                                                                        .incidentDate),
                                                            fontSize: 14,
                                                            color: CustomColors
                                                                .blackTextColor,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                verticalSpacer(20),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          regularText(
                                                            "Closest  incident time",
                                                            fontSize: 14,
                                                            color: CustomColors
                                                                .greyTextColor,
                                                          ),
                                                          verticalSpacer(4),
                                                          semiBoldText(
                                                            // widget.purchaseDetails.payload?.data
                                                            //         ?.lastName ??
                                                            widget.incidentTime,
                                                            fontSize: 14,
                                                            color: CustomColors
                                                                .blackTextColor,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          regularText(
                                                            "Incident location",
                                                            fontSize: 13,
                                                            color: CustomColors
                                                                .greyTextColor,
                                                          ),
                                                          verticalSpacer(4),
                                                          semiBoldText(
                                                            // widget.purchaseDetails.payload?.data
                                                            //         ?.firstName ??
                                                            widget
                                                                .incidentLocation,
                                                            fontSize: 14,
                                                            color: CustomColors
                                                                .blackTextColor,
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
                                      ),
                                    ),
                                    widget.incidentType == 'Accidental damage'
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: PlanExpandableContainer(
                                              title: "Damaged parts.",
                                              isExpanded: true,
                                              // expandedHeight: 210,
                                              fontSize: 16,
                                              titleColor: CustomColors
                                                  .primaryBrandColor(),
                                              child: Column(
                                                children: [
                                                  verticalSpacer(5),
                                                  if (damagePart.isNotEmpty)
                                                    ...damagePart.map((part) =>
                                                        DamagePreviewCard(
                                                          farImage: FileImage(
                                                              part.farRangeFile!),
                                                          closeImage: FileImage(
                                                              part.closeRangeFile!),
                                                          chipText:
                                                              '${part.damageArea} || ${part.damagePart}',
                                                          onPreviewTap:
                                                              () async {
                                                            final result =
                                                                await showDamagePreviewSheet(
                                                              damage: part,
                                                              context,
                                                              title:
                                                                  '${part.damageArea} || ${part.damagePart}',
                                                              farImage:
                                                                  FileImage(part
                                                                      .farRangeFile!),
                                                              closeImage:
                                                                  FileImage(part
                                                                      .closeRangeFile!),
                                                            );

                                                            if (result ==
                                                                DamagePreviewAction
                                                                    .removed) {
                                                              // remove the image(s) from your list
                                                            } else if (result ==
                                                                DamagePreviewAction
                                                                    .confirmed) {
                                                              // proceed
                                                            }
                                                          },
                                                        )),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomButton(
                      title: "Submit",
                      isLoading: claimVM.isLoading,
                      onTap: () async {
                        print(
                            'ddd ${widget.fileDamagedPart}. ${widget.fileLiquidDamage}');
                        if (widget.claimType.toLowerCase() == 'device') {
                          await claimVM.submitDeviceClaim(
                              ref: ref,
                              context: context,
                              incidentType: widget.incidentType,
                              incidentDate: widget.incidentDate,
                              incidentTime: StringUtils.convertToMilitaryTime(
                                  widget.incidentTime),
                              lossType: widget.lossType,
                              incidentLocation: widget.incidentLocation,
                              description: widget.description,
                              fileDamagedPart: widget.fileDamagedPart,
                              fileReceipt: widget.fileReceipt,
                              claimType: widget.claimType,
                              fileLiquidDamage: widget.fileLiquidDamage);
                        } else {
                          await claimVM.submitVehicleClaim(
                              ref: ref,
                              context: context,
                              incidentType: widget.incidentType,
                              incidentDate: widget.incidentDate,
                              incidentTime: StringUtils.convertToMilitaryTime(
                                  widget.incidentTime),
                              lossType: widget.lossType,
                              incidentLocation: widget.incidentLocation,
                              isThirdParty: widget.isThirdParty,
                              description: widget.description,
                              thirdPartyLossType: widget.thirdPartyLossType,
                              thirdPartyPhoneNumber:
                                  widget.thirdPartyPhoneNumber,
                              claimType: widget.claimType,
                              policeReport: widget.policeReport,
                              damagePart: ref.watch(vehicleDamagesProvider),
                              driversLicenseNumber: widget.driversLicenseNo,
                              selectedDriversLicense: widget.driverLicenseFile);
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
