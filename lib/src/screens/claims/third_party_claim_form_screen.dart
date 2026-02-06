import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/models/provider_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/all_providers_list_dropdown_field.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_date_picker.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_list_dropdown_multiselect_field.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_time_picker.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/product_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/form_validator.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ThirdPartyClaimFormScreen extends StatefulHookConsumerWidget {
  final PolicyModel policy;

  const ThirdPartyClaimFormScreen({
    super.key,
    required this.policy,
  });

  @override
  ConsumerState<ThirdPartyClaimFormScreen> createState() =>
      _ThirdPartyClaimFormScreenState();
}

class _ThirdPartyClaimFormScreenState
    extends ConsumerState<ThirdPartyClaimFormScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  String? selectedIncidentType;
  String? selectedDate;
  String? selectedTime;
  List<String>? selectedDamageType;
  int formStep = 1;

  int value = 0;
  String? incidentLocation;
  String? thirdPartyPhoneNumber;
  String? thirdPartyFullName;
  String? thirdPartyEmail;
  String? thirdPartyPolicyNumber;
  bool isThirdPartyInsured = false;
  bool shouldAutovalidate = false;

  String? whatHappened;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(productProvider).getAllInsuranceProviders(
            ref: ref,
            context: context,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final claimVM = ref.watch(claimVmProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            verticalSpacer(20),
            CustomAppbar(
              showLogo: false,
              showBackButton: true,
              onBackTap: formStep > 1
                  ? () {
                      setState(() {
                        formStep--;
                      });
                    }
                  : Navigator.canPop(context)
                      ? () => Navigator.pop(context)
                      : null,
            ),
            Visibility(
              visible: formStep == 1,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      semiBoldText(
                        "Submit your claim ",
                        fontSize: 20,
                      ),
                      verticalSpacer(20),
                      Container(
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
                                    (widget.policy.meta["vehicle_make"] ?? "") +
                                        " " +
                                        (widget.policy.meta["vehicle_model"] ??
                                            "") +
                                        " " +
                                        (widget.policy
                                                .meta["year_of_manufacture"] ??
                                            ""),
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
                                  shape: BoxShape.circle,
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
                      CustomListDropdownMultiSelectField(
                        label: "Incident type",
                        description: "Select Incident type",
                        fontSize: 12,
                        selectedLItems: thirdPartyIncidentTypeProvider,
                        refreshScreen: () => setState(() {}),
                        items: const [
                          "Third party bodily injury",
                          // "Third-party Vehicle Damage",
                          "Third party property damage",
                          "Third party death",
                          // "Other",
                        ],
                      ),
                      verticalSpacer(10),
                      CustomMiniDatePicker(
                        label: "Date of Incident",
                        description: "dd/mm/yyyy",
                        isTodayMax: true,
                        minDate: 12,
                        selectedDate: thirdPartyDateOfIncidentProvider,
                      ),
                      verticalSpacer(10),
                      CustomMiniTimePicker(
                        label: "Closest Time of Incident",
                        description: "--:-- --",
                        isTodayMax: true,
                        minDate: 12,
                        selectedTime: thirdPartyAccidentTimeProvider,
                      ),
                      const Spacer(),
                      CustomButton(
                        title: "Continue",
                        onTap: ref.watch(thirdPartyDateOfIncidentProvider) ==
                                    null ||
                                ref.watch(thirdPartyAccidentTimeProvider) ==
                                    null ||
                                StringUtils.isNullOrEmptyList(
                                    ref.watch(thirdPartyIncidentTypeProvider))
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
                                    formStep++;
                                  });
                                }
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
              visible: formStep == 2,
              child: Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  semiBoldText(
                                    "Submit your claim ",
                                    fontSize: 20,
                                  ),
                                  verticalSpacer(20),
                                  Container(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              regularText(
                                                "Vehicle name",
                                                fontSize: 13,
                                                color:
                                                    CustomColors.greyTextColor,
                                              ),
                                              verticalSpacer(2),
                                              semiBoldText(
                                                (widget.policy.meta[
                                                            "vehicle_make"] ??
                                                        "") +
                                                    " " +
                                                    (widget.policy.meta[
                                                            "vehicle_model"] ??
                                                        "") +
                                                    " " +
                                                    (widget.policy.meta[
                                                            "year_of_manufacture"] ??
                                                        ""),
                                                fontSize: 14,
                                                color: CustomColors
                                                    .primaryBrandColor(),
                                              ),
                                              verticalSpacer(10),
                                              regularText(
                                                "Plate number",
                                                fontSize: 13,
                                                color:
                                                    CustomColors.greyTextColor,
                                              ),
                                              verticalSpacer(2),
                                              semiBoldText(
                                                widget.policy.meta[
                                                        "registration_number"] ??
                                                    "",
                                                fontSize: 14,
                                                color: CustomColors
                                                    .primaryBrandColor(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                ConstantString.carImage,
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
                                  verticalSpacer(20),
                                  customFormTextField(
                                    'incidentLocation',
                                    title: 'Incident location',
                                    hintText: "Location of Incident",
                                    autovalidateMode: shouldAutovalidate
                                        ? AutovalidateMode.onUserInteraction
                                        : null,
                                    validator: (value) {
                                      return CustomValidator.validateForm(
                                          value ?? "", 'incident location', 4,
                                          errorMessage:
                                              "Enter incident location");
                                    },
                                    onChanged: (value) {},
                                    suffixIcon: Icons.location_on_outlined,
                                  ),
                                  // Visibility(
                                  //   visible: value == 1,
                                  //   child: Column(
                                  //     children: [
                                  //       verticalSpacer(25),
                                  //       CustomListDropdownMultiSelectField(
                                  //         label: "Select damageType",
                                  //         description: "Select damageType",
                                  //         selectedLItems:
                                  //             thirdPartyDamageTypeProvider,
                                  //         items: const [
                                  //           "Third party bodily injury",
                                  //           "Third party property damage",
                                  //           "Third party death",
                                  //         ],
                                  //       ),
                                  //       verticalSpacer(10),
                                  //       customFormTextField(
                                  //         'thirdPhoneNumber',
                                  //         title: 'Third party phone number',
                                  //         autovalidateMode: shouldAutovalidate
                                  //             ? AutovalidateMode
                                  //                 .onUserInteraction
                                  //             : null,
                                  //         hintText:
                                  //             "Third party involved phone number",
                                  //         validator: (value) {
                                  //           return CustomValidator
                                  //               .validatePhoneNumber(
                                  //             value ?? "",
                                  //             'Phone number',
                                  //           );
                                  //         },
                                  //         onChanged: (value) {},
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),

                                  verticalSpacer(10),
                                  customFormTextField(
                                    'whatHappened',
                                    title: null,
                                    hintText: "Tell us how it happened",
                                    autovalidateMode: shouldAutovalidate
                                        ? AutovalidateMode.onUserInteraction
                                        : null,
                                    maxLines: 5,
                                    validator: CustomValidator.howDidItHappen,
                                    onChanged: (value) {},
                                  ),
                                  verticalSpacer(20),
                                  Visibility(
                                    visible: (MediaQuery.of(context)
                                            .viewInsets
                                            .bottom !=
                                        0),
                                    child: CustomButton(
                                      title: "Continue",
                                      isLoading: claimVM.isLoading,
                                      onTap:
                                          // ref
                                          //             .watch(damageTypeProvider)
                                          //             .isEmpty ||
                                          //         (ref
                                          //                 .watch(
                                          //                     thirdPartyDamageTypeProvider)
                                          //                 .isEmpty &&
                                          //             value == 1)
                                          //     ? null
                                          //     :
                                          () async {
                                        setState(() {
                                          shouldAutovalidate = true;
                                        });
                                        FocusScope.of(context).unfocus();
                                        bool? validate =
                                            formKey.currentState?.validate();

                                        if (validate == true) {
                                          incidentLocation = formKey
                                              .currentState
                                              ?.fields['incidentLocation']
                                              ?.value
                                              .toString()
                                              .trim();
                                          // thirdPhoneNumber = formKey
                                          //     .currentState
                                          //     ?.fields['thirdPhoneNumber']
                                          //     ?.value
                                          //     .toString()
                                          //     .trim();

                                          whatHappened = formKey.currentState
                                              ?.fields['whatHappened']?.value;

                                          setState(() {
                                            shouldAutovalidate = false;
                                          });

                                          setState(() {
                                            formStep++;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  verticalSpacer(
                                      MediaQuery.of(context).viewInsets.bottom),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              !(MediaQuery.of(context).viewInsets.bottom != 0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomButton(
                              title: "Continue",
                              isLoading: claimVM.isLoading,
                              onTap:
                                  // ref.watch(damageTypeProvider).isEmpty ||
                                  //         (ref
                                  //                 .watch(
                                  //                     thirdPartyDamageTypeProvider)
                                  //                 .isEmpty &&
                                  //             value == 1)
                                  //     ? null
                                  //     :
                                  () async {
                                setState(() {
                                  shouldAutovalidate = true;
                                });
                                FocusScope.of(context).unfocus();
                                bool? validate =
                                    formKey.currentState?.validate();

                                if (validate == true) {
                                  incidentLocation = formKey.currentState
                                      ?.fields['incidentLocation']?.value
                                      .toString()
                                      .trim();
                                  // thirdPhoneNumber = formKey.currentState
                                  //     ?.fields['thirdPhoneNumber']?.value
                                  //     .toString()
                                  //     .trim();

                                  whatHappened = formKey.currentState
                                      ?.fields['whatHappened']?.value;

                                  setState(() {
                                    shouldAutovalidate = false;
                                  });

                                  setState(() {
                                    formStep++;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        verticalSpacer(25),
                        const PoweredByFooter()
                      ],
                    ),
                  );
                }),
              ),
            ),
            Visibility(
              visible: formStep == 3,
              child: Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  semiBoldText(
                                    "Submit your claim ",
                                    fontSize: 20,
                                  ),
                                  verticalSpacer(20),
                                  Container(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              regularText(
                                                "Vehicle name",
                                                fontSize: 13,
                                                color:
                                                    CustomColors.greyTextColor,
                                              ),
                                              verticalSpacer(2),
                                              semiBoldText(
                                                (widget.policy.meta[
                                                            "vehicle_make"] ??
                                                        "") +
                                                    " " +
                                                    (widget.policy.meta[
                                                            "vehicle_model"] ??
                                                        "") +
                                                    " " +
                                                    (widget.policy.meta[
                                                            "year_of_manufacture"] ??
                                                        ""),
                                                fontSize: 14,
                                                color: CustomColors
                                                    .primaryBrandColor(),
                                              ),
                                              verticalSpacer(10),
                                              regularText(
                                                "Plate number",
                                                fontSize: 13,
                                                color:
                                                    CustomColors.greyTextColor,
                                              ),
                                              verticalSpacer(2),
                                              semiBoldText(
                                                widget.policy.meta[
                                                        "registration_number"] ??
                                                    "",
                                                fontSize: 14,
                                                color: CustomColors
                                                    .primaryBrandColor(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                ConstantString.carImage,
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
                                  verticalSpacer(20),
                                  customFormTextField(
                                    'thirdPartyFullName',
                                    title: 'Enter third-Party full name',
                                    hintText: "Enter third-Party full name",
                                    autovalidateMode: shouldAutovalidate
                                        ? AutovalidateMode.onUserInteraction
                                        : null,
                                    validator: (value) {
                                      return CustomValidator.validateForm(
                                          value ?? "", 'Policy number', 4,
                                          errorMessage:
                                              "Enter third-Party full name");
                                    },
                                    onChanged: (value) {},
                                  ),
                                  // verticalSpacer(10),
                                  customFormTextField(
                                    'thirdPartyPhoneNumber',
                                    isNumber: true,
                                    //     inputFormatters: [
                                    //   LengthLimitingTextInputFormatter(11),
                                    //   FilteringTextInputFormatter.digitsOnly,
                                    // ],
                                    title: 'Third-party phone number',
                                    hintText: "Enter third-Party phone number",
                                    autovalidateMode: shouldAutovalidate
                                        ? AutovalidateMode.onUserInteraction
                                        : null,
                                    validator: (value) {
                                      return CustomValidator
                                          .validatePhoneNumber(
                                        value ?? "",
                                        'phone number',
                                      );
                                    },
                                    onChanged: (value) {},
                                  ),
                                  // verticalSpacer(20),
                                  customFormTextField(
                                    'thirdPartyEmail',
                                    title: 'Third-party email address',
                                    hintText: "Enter third-Party email address",
                                    autovalidateMode: shouldAutovalidate
                                        ? AutovalidateMode.onUserInteraction
                                        : null,
                                    maxLines: 1,
                                    validator: (value) {
                                      return CustomValidator.validateEmail(
                                        value ?? "",
                                        'email',
                                      );
                                    },
                                    onChanged: (value) {},
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      mediumText(
                                        "Is the third-party vehicle insured?",
                                        fontSize: 14,
                                        color: CustomColors.formTitleColor,
                                      ),
                                      AnimatedToggleSwitch<int>.size(
                                        textDirection: TextDirection.rtl,
                                        current: value,
                                        height: 28,
                                        values: const [
                                          1,
                                          0,
                                        ],
                                        // spacing: 10,
                                        iconAnimationType:
                                            AnimationType.onHover,
                                        // No scaling
                                        iconOpacity: 1,
                                        inactiveOpacity: 1,

                                        indicatorSize: const Size.fromWidth(30),
                                        iconBuilder: (toggleValue) =>
                                            toggleValue == 1
                                                ? Container(
                                                    child: semiBoldText(
                                                      "Yes",
                                                      fontSize: 10,
                                                      color:
                                                          value == toggleValue
                                                              ? CustomColors
                                                                  .whiteColor
                                                              : CustomColors
                                                                  .blackColor,
                                                    ),
                                                  )
                                                : regularText(
                                                    "No",
                                                    fontSize: 10,
                                                    color: value == toggleValue
                                                        ? CustomColors
                                                            .whiteColor
                                                        : CustomColors
                                                            .blackColor,
                                                  ),
                                        // iconBuilder: (value) => value == 0
                                        //     ? Container(
                                        //         child: regularText(
                                        //         "Yes",
                                        //         fontSize: 11,
                                        //       ))
                                        //     : regularText(
                                        //         "No",
                                        //         fontSize: 11,
                                        //       ),

                                        borderWidth: 0.5,
                                        // iconAnimationType: AnimationType.onHover,
                                        style: ToggleStyle(
                                          borderColor:
                                              CustomColors.greyToastColor,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          indicatorColor:
                                              CustomColors.primaryBrandColor(),
                                        ),
                                        onChanged: (i) => setState(() {
                                          value = i;
                                        }),
                                      ),
                                    ],
                                  ),
                                  verticalSpacer(30),
                                  Visibility(
                                    visible: (MediaQuery.of(context)
                                            .viewInsets
                                            .bottom !=
                                        0),
                                    child: CustomButton(
                                      title: "Continue",
                                      isLoading: claimVM.isLoading,
                                      onTap: () async {
                                        setState(() {
                                          shouldAutovalidate = true;
                                        });
                                        FocusScope.of(context).unfocus();
                                        bool? validate =
                                            formKey.currentState?.validate();

                                        if (validate == true) {
                                          thirdPartyFullName = formKey
                                              .currentState
                                              ?.fields['thirdPartyFullName']
                                              ?.value
                                              .toString()
                                              .trim();
                                          thirdPartyEmail = formKey.currentState
                                              ?.fields['thirdPartyEmail']?.value
                                              .toString()
                                              .trim();

                                          thirdPartyPhoneNumber = formKey
                                              .currentState
                                              ?.fields['thirdPartyPhoneNumber']
                                              ?.value;

                                          setState(() {
                                            shouldAutovalidate = false;
                                          });
                                          if (value == 1) {
                                            setState(() {
                                              formStep++;
                                            });
                                          } else {
                                            String? militaryTime = ref.watch(
                                                thirdPartyAccidentTimeProvider);
                                            await claimVM.submitThirdPartyClaim(
                                              ref: ref,
                                              context: context,
                                              incidentDate: ref.watch(
                                                      thirdPartyDateOfIncidentProvider) ??
                                                  "",
                                              incidentTime: StringUtils
                                                      .convertToMilitaryTime(
                                                          militaryTime ?? '') ??
                                                  "",
                                              incidentLocation:
                                                  incidentLocation ?? "",
                                              description: whatHappened ?? "",
                                              thirdPartyLossType: ref.watch(
                                                  thirdPartyIncidentTypeProvider),
                                              thirdPartyPhoneNumber:
                                                  thirdPartyPhoneNumber ?? "",
                                              thirdPartyInsuranceProvider: ref
                                                      .watch(
                                                          thirdPartyPolicyProvider)
                                                      ?.companyName ??
                                                  "",
                                              thirdPartyFullName:
                                                  thirdPartyFullName ?? "",
                                              thirdPartyPolicyNumber:
                                                  thirdPartyPolicyNumber ?? "",
                                              thirdPartyEmail:
                                                  thirdPartyEmail ?? "",
                                              isThirdPartyInsured:
                                                  value == 0 ? false : true,
                                            );
                                          }

                                          // print(ref.watch(
                                          //     thirdPartyIncidentTypeProvider));

                                          // print(ref.watch(
                                          //     thirdPartyDateOfIncidentProvider));
                                          // print(ref.watch(
                                          //     thirdPartyAccidentTimeProvider));
                                          // print(incidentLocation);
                                          // print(whatHappened);

                                          // print(thirdPartyFullName);
                                          // print(thirdPartyEmail);
                                          // print(thirdPartyPhoneNumber);
                                          // print(value);
                                        }
                                      },
                                    ),
                                  ),
                                  verticalSpacer(
                                      MediaQuery.of(context).viewInsets.bottom),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              !(MediaQuery.of(context).viewInsets.bottom != 0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomButton(
                              title: "Continue",
                              isLoading: claimVM.isLoading,
                              onTap:
                                  //  ref.watch(damageTypeProvider).isEmpty ||
                                  //         (ref
                                  //                 .watch(
                                  //                     thirdPartyDamageTypeProvider)
                                  //                 .isEmpty &&
                                  //             value == 1)
                                  //     ? null
                                  //     :
                                  () async {
                                setState(() {
                                  shouldAutovalidate = true;
                                });
                                FocusScope.of(context).unfocus();
                                bool? validate =
                                    formKey.currentState?.validate();

                                if (validate == true) {
                                  thirdPartyFullName = formKey.currentState
                                      ?.fields['thirdPartyFullName']?.value
                                      .toString()
                                      .trim();
                                  thirdPartyEmail = formKey.currentState
                                      ?.fields['thirdPartyEmail']?.value
                                      .toString()
                                      .trim();

                                  thirdPartyPhoneNumber = formKey.currentState
                                      ?.fields['thirdPartyPhoneNumber']?.value;
                                  setState(() {
                                    shouldAutovalidate = false;
                                  });
                                  if (value == 1) {
                                    setState(() {
                                      formStep++;
                                    });
                                  } else {
                                    await claimVM.submitThirdPartyClaim(
                                      ref: ref,
                                      context: context,
                                      incidentDate: ref.watch(
                                              thirdPartyDateOfIncidentProvider) ??
                                          "",
                                      incidentTime: ref.watch(
                                              thirdPartyAccidentTimeProvider) ??
                                          "",
                                      incidentLocation: incidentLocation ?? "",
                                      description: whatHappened ?? "",
                                      thirdPartyLossType: ref.watch(
                                          thirdPartyIncidentTypeProvider),
                                      thirdPartyPhoneNumber:
                                          thirdPartyPhoneNumber ?? "",
                                      thirdPartyInsuranceProvider: ref
                                              .watch(thirdPartyPolicyProvider)
                                              ?.companyName ??
                                          "",
                                      thirdPartyFullName:
                                          thirdPartyFullName ?? "",
                                      thirdPartyPolicyNumber:
                                          thirdPartyPolicyNumber ?? "",
                                      thirdPartyEmail: thirdPartyEmail ?? "",
                                      isThirdPartyInsured:
                                          value == 0 ? false : true,
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        verticalSpacer(25),
                        const PoweredByFooter()
                      ],
                    ),
                  );
                }),
              ),
            ),
            Visibility(
              visible: formStep == 4,
              child: Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  semiBoldText(
                                    "Submit your claim ",
                                    fontSize: 20,
                                  ),
                                  verticalSpacer(20),
                                  Container(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              regularText(
                                                "Vehicle name",
                                                fontSize: 13,
                                                color:
                                                    CustomColors.greyTextColor,
                                              ),
                                              verticalSpacer(2),
                                              semiBoldText(
                                                (widget.policy.meta[
                                                            "vehicle_make"] ??
                                                        "") +
                                                    " " +
                                                    (widget.policy.meta[
                                                            "vehicle_model"] ??
                                                        "") +
                                                    " " +
                                                    (widget.policy.meta[
                                                            "year_of_manufacture"] ??
                                                        ""),
                                                fontSize: 14,
                                                color: CustomColors
                                                    .primaryBrandColor(),
                                              ),
                                              verticalSpacer(10),
                                              regularText(
                                                "Plate number",
                                                fontSize: 13,
                                                color:
                                                    CustomColors.greyTextColor,
                                              ),
                                              verticalSpacer(2),
                                              semiBoldText(
                                                widget.policy.meta[
                                                        "registration_number"] ??
                                                    "",
                                                fontSize: 14,
                                                color: CustomColors
                                                    .primaryBrandColor(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                ConstantString.carImage,
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
                                  verticalSpacer(20),
                                  customFormTextField(
                                    'thirdPartyPolicyNumber',
                                    title: 'Enter third-Party policy number',
                                    hintText: "Enter third-Party policy number",
                                    autovalidateMode: shouldAutovalidate
                                        ? AutovalidateMode.onUserInteraction
                                        : null,
                                    validator: (value) {
                                      return CustomValidator.validateForm(
                                          value ?? "", 'policy number', 4,
                                          errorMessage:
                                              "Enter third-Party full name");
                                    },
                                    onChanged: (value) {},
                                  ),
                                  verticalSpacer(10),
                                  // BankListDropdownField(
                                  //   fieldName: "Select bank",
                                  //   label: "Select bank",
                                  //   description: "Select bank",
                                  //   items: widget.banks,
                                  //   selectedItem: selectedBankProvider,
                                  // ),
                                  AllProvidersListDropdownField(
                                    fieldName: "Select policy provider",
                                    label: "Select policy provider",
                                    description: "Select policy provider",
                                    items: ref.watch(allProviderListProvider) ??
                                        [],
                                    selectedItem: thirdPartyPolicyProvider,
                                  ),
                                  Visibility(
                                    visible: (MediaQuery.of(context)
                                            .viewInsets
                                            .bottom !=
                                        0),
                                    child: CustomButton(
                                      title: "Continue",
                                      isLoading: claimVM.isLoading,
                                      onTap: ref.watch(
                                                  thirdPartyPolicyProvider) ==
                                              null
                                          ? null
                                          : () async {
                                              String? militaryTime = ref.watch(
                                                  thirdPartyAccidentTimeProvider);
                                              setState(() {
                                                shouldAutovalidate = true;
                                              });
                                              FocusScope.of(context).unfocus();
                                              bool? validate = formKey
                                                  .currentState
                                                  ?.validate();

                                              if (validate == true) {
                                                thirdPartyPolicyNumber = formKey
                                                    .currentState
                                                    ?.fields[
                                                        'thirdPartyPolicyNumber']
                                                    ?.value
                                                    .toString()
                                                    .trim();

                                                setState(() {
                                                  shouldAutovalidate = false;
                                                });

                                                await claimVM
                                                    .submitThirdPartyClaim(
                                                  ref: ref,
                                                  context: context,
                                                  incidentDate: ref.watch(
                                                          thirdPartyDateOfIncidentProvider) ??
                                                      "",
                                                  incidentTime: StringUtils
                                                          .convertToMilitaryTime(
                                                              militaryTime ??
                                                                  "") ??
                                                      "",
                                                  incidentLocation:
                                                      incidentLocation ?? "",
                                                  description:
                                                      whatHappened ?? "",
                                                  thirdPartyLossType: ref.watch(
                                                      thirdPartyIncidentTypeProvider),
                                                  thirdPartyPhoneNumber:
                                                      thirdPartyPhoneNumber ??
                                                          "",
                                                  thirdPartyInsuranceProvider: ref
                                                          .watch(
                                                              thirdPartyPolicyProvider)
                                                          ?.companyName ??
                                                      "",
                                                  thirdPartyFullName:
                                                      thirdPartyFullName ?? "",
                                                  thirdPartyPolicyNumber:
                                                      thirdPartyPolicyNumber ??
                                                          "",
                                                  thirdPartyEmail:
                                                      thirdPartyEmail ?? "",
                                                  isThirdPartyInsured:
                                                      value == 0 ? false : true,
                                                );
                                              }
                                            },
                                    ),
                                  ),
                                  verticalSpacer(
                                      MediaQuery.of(context).viewInsets.bottom),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              !(MediaQuery.of(context).viewInsets.bottom != 0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomButton(
                              title: "Continue",
                              isLoading: claimVM.isLoading,
                              onTap: ref.watch(thirdPartyPolicyProvider) == null
                                  ? null
                                  : () async {
                                      setState(() {
                                        shouldAutovalidate = true;
                                      });
                                      FocusScope.of(context).unfocus();
                                      bool? validate =
                                          formKey.currentState?.validate();

                                      if (validate == true) {
                                        thirdPartyPolicyNumber = formKey
                                            .currentState
                                            ?.fields['thirdPartyPolicyNumber']
                                            ?.value
                                            .toString()
                                            .trim();

                                        setState(() {
                                          shouldAutovalidate = false;
                                        });

                                        await claimVM.submitThirdPartyClaim(
                                          ref: ref,
                                          context: context,
                                          incidentDate: ref.watch(
                                                  thirdPartyDateOfIncidentProvider) ??
                                              "",
                                          incidentTime: ref.watch(
                                                  thirdPartyAccidentTimeProvider) ??
                                              "",
                                          incidentLocation:
                                              incidentLocation ?? "",
                                          description: whatHappened ?? "",
                                          thirdPartyLossType: ref.watch(
                                              thirdPartyIncidentTypeProvider),
                                          thirdPartyPhoneNumber:
                                              thirdPartyPhoneNumber ?? "",
                                          thirdPartyInsuranceProvider: ref
                                                  .watch(
                                                      thirdPartyPolicyProvider)
                                                  ?.companyName ??
                                              "",
                                          thirdPartyFullName:
                                              thirdPartyFullName ?? "",
                                          thirdPartyPolicyNumber:
                                              thirdPartyPolicyNumber ?? "",
                                          thirdPartyEmail:
                                              thirdPartyEmail ?? "",
                                          isThirdPartyInsured:
                                              value == 0 ? false : true,
                                        );
                                      }
                                    },
                            ),
                          ),
                        ),
                        verticalSpacer(25),
                        const PoweredByFooter()
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

final thirdPartyIncidentTypeProvider = StateProvider<List<String>>((ref) => []);
final thirdPartyDateOfIncidentProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final thirdPartyAccidentTimeProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final thirdPartyPolicyProvider =
    StateProvider.autoDispose<ProviderModel?>((ref) => null);

// final thirdPartyPolicyProvider =
//     StateProvider.autoDispose<String?>((ref) => null);

final thirdPartyDamageTypeProvider = StateProvider<List<String>>((ref) => []);
