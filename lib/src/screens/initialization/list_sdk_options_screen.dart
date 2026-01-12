import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/widgets/list_options_container.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/listview_product_list/listview_product_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ListSdkOptionsScreen extends StatefulWidget {
  const ListSdkOptionsScreen({super.key});

  @override
  State<ListSdkOptionsScreen> createState() => _ListSdkOptionsScreenState();
}

class _ListSdkOptionsScreenState extends State<ListSdkOptionsScreen> {
  SdkOptions selectedOption = SdkOptions.buy;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: SafeArea(
          child: Column(
        children: [
          verticalSpacer(20.h),
          CustomAppbar(
            onBackTap:
                Navigator.canPop(context) ? () => Navigator.pop(context) : null,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  verticalSpacer(50.h),
                  semiBoldText(
                    "Select an option to proceed",
                    fontSize: 20.sp,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          verticalSpacer(40.h),
                          ListOptionsContainer(
                            title: "Buy Insurance",
                            subTitle: Global
                                    .businessDetails?.sdkMenu1SupportingText ??
                                "Get Insurance for your self, family and love ones. ",
                            icon: ConstantString.buyIcon,
                            isSelected: selectedOption == SdkOptions.buy,
                            onTap: () => setState(() {
                              selectedOption = SdkOptions.buy;
                            }),
                          ),
                          verticalSpacer(15.h),
                          ListOptionsContainer(
                            title: "Renew Insurance",
                            subTitle: Global
                                    .businessDetails?.sdkMenu2SupportingText ??
                                "Seamlessly renew your Insurance",
                            icon: ConstantString.renewIcon,
                            isSelected: selectedOption == SdkOptions.renew,
                            onTap: () => setState(() {
                              selectedOption = SdkOptions.renew;
                            }),
                          ),
                          verticalSpacer(15.h),
                          ListOptionsContainer(
                            title: "Manage Plan",
                            subTitle: Global
                                    .businessDetails?.sdkMenu3SupportingText ??
                                "Seamlessly manage your insurance plan",
                            icon: ConstantString.manageIcon,
                            isSelected: selectedOption == SdkOptions.manage,
                            onTap: () => setState(() {
                              selectedOption = SdkOptions.manage;
                            }),
                          ),
                          verticalSpacer(15.h),
                          ListOptionsContainer(
                            title: "Make Claim",
                            subTitle: Global
                                    .businessDetails?.sdkMenu4SupportingText ??
                                "Seamlessly lodge a claim",
                            icon: ConstantString.claimIcon,
                            isSelected: selectedOption == SdkOptions.claim,
                            onTap: () => setState(() {
                              selectedOption = SdkOptions.claim;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const Expanded(child: SizedBox()),
                  CustomButton(
                    title: "Continue",
                    onTap: selectedOption == SdkOptions.buy
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListViewProductListScreen()));
                          }
                        : null,
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
}
