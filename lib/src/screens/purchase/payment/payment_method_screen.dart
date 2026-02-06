import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/widgets/grid_options_container.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/widgets/list_options_container.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/payment_view_model.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/payment_details_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class PaymentMethodScreen extends StatefulHookConsumerWidget {
  const PaymentMethodScreen({
    super.key,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  PaymentMethod selectedOption = PaymentMethod.transfer;
  @override
  Widget build(BuildContext context) {
    final paymentVM = ref.watch(paymentProvider);
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: const PaymentDetailsContainer(
                // provider: widget.provider,
                // productDetails: widget.productDetails,
                ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacer(50.h),
                  semiBoldText(
                    "Select Payment method",
                    fontSize: 20.sp,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          verticalSpacer(40.h),
                          ref
                                      .watch(initResponseProvider)
                                      ?.businessDetails
                                      ?.layout
                                      ?.toLowerCase() ==
                                  SdkLayout.grid.getName
                              ? Row(
                                  children: [
                                    GridOptionsContainer(
                                      title: "Transfer",
                                      subTitle: "Send to a bank Account",
                                      icon: ConstantString.transferIcon,
                                      isSelected: selectedOption ==
                                          PaymentMethod.transfer,
                                      onTap: () => setState(() {
                                        selectedOption = PaymentMethod.transfer;
                                      }),
                                    ),
                                    horizontalSpacer(20.w),
                                    GridOptionsContainer(
                                      title: "USSD",
                                      subTitle:
                                          "Select any bank to generate USSD",
                                      icon: ConstantString.ussdIcon,
                                      isSelected:
                                          selectedOption == PaymentMethod.ussd,
                                      onTap: () => setState(() {
                                        selectedOption = PaymentMethod.ussd;
                                      }),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    ListOptionsContainer(
                                      title: "Transfer",
                                      subTitle: "Send to a bank Account",
                                      icon: ConstantString.transferIcon,
                                      isSelected: selectedOption ==
                                          PaymentMethod.transfer,
                                      onTap: () => setState(() {
                                        selectedOption = PaymentMethod.transfer;
                                      }),
                                    ),
                                    verticalSpacer(25.h),
                                    ListOptionsContainer(
                                      title: "USSD",
                                      subTitle:
                                          "Select any bank to generate USSD",
                                      icon: ConstantString.ussdIcon,
                                      isSelected:
                                          selectedOption == PaymentMethod.ussd,
                                      onTap: () => setState(() {
                                        selectedOption = PaymentMethod.ussd;
                                      }),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  // const Expanded(child: SizedBox()),
                  CustomButton(
                      title: "Continue",
                      isLoading: paymentVM.isLoading,
                      onTap: selectedOption == PaymentMethod.ussd
                          ? () {
                              paymentVM.fetchUssdProviders(
                                paymentMethod: selectedOption,
                                ref: ref,
                                context: context,
                              );
                            }
                          : () {
                              paymentVM.initiateGatewayPurchase(
                                paymentMethod: selectedOption,
                                ref: ref,
                                context: context,
                              );

                              //             );
                            }
                      // : null,
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
