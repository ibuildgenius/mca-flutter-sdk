import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/generic_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/generic_dialog.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/repair_estimate_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';
import 'package:path/path.dart' as p;

class RepairEstimateScreen extends StatefulHookConsumerWidget {
  final ClaimModel claim;

  const RepairEstimateScreen({
    super.key,
    required this.claim,
  });

  @override
  ConsumerState<RepairEstimateScreen> createState() =>
      _RepairEstimateScreenState();
}

class _RepairEstimateScreenState extends ConsumerState<RepairEstimateScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  int? amount;
  File? selectedInvoice;

  @override
  Widget build(BuildContext context) {
    final claimVM = ref.watch(claimVmProvider);

//     @override
// Widget build(BuildContext context) {
//   final claimVM = ref.watch(claimVmProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              verticalSpacer(20),
              CustomAppbar(
                showLogo: false,
                showBackButton: false,
                onBackTap: Navigator.canPop(context)
                    ? () => Navigator.pop(context)
                    : null,
              ),
              semiBoldText("Provide estimate of repair", fontSize: 20),
              verticalSpacer(20),

              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  // keyboardDismissBehavior:
                  //     ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Intro card
                      Container(
                        decoration: const BoxDecoration(
                            color: CustomColors.backBorderColor),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 100.0, left: 10, top: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalSpacer(10),
                                  semiBoldText("Estimate of repair invoice",
                                      fontSize: 16),
                                  verticalSpacer(10),
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text:
                                            "This is an invoice from a registered mechanic.  Click the ",
                                        style: CustomTextStyles.regular(
                                          fontSize: 14,
                                          color: CustomColors.formTitleColor,
                                          height: 1.2,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "help button ",
                                        style: CustomTextStyles.semiBold(
                                          fontSize: 15,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                          height: 1.4,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "above to learn more",
                                        style: CustomTextStyles.regular(
                                          fontSize: 14,
                                          color: CustomColors.blackTextColor,
                                          height: 1.2,
                                        ),
                                      ),
                                    ]),
                                    softWrap: true,
                                  ),
                                  verticalSpacer(6),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.asset(
                                ConstantString.invoiceImg,
                                height: 60,
                                package: 'mca_official_flutter_sdk',
                              ),
                            ),
                          ],
                        ),
                      ),

                      verticalSpacer(30),

                      // Upload tile
                      GestureDetector(
                        onTap: selectedInvoice != null
                            ? () => setState(() => selectedInvoice = null)
                            : () => GenericDialog().showSelectImageDialog2(
                                  context: context,
                                  onCameraPressed: () =>
                                      _pickFrom(ImageSource.camera, context),
                                  onGalleryPressed: () =>
                                      _pickFrom(ImageSource.gallery, context),
                                ),
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
                                    width: 0.8),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    selectedInvoice == null
                                        ? ConstantString.uploadInvoice
                                        : ConstantString.deleteInvoice,
                                    package: 'mca_official_flutter_sdk',
                                  ),
                                  verticalSpacer(5),
                                  if (selectedInvoice == null)
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                          text: "Click ",
                                          style: CustomTextStyles.w500(
                                            fontSize: 12,
                                            color: CustomColors
                                                .primaryBrandColor(),
                                            height: 1.2,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "to upload Repair Invoice",
                                          style: CustomTextStyles.regular(
                                            fontSize: 12.5,
                                            color: CustomColors.blackTextColor,
                                            height: 1.2,
                                          ),
                                        ),
                                      ]),
                                      textAlign: TextAlign.center,
                                    )
                                  else
                                    Text(
                                      p.basename(selectedInvoice?.path ?? ''),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: CustomTextStyles.regular(
                                        fontSize: 14.5,
                                        color: CustomColors.primaryBrandColor(),
                                        height: 1.25,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      verticalSpacer(40),

                      // Amount
                      customFormTextField(
                        'estimateAmount',
                        title: 'Enter estimate amount',
                        hintText: "Enter estimate amount",
                        isNumber: true,
                        isCurrency: true,
                        onChanged: (value) {
                          setState(() {
                            amount = value == null
                                ? 0
                                : int.tryParse(value.replaceAll(",", "")) ?? 0;
                          });
                        },
                      ),

                      verticalSpacer(20),
                    ],
                  ),
                ),
              ),

              // Sticky footer (buttons + footer), padded over keyboard
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: "Do this later",
                            buttonColor: CustomColors.dividerGreyColor,
                            textColor: CustomColors.backTextColor,
                            fontSize: 14,
                            onTap: () {
                              showGenericBottomSheet(
                                context,
                                title: "Do this later",
                                showBackButton: false,
                                okText: "Ok, continue",
                                onOkPressed: () {
                                  MyCoverAI.exitSDK(context);
                                  // Navigator.of(context).popUntil((route) {
                                  //   return route.settings.arguments ==
                                  //       ConstantString.initialScreenKey;
                                  // });
                                  // Navigator.of(context).pop();
                                },
                                child: const RepairEstimateWidget(),
                              );
                            },
                          ),
                        ),
                        horizontalSpacer(10),
                        Expanded(
                          child: CustomButton(
                            title: "Continue",
                            fontSize: 14,
                            onTap: (amount == null ||
                                    amount == 0 ||
                                    selectedInvoice == null)
                                ? null
                                : () {
                                    GenericDialog().showGenericSimplePopup(
                                      context: context,
                                      title: "Estimate of repair",
                                      content:
                                          "You are about to send an estimate of repair, are you sure you want to proceed with this action?",
                                      okText: "Yes, proceed",
                                      onOkPressed: () async {
                                        // Navigator.of(context,
                                        //         rootNavigator: true)
                                        //     .pop();
                                        if (widget.claim.policy
                                                ?.meta["vehicle_make"] !=
                                            null) {
                                          await claimVM
                                              .submitVehicleClaimEstimate(
                                            ref: ref,
                                            context: context,
                                            estimateAmount: amount ?? 0,
                                            selectedInvoice: selectedInvoice!,
                                          );
                                        } else {
                                          await claimVM
                                              .submitDeviceClaimEstimate(
                                            ref: ref,
                                            context: context,
                                            estimateAmount: amount ?? 0,
                                            selectedInvoice: selectedInvoice!,
                                            claim: widget.claim,
                                          );
                                        }
                                      },
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                    verticalSpacer(20),
                    const PoweredByFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//     return Scaffold(
//       // backgroundColor: CustomColors.whiteColor,
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//           child: FormBuilder(
//         key: formKey,
//         child: Column(
//           children: [
//             verticalSpacer(20),
//             CustomAppbar(
//               // showHelp: true,
//               showLogo: false,
//               showBackButton: false,
//               onBackTap: Navigator.canPop(context)
//                   ? () => Navigator.pop(context)
//                   : null,
//               // logoUrl: ref.watch(businessDetailsProvider)?.logo,
//             ),
//             semiBoldText(
//               "Provide estimate of repair",
//               fontSize: 20,
//             ),
//             verticalSpacer(20),
//             Expanded(
//               // height: MediaQuery.of(context).size.height - 250,
//               child: LayoutBuilder(builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   child: SizedBox(
//                     height: constraints.maxHeight,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 Container(
//                                   // height: 100,
//                                   width: double.infinity,
//                                   decoration: const BoxDecoration(
//                                     color: CustomColors.backBorderColor,
//                                   ),
//                                   child: Stack(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                           right: 100.0,
//                                           left: 10,
//                                           top: 10,
//                                           bottom: 10,
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             verticalSpacer(10),
//                                             semiBoldText(
//                                               "Estimate of repair invoice",
//                                               fontSize: 16,
//                                             ),
//                                             verticalSpacer(10),
//                                             RichText(
//                                               text: TextSpan(
//                                                 children: [
//                                                   TextSpan(
//                                                     text:
//                                                         "This is an invoice from a registered mechanic.  Click the ",
//                                                     style: CustomTextStyles
//                                                         .regular(
//                                                       fontSize: 14,
//                                                       color: CustomColors
//                                                           .formTitleColor,
//                                                       height: 1.2,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text: "help button ",
//                                                     style: CustomTextStyles
//                                                         .semiBold(
//                                                       fontSize: 15,
//                                                       color: CustomColors
//                                                           .primaryBrandColor(),
//                                                       height: 1.4,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text: "above to learn more",
//                                                     style: CustomTextStyles
//                                                         .regular(
//                                                       fontSize: 14,
//                                                       color: CustomColors
//                                                           .blackTextColor,
//                                                       height: 1.2,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             verticalSpacer(6),
//                                           ],
//                                         ),
//                                       ),
//                                       Positioned(
//                                         bottom: 0,
//                                         right: 0,
//                                         child: Container(
//                                           decoration: const BoxDecoration(
//                                             //HELP
//                                             shape: BoxShape.circle,
//                                             // color: CustomColors.lightBlackColor,
//                                           ),
//                                           child: Center(
//                                             child: Image.asset(
//                                               ConstantString.invoiceImg,
//                                               height: 60,
//                                               package:
//                                                   'mca_official_flutter_sdk',
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 verticalSpacer(30),
//                                 GestureDetector(
//                                   onTap: selectedInvoice != null
//                                       ? () async {
//                                           setState(() {
//                                             selectedInvoice = null;
//                                           });
//                                         }
//                                       : () async {
//                                           File? selectedImage;
//                                           await GenericDialog()
//                                               .showSelectImageDialog2(
//                                             context: context,
//                                             onCameraPressed: () => _pickFrom(
//                                                 ImageSource.camera, context),
//                                             onGalleryPressed: () => _pickFrom(
//                                                 ImageSource.gallery, context),
//                                           );
// //                                           await GenericDialog()
// //                                               .showSelectImageDialog2(
// //                                             context: context,
// //                                             onCameraPressed: () async {
// //                                               selectedImage = await selectImage(
// //                                                   ImageSource.camera);
// //                                               if (selectedImage != null) {
// //                                                 setState(() {
// //                                                   selectedInvoice =
// //                                                       selectedImage;
// //                                                 });
// //                                                 // GenericDialog().previewImageDialog(
// //                                                 //   context: context,
// //                                                 //   selectedImage: selectedImage!,
// //                                                 //   onNoPressed: () {
// //                                                 //     selectedImage = null;
// //                                                 //     Navigator.pop(context);
// //                                                 //     return;
// //                                                 //   },
// //                                                 //   onOkPressed: () {
// //                                                 //     Navigator.pop(context);
// //                                                 //     if (selectedImage != null) {
// //                                                 //       //
// //                                                 //     }
// //                                                 //   },
// //                                                 // );
// //                                               }
// //                                             },
// //                                             onGalleryPressed: () async {
// //                                               selectedImage = await selectImage(
// //                                                   ImageSource.gallery);
// //                                               if (selectedImage != null) {
// //                                                 setState(() {
// //                                                   selectedInvoice =
// //                                                       selectedImage;
// //                                                 });
// //                                               }
// //                                             },
// //                                           );
//                                         },
//                                   child: DottedBorder(
//                                     color: CustomColors.checkBoxBorderColor,
//                                     // strokeWidth: 2,
//                                     dashPattern: const [10, 10],
//                                     borderType: BorderType.RRect,
//                                     radius: const Radius.circular(5),
//                                     padding: EdgeInsets.zero,
//                                     child: ClipRRect(
//                                       borderRadius:
//                                           BorderRadiusDirectional.circular(5),
//                                       child: Container(
//                                         width: double.infinity,
//                                         // height: 46,
//                                         decoration: BoxDecoration(
//                                           color: CustomColors.backBorderColor,
//                                           border: Border.all(
//                                               color:
//                                                   CustomColors.dividerGreyColor,
//                                               width: 0.8),
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                         ),
//                                         child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 10.0,
//                                               vertical: 10,
//                                             ),
//                                             child: Column(
//                                               children: [
//                                                 SvgPicture.asset(
//                                                   selectedInvoice == null
//                                                       ? ConstantString
//                                                           .uploadInvoice
//                                                       : ConstantString
//                                                           .deleteInvoice,
//                                                   package:
//                                                       'mca_official_flutter_sdk',
//                                                 ),
//                                                 verticalSpacer(5),
//                                                 selectedInvoice == null
//                                                     ? RichText(
//                                                         text: TextSpan(
//                                                           children: [
//                                                             TextSpan(
//                                                               text: "Click ",
//                                                               style:
//                                                                   CustomTextStyles
//                                                                       .w500(
//                                                                 fontSize: 12,
//                                                                 color: CustomColors
//                                                                     .primaryBrandColor(),
//                                                                 height: 1.2,
//                                                               ),
//                                                             ),
//                                                             TextSpan(
//                                                               text:
//                                                                   "to upload Repair Invoice",
//                                                               style:
//                                                                   CustomTextStyles
//                                                                       .regular(
//                                                                 fontSize: 12.5,
//                                                                 color: CustomColors
//                                                                     .blackTextColor,
//                                                                 height: 1.2,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       )
//                                                     : regularText(
//                                                         p.basename(
//                                                             selectedInvoice
//                                                                     ?.path ??
//                                                                 ''),
//                                                         // selectedInvoice?.path ??
//                                                         // "",
//                                                         fontSize: 14.5,
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         color: CustomColors
//                                                             .primaryBrandColor(),
//                                                       ),
//                                               ],
//                                             )),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 verticalSpacer(40),
//                                 customFormTextField(
//                                   'estimateAmount',
//                                   title: 'Enter estimate amount',
//                                   hintText: "Enter estimate amount",
//                                   isNumber: true,
//                                   isCurrency: true,
//                                   // autovalidateMode: ref.watch(autoValidateProvider) == true
//                                   //     ? AutovalidateMode.onUserInteraction
//                                   //     : AutovalidateMode.disabled,

//                                   onChanged: (value) {
//                                     setState(() {
//                                       amount = value == null
//                                           ? 0
//                                           : int.parse(
//                                               value.replaceAll(",", ""));
//                                     });
//                                   },
//                                 ),
//                                 // const Spacer(),
//                               ],
//                             ),
//                           ),
//                           // const Spacer(),

//                           Row(
//                             // mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Expanded(
//                                 child: CustomButton(
//                                   title: "Do this later",
//                                   buttonColor: CustomColors.dividerGreyColor,
//                                   textColor: CustomColors.backTextColor,
//                                   fontSize: 14,
//                                   onTap: () {
//                                     showGenericBottomSheet(context,
//                                         title: "Do this later",
//                                         showBackButton: false,
//                                         okText: "Ok, continue",
//                                         onOkPressed: () {
//                                       // Navigator.of(context)
//                                       //     .popUntil((route) => route.isFirst);

//                                       ///CHECK HERE
//                                       ///
//                                       Navigator.of(context).popUntil((route) {
//                                         return route.settings.arguments ==
//                                             ConstantString.initialScreenKey;
//                                       });
//                                       Navigator.of(context).pop();
//                                     }, child: const RepairEstimateWidget());
//                                   },
//                                 ),
//                               ),
//                               horizontalSpacer(10),
//                               Expanded(
//                                 child: CustomButton(
//                                   title: "Continue",
//                                   fontSize: 14,
//                                   onTap: amount == 0 ||
//                                           amount == null ||
//                                           selectedInvoice == null
//                                       ? null
//                                       : () {
//                                           GenericDialog().showGenericSimplePopup(
//                                               context: context,
//                                               // isLoading: claimVM.isLoading,
//                                               title: "Estimate of repair",
//                                               content: "You are about to send an estimate of repair, are you sure you want to proceed with this action?",
//                                               okText: "Yes, proceed",
//                                               onOkPressed: () async {
//                                                 if (widget.claim.policy?.meta[
//                                                         "vehicle_make"] !=
//                                                     null) {
//                                                   await claimVM
//                                                       .submitVehicleClaimEstimate(
//                                                     ref: ref,
//                                                     context: context,
//                                                     estimateAmount: amount ?? 0,
//                                                     selectedInvoice:
//                                                         selectedInvoice!,
//                                                   );
//                                                 } else {
//                                                   print(widget.claim.policy);
//                                                   await claimVM
//                                                       .submitDeviceClaimEstimate(
//                                                     ref: ref,
//                                                     context: context,
//                                                     estimateAmount: amount ?? 0,
//                                                     selectedInvoice:
//                                                         selectedInvoice ??
//                                                             File(''),
//                                                     claim: widget.claim,
//                                                   );
//                                                 }
//                                               });
//                                           // Navigator.pop(context);
//                                         },
//                                   // fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           verticalSpacer(20),
//                           const PoweredByFooter(),
//                           verticalSpacer(
//                               MediaQuery.of(context).padding.bottom + 10)
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       )),
//     );

  bool _isPicking = false;

  Future<void> _pickFrom(ImageSource source, BuildContext context) async {
    if (_isPicking) return; // guard double taps
    _isPicking = true;
    Navigator.of(context, rootNavigator: true).pop(); // close sheet first
    try {
      final file = await selectImage(source); // await picker
      if (!context.mounted) return;
      if (file != null) setState(() => selectedInvoice = file);
    } finally {
      _isPicking = false;
    }
  }
}
