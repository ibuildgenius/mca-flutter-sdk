// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/form_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class CustomDropdownMultiSelectField extends StatefulHookConsumerWidget {
  final String fieldName, dataUrl, label, description;
  final String? dependsOn;
  final StateProvider<Map<String, dynamic>>? customProvider;
  void Function()? onPageRefresh, onClearFocus;
  final int? filteredFieldsLength;
  GlobalKey<FormBuilderState>? formKey;
  final FormViewModel? formVM;

  CustomDropdownMultiSelectField({
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
  });

  @override
  ConsumerState<CustomDropdownMultiSelectField> createState() =>
      _CustomDropdownMultiSelectFieldState();
}

class _CustomDropdownMultiSelectFieldState
    extends ConsumerState<CustomDropdownMultiSelectField> {
  Timer? debounce;

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(urlFormDataProvider)[widget.fieldName] != null
          ? returnTrue()
          : FormViewModel.initWhoAmI().getMapData(
              context: context,
              ref: ref,
              dataUrl: widget.dataUrl,
              fieldName: widget.fieldName,
              dependsOn: widget.dependsOn,
            );
    });
    if (ref.read(formDataProvider)[widget.fieldName] == null) {
      ref.read(formDataProvider.notifier).state[widget.fieldName] = [];
    }

    //     future:
  }

  @override
  Widget build(BuildContext context) {
    final formErrors = ref.watch(formErrorsProvider);
    final shouldValidate = ref.watch(shouldValidateImageplusDrop);
    var items = ref.watch(urlFormDataProvider)[widget.fieldName];
    var selectedItems = ref.watch(formDataProvider)[widget.fieldName];

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
                  items: items?.map<DropdownMenuItem<Object>>((room) {
                    var item = room.name;
                    return DropdownMenuItem<Object>(
                      value: room.id,
                      //disable default onTap to avoid closing menu when selecting an item
                      enabled: false,
                      child: StatefulBuilder(
                        builder: (context, menuSetState) {
                          final isSelected = selectedItems.contains(room.id);
                          return InkWell(
                            onTap: () {
                              isSelected
                                  ? selectedItems.remove(room.id)
                                  : selectedItems.add(room.id);
                              //This rebuilds the StatefulWidget to update the button's text
                              setState(() {});
                              //This rebuilds the dropdownMenu Widget to update the check mark
                              menuSetState(() {});
                            },
                            child: Container(
                              height: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  if (isSelected)
                                    Icon(
                                      Icons.check_box,
                                      color: CustomColors.primaryBrandColor(),
                                    )
                                  else
                                    const Icon(Icons.check_box_outline_blank),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item ?? "",
                                      style: CustomTextStyles.regular(
                                        fontSize: 15,
                                        color: CustomColors.backTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                  value: selectedItems.isEmpty ? null : selectedItems.last,
                  onChanged: (value) {},
                  selectedItemBuilder: (context) {
                    return items!.map(
                      (item) {
                        return Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: regularText(
                            selectedItems.join(', '),

                            fontSize: 15,
                            // overflow: TextOverflow.ellipsis,

                            maxLines: 2,
                          ),
                        );
                      },
                    ).toList();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(left: 16, right: 8),
                    height: 40,
                    width: 140,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.zero,
                  ),
                ),

    
              ),

            ),


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
