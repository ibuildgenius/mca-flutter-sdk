// ignore_for_file: must_be_immutable

import 'dart:async';

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

class CustomBooleanDropdownField extends StatefulHookConsumerWidget {
  final String fieldName, label, description;
  final StateProvider<Map<String, dynamic>>? customProvider;

  final int? filteredFieldsLength;
  GlobalKey<FormBuilderState>? formKey;
  final FormViewModel? formVM;
  bool isLastPage;

  CustomBooleanDropdownField({
    super.key,
    required this.fieldName,
    required this.label,
    required this.description,
    this.customProvider,
    this.filteredFieldsLength,
    this.formVM,
    this.formKey,
    this.isLastPage = false,
  });

  @override
  ConsumerState<CustomBooleanDropdownField> createState() =>
      _CustomBooleanDropdownFieldState();
}

class _CustomBooleanDropdownFieldState
    extends ConsumerState<CustomBooleanDropdownField> {
  Timer? debounce;
  final TextEditingController textEditingController = TextEditingController();
  final Map<String, bool> yesNoMap = {
    'Yes': true,
    'No': false,
  };
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: Center(
                  child: SvgPicture.asset(
                    ConstantString.chevronDown,
                    colorFilter: const ColorFilter.mode(
                        CustomColors.blackColor, BlendMode.srcIn),
                    // color: CustomColors.blackColor,
                    package: 'mca_official_flutter_sdk',
                  ),
                ),
                hint: Text(
                  widget.description,
                  style: CustomTextStyles.regular(
                      fontSize: 15.sp, color: CustomColors.formHintColor),
                ),
                isExpanded: true,
                dropdownColor: Colors.white,
                elevation: 0,
                value: widget.customProvider != null
                    ? ref.watch(widget.customProvider!)[widget.fieldName]
                    : ref.watch(formDataProvider)[widget.fieldName],
                items: yesNoMap.entries.map<DropdownMenuItem<bool>>((entry) {
                  return DropdownMenuItem<bool>(
                    value: entry.value,
                    child: Text(
                      entry.key,
                      style: CustomTextStyles.regular(
                          fontSize: 15.sp, color: CustomColors.blackColor),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  FocusScope.of(context).unfocus();
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

                  setState(() {});
                },
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
