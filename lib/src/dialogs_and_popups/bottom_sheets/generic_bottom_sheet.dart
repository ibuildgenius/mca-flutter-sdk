import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

void showGenericBottomSheet(
  BuildContext context, {
  required String title,
  required Widget child,
  String? okText,
  String? cancelText,
  Color? okBbuttonColor,
  Function()? onOkPressed,
  Function()? onCancelPressed,
  bool isDismissible = true,
  bool enableDrag = false,
  bool showBackButton = true,
}) {
  showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: isDismissible ? false : true,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
          child: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Consumer(builder: (context, ref, children) {
                    return Column(
                      children: [
                        verticalSpacer(30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              semiBoldText(title, fontSize: 16.sp),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: SvgPicture.asset(
                                  ConstantString.xMark,
                                  package: 'mca_official_flutter_sdk',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // verticalSpacer(30.h),
                        Flexible(
                          fit: FlexFit.loose,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  child,
                                ],
                              ),
                            ),
                          ),
                        ),
                        verticalSpacer(20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              showBackButton
                                  ? Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: CustomButton(
                                          title: cancelText ?? "Go back",
                                          buttonColor:
                                              CustomColors.dividerGreyColor,
                                          textColor: CustomColors.backTextColor,
                                          fontSize: 14.sp,
                                          onTap: onCancelPressed ??
                                              () {
                                                Navigator.pop(context);
                                              },
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              Expanded(
                                flex: 2,
                                child: CustomButton(
                                  isLoading:
                                      ref.watch(claimVmProvider).isLoading,
                                  title: okText ?? "Continue",
                                  buttonColor: okBbuttonColor,
                                  onTap: onOkPressed ?? () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpacer(
                            MediaQuery.of(context).padding.bottom + 25),
                      ],
                    );
                  }),
                ),
              ),
            );
          }),
        );
      });
}
