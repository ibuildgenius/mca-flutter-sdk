import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/form_field_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/form_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/build_form_field_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

void showItemPairBottomSheet(
  BuildContext context,
  WidgetRef ref,

  // GlobalKey<FormBuilderState> formKey,
  {
  required final FormFieldModel field,
  required Map<String, TextEditingController> controllers,
  required GlobalKey<FormBuilderState> formKey,
  String? providerId,
  // required String productName,
  // required String periodOfCover,
  // required String formattedPrice,
  // required String price,
  // ProviderLiteModel? provider,
  // required bool isDynamicPrice,
  String? keyBenefits,
  String? okText,
  String? cancelText,
  Color? iconColor,
  Widget? customIcon,
  Function()? onOkPressed,
  Function()? onCancelPressed,
  bool isDismissible = true,
  bool enableDrag = false,
  bool showButton = false,
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
      // barrierColor: Colors.white,

      context: context,
      builder: (context) {
        // void resetControllers() {
        //   controllers.forEach((key, controller) {
        //     controller.clear(); // Reset each controller by clearing its text
        //   });
        // }

        return PopScope(
          canPop: isDismissible ? false : true,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children: [
                FormBuilder(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.w, left: 20.w),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          children: [
                            verticalSpacer(30.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                semiBoldText("Add ${field.name}",
                                    fontSize: 16.sp),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: SvgPicture.asset(
                                    ConstantString.xMark,
                                    package: 'mca_official_flutter_sdk',
                                  ),
                                ),
                              ],
                            ),
                            verticalSpacer(5.h),
                            Row(
                              children: [
                                regularText(field.description ?? "",
                                    fontSize: 12.sp,
                                    color: CustomColors.greyTextColor),
                              ],
                            ),
                            verticalSpacer(30.h),
                            GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // Set to 2 to display items in pairs
                                  childAspectRatio:
                                      1.5, // Set aspect ratio to 1 to maintain square shape
                                ),
                                shrinkWrap: true,
                                itemCount: field.childData?.length,
                                itemBuilder: (context, index) {
                                  // FormFieldModel field = field;
                                  return Padding(
                                    padding: (index % 2 == 0)
                                        ? const EdgeInsets.only(right: 7.0)
                                        : const EdgeInsets.only(left: 7.0),
                                    child: BuildFormFieldWidget(
                                      field: field.childData![index],
                                      controller: controllers[field.name!],
                                      customProvider: globalItemPairProvider,
                                      onClearFocus: () =>
                                          FocusScope.of(context).unfocus(),
                                    ),
                                  );
                                }),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: CustomButton(
                                title: "Add",
                                buttonColor: CustomColors.whiteColor,
                                isOutlined: true,
                                textColor: CustomColors.primaryBrandColor(),
                                onTap: () {
                                  final validate =
                                      formKey.currentState?.validate();

                                  if (validate == true) {
                                    ref
                                        .read(globalItemListProvider.notifier)
                                        .state
                                        .add(ref.watch(globalItemPairProvider));

                                    ref
                                            .read(formDataProvider.notifier)
                                            .state[field.name ?? ""] =
                                        ref.watch(globalItemListProvider);

                                    formKey.currentState?.reset();

                                    ref
                                        .read(globalItemPairProvider.notifier)
                                        .state = {};
                                    controllers.forEach((key, controller) {
                                      // Reset each controller by clearing its text
                                    });
                                    // formKey.currentState!.dispose;

                                    setState(() {
                                      // Trigger UI update
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // const Expanded(child: SizedBox()),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    ref.watch(globalItemListProvider).length,
                                itemBuilder: (BuildContext context, int index) {
                                  // 'home_items':[
                                  //   {'name': 'Home', 'amount': 500},
                                  // ]

                                  // purchaseData[formItem['name']] = homeContent;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          // margin: const EdgeInsets.all(8.0),
                                          color: CustomColors
                                              .lightPrimaryBrandColor(),
                                          elevation: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0.0, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: ref
                                                  .watch(globalItemListProvider)[
                                                      index]
                                                  .entries
                                                  .map((entry) {
                                                return Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${entry.key[0].toUpperCase()}${entry.key.substring(1)}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 12),
                                                        ),
                                                        verticalSpacer(10),
                                                        Text(
                                                          entry.value
                                                              .toString(),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: () {
                                          // globalItem = {};
                                          // setState(() {
                                          ref
                                              .watch(globalItemListProvider)
                                              .removeAt(index);
                                          //   globalItemPair.removeAt(index);
                                          // });

                                          setState(() {});
                                        },
                                        child: const Icon(Icons.delete_outline,
                                            size: 20, color: Colors.red),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                if (ref.watch(formVmProvider).isImageUploading)
                  Container(
                    color: Colors.black
                        .withOpacity(0.5), // Adjust opacity as needed
                    child: Center(
                      child: SpinKitFadingCircle(
                        color: CustomColors.primaryBrandColor(),
                        size: 35.0,
                      ),
                    ),
                  ),
              ],
            );
          }),
        );
      });
}
