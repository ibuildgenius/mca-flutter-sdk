import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/form_field_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/form_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/build_form_field_widget.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/product_price_container.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/payment_method_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/payment/payment_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/provider_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class FirstFormScreen extends ConsumerStatefulWidget {
  final ProductDetailsModel? productDetails;

  const FirstFormScreen({super.key, required this.productDetails});

  @override
  ConsumerState<FirstFormScreen> createState() => _FirstFormScreenState();
}

class _FirstFormScreenState extends ConsumerState<FirstFormScreen> {
  int selectedProvider = 0;
  bool isLoading = true;
  int currentPage = 0;
  Timer? debounce;

  final formKey = GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> _controllers = {};
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    // ref.read(walletProvider.notifier).getWallet();
    for (var field in widget.productDetails?.formFields ?? []) {
      if (field.name != null) {
        _controllers[field.name!] = TextEditingController(
          text: StringUtils.getInitialValue(field.name),
        );
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(formDataProvider.notifier).state["product_id"] =
          ref.watch(selectedProductDetailsProvider)?.id ?? "";
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formVM = ref.watch(formVmProvider);
    final paymentVM = ref.watch(paymentProvider);

    List<FormFieldModel> filteredFields =
        (widget.productDetails?.formFields ?? [])
            .where((field) => field.showFirst == true)
            .toList();

    filteredFields.sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));

    int itemsPerPage = currentPage == 0 ? 4 : 3;

    int startIndex = currentPage == 0 ? 0 : 4 + (currentPage - 1) * 3;
    int endIndex = startIndex + itemsPerPage;

    List<FormFieldModel> currentFields = filteredFields.sublist(
      startIndex,
      endIndex > filteredFields.length ? filteredFields.length : endIndex,
    );

    bool isLastPage = endIndex >= filteredFields.length;

    return Scaffold(
      // resizeToAvoidBottomInset: ,
      backgroundColor: CustomColors.whiteColor,
      body: Stack(
        children: [
          SafeArea(
              child: FocusScope(
            node: _focusScopeNode,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: FormBuilder(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacer(20.h),
                    CustomAppbar(
                      onBackTap: currentPage > 0
                          ? () {
                              if (MediaQuery.of(context).viewInsets.bottom !=
                                  0) {
                                FocusScope.of(context).unfocus();
                              }
                              if (_focusScopeNode.hasFocus) {
                                _focusScopeNode.unfocus();
                              }
                              ref.read(autoValidateProvider.notifier).state =
                                  false;
                              setState(() {
                                currentPage--;
                              });
                              ref.read(productPriceProvider.notifier).state = 0;
                              ref.read(formErrorsProvider.notifier).state = {};
                            }
                          : Navigator.canPop(context)
                              ? () {
                                  if (MediaQuery.of(context)
                                          .viewInsets
                                          .bottom !=
                                      0) {
                                    FocusScope.of(context).unfocus();
                                  }
                                  if (_focusScopeNode.hasFocus) {
                                    _focusScopeNode.unfocus();
                                  }
                                  ref
                                      .read(autoValidateProvider.notifier)
                                      .state = false;
                                  ref
                                      .read(productPriceProvider.notifier)
                                      .state = 0;

                                  ProviderUtils.resetAllFormProviders(ref);

                                  Navigator.pop(context);
                                }
                              : null,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    verticalSpacer(10.h),
                                    semiBoldText(
                                      "Provide Plan Owner details",
                                      fontSize: 20.sp,
                                    ),
                                    verticalSpacer(25.h),
                                    GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: CustomColors
                                              .lightPrimaryBrandColor(),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 12.w),
                                          child: Row(
                                            children: [
                                              Center(
                                                child: SvgPicture.asset(
                                                  ConstantString.infoIcon,
                                                  colorFilter: ColorFilter.mode(
                                                      CustomColors
                                                          .primaryBrandColor(),
                                                      BlendMode.srcIn),
                                                  // color: CustomColors
                                                  //     .primaryBrandColor(),
                                                  package:
                                                      'mca_official_flutter_sdk',
                                                ),
                                              ),
                                              horizontalSpacer(25.w),
                                              Expanded(
                                                child: regularText(
                                                    "Make sure you provide the right details as it appears on legal document",
                                                    fontSize: 14.sp,
                                                    color: CustomColors
                                                        .blackTextColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    verticalSpacer(10.h),
                                    verticalSpacer(25.h),
                                    if (currentPage == 0) ...[
                                      Row(
                                        children: [
                                          Expanded(
                                              child: BuildFormFieldWidget(
                                            field: filteredFields[0],
                                            controller: _controllers[
                                                filteredFields[0].name!],
                                            filteredFieldsLength:
                                                filteredFields.length,
                                            formVM: formVM,
                                            isLastPage: isLastPage,
                                            onClearFocus: () {
                                              if (MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom !=
                                                  0) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                              if (_focusScopeNode.hasFocus) {
                                                _focusScopeNode.unfocus();
                                              }
                                            },
                                          )),
                                          horizontalSpacer(20.w),
                                          Expanded(
                                            child: BuildFormFieldWidget(
                                              field: filteredFields[1],
                                              isLastPage: isLastPage,
                                              controller: _controllers[
                                                  filteredFields[1].name!],
                                              filteredFieldsLength:
                                                  filteredFields.length,
                                              formVM: formVM,
                                              onClearFocus: () {
                                                if (MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom !=
                                                    0) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                                if (_focusScopeNode.hasFocus) {
                                                  _focusScopeNode.unfocus();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: currentFields.length - 2,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          FormFieldModel field =
                                              currentFields[index + 2];
                                          return BuildFormFieldWidget(
                                            field: field,
                                            isLastPage: isLastPage,
                                            controller:
                                                _controllers[field.name!],
                                            filteredFieldsLength:
                                                filteredFields.length,
                                            formVM: formVM,
                                            onClearFocus: () {
                                              if (MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom !=
                                                  0) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                              if (_focusScopeNode.hasFocus) {
                                                _focusScopeNode.unfocus();
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ] else ...[
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: currentFields.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          FormFieldModel field =
                                              currentFields[index];
                                          return BuildFormFieldWidget(
                                            field: field,
                                            isLastPage: isLastPage,
                                            controller:
                                                _controllers[field.name!],
                                            filteredFieldsLength:
                                                filteredFields.length,
                                            formVM: formVM,
                                            formKey: formKey,
                                            onClearFocus: () {
                                              if (MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom !=
                                                  0) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                              if (_focusScopeNode.hasFocus) {
                                                _focusScopeNode.unfocus();
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                    verticalSpacer(80.h),
                                    Visibility(
                                      visible: (MediaQuery.of(context)
                                              .viewInsets
                                              .bottom !=
                                          0),
                                      child: Column(
                                        children: [
                                          isLastPage
                                              ? ProductPriceContainer(
                                                  title: "Premium",
                                                  isLoading: formVM.isLoading,
                                                )
                                              : const SizedBox.shrink(),
                                          CustomButton(
                                            title: ref.watch(
                                                        productPriceProvider) ==
                                                    0
                                                ? "Continue"
                                                : "Proceed to payment",
                                            isLoading: paymentVM.isLoading,
                                            // || ref.watch(isGettingWallet),
                                            onTap: formVM.isLoading
                                                ? null
                                                : endIndex <
                                                        filteredFields.length
                                                    ? () {
                                                        if (MediaQuery.of(
                                                                    context)
                                                                .viewInsets
                                                                .bottom !=
                                                            0) {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                        }
                                                        if (_focusScopeNode
                                                            .hasFocus) {
                                                          _focusScopeNode
                                                              .unfocus();
                                                        }
                                                        var validate = formKey
                                                            .currentState
                                                            ?.validate();

                                                        if (ref
                                                            .watch(
                                                                formErrorsProvider)
                                                            .isNotEmpty) {
                                                          ref
                                                              .read(
                                                                  shouldValidateImageplusDrop
                                                                      .notifier)
                                                              .state = true;
                                                        } else {
                                                          ref
                                                              .read(
                                                                  shouldValidateImageplusDrop
                                                                      .notifier)
                                                              .state = false;
                                                          ref
                                                              .read(
                                                                  formErrorsProvider
                                                                      .notifier)
                                                              .state = {};

                                                          if (validate ==
                                                              true) {
                                                            ref
                                                                .read(autoValidateProvider
                                                                    .notifier)
                                                                .state = false;
                                                            formKey.currentState
                                                                ?.save();

                                                            setState(() {
                                                              currentPage++;
                                                            });
                                                          } else {
                                                            ref
                                                                .read(autoValidateProvider
                                                                    .notifier)
                                                                .state = true;
                                                          }
                                                        }
                                                      }
                                                    : ref.watch(productPriceProvider) ==
                                                            0
                                                        ? () async {
                                                            if (MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom !=
                                                                0) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                            }
                                                            if (_focusScopeNode
                                                                .hasFocus) {
                                                              _focusScopeNode
                                                                  .unfocus();
                                                            }
                                                            var validate = formKey
                                                                .currentState
                                                                ?.validate();

                                                            if (ref
                                                                .watch(
                                                                    formErrorsProvider)
                                                                .isNotEmpty) {
                                                              ref
                                                                  .read(shouldValidateImageplusDrop
                                                                      .notifier)
                                                                  .state = true;
                                                            } else {
                                                              ref
                                                                  .read(shouldValidateImageplusDrop
                                                                      .notifier)
                                                                  .state = false;
                                                              ref
                                                                  .read(formErrorsProvider
                                                                      .notifier)
                                                                  .state = {};
                                                              if (validate ==
                                                                  true) {
                                                                ref
                                                                    .read(autoValidateProvider
                                                                        .notifier)
                                                                    .state = false;
                                                                formKey
                                                                    .currentState
                                                                    ?.save();

                                                                await formVM
                                                                    .fetchProductPrice(
                                                                  ref: ref,
                                                                  context:
                                                                      context,
                                                                  productId: ref
                                                                          .watch(
                                                                              selectedProductDetailsProvider)
                                                                          ?.id ??
                                                                      "",
                                                                );
                                                              } else {
                                                                ref
                                                                    .read(autoValidateProvider
                                                                        .notifier)
                                                                    .state = true;
                                                              }
                                                            }
                                                          }
                                                        : () async {
                                                            if (MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom !=
                                                                0) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                            }
                                                            Global.paymentOption ==
                                                                    PaymentOption
                                                                        .wallet
                                                                ? await paymentVM
                                                                    .initiateWalletPurchase(
                                                                    ref: ref,
                                                                    context:
                                                                        context,
                                                                  )
                                                                : () async {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const PaymentMethodScreen()));
                                                                  };
                                                          },
                                          ),
                                          verticalSpacer(25.h),
                                          const PoweredByFooter(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // const Spacer(),
                            Visibility(
                              visible:
                                  !(MediaQuery.of(context).viewInsets.bottom !=
                                      0),
                              child: Column(
                                // mainAxisAlignment: MainAxisAligßnment.end,
                                children: [
                                  // const Spacer(),
                                  isLastPage
                                      ? ProductPriceContainer(
                                          title: "Premium",
                                          isLoading: formVM.isLoading,
                                        )
                                      : const SizedBox.shrink(),
                                  CustomButton(
                                    title: ref.watch(productPriceProvider) == 0
                                        ? "Continue"
                                        : "Proceed to payment",
                                    isLoading: paymentVM.isLoading,
                                    onTap: formVM.isLoading
                                        ? null
                                        : endIndex < filteredFields.length
                                            ? () {
                                                if (MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom !=
                                                    0) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                                if (_focusScopeNode.hasFocus) {
                                                  _focusScopeNode.unfocus();
                                                }
                                                var validate = formKey
                                                    .currentState
                                                    ?.validate();

                                                if (ref
                                                    .watch(formErrorsProvider)
                                                    .isNotEmpty) {
                                                  ref
                                                      .read(
                                                          shouldValidateImageplusDrop
                                                              .notifier)
                                                      .state = true;
                                                } else {
                                                  ref
                                                      .read(
                                                          shouldValidateImageplusDrop
                                                              .notifier)
                                                      .state = false;
                                                  ref
                                                      .read(formErrorsProvider
                                                          .notifier)
                                                      .state = {};

                                                  if (validate == true) {
                                                    ref
                                                        .read(
                                                            autoValidateProvider
                                                                .notifier)
                                                        .state = false;
                                                    formKey.currentState
                                                        ?.save();

                                                    setState(() {
                                                      currentPage++;
                                                    });
                                                  } else {
                                                    ref
                                                        .read(
                                                            autoValidateProvider
                                                                .notifier)
                                                        .state = true;
                                                  }
                                                }
                                              }
                                            : ref.watch(productPriceProvider) ==
                                                    0
                                                ? () async {
                                                    if (MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom !=
                                                        0) {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    }
                                                    if (_focusScopeNode
                                                        .hasFocus) {
                                                      _focusScopeNode.unfocus();
                                                    }
                                                    var validate = formKey
                                                        .currentState
                                                        ?.validate();

                                                    if (ref
                                                        .watch(
                                                            formErrorsProvider)
                                                        .isNotEmpty) {
                                                      ref
                                                          .read(
                                                              shouldValidateImageplusDrop
                                                                  .notifier)
                                                          .state = true;
                                                    } else {
                                                      ref
                                                          .read(
                                                              shouldValidateImageplusDrop
                                                                  .notifier)
                                                          .state = false;
                                                      ref
                                                          .read(
                                                              formErrorsProvider
                                                                  .notifier)
                                                          .state = {};
                                                      if (validate == true) {
                                                        ref
                                                            .read(
                                                                autoValidateProvider
                                                                    .notifier)
                                                            .state = false;
                                                        formKey.currentState
                                                            ?.save();

                                                        await formVM
                                                            .fetchProductPrice(
                                                          ref: ref,
                                                          context: context,
                                                          productId: ref
                                                                  .watch(
                                                                      selectedProductDetailsProvider)
                                                                  ?.id ??
                                                              "",
                                                        );
                                                      } else {
                                                        ref
                                                            .read(
                                                                autoValidateProvider
                                                                    .notifier)
                                                            .state = true;
                                                      }
                                                    }
                                                  }
                                                : () async {
                                                    Global.paymentOption ==
                                                            PaymentOption.wallet
                                                        ? await paymentVM
                                                            .initiateWalletPurchase(
                                                            ref: ref,
                                                            context: context,
                                                          )
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const PaymentMethodScreen()));
                                                  },
                                  ),
                                  verticalSpacer(25.h),
                                  const PoweredByFooter(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
          ref.watch(showFullScreenLoaderProvider)
              ? Container(
                  color: Colors.grey.withOpacity(0.4),
                  child: const Center(
                    child: SpinKitFadingCircle(
                      color: CustomColors.blackColor,
                      size: 25.0,
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

test() async {
  return true;
}
