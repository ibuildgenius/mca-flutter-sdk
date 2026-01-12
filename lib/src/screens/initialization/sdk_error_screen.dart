import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/initialization_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class SDKErrorScreen extends StatefulHookConsumerWidget {
  final String error;
  const SDKErrorScreen({
    super.key,
    required this.error,
  });

  @override
  ConsumerState<SDKErrorScreen> createState() => _SDKErrorScreenState();
}

class _SDKErrorScreenState extends ConsumerState<SDKErrorScreen> {
  final GlobalKey<_SDKErrorScreenState> myWidgetKey = GlobalKey();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpacer(50.h),
          CustomAppbar(
            showBackButton: false,
            showLogo: false,
            onBackTap:
                Navigator.canPop(context) ? () => Navigator.pop(context) : null,
          ),
          const Spacer(),
          Expanded(
            child: Center(
              child: Lottie.asset(
                ConstantString.sdkErrorAnimation,
                // height: 80,
                // width: 80,
                animate: true,
                repeat: true,
                reverse: false,
                fit: BoxFit.contain,
                package: 'mca_official_flutter_sdk',
              ),
            ),
          ),
          semiBoldText(
            "SDK Initialization Error",
            fontSize: 25.sp,
            color: CustomColors.orangeColor,
          ),
          verticalSpacer(20),
          RichText(
            // textAlign: TextAlign.center,
            textAlign: TextAlign.center,

            text: TextSpan(
              children: [
                TextSpan(
                  text: "We encountered an initialization issue because ",
                  style: CustomTextStyles.regular(
                      fontSize: 16.sp,
                      color: CustomColors.formTitleColor,
                      height: 1.2),
                ),
                TextSpan(
                  text: widget.error,
                  style: CustomTextStyles.semiBold(
                      fontSize: 16.sp,
                      color: CustomColors.primaryBrandColor(),
                      height: 1.2),
                ),
                TextSpan(
                  text:
                      ". It seems there's an error in the initialization process. ",
                  style: CustomTextStyles.regular(
                      fontSize: 16.sp,
                      color: CustomColors.formTitleColor,
                      height: 1.2),
                ),
              ],
            ),
          ),
          verticalSpacer(30),
          Container(
            decoration: BoxDecoration(
                color: CustomColors.lightOrangeColor,
                border: Border.all(
                  width: 0.4,
                  color: CustomColors.orangeColor,
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30,
              ),
              child: Column(
                children: [
                  semiBoldText(
                    "What to do next;",
                    fontSize: 16.sp,
                    color: CustomColors.blackColor,
                  ),
                  verticalSpacer(20),
                  RichText(
                    // textAlign: TextAlign.center,

                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "1.  Retry Initialization: ",
                          style: CustomTextStyles.w500(
                            fontSize: 14.sp,
                            color: CustomColors.blackTextColor,
                            height: 1.6,
                          ),
                        ),
                        TextSpan(
                          text:
                              "Click the button below to attempt initializing the SDK again with the correct public key.",
                          style: CustomTextStyles.regular(
                            fontSize: 13.sp,
                            color: CustomColors.blackTextColor,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          verticalSpacer(40),
          CustomButton(
            title: "Retry",
            isLoading: isLoading,
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              await InitViewModel().initialiseSdk(
                ref,
                context,
                redirectError: false,
              );
              setState(() {
                isLoading = false;
              });
            },
            fontSize: 13.sp,
          ),
          const Spacer(),
        ],
      ),
    ));
  }
}
