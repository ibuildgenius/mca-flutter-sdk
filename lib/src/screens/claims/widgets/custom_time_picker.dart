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
class CustomMiniTimePicker extends StatefulHookConsumerWidget {
  final String label, description;
  final bool isTodayMax;
  final int? minDate;
  // String? selectedTime;
  final AutoDisposeStateProvider<String?> selectedTime;
  const CustomMiniTimePicker({
    super.key,
    required this.label,
    required this.description,
    required this.isTodayMax,
    this.minDate,
    required this.selectedTime,
  });

  @override
  ConsumerState<CustomMiniTimePicker> createState() =>
      _CustomMiniTimePickerState();
}

class _CustomMiniTimePickerState extends ConsumerState<CustomMiniTimePicker> {
  Timer? debounce;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data:
                  customDatePickerTheme, // Adjust this to fit your theme for the time picker
              child: child!,
            );
          },
        );

        if (time != null) {
          setState(() {
            ref.read(widget.selectedTime.notifier).state = time.format(context);
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
                    child: ref.watch(widget.selectedTime) == null
                        ? Text(
                            widget.description,
                            style: CustomTextStyles.regular(
                                fontSize: 15.sp,
                                color: CustomColors.formHintColor),
                          )
                        : Text(
                            ref.watch(widget.selectedTime)!,
                            style: CustomTextStyles.regular(
                                fontSize: 15.sp,
                                color: CustomColors.blackColor),
                          ),
                  ),
                  const Icon(
                    Icons.timer_outlined,
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
