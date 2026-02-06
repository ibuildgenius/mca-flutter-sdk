import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/claim_image_picker.dart';
import 'package:mca_official_flutter_sdk/src/utils/form_validator.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class UploadThirdPartyDocumentScreen extends StatefulHookConsumerWidget {
  final ClaimModel claim;
  const UploadThirdPartyDocumentScreen({
    super.key,
    required this.claim,
  });

  @override
  ConsumerState<UploadThirdPartyDocumentScreen> createState() =>
      _UploadThirdPartyDocumentScreenState();
}

class _UploadThirdPartyDocumentScreenState
    extends ConsumerState<UploadThirdPartyDocumentScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  int? amount;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(part2DamageProvider);
      ref.invalidate(part1DamageProvider);
      ref.invalidate(part3DamageProvider);
      ref.invalidate(part4DamageProvider);
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
              onBackTap: Navigator.canPop(context)
                  ? () => Navigator.pop(context)
                  : null,
            ),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            regularText(
                                              "Vehicle name",
                                              fontSize: 13,
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(2),
                                            semiBoldText(
                                              (widget.claim.policy?.meta[
                                                          "vehicle_make"] ??
                                                      "") +
                                                  " " +
                                                  (widget.claim.policy?.meta[
                                                          "vehicle_model"] ??
                                                      "") +
                                                  " " +
                                                  (widget.claim.policy?.meta[
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
                                              color: CustomColors.greyTextColor,
                                            ),
                                            verticalSpacer(2),
                                            semiBoldText(
                                              widget.claim.policy?.meta[
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
                                verticalSpacer(40),
                                customFormTextField(
                                  'estimateAmount',
                                  title: 'Claim Amount',
                                  hintText: "Enter total claim amount",
                                  isNumber: true,
                                  isCurrency: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    // return null;

                                    return CustomValidator.validateForm(
                                      value ?? "",
                                      'amount',
                                      1,
                                      errorMessage:
                                          "Claim amount field is required",
                                    );
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      amount = value == null || value.isEmpty
                                          ? 0
                                          : int.parse(
                                              value.replaceAll(",", ""));
                                    });
                                  },
                                ),
                                // verticalSpacer(20),
                                ClaimImagePicker(
                                  label: "Damage part one",
                                  imageProvider: part1DamageProvider,
                                ),
                                ClaimImagePicker(
                                  label: "Damage part two",
                                  imageProvider: part2DamageProvider,
                                ),
                                ClaimImagePicker(
                                  label: "Damage part three",
                                  imageProvider: part3DamageProvider,
                                ),
                                ClaimImagePicker(
                                  label: "Damage part four",
                                  imageProvider: part4DamageProvider,
                                ),
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
                                      FocusScope.of(context).unfocus();
                                      bool? validate =
                                          formKey.currentState?.validate();
                                      if (ref
                                                  .watch(part1DamageProvider) ==
                                              null ||
                                          ref
                                                  .watch(part2DamageProvider) ==
                                              null ||
                                          ref
                                                  .watch(part3DamageProvider) ==
                                              null ||
                                          ref.watch(part4DamageProvider) ==
                                              null ||
                                          validate != true) {
                                        ref
                                            .read(validateClaimDocProvider
                                                .notifier)
                                            .state = true;
                                      } else {
                                        claimVM.submitThirdPartyClaimInspection(
                                            ref: ref,
                                            context: context,
                                            partOne:
                                                ref.watch(part1DamageProvider)!,
                                            partTwo:
                                                ref.watch(part2DamageProvider)!,
                                            partThree:
                                                ref.watch(part3DamageProvider)!,
                                            partFour:
                                                ref.watch(part4DamageProvider)!,
                                            amount: amount ?? 0);
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
                              FocusScope.of(context).unfocus();
                              bool? validate = formKey.currentState?.validate();
                              if (ref.watch(part1DamageProvider) == null ||
                                  ref.watch(part2DamageProvider) == null ||
                                  ref.watch(part3DamageProvider) == null ||
                                  ref.watch(part4DamageProvider) == null ||
                                  validate != true) {
                                ref
                                    .read(validateClaimDocProvider.notifier)
                                    .state = true;
                              } else {
                                claimVM.submitThirdPartyClaimInspection(
                                    ref: ref,
                                    context: context,
                                    partOne: ref.watch(part1DamageProvider)!,
                                    partTwo: ref.watch(part2DamageProvider)!,
                                    partThree: ref.watch(part3DamageProvider)!,
                                    partFour: ref.watch(part4DamageProvider)!,
                                    amount: amount ?? 0);
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
          ],
        ),
      )),
    );
  }
}

final part1DamageProvider = StateProvider<File?>((ref) => null);
final part2DamageProvider = StateProvider<File?>((ref) => null);
final part3DamageProvider = StateProvider<File?>((ref) => null);
final part4DamageProvider = StateProvider<File?>((ref) => null);
final validateClaimDocProvider = StateProvider<bool>((ref) => false);
