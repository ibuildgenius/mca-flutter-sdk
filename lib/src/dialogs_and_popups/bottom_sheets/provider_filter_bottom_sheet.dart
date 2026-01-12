import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/product_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/color_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_image_network.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

void showProviderFilterBottomSheet(
  BuildContext context,
  WidgetRef ref, {
  required ProductViewModel productVM,
  required String categoryid,
  // String? providerId,
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
        return PopScope(
          canPop: isDismissible ? false : true,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return LayoutBuilder(builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.8, // max height constraint
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      verticalSpacer(30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          semiBoldText("Providers", fontSize: 17.sp),
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(selectedproductProviderListProvider
                                      .notifier)
                                  .state = List.from(ref.read(
                                      tempSelectedproductProviderListProvider) ??
                                  []);
                              ref
                                      .read(selectedAllprovidersProvider.notifier)
                                      .state =
                                  ref.read(tempSelectedAllprovidersProvider);
                              // ref
                              //         .read(productProviderListProvider.notifier)
                              //         .state =
                              //     ref.watch(tempProductProviderListProvider);

                              // ref
                              //         .read(selectedAllprovidersProvider.notifier)
                              //         .state =
                              //     ref.watch(tempSelectedAllprovidersProvider);

                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              ConstantString.xMark,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                        ],
                      ),
                      verticalSpacer(30.h),
                      Column(
                        children: [
                          CheckboxListTile(
                            activeColor: CustomColors.primaryBrandColor(),
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Container(
                                  height: 33,
                                  width: 33,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ColorUtils.getColorFromHex(
                                              "#66708580")
                                          .withOpacity(0.5),
                                      width: 4.13,
                                    ),

                                    // color: Colors.red,
                                  ),
                                  child: Center(
                                      child: semiBoldText(
                                    "A",
                                    fontSize: 13.sp,
                                    color: CustomColors.blackColor,
                                  )),
                                ),
                                horizontalSpacer(10.w),
                                Expanded(
                                    child: semiBoldText(
                                  'All providers',
                                  color: CustomColors.blackTextColor,
                                  fontSize: 15.sp,
                                )),
                              ],
                            ),
                            value: ref.watch(selectedAllprovidersProvider),
                            onChanged: (bool? value) {
                              if (ref.watch(selectedAllprovidersProvider) ==
                                  false) {
                                ref
                                    .read(selectedAllprovidersProvider.notifier)
                                    .state = true;

                                ref
                                    .read(selectedproductProviderListProvider
                                        .notifier)
                                    .state = [];
                              } else {
                                ref
                                    .read(selectedAllprovidersProvider.notifier)
                                    .state = false;
                              }

                              setState(() {
                                // allSelected = true;
                              });
                              // setst
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: const Divider(
                              color: CustomColors.productBorderColor,
                              thickness: 0.7,
                            ),
                          )
                        ],
                      ),

                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount:
                              ref.watch(productProviderListProvider)?.length ??
                                  0,
                          itemBuilder: (BuildContext context, int index) {
                            final provider =
                                ref.watch(productProviderListProvider)![index];
                            final isSelected = ref
                                .watch(selectedproductProviderListProvider)
                                .contains(provider.id);
                            return Column(
                              children: [
                                CheckboxListTile(
                                  activeColor: CustomColors.primaryBrandColor(),
                                  contentPadding: EdgeInsets.zero,
                                  title: Row(
                                    children: [
                                      Container(
                                        height: 33,
                                        width: 33,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: ColorUtils.getColorFromHex(
                                                    provider.brandColorPrimary)
                                                .withOpacity(0.5),
                                            width: 4.13,
                                          ),

                                          // color: Colors.red,
                                        ),
                                        child: Center(
                                            child: StringUtils.isNullOrEmpty(
                                                    provider.icon)
                                                ? semiBoldText(
                                                    StringUtils
                                                        .getFirstCharCapitalized(
                                                            provider
                                                                .companyName),
                                                    fontSize: 13.sp,
                                                    color:
                                                        CustomColors.blackColor,
                                                  )
                                                : customImagenetwork(
                                                    imageUrl: provider.icon!,
                                                    loaderWidget: regularText(
                                                        provider.companyName ??
                                                            "",
                                                        fontSize: 13.sp,
                                                        color: CustomColors
                                                            .greyTextColor),
                                                    // fit: BoxFit.cover,
                                                    height: 15.h,
                                                  )

                                            // kk semiBoldText(
                                            //   StringUtils.getFirstCharCapitalized(provider?.companyName),
                                            //   fontSize: 13.sp,
                                            //   color: CustomColors.blackColor,
                                            // ),
                                            ),
                                      ),
                                      horizontalSpacer(10.w),
                                      Expanded(
                                          child: semiBoldText(
                                        provider.companyName ?? '',
                                        color: CustomColors.blackTextColor,
                                        fontSize: 15.sp,
                                      )),
                                    ],
                                  ),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      ref
                                          .watch(
                                              selectedproductProviderListProvider)
                                          .add(provider.id!);
                                      ref
                                          .read(selectedAllprovidersProvider
                                              .notifier)
                                          .state = false;
                                    } else {
                                      ref
                                          .watch(
                                              selectedproductProviderListProvider)
                                          .remove(provider.id);
                                    }
                                    setState(() {
                                      // Trigger UI update
                                    });
                                    // setst
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  child: const Divider(
                                    color: CustomColors.productBorderColor,
                                    thickness: 0.7,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      verticalSpacer(10.w),
                      // verticalSpacer(50),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomButton(
                              title: "Cancel",
                              buttonColor: CustomColors.dividerGreyColor,
                              textColor: CustomColors.backTextColor,
                              fontSize: 14.sp,
                              onTap: () {
                                ref
                                    .read(selectedproductProviderListProvider
                                        .notifier)
                                    .state = List.from(ref.read(
                                        tempSelectedproductProviderListProvider) ??
                                    []);
                                ref
                                        .read(selectedAllprovidersProvider.notifier)
                                        .state =
                                    ref.read(tempSelectedAllprovidersProvider);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          horizontalSpacer(10.w),
                          Expanded(
                            flex: 2,
                            child: CustomButton(
                              title: "Save Changes",
                              onTap: () async {
                                Navigator.pop(context);

                                ref
                                    .read(productProviderListProvider.notifier)
                                    .state = null;
                                ref.read(productListProvider.notifier).state =
                                    null;
                                await productVM.getInsuranceProviders(
                                    categoryid: categoryid,
                                    // providerIds: ref.watch(
                                    //     selectedproductProviderListProvider),
                                    ref: ref,
                                    context: context);
                              },
                            ),
                          ),
                        ],
                      ),
                      verticalSpacer(
                          MediaQuery.of(context).padding.bottom + 10),
                    ],
                  ),
                ),
              );
            });
          }),
        );
      });
}
