import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_first_form_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_list_dropdown_multiselect_field.dart';
import 'package:mca_official_flutter_sdk/src/utils/form_validator.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ClaimSecondFormScreen extends StatefulHookConsumerWidget {
  const ClaimSecondFormScreen({super.key});

  @override
  ConsumerState<ClaimSecondFormScreen> createState() =>
      _ClaimSecondFormScreenState();
}

class _ClaimSecondFormScreenState extends ConsumerState<ClaimSecondFormScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  String? selectedIncidentType;
  String? selectedDate;
  String? selectedTime;
  List<String>? selectedDamageType;
  int value = 0;

  @override
  Widget build(BuildContext context) {
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
                                    "Toyota camry 2022",
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
                                    "Toyota camry 2022",
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
                      verticalSpacer(20),
                      CustomListDropdownMultiSelectField(
                        label: "Select damageType",
                        description: "Select damageType",
                        selectedLItems: damageTypeProvider,
                        items: const [
                          "Collision",
                          "Fire",
                          "Vandalization",
                          "Windscreen",
                        ],
                        // selectedItems: selectedDamageType,
                      ),
                      verticalSpacer(10),
                      customFormTextField(
                        'policyNumber',
                        title: 'Enter incident location',
                        hintText: "Enter incident location",
                        // autovalidateMode: ref.watch(autoValidateProvider) == true
                        //     ? AutovalidateMode.onUserInteraction
                        //     : AutovalidateMode.disabled,
                        validator: (value) {
                          // return null;

                          return CustomValidator.validateForm(
                              value ?? "", 'Policy number', 4,
                              errorMessage: "Enter incident location");
                        },
                        onChanged: (value) {},
                        suffixIcon: Icons.location_on_outlined,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mediumText(
                            "Does this accident involve a third party",
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
                                AnimationType.onHover, // No scaling
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
                                : regularText(
                                    "No",
                                    fontSize: 10,
                                    color: value == toggleValue
                                        ? CustomColors.whiteColor
                                        : CustomColors.blackColor,
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
                              borderColor: CustomColors.greyToastColor,
                              borderRadius: BorderRadius.circular(5.0),
                              indicatorColor: CustomColors.primaryBrandColor(),
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
                        'whatHappened',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        title: null,
                        hintText: "Tell us how it happened",
                        // autovalidateMode: ref.watch(autoValidateProvider) == true
                        //     ? AutovalidateMode.onUserInteraction
                        //     : AutovalidateMode.disabled,
                        maxLines: 5,
                        validator: CustomValidator.howDidItHappen,
                        onChanged: (value) {},
                      ),
                      // const Spacer(),
                      CustomButton(
                        title: "Continue",
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          bool? validate = formKey.currentState?.validate();

                          if (validate == true) {
                            // var policyNumber = formKey
                            //     .currentState?.fields['policyNumber']?.value
                            //     .toString()
                            //     .trim();
                            // var email =
                            //     formKey.currentState?.fields['email']?.value;
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const ClaimSummaryScreen()));

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
          ],
        ),
      )),
    );
  }
}
