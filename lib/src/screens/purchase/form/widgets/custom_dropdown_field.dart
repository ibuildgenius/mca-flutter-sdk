// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/form_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class CustomDropdownField extends StatefulHookConsumerWidget {
  final String fieldName, dataUrl, label, description;
  final String? dependsOn;
  final StateProvider<Map<String, dynamic>>? customProvider;
  void Function()? onPageRefresh, onClearFocus;
  final int? filteredFieldsLength;
  GlobalKey<FormBuilderState>? formKey;
  final FormViewModel? formVM;
  bool isLastPage;
  CustomDropdownField({
    super.key,
    required this.fieldName,
    required this.dataUrl,
    required this.label,
    required this.description,
    this.dependsOn,
    this.customProvider,
    this.filteredFieldsLength,
    this.formVM,
    this.formKey,
    this.onPageRefresh,
    required this.onClearFocus,
    this.isLastPage = false,
  });

  @override
  ConsumerState<CustomDropdownField> createState() =>
      _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends ConsumerState<CustomDropdownField> {
  Timer? debounce;

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(urlFormDataProvider)[widget.fieldName] != null
          ? returnTrue()
          : FormViewModel.initWhoAmI().getListData(
              context: context,
              ref: ref,
              dataUrl: widget.dataUrl,
              fieldName: widget.fieldName,
              dependsOn: widget.dependsOn,
            );
    });

    //     future:
  }

  @override
  Widget build(BuildContext context) {
    FocusNode myNode = FocusNode();
    final formErrors = ref.watch(formErrorsProvider);
    final shouldValidate = ref.watch(shouldValidateImageplusDrop);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mediumText(
          widget.label,
          fontSize: 14.sp,
          color: CustomColors.formTitleColor,
        ),
        verticalSpacer(8.sp),
        Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            color: CustomColors.backBorderColor,
            border:
                Border.all(color: CustomColors.dividerGreyColor, width: 0.8),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 10.0,
              // left: 30,
            ),
            child: DropdownButtonHideUnderline(
              child: Listener(
                // onPointerDown: (_) => FocusScope.of(context).unfocus(),
                onPointerDown: (_) => FocusScope.of(context).requestFocus(
                  FocusNode(),
                ),
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Text(
                    widget.description,
                    style: CustomTextStyles.regular(
                        fontSize: 14.sp, color: CustomColors.formHintColor),
                    maxLines: 1,
                  ),
                  selectedItemBuilder:
                      ref.watch(urlFormDataProvider)[widget.fieldName] == null
                          ? null
                          : (BuildContext context) {
                              return ref
                                  .watch(urlFormDataProvider)[widget.fieldName]!
                                  .map<Widget>((room) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      room.name.toString(),
                                      style: CustomTextStyles.regular(
                                          fontSize: 15.sp,
                                          color: CustomColors.blackTextColor),
                                      maxLines: 1,
                                    ),
                                  ],
                                );
                              }).toList();
                            },

                  items: ref
                      .watch(urlFormDataProvider)[widget.fieldName]
                      ?.map<DropdownMenuItem<Object>>((room) {
                    return DropdownMenuItem<Object>(
                      value: room.name,
                      child: Text(
                        room.name.toString(),
                        style: CustomTextStyles.regular(
                          fontSize: 14.sp,
                          color: CustomColors.greyTextColor,
                        ),
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  value: widget.customProvider != null
                      ? ref.watch(widget.customProvider!)[widget.fieldName]
                      : ref.watch(formDataProvider)[widget.fieldName],

                  onChanged: (value) async {
                    if (widget.onClearFocus != null) {
                      widget.onClearFocus!();
                    }
                    // FocusScope.of(context).unfocus();
                    setState(() {});
                    if (widget.customProvider != null) {
                      ref
                          .read(widget.customProvider!.notifier)
                          .state[widget.fieldName] = value;

                      ref
                          .read(formErrorsProvider.notifier)
                          .state
                          .remove(widget.fieldName);
                    } else {
                      ref
                          .read(formDataProvider.notifier)
                          .state[widget.fieldName] = value;

                      ref
                          .read(formErrorsProvider.notifier)
                          .state
                          .remove(widget.fieldName);

                      if ((widget.filteredFieldsLength != null) &&
                          (widget.formVM != null) &&
                          (widget.formKey != null) &&
                          widget.isLastPage) {
                        final formData = ref.watch(formDataProvider);

                        if (debounce?.isActive ?? false) {
                          debounce?.cancel();
                        }
                        debounce = Timer(
                          const Duration(seconds: 1),
                          () async {
                            if (widget.filteredFieldsLength! + 2 ==
                                formData.length) {
                              var validate =
                                  widget.formKey!.currentState?.validate();

                              if (validate == true) {
                                await widget.formVM!.fetchProductPrice(
                                  ref: ref,
                                  context: context,
                                  productId: ref
                                          .watch(selectedProductDetailsProvider)
                                          ?.id ??
                                      "",
                                );
                              }
                            }
                          },
                        );
                      }
                    }

                    if (ref
                        .watch(urlDependentsProvider)
                        .containsKey(widget.fieldName)) {
                      ref.read(formDataProvider.notifier).state[ref
                              .watch(urlDependentsProvider)[widget.fieldName]
                              ?.name ??
                          ""] = null;

                      ref.read(urlFormDataProvider.notifier).state[ref
                                  .watch(
                                      urlDependentsProvider)[widget.fieldName]
                                  ?.name ??
                              ""] ==
                          null;
                      setState(() {});

                      ref.read(showFullScreenLoaderProvider.notifier).state =
                          true;

                      await FormViewModel.initWhoAmI().getListData(
                        context: context,
                        ref: ref,
                        dataUrl: ref
                                .watch(urlDependentsProvider)[widget.fieldName]
                                ?.dataUrl ??
                            "",
                        fieldName: ref
                                .watch(urlDependentsProvider)[widget.fieldName]
                                ?.name ??
                            "",
                        dependsOn: ref
                            .watch(urlDependentsProvider)[widget.fieldName]
                            ?.dependsOn,
                      );
                      ref.read(showFullScreenLoaderProvider.notifier).state =
                          false;
                      if (widget.onPageRefresh != null) {
                        widget.onPageRefresh!();
                      }
                    }
                  },
                  iconStyleData: IconStyleData(
                    icon: SvgPicture.asset(
                      ConstantString.chevronDown,
                      colorFilter: const ColorFilter.mode(
                        CustomColors.blackColor,
                        BlendMode.srcIn,
                      ),
                      // color: CustomColors.blackColor,
                      package: 'mca_official_flutter_sdk',
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                  ),

                  // buttonStyleData: const ButtonStyleData(
                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                  //   height: 40,
                  //   width: 200,
                  // ),
                  // customButton:
                  focusNode: myNode,
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                    elevation: 0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CustomColors.blackColor.withOpacity(0.15),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: CustomColors.whiteColor,
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  dropdownSearchData:
                      ((ref.watch(urlFormDataProvider)[widget.fieldName]
                                          as List?)
                                      ?.length ??
                                  0) <
                              5
                          ? null
                          : DropdownSearchData(
                              searchController: textEditingController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: textEditingController,
                                  cursorColor:
                                      CustomColors.blackColor.withOpacity(0.5),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'search',
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.dividerGreyColor,
                                          width: 0.8),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: CustomColors.primaryBrandColor()
                                            .withOpacity(0.4),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: CustomColors.primaryBrandColor(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.value
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase());
                              },
                            ),
                  //This to clear the search value when you close the menu
                  onMenuStateChange: (isOpen) async {
                    // FocusScope.of(context).unfocus();

                    // if (widget.onClearFocus != null) {
                    //   widget.onClearFocus!();
                    //   print(11111);
                    // }
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),

              // DropdownButton(
              //   icon: Center(
              //     child: SvgPicture.asset(
              //       ConstantString.chevronDown,
              //       colorFilter: const ColorFilter.mode(
              //           CustomColors.blackColor, BlendMode.srcIn),
              //       // color: CustomColors.blackColor,
              //       package: 'mca_official_flutter_sdk',
              //     ),
              //   ),
              //   hint: Text(
              //     widget.description,
              //     style: CustomTextStyles.regular(
              //         fontSize: 15.sp,
              //         color: CustomColors.formHintColor),
              //   ),
              //   isExpanded: true,
              //   dropdownColor: Colors.white,
              //   elevation: 0,
              //   value: widget.customProvider != null
              //       ? ref
              //           .watch(widget.customProvider!)[widget.fieldName]
              //       : ref.watch(formDataProvider)[widget.fieldName],
              //   items: ref
              //       .watch(urlFormDataProvider)[widget.fieldName]
              //       .map<DropdownMenuItem<Object>>((room) {
              //     return DropdownMenuItem<Object>(
              //       value: room,
              //       child: Text(
              //         room.toString(),
              //         style: CustomTextStyles.regular(
              //             fontSize: 15.sp,
              //             color: CustomColors.blackColor),
              //       ),
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     FocusScope.of(context).unfocus();
              //     if (widget.customProvider != null) {
              //       ref
              //           .read(widget.customProvider!.notifier)
              //           .state[widget.fieldName] = value;

              //       ref
              //           .read(formErrorsProvider.notifier)
              //           .state
              //           .remove(widget.fieldName);
              //     } else {
              //       ref
              //           .read(formDataProvider.notifier)
              //           .state[widget.fieldName] = value;

              //       ref
              //           .read(formErrorsProvider.notifier)
              //           .state
              //           .remove(widget.fieldName);

              //       if ((widget.filteredFieldsLength != null) &&
              //           (widget.formVM != null) &&
              //           (widget.formKey != null)) {
              //         final formData = ref.watch(formDataProvider);

              //         if (debounce?.isActive ?? false) {
              //           debounce?.cancel();
              //         }
              //         debounce = Timer(
              //           const Duration(seconds: 1),
              //           () async {
              //             if (widget.filteredFieldsLength! + 2 ==
              //                 formData.length) {
              //               var validate = widget.formKey!.currentState
              //                   ?.validate();

              //               if (validate == true) {
              //                 await widget.formVM!.fetchProductPrice(
              //                   ref: ref,
              //                   context: context,
              //                   productId: ref
              //                           .watch(
              //                               selectedProductDetailsProvider)
              //                           ?.id ??
              //                       "",
              //                 );
              //               }
              //             }
              //           },
              //         );
              //       }
              //     }

              //     setState(() {});
              //   },
              // ),
            ),

            // FutureBuilder<bool>(
            //     future: ref.watch(urlFormDataProvider)[widget.fieldName] != null
            //         ? returnTrue()
            //         : FormViewModel.initWhoAmI().getListData(
            //             context: context,
            //             ref: ref,
            //             dataUrl: widget.dataUrl,
            //             fieldName: widget.fieldName,
            //             dependsOn: widget.dependsOn,
            //           ),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Row(
            //           children: [
            //             Expanded(
            //               child: Text(
            //                 widget.description,
            //                 style: CustomTextStyles.regular(
            //                     fontSize: 15.sp,
            //                     color: CustomColors.formHintColor),
            //               ),
            //             ),
            //             SvgPicture.asset(
            //               ConstantString.chevronDown,
            //               // color: CustomColors.blackColor,
            //               package: 'mca_official_flutter_sdk',
            //             ),
            //           ],
            //         );
            //       } else if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}');
            //       } else if (snapshot.hasData) {
            //         return DropdownButtonHideUnderline(
            //           child: Listener(
            //             // onPointerDown: (_) => FocusScope.of(context).unfocus(),
            //             onPointerDown: (_) =>
            //                 FocusScope.of(context).requestFocus(
            //               FocusNode(),
            //             ),
            //             child: DropdownButton2(
            //               isExpanded: true,
            //               hint: Text(
            //                 widget.description,
            //                 style: CustomTextStyles.regular(
            //                     fontSize: 14.sp,
            //                     color: CustomColors.formHintColor),
            //                 maxLines: 1,
            //               ),

            //               items: ref
            //                   .watch(urlFormDataProvider)[widget.fieldName]
            //                   ?.map<DropdownMenuItem<Object>>((room) {
            //                 return DropdownMenuItem<Object>(
            //                   value: room.name,
            //                   child: Text(
            //                     room.name.toString(),
            //                     style: CustomTextStyles.regular(
            //                       fontSize: 14.sp,
            //                       color: CustomColors.blackTextColor,
            //                     ),
            //                     maxLines: 1,
            //                   ),
            //                 );
            //               }).toList(),
            //               value: widget.customProvider != null
            //                   ? ref.watch(
            //                       widget.customProvider!)[widget.fieldName]
            //                   : ref.watch(formDataProvider)[widget.fieldName],

            //               onChanged: (value) async {
            //                 if (widget.onClearFocus != null) {
            //                   widget.onClearFocus!();
            //                 }
            //                 // FocusScope.of(context).unfocus();
            //                 // setState(() {});
            //                 if (widget.customProvider != null) {
            //                   ref
            //                       .read(widget.customProvider!.notifier)
            //                       .state[widget.fieldName] = value;

            //                   ref
            //                       .read(formErrorsProvider.notifier)
            //                       .state
            //                       .remove(widget.fieldName);
            //                 } else {
            //                   ref
            //                       .read(formDataProvider.notifier)
            //                       .state[widget.fieldName] = value;

            //                   ref
            //                       .read(formErrorsProvider.notifier)
            //                       .state
            //                       .remove(widget.fieldName);

            //                   if ((widget.filteredFieldsLength != null) &&
            //                       (widget.formVM != null) &&
            //                       (widget.formKey != null)) {
            //                     final formData = ref.watch(formDataProvider);

            //                     if (debounce?.isActive ?? false) {
            //                       debounce?.cancel();
            //                     }
            //                     debounce = Timer(
            //                       const Duration(seconds: 1),
            //                       () async {
            //                         if (widget.filteredFieldsLength! + 2 ==
            //                             formData.length) {
            //                           var validate = widget
            //                               .formKey!.currentState
            //                               ?.validate();

            //                           if (validate == true) {
            //                             await widget.formVM!.fetchProductPrice(
            //                               ref: ref,
            //                               context: context,
            //                               productId: ref
            //                                       .watch(
            //                                           selectedProductDetailsProvider)
            //                                       ?.id ??
            //                                   "",
            //                             );
            //                           }
            //                         }
            //                       },
            //                     );
            //                   }
            //                 }

            //                 if (ref
            //                     .watch(urlDependentsProvider)
            //                     .containsKey(widget.fieldName)) {
            //                   ref.read(formDataProvider.notifier).state[ref
            //                           .watch(urlDependentsProvider)[
            //                               widget.fieldName]
            //                           ?.name ??
            //                       ""] = null;
            //                   await FormViewModel.initWhoAmI().getListData(
            //                     context: context,
            //                     ref: ref,
            //                     dataUrl: ref
            //                             .watch(urlDependentsProvider)[
            //                                 widget.fieldName]
            //                             ?.dataUrl ??
            //                         "",
            //                     fieldName: ref
            //                             .watch(urlDependentsProvider)[
            //                                 widget.fieldName]
            //                             ?.name ??
            //                         "",
            //                     dependsOn: ref
            //                         .watch(
            //                             urlDependentsProvider)[widget.fieldName]
            //                         ?.dependsOn,
            //                   );
            //                   if (widget.onPageRefresh != null) {
            //                     widget.onPageRefresh!();
            //                   }
            //                 }
            //               },
            //               iconStyleData: IconStyleData(
            //                 icon: SvgPicture.asset(
            //                   ConstantString.chevronDown,
            //                   colorFilter: const ColorFilter.mode(
            //                     CustomColors.blackColor,
            //                     BlendMode.srcIn,
            //                   ),
            //                   // color: CustomColors.blackColor,
            //                   package: 'mca_official_flutter_sdk',
            //                 ),
            //                 iconSize: 14,
            //                 iconEnabledColor: Colors.black,
            //                 iconDisabledColor: Colors.grey,
            //               ),

            //               // buttonStyleData: const ButtonStyleData(
            //               //   padding: EdgeInsets.symmetric(horizontal: 16),
            //               //   height: 40,
            //               //   width: 200,
            //               // ),
            //               // customButton:
            //               focusNode: myNode,
            //               dropdownStyleData: DropdownStyleData(
            //                 maxHeight:  MediaQuery.of(context).size.height * 0.4,
            //               ),
            //               menuItemStyleData: const MenuItemStyleData(
            //                 height: 40,
            //               ),
            //               dropdownSearchData: ((ref.watch(urlFormDataProvider)[
            //                                   widget.fieldName] as List?)
            //                               ?.length ??
            //                           0) <
            //                       5
            //                   ? null
            //                   : DropdownSearchData(
            //                       searchController: textEditingController,
            //                       searchInnerWidgetHeight: 50,
            //                       searchInnerWidget: Container(
            //                         height: 50,
            //                         padding: const EdgeInsets.only(
            //                           top: 8,
            //                           bottom: 4,
            //                           right: 8,
            //                           left: 8,
            //                         ),
            //                         child: TextFormField(
            //                           expands: true,
            //                           maxLines: null,
            //                           controller: textEditingController,
            //                           cursorColor: CustomColors.blackColor
            //                               .withOpacity(0.5),
            //                           decoration: InputDecoration(
            //                             isDense: true,
            //                             contentPadding:
            //                                 const EdgeInsets.symmetric(
            //                               horizontal: 10,
            //                               vertical: 8,
            //                             ),
            //                             hintText: 'search',
            //                             enabledBorder: const OutlineInputBorder(
            //                               borderSide: BorderSide(
            //                                   color:
            //                                       CustomColors.dividerGreyColor,
            //                                   width: 0.8),
            //                               borderRadius: BorderRadius.all(
            //                                 Radius.circular(5),
            //                               ),
            //                             ),
            //                             focusedBorder: OutlineInputBorder(
            //                               borderSide: BorderSide(
            //                                 color:
            //                                     CustomColors.primaryBrandColor()
            //                                         .withOpacity(0.4),
            //                               ),
            //                               borderRadius: const BorderRadius.all(
            //                                 Radius.circular(5),
            //                               ),
            //                             ),
            //                             hintStyle:
            //                                 const TextStyle(fontSize: 12),
            //                             border: OutlineInputBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(8),
            //                               borderSide: BorderSide(
            //                                 color: CustomColors
            //                                     .primaryBrandColor(),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                       searchMatchFn: (item, searchValue) {
            //                         return item.value
            //                             .toString()
            //                             .toLowerCase()
            //                             .contains(searchValue.toLowerCase());
            //                       },
            //                     ),
            //               //This to clear the search value when you close the menu
            //               onMenuStateChange: (isOpen) async {
            //                 // FocusScope.of(context).unfocus();

            //                 // if (widget.onClearFocus != null) {
            //                 //   widget.onClearFocus!();
            //                 //   print(11111);
            //                 // }
            //                 if (!isOpen) {
            //                   textEditingController.clear();
            //                 }
            //               },
            //             ),
            //           ),

            //           // DropdownButton(
            //           //   icon: Center(
            //           //     child: SvgPicture.asset(
            //           //       ConstantString.chevronDown,
            //           //       colorFilter: const ColorFilter.mode(
            //           //           CustomColors.blackColor, BlendMode.srcIn),
            //           //       // color: CustomColors.blackColor,
            //           //       package: 'mca_official_flutter_sdk',
            //           //     ),
            //           //   ),
            //           //   hint: Text(
            //           //     widget.description,
            //           //     style: CustomTextStyles.regular(
            //           //         fontSize: 15.sp,
            //           //         color: CustomColors.formHintColor),
            //           //   ),
            //           //   isExpanded: true,
            //           //   dropdownColor: Colors.white,
            //           //   elevation: 0,
            //           //   value: widget.customProvider != null
            //           //       ? ref
            //           //           .watch(widget.customProvider!)[widget.fieldName]
            //           //       : ref.watch(formDataProvider)[widget.fieldName],
            //           //   items: ref
            //           //       .watch(urlFormDataProvider)[widget.fieldName]
            //           //       .map<DropdownMenuItem<Object>>((room) {
            //           //     return DropdownMenuItem<Object>(
            //           //       value: room,
            //           //       child: Text(
            //           //         room.toString(),
            //           //         style: CustomTextStyles.regular(
            //           //             fontSize: 15.sp,
            //           //             color: CustomColors.blackColor),
            //           //       ),
            //           //     );
            //           //   }).toList(),
            //           //   onChanged: (value) {
            //           //     FocusScope.of(context).unfocus();
            //           //     if (widget.customProvider != null) {
            //           //       ref
            //           //           .read(widget.customProvider!.notifier)
            //           //           .state[widget.fieldName] = value;

            //           //       ref
            //           //           .read(formErrorsProvider.notifier)
            //           //           .state
            //           //           .remove(widget.fieldName);
            //           //     } else {
            //           //       ref
            //           //           .read(formDataProvider.notifier)
            //           //           .state[widget.fieldName] = value;

            //           //       ref
            //           //           .read(formErrorsProvider.notifier)
            //           //           .state
            //           //           .remove(widget.fieldName);

            //           //       if ((widget.filteredFieldsLength != null) &&
            //           //           (widget.formVM != null) &&
            //           //           (widget.formKey != null)) {
            //           //         final formData = ref.watch(formDataProvider);

            //           //         if (debounce?.isActive ?? false) {
            //           //           debounce?.cancel();
            //           //         }
            //           //         debounce = Timer(
            //           //           const Duration(seconds: 1),
            //           //           () async {
            //           //             if (widget.filteredFieldsLength! + 2 ==
            //           //                 formData.length) {
            //           //               var validate = widget.formKey!.currentState
            //           //                   ?.validate();

            //           //               if (validate == true) {
            //           //                 await widget.formVM!.fetchProductPrice(
            //           //                   ref: ref,
            //           //                   context: context,
            //           //                   productId: ref
            //           //                           .watch(
            //           //                               selectedProductDetailsProvider)
            //           //                           ?.id ??
            //           //                       "",
            //           //                 );
            //           //               }
            //           //             }
            //           //           },
            //           //         );
            //           //       }
            //           //     }

            //           //     setState(() {});
            //           //   },
            //           // ),
            //         );
            //       } else {
            //         return const Text('No data available');
            //       }
            //     }),
          ),
        ),
        verticalSpacer(5.sp),
        formErrors.containsKey(widget.fieldName) && shouldValidate
            ? Padding(
                padding: EdgeInsets.only(top: 5.sp),
                child: Text(
                  formErrors[widget.fieldName],
                  style: CustomTextStyles.regular(
                    fontSize: 12.sp,
                    color: Colors.red,
                  ),
                ),
              )
            : Container(),
        verticalSpacer(25.sp),
      ],
    );
  }
}

Future<bool> returnTrue() async {
  return true;
}
