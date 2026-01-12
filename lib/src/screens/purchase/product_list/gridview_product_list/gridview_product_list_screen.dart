import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/gridview_product_list/gridview_provider_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/icon_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/icon_container.dart';

class GridViewProductListScreen extends StatefulHookConsumerWidget {
  const GridViewProductListScreen({super.key});

  @override
  ConsumerState<GridViewProductListScreen> createState() =>
      _GridViewProductListScreenState();
}

class _GridViewProductListScreenState
    extends ConsumerState<GridViewProductListScreen> {
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
                      // verticalSpacer(30.h),
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
                      verticalSpacer(30.h),
                      mediumText(
                          "${ref.watch(productCategoriesProvider).fold(0, (sum, item) => sum + (item.productCount ?? 0))} Insurance products",
                          fontSize: 16.sp,
                          color: CustomColors.checkBoxBorderColor),
                      verticalSpacer(25.h),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 25),
                          shrinkWrap: true,

                          // clipBehavior: ,// Set to true to enable scrolling in ListView
                          // physics:
                          //     const NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                2, // Set to 2 to display items in pairs
                            childAspectRatio:
                                1.1, // Set aspect ratio to 1 to maintain square shape
                            crossAxisSpacing: 12.w,
                            // // Set spacing between columns
                            mainAxisSpacing:
                                MediaQuery.of(context).size.width * 0.049,
                          ),
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
                                            GridViewProviderListScreen(
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
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: CustomColors.productBorderColor,
                                  width: 0.6,
                                )),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 25.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconContainer(
                                        icon: IconUtils.getIcon(ref
                                                .watch(productCategoriesProvider)[
                                                    index]
                                                .name ??
                                            ""),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      semiBoldText(
                                        "${ref.watch(productCategoriesProvider)[index].name ?? ""} Insurance",
                                        fontSize: 14.sp,
                                      ),
                                      verticalSpacer(5.h),
                                      regularText(
                                          "${ref.watch(productCategoriesProvider)[index].productCount} products",
                                          fontSize: 13.sp,
                                          color: CustomColors.greyTextColor),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
