import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/form_validator.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ConfirmPolicyScreen extends StatefulHookConsumerWidget {
  const ConfirmPolicyScreen({super.key});

  @override
  ConsumerState<ConfirmPolicyScreen> createState() =>
      _ConfirmPolicyScreenState();
}

class _ConfirmPolicyScreenState extends ConsumerState<ConfirmPolicyScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // verticalSpacer(10),
                    semiBoldText(
                      "Make a claim",
                      fontSize: 20,
                    ),

                    verticalSpacer(20),
                    Container(
                      // height: 100,
                      decoration: const BoxDecoration(
                        color: CustomColors.backBorderColor,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 100.0,
                                left: 15,
                              ),
                              child: Column(
                                children: [
                                  regularText(
                                    "Provide your email address and policy number to confirm your policy details.",
                                    fontSize: 14.5,
                                  ),
                                  verticalSpacer(20),
                                  regularText(
                                    " You can find your policy number in your email or on your certificate (e.g., INS-12345678-XY)",
                                    fontSize: 13,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: Container(
                              decoration: const BoxDecoration(
                                //HELP
                                shape: BoxShape.circle,
                                // color: CustomColors.lightBlackColor,
                              ),
                              child: Center(
                                child: Image.asset(
                                  ConstantString.claimImg,
                                  height: 80,
                                  package: 'mca_official_flutter_sdk',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(40),
                    customFormTextField(
                      'policyNumber',
                      enabled: false,
                      title: 'Policy number',
                      hintText: "Enter Policy Number",
                      initialValue: Global.policyNumber,
                      // autovalidateMode: ref.watch(autoValidateProvider) == true
                      //     ? AutovalidateMode.onUserInteraction
                      //     : AutovalidateMode.disabled,
                      validator: (value) {
                        // return null;

                        return CustomValidator.validateForm(
                            value ?? "", 'Policy number', 4);
                      },
                      onChanged: (value) {},
                    ),
                    verticalSpacer(5),
                    customFormTextField(
                      'email',
                      enabled: false,
                      title: 'Email Address',
                      hintText: "Enter Email",
                      initialValue: Global.inspectionEmail,
                      // autovalidateMode: ref.watch(autoValidateProvider) == true
                      //     ? AutovalidateMode.onUserInteraction
                      //     : AutovalidateMode.disabled,
                      validator: (value) {
                        // return null;
                        return CustomValidator.validateForm(
                            value ?? "", 'Email', 4);
                      },
                      onChanged: (value) {},
                    ),

                    const Spacer(),
                    CustomButton(
                      title: "Continue",
                      isLoading: claimVM.isLoading,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        bool? validate = formKey.currentState?.validate();

                        if (validate == true) {
                          var policyNumber = formKey
                              .currentState?.fields['policyNumber']?.value
                              .toString()
                              .trim();
                          var email =
                              formKey.currentState?.fields['email']?.value;
                        
                          claimVM.getClaimsById(
                            ref: ref,
                            context: context,
                            email: email,
                            policyNumber: policyNumber ?? "",
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             const ConfirmPolicyInfoScreen()));

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
          ],
        ),
      )),
    );
  }
}
