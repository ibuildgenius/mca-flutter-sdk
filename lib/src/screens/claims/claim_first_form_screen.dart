import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/generic_dialog.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/caim_damaged_part.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_summary.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_date_picker.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_list_dropdown_field.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_list_dropdown_multiselect_field.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_time_picker.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/form_validator.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';
import 'package:path/path.dart' as p;

class ClaimFirstFormScreen extends StatefulHookConsumerWidget {
  final PolicyModel policy;

  const ClaimFirstFormScreen({super.key, required this.policy});

  @override
  ConsumerState<ClaimFirstFormScreen> createState() =>
      _ClaimFirstFormScreenState();
}

class _ClaimFirstFormScreenState extends ConsumerState<ClaimFirstFormScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  String? selectedIncidentType;
  String? selectedDate;
  String? selectedTime;
  List<String>? selectedDamageType;
  bool showFirstform = true;
  File? selectePoliceReport;
  File? selectedDriversLicense;
  String? driversLicenseNumber;

  //  String? selectedIncidentType;
  // String? selectedDate;
  // String? selectedTime;
  // List<String>? selectedDamageType;
  int value = 0;
  String? incidentLocation;
  String? thirdPhoneNumber;

  String? whatHappened;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(autoDamageTypeProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final claimVM = ref.watch(claimVmProvider);
    final isAccidentalDamage =
        ref.watch(incidentTypeProvider) == "Accidental damage";
    final isTheft = ref.watch(incidentTypeProvider) == "Theft";

    final disableButton =
        ref.watch(incidentTypeProvider)?.toLowerCase() == "theft"
            ? (driversLicenseNumber == null ||
                selectedDriversLicense == null ||
                selectePoliceReport == null ||
                incidentLocation == null ||
                whatHappened == null)
            : (incidentLocation == null ||
                whatHappened == null ||
                ref.watch(autoDamageTypeProvider).isEmpty);

    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            verticalSpacer(20),
            verticalSpacer(20),
            CustomAppbar(
              // showHelp: true,
              showLogo: false,
              showBackButton: true,
              onBackTap: showFirstform == false
                  ? () {
                      setState(() {
                        showFirstform = true;
                      });
                    }
                  : Navigator.canPop(context)
                      ? () => Navigator.pop(context)
                      : null,
              // logoUrl: ref.watch(businessDetailsProvider)?.logo,
            ),
            Visibility(
              visible: showFirstform,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // verticalSpacer(10),
                      semiBoldText("Submit your claim ", fontSize: 20),
                      verticalSpacer(20),
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
                                    [
                                      widget.policy.meta["vehicle_make"],
                                      widget.policy.meta["vehicle_model"],
                                      widget.policy.meta["year_of_manufacture"],
                                    ]
                                        .where((e) =>
                                            e != null &&
                                            e.toString().trim().isNotEmpty)
                                        .join(" "),
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
                                    widget.policy.meta["registration_number"] ??
                                        "",
                                    fontSize: 14,
                                    color: CustomColors.primaryBrandColor(),
                                  ),
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
                                    ConstantString.carImage,
                                    height: 60,
                                    package: 'mca_official_flutter_sdk',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpacer(30),

                      CustomListDropdownField(
                        fieldName: "Select Incident type",
                        label: "Select Incident type",
                        description: "Select Incident type",
                        items: const [
                          "Accidental damage",
                          "Theft",
                        ],
                        selectedItem: incidentTypeProvider,
                      ),
                      verticalSpacer(10),
                      CustomMiniDatePicker(
                        label: "Enter date of incident",
                        description: "dd/mm/yyyy",
                        isTodayMax: true,
                        minDate: 12,
                        selectedDate: dateOfIncidentProvider,
                      ),
                      verticalSpacer(10),
                      CustomMiniTimePicker(
                        label: "Incident closest time",
                        description: "--:-- --",
                        isTodayMax: true,
                        minDate: 12,
                        selectedTime: accidentTimeProvider,
                      ),

                      const Spacer(),
                      CustomButton(
                        title: "Continue",
                        onTap: ref.watch(incidentTypeProvider) == null ||
                                ref.watch(dateOfIncidentProvider) == null ||
                                ref.watch(accidentTimeProvider) == null
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                bool? validate =
                                    formKey.currentState?.validate();

                                if (validate == true) {
                                  // var policyNumber = formKey.currentState
                                  //     ?.fields['policyNumber']?.value
                                  //     .toString()
                                  //     .trim();
                                  // var email = formKey
                                  //     .currentState?.fields['email']?.value;

                                  setState(() {
                                    showFirstform = false;
                                  });
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const ClaimSecondFormScreen()));

                                  // print(email);
                                  // print(password);

                                  // await authVM.signIn(
                                  //     userName: userName ?? "",
                                  //     password: password,
                                  //     ref: ref,
                                  //     context: context);
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const ConfirmPolicyInfoScreen()));
                              },
                      ),
                      verticalSpacer(25),
                      const PoweredByFooter()
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !showFirstform,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // verticalSpacer(10),
                        semiBoldText(
                          "Submit your claim ",
                          fontSize: 20,
                        ),
                        verticalSpacer(20),
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
                                      [
                                        widget.policy.meta["vehicle_make"],
                                        widget.policy.meta["vehicle_model"],
                                        widget
                                            .policy.meta["year_of_manufacture"],
                                      ]
                                          .where((e) =>
                                              e != null &&
                                              e.toString().trim().isNotEmpty)
                                          .join(" "),
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
                                      widget.policy
                                              .meta["registration_number"] ??
                                          "",
                                      fontSize: 14,
                                      color: CustomColors.primaryBrandColor(),
                                    ),
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
                                      ConstantString.carImage,
                                      height: 60,
                                      package: 'mca_official_flutter_sdk',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (ref.watch(incidentTypeProvider)?.toLowerCase() ==
                            "accidental damage") ...[
                          verticalSpacer(20),
                          CustomListDropdownMultiSelectField(
                            label: "Select damageType",
                            description: "Select damageType",
                            selectedLItems: autoDamageTypeProvider,
                            items: const [
                              "Own damage",
                              "Collision",
                              "Fire",
                              "Vandalization",
                              "Windscreen",
                            ],
                          ),
                        ] else if (ref
                                .watch(incidentTypeProvider)
                                ?.toLowerCase() ==
                            "theft") ...[
                          verticalSpacer(20),
                          UploadDocumentField(
                            label: "Police Report",
                            file: selectePoliceReport,
                            onChanged: (file) {
                              setState(() => selectePoliceReport = file);
                            },
                          ),
                          verticalSpacer(20.h),
                          customFormTextField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLength: 11,
                            isNumber: true,
                            'driversLicense',
                            title: 'Enter your driver’s license number',
                            hintText: "Enter your driver’s license number",
                            validator: (value) {
                              final input = value?.trim() ?? "";

                              if (input.isEmpty) {
                                return "Driver’s license is required";
                              }

                              // Regex: Either starts with DL + 8 digits, or 9–11 digits
                              final licensePattern =
                                  RegExp(r'^(DL\d{8}|\d{9,11})$');

                              if (!licensePattern.hasMatch(input)) {
                                return "Enter a valid Nigerian driver’s license";
                              }
                              return null; // valid
                            },
                            onChanged: (value) {
                              driversLicenseNumber = value;
                              setState(() {});
                            },
                            suffixIcon:
                                Icons.badge_outlined, // better icon for license
                          ),
                          UploadDocumentField(
                            label: "Driver’s License",
                            file: selectedDriversLicense,
                            onChanged: (file) {
                              setState(() => selectedDriversLicense = file);
                            },
                          ),
                          verticalSpacer(20.h),
                        ],
                        // verticalSpacer(10),
                        customFormTextField(
                          'incidentLocation',
                          title: 'Enter incident location',
                          hintText: "Enter incident location",
                          validator: (value) {
                            return CustomValidator.validateForm(
                                value ?? "", 'Policy number', 4,
                                errorMessage: "Enter incident location");
                          },
                          onChanged: (value) {
                            setState(() {
                              incidentLocation = value;
                            });
                          },
                          suffixIcon: Icons.location_on_outlined,
                        ),
                        if (ref.watch(incidentTypeProvider)?.toLowerCase() ==
                            "accidental damage")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              mediumText(
                                "Does this accident involve a third party?",
                                fontSize: 14,
                                color: CustomColors.formTitleColor,
                              ),
                              AnimatedToggleSwitch<int>.size(
                                textDirection: TextDirection.rtl,
                                current: value,
                                height: 28,
                                values: const [1, 0],
                                // spacing: 10,
                                iconAnimationType: AnimationType.onHover,
                                // No scaling
                                iconOpacity: 1,
                                inactiveOpacity: 1,

                                indicatorSize: const Size.fromWidth(30),
                                iconBuilder: (toggleValue) => toggleValue == 1
                                    ? Container(
                                        child: semiBoldText(
                                          "Yes",
                                          fontSize: 10,
                                          color: value == toggleValue
                                              ? CustomColors.whiteColor
                                              : CustomColors.blackColor,
                                        ),
                                      )
                                    : regularText("No",
                                        fontSize: 10,
                                        color: value == toggleValue
                                            ? CustomColors.whiteColor
                                            : CustomColors.blackColor),
                                borderWidth: 0.5,
                                // iconAnimationType: AnimationType.onHover,
                                style: ToggleStyle(
                                  borderColor: CustomColors.greyToastColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                  indicatorColor:
                                      CustomColors.primaryBrandColor(),
                                ),
                                onChanged: (i) => setState(() {
                                  value = i;
                                }),
                              ),
                            ],
                          ),

                        Visibility(
                          visible: value == 1,
                          child: Column(
                            children: [
                              verticalSpacer(25),
                              CustomListDropdownMultiSelectField(
                                label: "Select damageType",
                                description: "Select damageType",
                                selectedLItems: thirdPartyDamageTypeProvider,
                                items: const [
                                  "Third party bodily injury",
                                  "Third party property damage",
                                  "Third party death",
                                ],
                                // selectedItems: selectedDamageType,
                              ),
                              verticalSpacer(10),
                              customFormTextField(
                                'thirdPhoneNumber',
                                title: 'Third party phone number',
                                isNumber: true,
                                hintText: "Third party involved phone number",
                                // autovalidateMode: ref.watch(autoValidateProvider) == true
                                //     ? AutovalidateMode.onUserInteraction
                                //     : AutovalidateMode.disabled,
                                validator: (value) {
                                  // return null;

                                  return CustomValidator.validateForm(
                                      value ?? "", 'Phone number', 4);
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        verticalSpacer(10),
                        customFormTextField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          'whatHappened',
                          title: null,
                          hintText: "Tell us how it happened",
                          // autovalidateMode: ref.watch(autoValidateProvider) == true
                          //     ? AutovalidateMode.onUserInteraction
                          //     : AutovalidateMode.disabled,
                          maxLines: 5,
                          validator: CustomValidator.howDidItHappen,
                          onChanged: (value) {
                            setState(() {
                              whatHappened = value;
                            });
                          },
                        ),
                        // const Spacer(),
                        CustomButton(
                          title: "Continue",
                          isLoading: claimVM.isLoading,
                          onTap: disableButton
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  await claimVM.getDamagedParts(ref: ref);
                                  bool? validate =
                                      formKey.currentState?.validate();

                                  if (validate == true) {
                                    incidentLocation = formKey.currentState
                                        ?.fields['incidentLocation']?.value
                                        .toString()
                                        .trim();

                                    thirdPhoneNumber = formKey.currentState
                                        ?.fields['thirdPhoneNumber']?.value
                                        .toString()
                                        .trim();
                                    driversLicenseNumber = formKey.currentState
                                        ?.fields['incidentLocation']?.value
                                        .toString()
                                        .trim();

                                    whatHappened = formKey.currentState
                                        ?.fields['whatHappened']?.value;
                                    if (ref
                                            .watch(incidentTypeProvider)
                                            ?.toLowerCase() ==
                                        "accidental damage") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ClaimDamagedPartScreen(
                                            incidentType: ref.watch(
                                                    incidentTypeProvider) ??
                                                "",
                                            incidentDate: ref.watch(
                                                    dateOfIncidentProvider) ??
                                                "",
                                            incidentTime: ref.watch(
                                                    accidentTimeProvider) ??
                                                "",
                                            lossType: ref
                                                .watch(autoDamageTypeProvider),
                                            incidentLocation:
                                                incidentLocation ?? "",
                                            isThirdParty:
                                                value == 0 ? false : true,
                                            description: whatHappened ?? " ",
                                            thirdPartyLossType: ref.watch(
                                                thirdPartyDamageTypeProvider),
                                            thirdPartyPhoneNumber:
                                                thirdPhoneNumber ?? "",
                                            claimType: "Vehicle",
                                            policeReport: selectePoliceReport,
                                            driversLicenseNo:
                                                driversLicenseNumber,
                                            driverLicenseFile:
                                                selectedDriversLicense,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ClaimSummaryScreen(
                                            incidentType: ref.watch(
                                                    incidentTypeProvider) ??
                                                "",
                                            incidentDate: ref.watch(
                                                    dateOfIncidentProvider) ??
                                                "",
                                            incidentTime: ref.watch(
                                                    accidentTimeProvider) ??
                                                "",
                                            lossType: ref
                                                .watch(autoDamageTypeProvider),
                                            incidentLocation:
                                                incidentLocation ?? "",
                                            isThirdParty:
                                                value == 0 ? false : true,
                                            description: whatHappened ?? " ",
                                            thirdPartyLossType: ref.watch(
                                                thirdPartyDamageTypeProvider),
                                            thirdPartyPhoneNumber:
                                                thirdPhoneNumber ?? "",
                                            claimType: "Vehicle",
                                            policeReport: selectePoliceReport,
                                            driversLicenseNo:
                                                driversLicenseNumber,
                                            driverLicenseFile:
                                                selectedDriversLicense,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                        ),
                        // CustomButton(
                        //   title: "Continue",
                        //   isLoading: claimVM.isLoading,
                        //   onTap: (ref.watch(incidentTypeProvider) == "Accidental damage") && (ref.watch(autoDamageTypeProvider).isEmpty ||
                        //                   (ref
                        //                           .watch(
                        //                               thirdPartyDamageTypeProvider)
                        //                           .isEmpty &&
                        //                       value == 1)) ||
                        //           (ref.watch(incidentTypeProvider) ==
                        //                   "Theft") &&
                        //               (selectePoliceReport == null ||
                        //                   incidentLocation == null)
                        //       ? null
                        //       : () async {
                        //           FocusScope.of(context).unfocus();
                        //           bool? validate =
                        //               formKey.currentState?.validate();
                        //
                        //           if (validate == true) {
                        //             incidentLocation = formKey.currentState
                        //                 ?.fields['incidentLocation']?.value
                        //                 .toString()
                        //                 .trim();
                        //             thirdPhoneNumber = formKey.currentState
                        //                 ?.fields['thirdPhoneNumber']?.value
                        //                 .toString()
                        //                 .trim();
                        //
                        //             whatHappened = formKey.currentState
                        //                 ?.fields['whatHappened']?.value;
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (context) =>
                        //                         ClaimSummaryScreen(
                        //                           incidentType: ref.watch(
                        //                                   incidentTypeProvider) ??
                        //                               "",
                        //                           incidentDate: ref.watch(
                        //                                   dateOfIncidentProvider) ??
                        //                               "",
                        //                           incidentTime: ref.watch(
                        //                                   accidentTimeProvider) ??
                        //                               "",
                        //                           lossType: ref.watch(
                        //                               autoDamageTypeProvider),
                        //                           incidentLocation:
                        //                               incidentLocation ?? "",
                        //                           isThirdParty:
                        //                               value == 0 ? false : true,
                        //                           description:
                        //                               whatHappened ?? " ",
                        //                           thirdPartyLossType: ref.watch(
                        //                               thirdPartyDamageTypeProvider),
                        //                           thirdPartyPhoneNumber:
                        //                               thirdPhoneNumber ?? "",
                        //                           claimType: "Vehicle",
                        //                         )));
                        //           }
                        //         },
                        // ),
                        verticalSpacer(25),
                        const PoweredByFooter()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class UploadDocumentField extends StatefulWidget {
  final String label; // e.g. "Police Report" or "Driver’s License"
  final File? file;
  final ValueChanged<File?> onChanged;

  const UploadDocumentField({
    super.key,
    required this.label,
    required this.file,
    required this.onChanged,
  });

  @override
  State<UploadDocumentField> createState() => _UploadDocumentFieldState();
}

class _UploadDocumentFieldState extends State<UploadDocumentField> {
  Future<void> _pickFile(BuildContext context) async {
    File? selectedImage;

    await GenericDialog().showSelectImageDialog2(
      context: context,
      onCameraPressed: () async {
        selectedImage = await selectImage(ImageSource.camera);
        if (selectedImage != null) widget.onChanged(selectedImage);
      },
      onGalleryPressed: () async {
        selectedImage = await selectImage(ImageSource.gallery);
        if (selectedImage != null) widget.onChanged(selectedImage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = widget.file != null;

    return GestureDetector(
      onTap: hasFile
          ? () => widget.onChanged(null) // remove file
          : () => _pickFile(context), // pick file
      child: DottedBorder(
        color: CustomColors.checkBoxBorderColor,
        dashPattern: const [10, 10],
        borderType: BorderType.RRect,
        radius: const Radius.circular(5),
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.backBorderColor,
              border: Border.all(
                color: CustomColors.dividerGreyColor,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                SvgPicture.asset(
                  hasFile
                      ? ConstantString.deleteInvoice
                      : ConstantString.uploadInvoice,
                  package: 'mca_official_flutter_sdk',
                ),
                verticalSpacer(5),
                hasFile
                    ? regularText(
                        p.basename(widget.file?.path ?? ""),
                        fontSize: 14.5,
                        textAlign: TextAlign.center,
                        color: CustomColors.primaryBrandColor(),
                      )
                    : RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Click ",
                              style: CustomTextStyles.w500(
                                fontSize: 12,
                                color: CustomColors.primaryBrandColor(),
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: "to upload ${widget.label}",
                              style: CustomTextStyles.regular(
                                fontSize: 12.5,
                                color: CustomColors.blackTextColor,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// final damageTypeProvider = StateProvider<List<String>>((ref) => []);

final incidentTypeProvider = StateProvider.autoDispose<String?>((ref) => null);
final dateOfIncidentProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final accidentTimeProvider = StateProvider.autoDispose<String?>((ref) => null);

final damageTypeProvider = StateProvider<List<String>>((ref) => []);
final autoDamageTypeProvider = StateProvider<List<String>>((ref) => []);

final thirdPartyDamageTypeProvider = StateProvider<List<String>>((ref) => []);
