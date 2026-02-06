import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/listview_product_list/listview_provider_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/icon_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/icon_container.dart';

class ListViewProductListScreen extends StatefulHookConsumerWidget {
  const ListViewProductListScreen({super.key});

  @override
  ConsumerState<ListViewProductListScreen> createState() =>
      _ListViewProductListScreenState();
}

class _ListViewProductListScreenState
    extends ConsumerState<ListViewProductListScreen> {
  SdkOptions selectedOption = SdkOptions.buy;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              verticalSpacer(20.h),
              CustomAppbar(
                popTwice: false,
                onBackTap: Navigator.canPop(context)
                    ? () => Navigator.pop(context)
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpacer(10.h),
                      semiBoldText(
                        "Select product category",
                        fontSize: 20.sp,
                      ),
                      verticalSpacer(20.h),
                      // customTextField(
                      //   "search",
                      //   labelText: "Search Product",
                      //   prefix: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       SvgPicture.asset(
                      //         ConstantString.searchIcon,
                      //         package: 'mca_official_flutter_sdk',
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // verticalSpacer(30.h),
                      mediumText(
                          "${ref.watch(productCategoriesProvider).fold(0, (sum, item) => sum + (item.productCount ?? 0))} Insurance products",
                          fontSize: 16.sp,
                          color: CustomColors.checkBoxBorderColor),
                      verticalSpacer(40.h),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.h),
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).padding.bottom + 5),
                            shrinkWrap: true,

                            // clipBehavior: ,// Set to true to enable scrolling in ListView
                            // physics:
                            //     const NeverScrollableScrollPhysics(), // Disable scrolling in ListView

                            itemCount:
                                ref.watch(productCategoriesProvider).length,
                            // itemCount: 1,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListViewProviderListScreen(
                                                categoryid: ref
                                                        .watch(productCategoriesProvider)[
                                                            index]
                                                        .id ??
                                                    "",
                                                productCategory: ref.watch(
                                                        productCategoriesProvider)[
                                                    index],
                                              )));
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              IconContainer(
                                                diameter: 41,
                                                icon: IconUtils.getIcon(ref
                                                        .watch(productCategoriesProvider)[
                                                            index]
                                                        .name ??
                                                    ""),
                                              ),
                                              horizontalSpacer(13.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  semiBoldText(
                                                    "${ref.watch(productCategoriesProvider)[index].name ?? ""} Insurance",
                                                    fontSize: 15.sp,
                                                  ),
                                                  verticalSpacer(3.h),
                                                  regularText(
                                                      "${ref.watch(productCategoriesProvider)[index].productCount} products",
                                                      fontSize: 13.sp,
                                                      color: CustomColors
                                                          .greyTextColor),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          ConstantString.chevronRight,
                                          package: 'mca_official_flutter_sdk',
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 11.h),
                                      child: const Divider(
                                        color: CustomColors.productBorderColor,
                                        thickness: 0.7,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // CustomButton(
                      //   title: "Continue",
                      //   onTap: () {},
                      // ),
                      // verticalSpacer(25.h),
                      // const PoweredByFooter(),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
