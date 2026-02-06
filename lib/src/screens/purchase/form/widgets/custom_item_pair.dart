import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/item_pair_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/form_field_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class CustomItemPairWidget extends StatefulHookConsumerWidget {
  final FormFieldModel field;
  // final List<ChildDataModel> childData;
  const CustomItemPairWidget({
    super.key,
    required this.field,
  });

  @override
  ConsumerState<CustomItemPairWidget> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends ConsumerState<CustomItemPairWidget> {
  final formKey = GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.field.childData ?? []) {
      if (field.name != null) {
        _controllers[field.name!] = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showItemPairBottomSheet(
          context,
          ref,
          field: widget.field,
          controllers: _controllers,
          formKey: formKey,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mediumText(
            widget.field.label ?? "",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:
                        ref.watch(formDataProvider)[widget.field.name] == null
                            ? Text(
                                widget.field.description ?? "",
                                maxLines: 1,
                                style: CustomTextStyles.regular(
                                    fontSize: 13.sp,
                                    color: CustomColors.formHintColor),
                              )
                            : Text(
                                ref
                                    .watch(formDataProvider)[widget.field.name]
                                    .toString(),
                                maxLines: 1,
                                style: CustomTextStyles.regular(
                                    fontSize: 14.sp,
                                    color: CustomColors.blackColor),
                              ),
                  ),
                  const Icon(
                    Icons.date_range_rounded,
                    color: CustomColors.formHintColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          verticalSpacer(25.sp),
        ],
      ),
    );
  }
}
