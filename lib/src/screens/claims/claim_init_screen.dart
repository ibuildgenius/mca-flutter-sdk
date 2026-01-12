import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/bottom_sheets/privacy_policy_bottom_sheet.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/confirm_policy_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ClaimInitScreen extends StatefulHookConsumerWidget {
  static const routeName = '/ClaimInitScreen';

  const ClaimInitScreen({super.key});

  @override
  ConsumerState<ClaimInitScreen> createState() => _ClaimInitScreenState();
}

class _ClaimInitScreenState extends ConsumerState<ClaimInitScreen> {
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
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          child: Column(
        children: [
          verticalSpacer(20),
          const CustomAppbar(
            showHelp: true,
            showLogo: true,
            showBackButton: false,
            popTwice: false,
            // onBackTap: Navigator.canPop(context)
            //     ? () => Navigator.pop(context)
            //     : null,
            // logoUrl: ref.watch(businessDetailsProvider)?.logo,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  verticalSpacer(10),
                  GestureDetector(
                    onTap: () {
                  
                    },
                    child: semiBoldText(
                        Global.businessDetails
                                ?.sdkWelcomeScreenHeaderPreClaim ??
                            Global.businessDetailsFallback
                                ?.sdkWelcomeScreenHeaderPreClaim ??
                            "Welcome to claim Portal",
                        fontSize: 20),
                  ),
                  verticalSpacer(20),
                  regularText(
                      Global.businessDetails?.sdkWelcomeScreenBodyPreClaim ??
                          Global.businessDetailsFallback
                              ?.sdkWelcomeScreenBodyPreClaim ??
                          "Welcome to the claim portal. We're sorry to see you here, and we're here to assist you through the process.",
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
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: Global.businessDetails?.sdkBannerClaim ??
                              Global.businessDetailsFallback!.sdkBannerClaim!,
                          placeholder: (context, url) => SpinKitFadingCircle(
                            color: CustomColors.primaryBrandColor(),
                            size: 35.0,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),

                        //  Image.asset(
                        //   ConstantString.inspectionWelcome,
                        //   fit: BoxFit.fill,
                        //   package: 'mca_official_flutter_sdk',
                        // ),

                        //  Image.network(
                        //     Global.businessDetails!.sdkBannerPurchase!,
                        //     fit: BoxFit.fill,
                        //   ),
                      ),
                    ),
                  ),

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
                        horizontalSpacer(10),
                        SizedBox(
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'I have Read and  Understand  this  Privacy ',
                              style: CustomTextStyles.regular(
                                fontSize: 14,
                                color: CustomColors.blackTextColor,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showPrivacyPolicyBottomSheet(context,
                                title: "Privacy Condition");
                          },
                          child: Text('Policy.',
                              style: CustomTextStyles.regular(
                                fontSize: 14,
                                color: CustomColors.primaryBrandColor(),
                              )),
                        )
                      ],
                    ),
                  ),

                  verticalSpacer(30),
                  CustomButton(
                    title: "Continue",
                    onTap: _isChecked
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ConfirmPolicyScreen()));
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
