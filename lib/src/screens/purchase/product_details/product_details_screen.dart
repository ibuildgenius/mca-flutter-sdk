import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/form_field_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/first_form_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/form_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';
import 'package:mca_official_flutter_sdk/src/widgets/product_details_container.dart';

class ProductDetailsScreen extends StatefulHookConsumerWidget {
  // final String title;
  // final String productName;
  // final String periodOfCover;
  // final String formattedPrice;
  // final String price;
  // final ProviderLiteModel? provider;
  // final bool isDynamicPrice;
  // final String? keyBenefits;
  // final String? howToClaim;
  // final String? howItWorks;
  // final String? fullBenefits;
  // final ProductCategoriesModel productCategory;
  final ProductDetailsModel? productDetails;

  //

  // periodOfCover: StringUtils
  //                                                 .getProviderPeriodOfCover(
  //                                               productDetails?.coverPeriod ??
  //                                                   "",
  //                                             ),
  //                                             formattedPrice:
  //                                                 StringUtils.getProductPrice(
  //                                                     productDetails?.price ??
  //                                                         "",
  //                                                     productDetails
  //                                                             ?.isDynamicPricing ??
  //                                                         false),

  //

  //  price:
  //                                               productDetails?.price ?? "",
  //                                           provider:
  //                                               productDetails?.provider,
  //                                           isDynamicPrice: productDetails
  //                                                   ?.isDynamicPricing ??
  //                                               false,

  const ProductDetailsScreen({
    super.key,
    // required this.title,
    // required this.productName,
    // required this.periodOfCover,
    // required this.formattedPrice,
    // required this.price,
    // required this.productCategory,
    required this.productDetails,
    // this.provider,
    // required this.isDynamicPrice,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  SdkOptions selectedOption = SdkOptions.buy;
  bool isLoading = true;

  void handleFilteredFields(WidgetRef ref, BuildContext context) async {
    List<FormFieldModel> filteredFields =
        (widget.productDetails?.formFields ?? [])
            .where((field) => field.showFirst == true && field.dataUrl != null)
            .toList();

    await processFields(fields: filteredFields, ref: ref, context: context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleFilteredFields(ref, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          child: Column(
        children: [
          verticalSpacer(20.h),
          CustomAppbar(
            popTwice: false,
            onBackTap:
                Navigator.canPop(context) ? () => Navigator.pop(context) : null,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacer(10.h),
                  semiBoldText(
                    "Product details",
                    fontSize: 20.sp,
                    color: CustomColors.darkTextColor,
                  ),
                  verticalSpacer(30.h),
                  const ProductDetailsContainer(
                      // isWhiteBg: true,
                      // productName: widget.productName,
                      // periodOfCover: widget.periodOfCover,
                      // formattedPrice: widget.formattedPrice,
                      // price: widget.price,
                      // provider: widget.provider,
                      // isDynamicPrice: widget.isDynamicPrice,
                      // productCategory: widget.productCategory,
                      ),
                  verticalSpacer(10.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          widget.productDetails?.keyBenefits == null
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: ExpandableContainer(
                                    title: "About product",
                                    subTtitle:
                                        widget.productDetails!.keyBenefits!,
                                  ),
                                ),
                          widget.productDetails?.howItWorks == null
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: ExpandableContainer(
                                    title: "How it work",
                                    subTtitle:
                                        widget.productDetails!.howItWorks!,
                                  ),
                                ),
                          widget.productDetails?.fullBenefits == null
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: ExpandableContainer(
                                    title: "Benefits",
                                    subTtitle:
                                        widget.productDetails!.fullBenefits!,
                                  ),
                                ),
                          widget.productDetails?.howToClaim == null
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: ExpandableContainer(
                                    title: "How to claim",
                                    subTtitle:
                                        widget.productDetails!.howToClaim!,
                                  ),
                                ),
                          verticalSpacer(30.h),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    title: "Continue",
                    onTap: (ref.watch(selectedProductDetailsProvider) == null ||
                            ref
                                    .watch(selectedProductDetailsProvider)
                                    ?.formFields ==
                                null ||
                            ref
                                .watch(selectedProductDetailsProvider)!
                                .formFields!
                                .isEmpty)
                        ? () => CustomToast.showErrorMessage(context,
                            "Product Unavailable, please try again later.")
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstFormScreen(
                                          productDetails: ref.watch(
                                              selectedProductDetailsProvider),
                                          // formFields:
                                          //     widget.productDetails?.formFields ?? [],

                                          // provider: widget.provider,
                                        )));
                          },
                  ),
                  verticalSpacer(25.h),
                  const PoweredByFooter(),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> processFields({
    required List<FormFieldModel> fields,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    for (var field in fields) {
      if (field.dataUrl != null) {
        field.dataType == "array"
            ? await FormViewModel.initWhoAmI().getMapData(
                context: context,
                ref: ref,
                dataUrl: field.dataUrl ?? "",
                fieldName: field.name ?? "",
              )
            : await FormViewModel.initWhoAmI().getListData(
                context: context,
                ref: ref,
                dataUrl: field.dataUrl ?? "",
                fieldName: field.name ?? "",
              );
      }
    }
  }
}

class ExpandableContainer extends StatefulWidget {
  final String title;
  final String subTtitle;

  const ExpandableContainer({
    super.key,
    required this.title,
    required this.subTtitle,
  });

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool _isExpanded = false;

  void _toggleContainer() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleContainer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: CustomColors.backBorderColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        // width: 300,
        height: _isExpanded ? MediaQuery.of(context).size.height * 0.3 : 55,
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    semiBoldText(
                      widget.title,
                      fontSize: 14.sp,
                      color: CustomColors.blackColor,
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Center(
                        child: SvgPicture.asset(ConstantString.chevronDown,
                            package: 'mca_official_flutter_sdk'),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: AnimatedCrossFade(
                  firstChild: Container(),
                  secondChild: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      // bottom: 5,
                      left: 16.w,
                      right: 16.w,
                    ),
                    child:

                        //     HtmlWidget(
                        //   widget.subTtitle,
                        // ),

                        Scrollbar(
                      // isAlwaysShown: true,
                      child: SingleChildScrollView(
                        child: HtmlWidget(
                          widget.subTtitle,
                        ),

                        // Text(
                        //   'Here is the expanded content. You can show more information here. Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.t. You can show more information here.Here is the expanded content. You can show more information here.Here is the expanded content. You can show more information here.\nHere is the expanded content. You can show more information here.',
                        //   style: TextStyle(color: Colors.black, fontSize: 16),
                        // ),
                      ),
                    ),
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ),
              // if (_isExpanded) ...[
              //   const SizedBox(height: 20),
              //   const Text(
              //     'Here is the expanded content. You can show more information here.',
              //     style: TextStyle(color: Colors.white, fontSize: 16),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}

// verticalSpacer(30.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 semiBoldText("Auto Product", fontSize: 16.sp),
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: SvgPicture.asset(
//                     ConstantString.xMark,
//                     package: 'mca_official_flutter_sdk',
//                   ),
//                 ),
//               ],
//             ),
//             verticalSpacer(30.h),
//             Container(
//               decoration: BoxDecoration(
//                   color: CustomColors.backBorderColor,
//                   borderRadius: BorderRadius.circular(2.r),
//                   border: const Border(
//                       bottom: BorderSide(
//                     color: CustomColors.productBorderColor,
//                     width: 0.2,
//                   ))),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   vertical: 10.h,
//                   horizontal: 15.w,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Row(
//                         children: [
//                           IconContainer(
//                             icon: mockProductLists[0].icon,
//                           ),
//                           horizontalSpacer(10.w),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               semiBoldText(
//                                 mockProviderProductLists[0].title,
//                                 fontSize: 14.sp,
//                               ),
//                               verticalSpacer(3.h),
//                               Row(
//                                 children: [
//                                   regularText("by; ",
//                                       fontSize: 13.sp,
//                                       color: CustomColors.greyTextColor),
//                                   horizontalSpacer(3.w),
//                                   Image.asset(
//                                     height: 15.h,
//                                     mockProviderProductLists[1].imageUrl,
//                                     fit: BoxFit.cover,
//                                     package: 'mca_official_flutter_sdk',
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         semiBoldText(
//                           "5% / Annum",
//                           fontSize: 14.sp,
//                           color: CustomColors.primaryGreenColor,
//                         ),
//                         verticalSpacer(5.h),
//                         (mockProviderProductLists[0].hasDiscount)
//                             ? Container(
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                     color: CustomColors.discountBgColor,
//                                     borderRadius:
//                                         BorderRadius.circular(2.r)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 5.0),
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                     children: [
//                                       regularText("30% discount",
//                                           fontSize: 12.sp,
//                                           color: CustomColors.blackColor),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             : const SizedBox(
//                                 height: 20,
//                               ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             verticalSpacer(30.h),
//             regularText(
//               "3rd party Auto underwritten by AIICO is a 12 Months premium that covere your vehicle and other valuable bla blah",
//               fontSize: 14.sp,
//             ),
//             verticalSpacer(50),
