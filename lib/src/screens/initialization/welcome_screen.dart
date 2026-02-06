import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/privacy_policy_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/grid_sdk_options_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/list_sdk_options_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/gridview_product_list/gridview_product_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/listview_product_list/listview_product_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class WelcomeScreen extends StatefulHookConsumerWidget {
  static const routeName = '/WelcomeScreen';
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  void closeSDK() {
    // Close the SDK screen
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    //     (Route<dynamic> route) => false);
    Navigator.of(context).pop();
    // locator<NavigationHandler>().pop();
  }

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          child: Column(
        children: [
          verticalSpacer(20.h),
          const CustomAppbar(
            showHelp: true,
            showLogo: true,
            showBackButton: false,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  verticalSpacer(25.h),
// ref.watch(businessDetailsProvider)?.sdkba
                  // sdk_banner_purchase

                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: (Global.businessDetails == null ||
                                StringUtils.isNullOrEmpty(
                                    Global.businessDetails?.sdkBannerPurchase))
                            ? Image.asset(
                                ConstantString.introImage,
                                fit: BoxFit.fill,
                                package: 'mca_official_flutter_sdk',
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl:
                                    Global.businessDetails!.sdkBannerPurchase!,
                                placeholder: (context, url) =>
                                    SpinKitFadingCircle(
                                  color: CustomColors.primaryBrandColor(),
                                  size: 35.0,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),

                        //  Image.network(
                        //     Global.businessDetails!.sdkBannerPurchase!,
                        //     fit: BoxFit.fill,
                        //   ),
                      ),
                    ),
                  ),
                  verticalSpacer(30.h),
                  semiBoldText(
                      Global.businessDetails
                              ?.sdkWelcomeScreenHeaderPrePurchase ??
                          "Insurance by Cowrywise",
                      fontSize: 20.sp),
                  verticalSpacer(20.h),
                  regularText(
                      Global.businessDetails?.sdkWelcomeScreenBodyPrePurchase ??
                          "Insurance by cowrywise powered by mycover.ai gives you everything you need about insurance ranging from Health product to more than thousands plus products",
                      fontSize: 14.sp,
                      textAlign: TextAlign.center),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isChecked = !_isChecked;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // hor(10.w),
                        SizedBox(
                          height: 14,
                          width: 14,
                          child: Checkbox(
                            checkColor: CustomColors.whiteColor,
                            activeColor: CustomColors.primaryBrandColor(),
                            side: const BorderSide(
                                color: CustomColors.checkBoxBorderColor,
                                width: 2),
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                        ),
                        horizontalSpacer(10.w),
                        SizedBox(
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'I have Read and  Understand  this  Privacy ',
                              style: CustomTextStyles.regular(
                                fontSize: 14.sp,
                                color: CustomColors.blackTextColor,
                              ),
                              children: [
                                TextSpan(
                                    text: 'Privacy.',
                                    style: CustomTextStyles.regular(
                                      fontSize: 14.sp,
                                      color: CustomColors.primaryBrandColor(),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showPrivacyPolicyBottomSheet(context,
                                            title: "Privacy Condition");
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             const PrivacyPolicyScreen()
                                        // const WebViewScreen(
                                        //   title: "Privacy",
                                        //   url:
                                        //       "https://www.mycover.ai/",
                                        // )

                                        // ));
                                      })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  verticalSpacer(30.h),
                  CustomButton(
                    title: "Continue",
                    onTap: _isChecked
                        ? () {
                            Global.transactionType == TransactionType.purchase
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ref
                                                    .watch(initResponseProvider)
                                                    ?.businessDetails
                                                    ?.layout
                                                    ?.toLowerCase() ==
                                                SdkLayout.grid.getName
                                            ? const GridViewProductListScreen()
                                            : const ListViewProductListScreen()))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ref
                                                    .watch(initResponseProvider)
                                                    ?.businessDetails
                                                    ?.layout
                                                    ?.toLowerCase() ==
                                                SdkLayout.grid.getName
                                            ? const GridSdkOptionsScreen()
                                            : const ListSdkOptionsScreen()));
                          }
                        : null,
                  ),
                  verticalSpacer(25.h),
                  const PoweredByFooter()
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
