import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/form_field_model.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/widgets/build_form_field_widget.dart';
import 'package:mca_official_flutter_sdk/src/screens/purchase/form/form_view_model.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class SecondFormScreen extends StatefulHookConsumerWidget {
  final ProductDetailsModel? productDetails;
  // final ProviderLiteModel? provider;
  const SecondFormScreen({
    super.key,
    required this.productDetails,
    // required this.provider,
  });

  @override
  ConsumerState<SecondFormScreen> createState() => _SecondFormScreenState();
}

class _SecondFormScreenState extends ConsumerState<SecondFormScreen> {
  int selectedProvider = 0;
  bool isLoading = true;
  int currentPage = 0;

  final formKey = GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> _controllers = {};
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each form field
    // for (var field
    //     in ref.watch(selectedProductDetailsProvider)?.formFields ?? []) {
    //   if (field.name != null) {
    //     _controllers[field.name!] = TextEditingController(
    //       text: StringUtils.getInitialValue(field.name),
    //     );
    //   }
    // }
    //
    // final controller = _getControllerOf(item['name'].toString(),
    //     initValue:
    //         getInitialValue(item['label'].toString(), item['name'].toString()));

    for (var field in widget.productDetails?.formFields ?? []) {
      if (field.name != null) {
        _controllers[field.name!] = TextEditingController(
            // text: StringUtils.getInitialValue(field.name),
            );
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formVM = ref.watch(formVmProvider);

    List<FormFieldModel> filteredFields =
        (widget.productDetails?.formFields ?? [])
            .where((field) => field.showFirst == false)
            .toList();

// Sort the filtered form fields by position
    filteredFields.sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));

// Define the number of items to show on the first page and subsequent pages
    int itemsPerPage = 3;

// Calculate the start and end index for the current page
    int startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

// Ensure endIndex does not exceed the length of the list
    endIndex =
        endIndex > filteredFields.length ? filteredFields.length : endIndex;

// Get the sublist of form fields for the current page
    List<FormFieldModel> currentFields =
        filteredFields.sublist(startIndex, endIndex);

    // Determine if we are on the last page
    bool isLastPage = endIndex >= filteredFields.length;

    return Scaffold(
      // backgroundColor: CustomColors.whiteColor,
      body: Stack(
        children: [
          SafeArea(
              child: FocusScope(
            node: _focusScopeNode,
            child: FormBuilder(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacer(20.h),
                  CustomAppbar(
                    // showHelp: true,
                    // helpText: "Plan details",
                    onBackTap: currentPage > 0
                        ? () {
                            if (MediaQuery.of(context).viewInsets.bottom != 0) {
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
                          }
                        : Navigator.canPop(context)
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
                                children: [
                                  verticalSpacer(10.h),
                                  semiBoldText(
                                    "Activate Plan",
                                    fontSize: 20.sp,
                                  ),
                                  verticalSpacer(25.h),
                                  MediaQuery.of(context).viewInsets.bottom != 0
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 25.h),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: CustomColors
                                                  .lightPrimaryBrandColor(),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 12.w),
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

                                  // verticalSpacer(25.h),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: currentFields.length,
                                    itemBuilder: (context, index) {
                                      FormFieldModel field =
                                          currentFields[index];
                                      return BuildFormFieldWidget(
                                        field: field,
                                        controller: _controllers[field.name!],
                                        onClearFocus: () =>
                                            FocusScope.of(context).unfocus(),
                                        onPageRefresh: () {
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),

                                  Visibility(
                                    visible: (MediaQuery.of(context)
                                            .viewInsets
                                            .bottom !=
                                        0),
                                    child: Column(
                                      children: [
                                        CustomButton(
                                            title: isLastPage
                                                ? "Activate Plan"
                                                : "Continue",
                                            isLoading: formVM.isLoading,
                                            onTap: endIndex <
                                                    filteredFields.length
                                                ? () {
                                                    // Check if the keyboard is currently visible
                                                    // FocusScope.of(context).unfocus();
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
                                                : () async {
                                                    // Check if the keyboard is currently visible
                                                    // FocusScope.of(context).unfocus();
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

                                                    if (validate == true) {
                                                      ref
                                                          .read(
                                                              autoValidateProvider
                                                                  .notifier)
                                                          .state = false;
                                                      formKey.currentState
                                                          ?.save();

                                                      ref
                                                              .read(
                                                                  formDataProvider
                                                                      .notifier)
                                                              .state[
                                                          "product_id"] = ref
                                                              .watch(
                                                                  selectedProductDetailsProvider)
                                                              ?.id ??
                                                          "";

                                                      await formVM
                                                          .completePurchase(
                                                              ref: ref,
                                                              context: context);
                                                    } else {
                                                      ref
                                                          .read(
                                                              autoValidateProvider
                                                                  .notifier)
                                                          .state = true;
                                                    }
                                                  }),
                                        verticalSpacer(25.h),
                                        const PoweredByFooter(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                !(MediaQuery.of(context).viewInsets.bottom !=
                                    0),
                            child: Column(
                              children: [
                                CustomButton(
                                    title: isLastPage
                                        ? "Activate Plan"
                                        : "Continue",
                                    isLoading: formVM.isLoading,
                                    onTap: endIndex < filteredFields.length
                                        ? () {
                                            // Check if the keyboard is currently visible
                                            // FocusScope.of(context).unfocus();
                                            if (MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom !=
                                                0) {
                                              FocusScope.of(context).unfocus();
                                            }
                                            if (_focusScopeNode.hasFocus) {
                                              _focusScopeNode.unfocus();
                                            }
                                            var validate = formKey.currentState
                                                ?.validate();

                                            if (validate == true) {
                                              ref
                                                  .read(autoValidateProvider
                                                      .notifier)
                                                  .state = false;
                                              formKey.currentState?.save();

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
                                        : () async {
                                            // Check if the keyboard is currently visible
                                            // FocusScope.of(context).unfocus();
                                            if (MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom !=
                                                0) {
                                              FocusScope.of(context).unfocus();
                                            }
                                            if (_focusScopeNode.hasFocus) {
                                              _focusScopeNode.unfocus();
                                            }
                                            var validate = formKey.currentState
                                                ?.validate();

                                            if (validate == true) {
                                              ref
                                                  .read(autoValidateProvider
                                                      .notifier)
                                                  .state = false;
                                              formKey.currentState?.save();

                                              ref
                                                  .read(
                                                      formDataProvider.notifier)
                                                  .state["product_id"] = ref
                                                      .watch(
                                                          selectedProductDetailsProvider)
                                                      ?.id ??
                                                  "";

                                              await formVM.completePurchase(
                                                  ref: ref, context: context);
                                            } else {
                                              ref
                                                  .read(autoValidateProvider
                                                      .notifier)
                                                  .state = true;
                                            }
                                          }),
                                verticalSpacer(25.h),
                                const PoweredByFooter(),
                                // verticalSpacer(25.h),
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
