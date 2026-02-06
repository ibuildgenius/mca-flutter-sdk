import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/privacy_policy_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/auto_inspection_pageview.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/gadget/gadget_inspection_pageview.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';
import 'dart:developer';
class InspectionInitScreen extends StatefulHookConsumerWidget {
  final ClaimModel? claim;
  final ProductCategory? productCategory;
  static const routeName = '/InspectionInitScreen';

  const InspectionInitScreen({super.key, this.claim, this.productCategory});

  @override
  ConsumerState<InspectionInitScreen> createState() =>
      _InspectionInitScreenState();
}

class _InspectionInitScreenState extends ConsumerState<InspectionInitScreen> {
  void closeSDK() {
    // Close the SDK screen
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    //     (Route<dynamic> route) => false);
    Navigator.of(context).pop();
    // locator<NavigationHandler>().pop();
  }

  bool _isChecked = false;

  // @override
  // void initState() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);

  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final businessConfig = ref.watch(businessDetailsProvider);

    final bannerFallBackConfig = ref.watch(businessFallBackDetailsProvider);
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          child: Column(
        children: [
          verticalSpacer(20),
          CustomAppbar(
            showHelp: true,
            showLogo: false,
            showBackButton: true,
            popTwice: true,
            onBackTap:
                Navigator.canPop(context) ? () => Navigator.pop(context) : null,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  verticalSpacer(10),
                  semiBoldText(
                      Global.businessDetails
                              ?.sdkWelcomeScreenHeaderPreInspection ??
                          Global.businessDetailsFallback
                              ?.sdkWelcomeScreenHeaderPreInspection ??
                          "Inspection Portal",
                      fontSize: 20),
                  regularText(
                      Global.businessDetails
                              ?.sdkWelcomeScreenBodyPreInspection ??
                          Global.businessDetailsFallback
                              ?.sdkWelcomeScreenBodyPreInspection ??
                          "Welcome to the Inspection Portal! Here, you can seamlessly carry out both Pre-loss and Post-loss inspections for your vehicle.",
                      fontSize: 14,
                      textAlign: TextAlign.center),
// ref.watch(businessDetailsProvider)?.sdkba
                  // sdk_banner_purchase
                  verticalSpacer(30),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child:
                            // (
                            //     (Global.businessDetails == null ||
                            //         StringUtils.isNullOrEmpty(Global.businessDetails?.sdkBannerInspection)) && (Global.businessDetailsFallback == null || StringUtils.isNullOrEmpty(Global.businessDetailsFallback?.sdkBannerInspection))
                            // )
                            //     ? Image.asset(
                            //         ConstantString.inspectionWelcome,
                            //         fit: BoxFit.fill,
                            //         package: 'mca_official_flutter_sdk',
                            //       )
                            //     :
                            CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl:
                              Global.businessDetails?.sdkBannerInspection ??
                                  Global.businessDetailsFallback
                                      ?.sdkBannerInspection ??
                                  bannerFallBackConfig?.sdkBannerInspection ??
                                  '',
                          placeholder: (context, url) => SpinKitFadingCircle(
                            color: CustomColors.primaryBrandColor(),
                            size: 35.0,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),

                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Row(
                    children: [
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
                            horizontalSpacer(10),
                            SizedBox(
                              child: Text(
                                'I have Read and  Understand  this  Privacy ',
                                style: CustomTextStyles.regular(
                                  fontSize: 14,
                                  color: CustomColors.blackTextColor,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () async {
                                showPrivacyPolicyBottomSheet(context,
                                    title: "Privacy Condition");
                              },
                              child: Text(
                                'Privacy.',
                                style: CustomTextStyles.regular(
                                  fontSize: 14,
                                  color: CustomColors.primaryBrandColor(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  verticalSpacer(30),
                  CustomButton(
                    title: "Continue",
                    onTap: _isChecked
                        ? () {
                            log('wii ${widget.productCategory}');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        widget.productCategory ==
                                                ProductCategory.gadget
                                            ? const GadgetInspectionPageView()
                                            : const CarInspectionPageView()));
                          }
                        : null,
                  ),
                  verticalSpacer(25),
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
