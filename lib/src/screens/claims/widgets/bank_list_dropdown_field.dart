import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/models/bank_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class BankListDropdownField extends StatefulHookConsumerWidget {
  final String fieldName, label, description;
  final List<BankModel> items;
  final bool isLoadingBanks;
  // String? selectedItem;
  final AutoDisposeStateProvider<BankModel?> selectedItem;
  const BankListDropdownField({
    super.key,
    required this.fieldName,
    required this.label,
    required this.isLoadingBanks,
    required this.description,
    required this.items,
    required this.selectedItem,
  });

  @override
  ConsumerState<BankListDropdownField> createState() =>
      _BankListDropdownFieldState();
}

class _BankListDropdownFieldState extends ConsumerState<BankListDropdownField> {
  Timer? debounce;

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusNode myNode = FocusNode();

   
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
            ),
            child: DropdownButtonHideUnderline(
              child: Listener(
                onPointerDown: (_) => FocusScope.of(context).requestFocus(
                  FocusNode(),
                ),
                child: DropdownButton2<BankModel?>(
                  isExpanded: true,
                  hint: widget.isLoadingBanks
                      ? Text(
                          'Loading banks....',
                          style: CustomTextStyles.regular(
                              fontSize: 14.sp,
                              color: CustomColors.formHintColor),
                        )
                      : Text(
                          widget.description,
                          style: CustomTextStyles.regular(
                              fontSize: 14.sp,
                              color: CustomColors.formHintColor),
                          maxLines: 1,
                        ),
                  selectedItemBuilder:
                      // ref.watch(urlFormDataProvider)[widget.fieldName] == null
                      //     ? null
                      //     :
                      (BuildContext context) {
                    return widget.items.map<Widget>((room) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            room.name ?? "",
                            style: CustomTextStyles.regular(
                                fontSize: 15.sp,
                                color: CustomColors.greyTextColor),
                            maxLines: 1,
                          ),
                        ],
                      );
                    }).toList();
                  },
                  items: widget.items.map<DropdownMenuItem<BankModel?>>((item) {
                    return DropdownMenuItem<BankModel?>(
                      value: item,
                      child: Text(
                        item.name ?? "",
                        style: CustomTextStyles.regular(
                          fontSize: 14.sp,
                          color: CustomColors.blackTextColor,
                        ),
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  value: ref.watch(widget.selectedItem),
                  onChanged: (widget.isLoadingBanks || widget.items.isEmpty)
                      ? null
                      : (value) =>
                          ref.read(widget.selectedItem.notifier).state = value,

                  // onChanged: (value) async {
                  //   setState(() {
                  //     ref.read(widget.selectedItem.notifier).state = value;
                  //   });
                  // },
                  iconStyleData: IconStyleData(
                    icon: SvgPicture.asset(
                      ConstantString.chevronDown,
                      colorFilter: const ColorFilter.mode(
                        CustomColors.blackColor,
                        BlendMode.srcIn,
                      ),
                      package: 'mca_official_flutter_sdk',
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                  ),
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
                  dropdownSearchData: widget.items.length < 5
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
                                hintText: widget.description,
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
                            return (item.value?.name)
                                .toString()
                                .toLowerCase()
                                .contains(searchValue.toLowerCase());
                          },
                        ),
                  onMenuStateChange: (isOpen) async {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        verticalSpacer(25),
      ],
    );
  }
}
