import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/form_field_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/form_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/custom_boolean_droppdown.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/custom_date_picker.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/custom_dropdown_field.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/custom_dropdown_multiselect_field.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/custom_image_picker.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/custom_image_uploader.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/custom_item_pair.dart';
import 'package:mca_official_flutter_sdk/src/utils/form_validator.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';

// ignore: must_be_immutable
class BuildFormFieldWidget extends StatefulHookConsumerWidget {
  final FormFieldModel field;
  final TextEditingController? controller;
  final int? filteredFieldsLength;
  GlobalKey<FormBuilderState>? formKey;
  final FormViewModel? formVM;
  final StateProvider<Map<String, dynamic>>? customProvider;
  void Function()? onPageRefresh, onClearFocus;
  bool isLastPage;
  BuildFormFieldWidget({
    super.key,
    required this.field,
    required this.controller,
    this.filteredFieldsLength,
    this.formVM,
    this.formKey,
    this.customProvider,
    this.onPageRefresh,
    this.isLastPage = false,
    required this.onClearFocus,
  });

  @override
  ConsumerState<BuildFormFieldWidget> createState() =>
      _BuildFormFieldWidgetState();
}

class _BuildFormFieldWidgetState extends ConsumerState<BuildFormFieldWidget> {
  Timer? debounce;
  @override
  Widget build(BuildContext context) {
    if (!StringUtils.isNullOrEmpty(widget.field.dataUrl)) {
      if (widget.field.required == true &&
          !ref.watch(formDataProvider).containsKey(widget.field.name)) {
        ref.read(formErrorsProvider.notifier).state[widget.field.name ?? ""] =
            "This is a required field";
      }

      return (widget.field.dataType == "boolean")
          ? CustomBooleanDropdownField(
              fieldName: widget.field.name ?? "",
              label: widget.field.label ?? "",
              description: widget.field.description ?? "",
              customProvider: widget.customProvider,
              filteredFieldsLength: widget.filteredFieldsLength,
              formVM: widget.formVM,
              formKey: widget.formKey,
              isLastPage: widget.isLastPage,
            )
          : widget.field.dataType == "array"
              ? CustomDropdownMultiSelectField(
                  fieldName: widget.field.name ?? "",
                  dataUrl: widget.field.dataUrl ?? "",
                  label: widget.field.label ?? "",
                  description: widget.field.description ?? "",
                  customProvider: widget.customProvider,
                  filteredFieldsLength: widget.filteredFieldsLength,
                  formVM: widget.formVM,
                  formKey: widget.formKey,
                  dependsOn: widget.field.dependsOn,
                  onPageRefresh: widget.onPageRefresh,
                  onClearFocus: widget.onClearFocus,
                )
              : CustomDropdownField(
                  fieldName: widget.field.name ?? "",
                  dataUrl: widget.field.dataUrl ?? "",
                  label: widget.field.label ?? "",
                  description: widget.field.description ?? "",
                  customProvider: widget.customProvider,
                  filteredFieldsLength: widget.filteredFieldsLength,
                  formVM: widget.formVM,
                  formKey: widget.formKey,
                  dependsOn: widget.field.dependsOn,
                  onPageRefresh: widget.onPageRefresh,
                  onClearFocus: widget.onClearFocus,
                  isLastPage: widget.isLastPage,
                );
    } else if (widget.field.dataType == "boolean") {
      if (widget.field.required == true &&
          !ref.watch(formDataProvider).containsKey(widget.field.name)) {
        ref.read(formErrorsProvider.notifier).state[widget.field.name ?? ""] =
            "This is a required field";
      }

      return CustomBooleanDropdownField(
        fieldName: widget.field.name ?? "",
        label: widget.field.label ?? "",
        description: widget.field.description ?? "",
        customProvider: widget.customProvider,
        filteredFieldsLength: widget.filteredFieldsLength,
        formVM: widget.formVM,
        formKey: widget.formKey,
        isLastPage: widget.isLastPage,
      );
    } else if (widget.field.inputType == "date") {
      if (widget.field.required == true &&
          !ref.watch(formDataProvider).containsKey(widget.field.name)) {
        ref.read(formErrorsProvider.notifier).state[widget.field.name ?? ""] =
            "This is a required field";
      }
      return CustomDatePicker(
        fieldName: widget.field.name ?? "",
        label: widget.field.label ?? "",
        description: widget.field.description ?? "",
        min: widget.field.min ?? 0,
        customProvider: widget.customProvider,
        filteredFieldsLength: widget.filteredFieldsLength,
        formVM: widget.formVM,
        formKey: widget.formKey,
        isLastPage: widget.isLastPage,
      );
    } else if (widget.field.inputType == "file") {
      if (widget.field.required == true &&
          !ref.watch(formDataProvider).containsKey(widget.field.name)) {
        ref.read(formErrorsProvider.notifier).state[widget.field.name ?? ""] =
            "This is a required field";
      }

      return widget.customProvider != null
          ? CustomImageUploader(
              fieldName: widget.field.name ?? "",
              label: widget.field.label ?? "",
              description: widget.field.description ?? "",
              customProvider: widget.customProvider,
              required: widget.field.required ?? false,
            )
          : CustomImagePicker(
              fieldName: widget.field.name ?? "",
              label: widget.field.label ?? "",
              description: widget.field.description ?? "",
              required: widget.field.required ?? false,
            );
    } else if (widget.field.hasChild != null && widget.field.hasChild!) {
      return CustomItemPairWidget(field: widget.field);
    } else {
      return customFormTextField(
        widget.field.name ?? '',
        controller: widget.controller,
        readOnly: (widget.field.inputType == "date") ||
            (widget.field.name.toString().toLowerCase() == "email" &&
                !StringUtils.isNullOrEmpty(Global.email) &&
                (Global.isContactFieldsEditable == false)) ||
            (widget.field.name.toString().toLowerCase() == "phone_number" &&
                !StringUtils.isNullOrEmpty(Global.phone) &&
                (Global.isContactFieldsEditable == false)),
        title: widget.field.label ?? "",
        hintText: widget.field.description,
        isNumber: widget.field.dataType == "number",
        isCurrency: widget.field.isCurrency == true,
        autovalidateMode: ref.watch(autoValidateProvider) == true
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          return CustomValidator.generalValidator(
            value: value,
            name: widget.field.name,
            label: widget.field.label ?? "",
            dataType: widget.field.dataType,
            inputType: widget.field.inputType ?? "",
            minMaxConstraint: widget.field.minMaxConstraint,
            errorMsg: widget.field.errorMsg,
            min: widget.field.min ?? 0,
            max: widget.field.max,
          );
        },
        onChanged: (value) {
          ref.read(productPriceProvider.notifier).state = 0;
          if (value == null) {
            return;
          }
          if (widget.field.dataType == 'number') {
            if (value.isNotEmpty) {
              widget.customProvider != null
                  ? ref
                          .read(widget.customProvider!.notifier)
                          .state[widget.field.name ?? ""] =
                      int.parse(value.replaceAll(",", ""))
                  : ref
                          .read(formDataProvider.notifier)
                          .state[widget.field.name ?? ""] =
                      int.parse(value.replaceAll(",", ""));
            } else {
              // Remove the entry if the value is empty
              widget.customProvider != null
                  ? ref
                      .read(widget.customProvider!.notifier)
                      .state
                      .remove(widget.field.name ?? "")
                  : ref
                      .read(formDataProvider.notifier)
                      .state
                      .remove(widget.field.name ?? "");
            }
          } else {
            if (value.isNotEmpty) {
              widget.customProvider != null
                  ? ref
                      .read(widget.customProvider!.notifier)
                      .state[widget.field.name ?? ""] = value
                  : ref
                      .read(formDataProvider.notifier)
                      .state[widget.field.name ?? ""] = value;
            } else {
              // Remove the entry if the value is empty

              widget.customProvider != null
                  ? ref
                      .read(widget.customProvider!.notifier)
                      .state
                      .remove(widget.field.name ?? "")
                  : ref
                      .read(formDataProvider.notifier)
                      .state
                      .remove(widget.field.name ?? "");
            }
          }

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
                if (widget.filteredFieldsLength! + 2 == formData.length) {
                  var validate = widget.formKey!.currentState?.validate();

                  if (validate == true) {
                    await widget.formVM!.fetchProductPrice(
                      ref: ref,
                      context: context,
                      productId:
                          ref.watch(selectedProductDetailsProvider)?.id ?? "",
                    );
                  }
                }
              },
            );
          }

          ////nooooo
          // if (widget.field.dataType == 'number') {
          //   if (value!.isNotEmpty) {
          //     ref
          //             .read(formDataProvider.notifier)
          //             .state[widget.field.name ?? ""] =
          //         int.parse(value.replaceAll(",", ""));
          //   }
          // } else {
          //   ref.read(formDataProvider.notifier).state[widget.field.name ?? ""] =
          //       value;
          //   if (widget.field.name == "email") {
          //     Global.email = value;
          //   }
          // }
        },
      );
    }
    // return const Placeholder();
  }
}
