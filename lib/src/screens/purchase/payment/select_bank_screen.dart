import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/payment_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/payment_details_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class SelectBankScreen extends StatefulHookConsumerWidget {
  const SelectBankScreen({
    super.key,
  });

  @override
  ConsumerState<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends ConsumerState<SelectBankScreen> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    final paymentVM = ref.watch(paymentProvider);
    return Stack(
      children: [
        Scaffold(
          // backgroundColor: CustomColors.whiteColor,
          body: SafeArea(
              child: Column(
            children: [
              verticalSpacer(20.h),
              CustomAppbar(
                onBackTap: Navigator.canPop(context)
                    ? () => Navigator.pop(context)
                    : null,
              ),
              verticalSpacer(10.h),
              // pusher.
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const PaymentDetailsContainer(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpacer(30),
                      customTextField(
                        "search",
                        labelText: "Search for bank of your choice",
                        prefix: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ConstantString.searchIcon,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ],
                        ),
                      ),
                      verticalSpacer(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          semiBoldText(
                            "Select your preferred bank",
                            fontSize: 15.sp,
                          ),
                        ],
                      ),
                      verticalSpacer(20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: Global.ussdProviders.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: paymentVM.isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                        ref
                                            .read(selectedBankProvider.notifier)
                                            .state = Global.ussdProviders[index];
                                        paymentVM.initiateGatewayPurchase(
                                          paymentMethod: PaymentMethod.ussd,
                                          ref: ref,
                                          context: context,
                                          // provider: widget.provider,
                                          // productDetails: widget.productDetails,
                                        );
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: CustomColors
                                                  .lighterPrimaryBrandColor(),
                                            ),
                                            child: Center(
                                              child: mediumText(
                                                  StringUtils
                                                      .getFirstCharCapitalized(
                                                          Global
                                                              .ussdProviders[
                                                                  index]
                                                              .bankName),
                                                  color: CustomColors
                                                      .primaryBrandColor(),
                                                  fontSize: 18),
                                            ),
                                          ),
                                          horizontalSpacer(10),
                                          regularText(
                                            Global.ussdProviders[index]
                                                    .bankName ??
                                                "",
                                            color: CustomColors.backTextColor,
                                            fontSize: 18,
                                          ),
                                          paymentVM.isLoading &&
                                                  selectedIndex == index
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: SizedBox(
                                                    height: 12,
                                                    width: 12,
                                                    child: Center(
                                                      child:
                                                          SpinKitFadingCircle(
                                                        color: CustomColors
                                                            .primaryBrandColor(),
                                                        size: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink()
                                        ],
                                      ),
                                      verticalSpacer(5),
                                      const Divider(
                                        color: CustomColors.dividerGreyColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const PoweredByFooter(),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }
}
