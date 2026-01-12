import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/widgets/grid_options_container.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_init_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/product_list/gridview_product_list/gridview_product_list_screen.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class GridSdkOptionsScreen extends StatefulWidget {
  const GridSdkOptionsScreen({super.key});

  @override
  State<GridSdkOptionsScreen> createState() => _GridSdkOptionsScreenState();
}

class _GridSdkOptionsScreenState extends State<GridSdkOptionsScreen> {
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
                  verticalSpacer(40.h),
                  Row(
                    children: [
                      GridOptionsContainer(
                        title: "Buy Insurance",
                        subTitle:
                            "Get Insurance for your self, family and love ones",
                        icon: ConstantString.buyIcon,
                        isSelected: selectedOption == SdkOptions.buy,
                        onTap: () => setState(() {
                          selectedOption = SdkOptions.buy;
                        }),
                      ),
                      horizontalSpacer(20.w),
                      GridOptionsContainer(
                        title: "Renew Insurance",
                        subTitle: "Seamlessly renew your Insurance",
                        icon: ConstantString.renewIcon,
                        isSelected: selectedOption == SdkOptions.renew,
                        onTap: () => setState(() {
                          selectedOption = SdkOptions.renew;
                        }),
                      ),
                    ],
                  ),
                  verticalSpacer(30.h),
                  Row(
                    children: [
                      GridOptionsContainer(
                        title: "Manage Plan",
                        subTitle: "Seamlessly manage your insurance plan",
                        icon: ConstantString.manageIcon,
                        isSelected: selectedOption == SdkOptions.manage,
                        onTap: () => setState(() {
                          selectedOption = SdkOptions.manage;
                        }),
                      ),
                      horizontalSpacer(15.w),
                      GridOptionsContainer(
                        title: "Make Claim",
                        subTitle: "Seamlessly lodge a claim",
                        icon: ConstantString.claimIcon,
                        isSelected: selectedOption == SdkOptions.claim,
                        onTap: () => setState(() {
                          selectedOption = SdkOptions.claim;
                        }),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  CustomButton(
                    title: "Continue",
                    onTap: selectedOption == SdkOptions.renew
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InspectionInitScreen()));
                          }
                        : selectedOption == SdkOptions.buy
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GridViewProductListScreen()));
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
