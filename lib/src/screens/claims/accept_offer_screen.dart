import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/generic_dialog.dart';
import 'package:mca_official_flutter_sdk/src/models/bank_model.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/widgets/bank_list_dropdown_field.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/form_validator.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class AcceptOfferScreen extends StatefulHookConsumerWidget {
  final List<BankModel> banks;
  final ClaimModel claim;
  const AcceptOfferScreen({
    super.key,
    required this.claim,
    required this.banks,
  });

  @override
  ConsumerState<AcceptOfferScreen> createState() => _AcceptOfferScreenState();
}

class _AcceptOfferScreenState extends ConsumerState<AcceptOfferScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Safe here — widget tree is ready

      ref.invalidate(accountDetailsProvider);
      ref.invalidate(selectedBankProvider); // optional, but likely desired

      final banks = ref.read(bankListProvider);
      if (banks.isEmpty) {
        ref.read(claimVmProvider).getBankList(
              ref: ref,
              context: context,
              claim: widget.claim,
            );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final claimVM = ref.watch(claimVmProvider);

//     return @override
// Widget build(BuildContext context) {
//   final claimVM = ref.watch(claimVmProvider);

    return Scaffold(
      // default is true; helps when the keyboard opens
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              verticalSpacer(20),
              CustomAppbar(
                showLogo: false,
                showBackButton: false,
                onBackTap: Navigator.canPop(context)
                    ? () => Navigator.pop(context)
                    : null,
              ),
              semiBoldText("Accept offer", fontSize: 20),
              verticalSpacer(20),

              // Make the middle area scrollable
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: CustomColors.backBorderColor),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 100.0,
                                      left: 10,
                                      top: 10,
                                      bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      verticalSpacer(10),
                                      Text(
                                        "To proceed with the settlement, please provide your account details to receive the offer.",
                                        style: CustomTextStyles.regular(
                                          fontSize: 14,
                                          color: CustomColors.formTitleColor,
                                          height: 1.2,
                                        ),
                                        softWrap: true,
                                      ),
                                      verticalSpacer(6),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Image.asset(
                                    ConstantString.invoiceImg,
                                    height: 60,
                                    package: 'mca_official_flutter_sdk',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          verticalSpacer(30),
                          BankListDropdownField(
                            fieldName: "Select bank",
                            label: "Select bank",
                            isLoadingBanks: ref.watch(loadBankListProvider),
                            description: "Select bank",
                            items: ref.watch(bankListProvider),
                            selectedItem: selectedBankProvider,
                          ),
                          verticalSpacer(10),
                          customFormTextField(
                            'accountNumber',
                            maxLength: 10,
                            title: 'Account Number',
                            hintText: "Enter account number",
                            isNumber: true,
                            validator: (value) {
                              return CustomValidator.validateForm(
                                value ?? "",
                                'Policy number',
                                4,
                                errorMessage: "Enter incident location",
                              );
                            },
                            onChanged: (value) {
                              claimVM.isNameLoading = false;
                              ref.read(accountDetailsProvider.notifier).state =
                                  null;
                              ref
                                  .watch(defaultAccountNoProvider.notifier)
                                  .state = value ?? '';

                              if ((value?.length ?? 0) == 10 &&
                                  ref.watch(selectedBankProvider) != null) {
                                claimVM.verifyBankAccount(
                                  ref: ref,
                                  context: context,
                                  accountNumber: value ?? "",
                                  bankCode:
                                      ref.watch(selectedBankProvider)?.code ??
                                          "",
                                );
                              }
                            },
                            suffix: Builder(
                              builder: (_) {
                                final details =
                                    ref.watch(accountDetailsProvider);
                                if (details != null) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: CustomColors.productBorderColor
                                              .withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: semiBoldText(
                                          (details.accountName ?? "")
                                              .toLowerCase(),
                                          color: CustomColors.lightBlackColor,
                                        ),
                                      ),
                                      horizontalSpacer(5),
                                    ],
                                  );
                                }
                                if (claimVM.isNameLoading) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SpinKitFadingCircle(
                                        color: CustomColors.primaryBrandColor(),
                                        size: 20.0,
                                      ),
                                      horizontalSpacer(5),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          verticalSpacer(20),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Sticky footer area: button + footer, padded for keyboard
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // No Row+Expanded needed, just stretch the button
                    CustomButton(
                      title: "Continue",
                      isLoading: claimVM.isLoading,
                      fontSize: 14,
                      onTap: ref.watch(accountDetailsProvider) == null
                          ? null
                          : () {
                              GenericDialog().showGenericSimplePopup(
                                context: context,
                                horizontalPadding: 20,
                                title: "Accept Offer",
                                contentBody: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Your claim offer will be made to the bank information supplied ",
                                        style: CustomTextStyles.regular(
                                          fontSize: 14,
                                          color: CustomColors.formTitleColor,
                                          height: 1.2,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "(${(ref.watch(selectedBankProvider)?.name)}, "
                                            "${(ref.watch(accountDetailsProvider)?.accountName ?? "").toLowerCase()}, "
                                            "${(ref.watch(accountDetailsProvider)?.accountNumber ?? "").toLowerCase()}) ",
                                        style: CustomTextStyles.semiBold(
                                          fontSize: 15,
                                          color: CustomColors.formTitleColor,
                                          height: 1.4,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "do you want to continue with this action?",
                                        style: CustomTextStyles.regular(
                                          fontSize: 14,
                                          color: CustomColors.formTitleColor,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                okText: "Yes, proceed",
                                onOkPressed: () async {
                                  await claimVM.acceptClaimOffer(
                                    ref: ref,
                                    context: context,
                                    claim: widget.claim,
                                    accountNumber: ref
                                            .watch(accountDetailsProvider)
                                            ?.accountNumber ??
                                        ref.watch(defaultAccountNoProvider),
                                    bankCode:
                                        ref.watch(selectedBankProvider)?.code ??
                                            "",
                                    accountName: ref
                                            .watch(accountDetailsProvider)
                                            ?.accountName ??
                                        "Mercy Joy",
                                    bankName:
                                        ref.watch(selectedBankProvider)?.name ??
                                            "",
                                  );
                                },
                              );
                            },
                    ),

                    verticalSpacer(20),
                    const PoweredByFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final selectedBankProvider =
    StateProvider.autoDispose<BankModel?>((ref) => null);
