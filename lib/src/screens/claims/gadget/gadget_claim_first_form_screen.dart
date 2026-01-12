import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/generic_dialog.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_summary.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_date_picker.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_list_dropdown_field.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_list_dropdown_multiselect_field.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/custom_time_picker.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';
import 'package:path/path.dart' as p;

import '../claim_first_form_screen.dart';

class GadgetClaimFirstFormScreen extends StatefulHookConsumerWidget {
  final PolicyModel policy;

  const GadgetClaimFirstFormScreen({super.key, required this.policy});

  @override
  ConsumerState<GadgetClaimFirstFormScreen> createState() =>
      _GadgetClaimFirstFormScreenState();
}

class _GadgetClaimFirstFormScreenState
    extends ConsumerState<GadgetClaimFirstFormScreen> {
  int value = 0;
  bool showFirstForm = true;
  String? incidentLocation;
  String? whatHappened;
  String? thirdPhoneNumber;
  bool? isFormOneValid = false;
  bool? isFormOTwoValid = false;
  bool _cameraOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.invalidate(receiptImageProvider);
      ref.invalidate(damagedPartImageProvider);
      ref.invalidate(damageTypeProvider);

      List<String> benefits = [];
      ref.read(claimBenefitsProvider.notifier).state?.clear();
      benefits = await ref
          .read(claimVmProvider.notifier)
          .claimBenefits(widget.policy.id!);
      ref.read(claimBenefitsProvider.notifier).state = benefits;
    });
  }

  void validateForm1() {
    final incidentType = ref.read(incidentTypeProvider);
    final damageTypes = ref.read(damageTypeProvider);
    final incidentDate = ref.read(dateOfIncidentProvider);
    final incidentTime = ref.read(accidentTimeProvider);

    isFormOneValid = incidentType != null &&
        damageTypes.isNotEmpty &&
        incidentDate != null &&
        incidentTime != null;
    setState(() {});
  }

  void validateForm2() {
    final damageTypes = ref.read(damageTypeProvider);
    final receipt = ref.read(receiptImageProvider);
    final damagedPart = ref.read(damagedPartImageProvider);
    final liquidPart = ref.read(liquidProvider);

    bool isValid = true;

    if (incidentLocation == null || incidentLocation!.trim().isEmpty) {
      isValid = false;
    }

    if (whatHappened == null || whatHappened!.trim().length < 150) {
      isValid = false;
    }

    if (receipt == null) {
      isValid = false;
    }

    if (damageTypes.contains('Screen Damage') && damagedPart == null) {
      isValid = false;
    }

    if (damageTypes.contains('Liquid Damage') && liquidPart == null) {
      isValid = false;
    }

    isFormOTwoValid = isValid;
    setState(() {});
  }

  /// Helper to pick image and handle _cameraOpen
  Future<void> pickImage(File? Function(File?) setter, ImageSource src) async {
    setState(() => _cameraOpen = true); // Camera is opening
    final picked = await selectImage(src); // Your helper to pick image
    setState(() => _cameraOpen = false); // Camera closed

    if (picked != null) {
      setter(picked);
      validateForm2();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(damageTypeProvider, (_, __) => validateForm2());
    ref.listen(receiptImageProvider, (_, __) => validateForm2());
    ref.listen(damagedPartImageProvider, (_, __) => validateForm2());
    ref.listen(liquidProvider, (_, __) => validateForm2());
    ref.listen(whatHappenProvider, (_, __) => validateForm2());
    ref.listen(accidentLocationProvider, (_, __) => validateForm2());

    final claimVM = ref.watch(claimVmProvider);
    final gadgetDetails = [
      widget.policy.meta["device_make"] ?? "",
      widget.policy.meta["device_model"] ?? "",
      widget.policy.meta["year_of_manufacture"] ?? "",
    ].where((part) => part.trim().isNotEmpty).join(' ');

    return WillPopScope(
      onWillPop: () async {
        // 1. Close keyboard if open
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
          return false;
        }

        // 2. Prevent pop if camera is open
        if (_cameraOpen) return false;

        // 3. Normal navigation logic → use Navigator.canPop
        return Navigator.canPop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              verticalSpacer(20),
              CustomAppbar(
                showLogo: false,
                showBackButton: true,
                onBackTap: showFirstForm == false
                    ? () => setState(() => showFirstForm = true)
                    : Navigator.canPop(context)
                        ? () => Navigator.pop(context)
                        : null,
              ),
              verticalSpacer(20),
              Expanded(
                child: IndexedStack(
                  index: showFirstForm ? 0 : 1,
                  children: [
                    // FORM 1
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          GadgetDetail(
                              gadgetDetails: gadgetDetails, widget: widget),
                          verticalSpacer(20),
                          CustomListDropdownField(
                            fieldName: 'Select Incident type',
                            selectedItem: incidentTypeProvider,
                            label: "Select Incident type",
                            description: "Select Incident type",
                            items: const ['Damage'],
                          ),
                          verticalSpacer(10),
                          CustomListDropdownMultiSelectField(
                            label: "Select Damage type",
                            description: "Select Damage type",
                            selectedLItems: damageTypeProvider,
                            items: ref.watch(claimBenefitsProvider) ?? [],
                          ),
                          CustomMiniDatePicker(
                              label: "Enter date of incident",
                              description: "dd/mm/yyyy",
                              isTodayMax: true,
                              minDate: 12,
                              selectedDate: dateOfIncidentProvider),
                          verticalSpacer(10),
                          CustomMiniTimePicker(
                              label: "Incident closest time",
                              description: "--:-- --",
                              isTodayMax: true,
                              minDate: 12,
                              selectedTime: accidentTimeProvider),
                          verticalSpacer(20),
                          CustomButton(
                            title: "Continue",
                            onTap: ref.watch(accidentTimeProvider) == null ||
                                    ref.watch(dateOfIncidentProvider) == null ||
                                    ref.watch(incidentTypeProvider) == null ||
                                    ref.watch(damageTypeProvider).isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      showFirstForm = false;
                                    });
                                  },
                          ),
                          verticalSpacer(25),
                          const PoweredByFooter()
                        ],
                      ),
                    ),

                    // FORM 2
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          semiBoldText("Submit your claim", fontSize: 20),
                          verticalSpacer(20),
                          GadgetDetail(
                              gadgetDetails: gadgetDetails, widget: widget),
                          verticalSpacer(20),
                          customFormTextField(
                            'incidentLocation',
                            title: 'Enter incident location',
                            hintText: "Enter incident location",
                            onChanged: (value) {
                              incidentLocation = value;
                              ref
                                  .read(accidentLocationProvider.notifier)
                                  .state = value;
                              validateForm2();
                              setState(() {});
                            },
                            suffixIcon: Icons.location_on_outlined,
                          ),
                          verticalSpacer(15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: mediumText(
                              'Evidence of payment',
                              fontSize: 14.sp,
                              color: CustomColors.formTitleColor,
                            ),
                          ),
                          verticalSpacer(8),
                          ImageUploadField(
                            placeholderText:
                                "Gadget Receipt/ Evidence of Payment",
                            provider: receiptImageProvider,
                            selectedFile: (file) {
                              validateForm2();
                              setState(() {});
                            },
                          ),
                          verticalSpacer(20),
                          if (ref
                              .watch(damageTypeProvider)
                              .contains('Screen Damage'))
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: mediumText(
                                    "Damaged part image",
                                    fontSize: 14.sp,
                                    color: CustomColors.formTitleColor,
                                  ),
                                ),
                                verticalSpacer(8),
                                ImageUploadField(
                                  placeholderText: "Damaged part image",
                                  provider: damagedPartImageProvider,
                                  selectedFile: (file) {
                                    validateForm2();
                                  },
                                  onCameraOpen: () {
                                    setState(() => _cameraOpen = true);
                                  },
                                ),
                              ],
                            ),
                          if (ref
                              .watch(damageTypeProvider)
                              .contains('Liquid Damage'))
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: mediumText(
                                    "Liquid damaged part image",
                                    fontSize: 14.sp,
                                    color: CustomColors.formTitleColor,
                                  ),
                                ),
                                verticalSpacer(8),
                                ImageUploadField(
                                  placeholderText: "Liquid damaged part image",
                                  provider: liquidProvider,
                                  selectedFile: (file) {
                                    validateForm2();
                                  },
                                ),
                              ],
                            ),
                          verticalSpacer(20),
                          customFormTextField(
                            'whatHappened',
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            title: 'State how it happened',
                            hintText: "Describe how it happened",
                            maxLines: 5,
                            onChanged: (value) {
                              whatHappened = value;
                              ref.read(whatHappenProvider.notifier).state =
                                  value;
                              validateForm2();
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              }
                              if (value.trim().length < 150) {
                                return 'Please enter at least 150 characters';
                              }
                              return null; // valid
                            },
                          ),
                          verticalSpacer(20),
                          CustomButton(
                            title: "Continue",
                            isLoading: claimVM.isLoading,
                            onTap: isFormOTwoValid == true
                                ? () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClaimSummaryScreen(
                                          incidentType:
                                              ref.watch(incidentTypeProvider) ??
                                                  "",
                                          incidentDate: ref.watch(
                                                  dateOfIncidentProvider) ??
                                              "",
                                          incidentTime:
                                              ref.watch(accidentTimeProvider) ??
                                                  "",
                                          lossType:
                                              ref.watch(damageTypeProvider),
                                          incidentLocation: ref.watch(
                                                  accidentLocationProvider) ??
                                              incidentLocation ??
                                              '',
                                          isThirdParty:
                                              value == 0 ? false : true,
                                          description:
                                              ref.watch(whatHappenProvider) ??
                                                  whatHappened ??
                                                  " ",
                                          thirdPartyLossType: ref.watch(
                                              thirdPartyDamageTypeProvider),
                                          thirdPartyPhoneNumber:
                                              thirdPhoneNumber ?? "",
                                          fileReceipt:
                                              ref.read(receiptImageProvider),
                                          fileLiquidDamage:
                                              ref.read(liquidProvider),
                                          fileDamagedPart: ref
                                              .read(damagedPartImageProvider),
                                          claimType: "Device",
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                          verticalSpacer(25),
                          const PoweredByFooter()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GadgetDetail extends StatelessWidget {
  const GadgetDetail({
    super.key,
    required this.gadgetDetails,
    required this.widget,
  });

  final String gadgetDetails;
  final GadgetClaimFirstFormScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  "Gadget name",
                  fontSize: 13,
                  color: CustomColors.greyTextColor,
                ),
                verticalSpacer(2),
                semiBoldText(
                  gadgetDetails,
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
                  widget.policy.meta["device_serial_number"] ?? "",
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
                child: SvgPicture.asset(
                  ConstantString.gadgetsIcon,
                  height: 60,
                  package: 'mca_official_flutter_sdk',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageUploadField extends ConsumerWidget {
  final String placeholderText;
  final StateProvider<File?> provider;
  final Function(File?)? selectedFile;
  final VoidCallback? onCameraOpen; // optional

  const ImageUploadField({
    super.key,
    this.selectedFile,
    this.onCameraOpen,
    required this.placeholderText,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(provider);

    return GestureDetector(
      onTap: selectedImage == null
          ? () async {
              File? pickedFile;

              await GenericDialog().showSelectImageDialog2(
                context: context,
                onCameraPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();

                  // Notify parent that camera is opening
                  onCameraOpen?.call();

                  pickedFile = await selectImage(ImageSource.camera);
                  if (pickedFile != null) {
                    ref.read(provider.notifier).state = pickedFile;
                    selectedFile?.call(pickedFile);
                  }
                },
                onGalleryPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  pickedFile = await selectImage(ImageSource.gallery);
                  if (pickedFile != null) {
                    ref.read(provider.notifier).state = pickedFile;
                    selectedFile?.call(pickedFile);
                  }
                },
              );
            }
          : () {
              ref.read(provider.notifier).state = null;
            },
      child: DottedBorder(
        color: CustomColors.checkBoxBorderColor,
        dashPattern: const [10, 10],
        borderType: BorderType.RRect,
        radius: const Radius.circular(5),
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadiusDirectional.circular(5),
          child: Container(
            width: double.infinity,
            height: 54.h,
            decoration: BoxDecoration(
              color: CustomColors.backBorderColor,
              border:
                  Border.all(color: CustomColors.dividerGreyColor, width: 0.8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: selectedImage == null
                                      ? Text(
                                          "Upload",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: CustomColors.greyTextColor,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.image,
                                          color: CustomColors.formHintColor,
                                          size: 20,
                                        ),
                                ),
                                WidgetSpan(child: SizedBox(width: 10.w)),
                                TextSpan(
                                  text: selectedImage == null
                                      ? placeholderText
                                      : p.basename(selectedImage.path),
                                  style: CustomTextStyles.w500(
                                    fontSize: 12,
                                    color: CustomColors.backTextColor,
                                  ),
                                ),
                              ],
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: selectedImage == null
                          ? CustomColors.lightPrimaryBrandColor()
                          : Colors.red.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Center(
                        child: mediumText(
                          selectedImage == null ? "Upload" : "Remove",
                          fontSize: 13.sp,
                          color: selectedImage == null
                              ? CustomColors.primaryBrandColor()
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ImageUploadField extends ConsumerWidget {
//   final String placeholderText;
//   final StateProvider<File?> provider;
//   final Function(File)? selectedFile;
//
//   const ImageUploadField({
//     super.key,
//     this.selectedFile,
//     required this.placeholderText,
//     required this.provider,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedImage = ref.watch(provider);
//
//     return GestureDetector(
//       onTap: selectedImage == null
//           ? () async {
//               File? pickedFile;
//
//               await GenericDialog().showSelectImageDialog2(
//                 context: context,
//                 onCameraPressed: () async {
//                   Navigator.of(context, rootNavigator: true).pop();
//                   pickedFile = await selectImage(ImageSource.camera);
//                   if (pickedFile != null) {
//                     ref.read(provider.notifier).state = pickedFile;
//                     selectedFile!(pickedFile!);
//                   }
//                   // Navigator.pop(context);
//                 },
//                 onGalleryPressed: () async {
//                   Navigator.of(context, rootNavigator: true).pop();
//                   pickedFile = await selectImage(ImageSource.gallery);
//                   if (pickedFile != null) {
//                     ref.read(provider.notifier).state = pickedFile;
//                     selectedFile!(pickedFile!);
//                   }
//                 },
//               );
//             }
//           : () {
//               ref.read(provider.notifier).state = null;
//             },
//       child: DottedBorder(
//         color: CustomColors.checkBoxBorderColor,
//         dashPattern: const [10, 10],
//         borderType: BorderType.RRect,
//         radius: const Radius.circular(5),
//         padding: EdgeInsets.zero,
//         child: ClipRRect(
//           borderRadius: BorderRadiusDirectional.circular(5),
//           child: Container(
//             width: double.infinity,
//             height: 54.h,
//             decoration: BoxDecoration(
//               color: CustomColors.backBorderColor,
//               border:
//                   Border.all(color: CustomColors.dividerGreyColor, width: 0.8),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                       child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: RichText(
//                           text: TextSpan(
//                             children: [
//                               WidgetSpan(
//                                 alignment: PlaceholderAlignment.middle,
//                                 child: selectedImage == null
//                                     ? Text(
//                                         "Upload",
//                                         style: TextStyle(
//                                           fontSize: 13.sp,
//                                           color: CustomColors.greyTextColor,
//                                         ),
//                                       )
//                                     : const Icon(
//                                         Icons.image,
//                                         color: CustomColors.formHintColor,
//                                         size: 20,
//                                       ),
//                               ),
//                               WidgetSpan(child: SizedBox(width: 10.w)),
//                               TextSpan(
//                                 text: selectedImage == null
//                                     ? placeholderText
//                                     : p.basename(selectedImage.path),
//                                 style: CustomTextStyles.w500(
//                                   fontSize: 12,
//                                   color: CustomColors.backTextColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           softWrap: true,
//                           overflow: TextOverflow.visible,
//                         ),
//                       ),
//                     ],
//                   )),
//                   Container(
//                     height: 35,
//                     decoration: BoxDecoration(
//                       color: selectedImage == null
//                           ? CustomColors.lightPrimaryBrandColor()
//                           : Colors.red.withOpacity(0.07),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24.w),
//                       child: Center(
//                         child: mediumText(
//                           selectedImage == null ? "Upload" : "Remove",
//                           fontSize: 13.sp,
//                           color: selectedImage == null
//                               ? CustomColors.primaryBrandColor()
//                               : Colors.red,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ImageUploadField2 extends ConsumerWidget {
  final String providerKey; // unique per field
  final String placeholderText;
  final ValueChanged<File?>? onChanged; // null = removed

  const ImageUploadField2({
    super.key,
    required this.providerKey,
    required this.placeholderText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(fileImageProviderFamily(providerKey));

    Future<void> pick(ImageSource src) async {
      final picked = await selectImage(src); // your helper
      if (picked != null) {
        ref.read(fileImageProviderFamily(providerKey).notifier).state = picked;
        onChanged?.call(picked);
      }
    }

    return GestureDetector(
      onTap: selectedImage == null
          ? () async {
              await GenericDialog().showSelectImageDialog2(
                context: context,
                onCameraPressed: () => pick(ImageSource.camera),
                onGalleryPressed: () => pick(ImageSource.gallery),
              );
            }
          : () {
              ref.read(fileImageProviderFamily(providerKey).notifier).state =
                  null;
              onChanged?.call(null);
            },
      child: DottedBorder(
        color: CustomColors.checkBoxBorderColor,
        dashPattern: const [10, 10],
        borderType: BorderType.RRect,
        radius: const Radius.circular(5),
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadiusDirectional.circular(5),
          child: Container(
            width: double.infinity,
            height: 54.h,
            decoration: BoxDecoration(
              color: CustomColors.backBorderColor,
              border:
                  Border.all(color: CustomColors.dividerGreyColor, width: 0.8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: selectedImage == null
                                      ? Text(
                                          "Upload",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: CustomColors.greyTextColor,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.image,
                                          color: CustomColors.formHintColor,
                                          size: 20,
                                        ),
                                ),
                                WidgetSpan(child: SizedBox(width: 10.w)),
                                TextSpan(
                                  text: selectedImage == null
                                      ? placeholderText
                                      : p.basename(selectedImage.path),
                                  style: CustomTextStyles.w500(
                                    fontSize: 14,
                                    color: CustomColors.backTextColor,
                                  ),
                                ),
                              ],
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: selectedImage == null
                          ? CustomColors.lightPrimaryBrandColor()
                          : Colors.red.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Center(
                        child: mediumText(
                          selectedImage == null ? "Upload" : "Remove",
                          fontSize: 13.sp,
                          color: selectedImage == null
                              ? CustomColors.primaryBrandColor()
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
final accidentLocationProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final damagePartNameProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final whatHappenProvider = StateProvider.autoDispose<String?>((ref) => null);

// final damageTypeProvider = StateProvider<List<String>>((ref) => []);

final damagedPartImageProvider = StateProvider<File?>((ref) => null);
final receiptImageProvider = StateProvider<File?>((ref) => null);
final liquidProvider = StateProvider<File?>((ref) => null);
final claimBenefitsProvider = StateProvider<List<String>?>((ref) => null);

final fileImageProviderFamily =
    StateProvider.family<File?, String>((ref, key) => null);
