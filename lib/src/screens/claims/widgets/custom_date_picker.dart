import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/custom_date_picker.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

// ignore: must_be_immutable
class CustomMiniDatePicker extends StatefulHookConsumerWidget {
  final String label, description;
  final bool isTodayMax;
  final int? minDate;
  // String? selectedDate;
  final AutoDisposeStateProvider<String?> selectedDate;
  const CustomMiniDatePicker({
    super.key,
    required this.label,
    required this.description,
    required this.isTodayMax,
    this.minDate,
    required this.selectedDate,
  });

  @override
  ConsumerState<CustomMiniDatePicker> createState() =>
      _CustomMiniDatePickerState();
}

class _CustomMiniDatePickerState extends ConsumerState<CustomMiniDatePicker> {
  Timer? debounce;
  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();
    var maxDate = widget.isTodayMax ? today : DateTime(3000);
    var minDate = widget.minDate == null
        ? DateTime(1000)
        : today.subtract(Duration(days: widget.minDate!));

    DateTime initialDate = today;

    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final date = await showDatePicker(
          context: context,
          // initialDate: DateTime.now(),
          // firstDate: DateTime(2000),
          // lastDate: DateTime.now(),

          initialDate: initialDate,
          firstDate: minDate,
          lastDate: maxDate,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: customDatePickerTheme,
              child: child!,
            );
          },
        );

        // onDateTimeChanged:
        // (DateTime newDate) {
        //   setState(() {
        //     controller.text =
        //         newDate.toString().substring(0, 10);
        //     purchaseData[item['name']] =
        //         controller.text;

        //     _formKey.currentState!.validate();
        //   });
        // };
        if (date != null) {
          setState(() {
            ref.read(widget.selectedDate.notifier).state =
                date.toString().substring(0, 10);
          });
        }
      },
      child: Column(
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
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ref.watch(widget.selectedDate) == null
                        ? Text(
                            widget.description,
                            style: CustomTextStyles.regular(
                                fontSize: 15.sp,
                                color: CustomColors.formHintColor),
                          )
                        : Text(
                            ref.watch(widget.selectedDate)!,
                            style: CustomTextStyles.regular(
                                fontSize: 15.sp,
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
