import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/gadget/gadget_claim_first_form_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_textfield.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

import 'additional_information_confermation_screen.dart';

class AdditionalInformationScreen extends StatefulHookConsumerWidget {
  final ClaimModel claim;

  const AdditionalInformationScreen({super.key, required this.claim});

  @override
  ConsumerState<AdditionalInformationScreen> createState() =>
      _AdditionalInformationScreenState();
}

class _AdditionalInformationScreenState
    extends ConsumerState<AdditionalInformationScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  int? amount;
  File? selectedInvoice;

  late List<AdditionalInfo> _additionalInfo; // <-- local mutable copy

  @override
  void initState() {
    super.initState();
    List<AdditionalInfo> temp =
        List<AdditionalInfo>.from(widget.claim.additionalInfo ?? const []);
    _additionalInfo = temp.where((item) => item.data == null).toList();
  }

  void _updateAdditionalAtIndex(int index, {dynamic data, String? label}) {
    setState(() {
      final current = _additionalInfo[index];
      _additionalInfo[index] = current.copyWith(
        data: data ?? current.data,
        label: label ?? current.label,
      );
    });
  }

  void _updateAdditionalById(String id, {dynamic data, String? label}) {
    final idx = _additionalInfo.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    _updateAdditionalAtIndex(idx, data: data, label: label);
  }

  @override
  Widget build(BuildContext context) {
    final claimVM = ref.watch(claimVmProvider);

    return Scaffold(
      body: SafeArea(
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              // ... app bar etc.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            verticalSpacer(20),
                            CustomAppbar(
                              showLogo: false,
                              showBackButton: true,
                              onBackTap: Navigator.canPop(context)
                                  ? () => Navigator.pop(context)
                                  : null,
                            ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: semiBoldText("Additional information",
                                    fontSize: 20)),
                            verticalSpacer(20),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    verticalSpacer(40),
                                    ..._additionalInfo
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final info = entry.value;

                                      if (info.type == 'file') {
                                        final key = info.id ??
                                            'idx_$index'; // unique per field

                                        return Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 20.0.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              mediumText(
                                                  info.label ?? 'Label text',
                                                  fontSize: 13.sp,
                                                  color: CustomColors
                                                      .formTitleColor),
                                              verticalSpacer(8),
                                              ImageUploadField2(
                                                providerKey: key,
                                                placeholderText:
                                                    info.description ?? '',
                                                onChanged: (file) {
                                                  _updateAdditionalAtIndex(
                                                      index,
                                                      data: file);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (info.type == 'text') {
                                        return customFormTextField(
                                          'additional_text_$index',
                                          title: info.label,
                                          hintText: info.description,
                                          isNumber: false,
                                          isCurrency: false,
                                          onChanged: (val) {
                                            _updateAdditionalAtIndex(index,
                                                data: val);
                                            _updateAdditionalById(info.id ?? '',
                                                data: val);
                                            // optional: keep a numeric mirror if this one is the amount
                                            if ((info.label ?? '')
                                                .toLowerCase()
                                                .contains('amount')) {
                                              amount = val == null
                                                  ? 0
                                                  : int.tryParse(val.replaceAll(
                                                          ",", "")) ??
                                                      0;
                                            }
                                          },
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            CustomButton(
                              title: "Continue",
                              fontSize: 14,
                              onTap: _additionalInfo.any((e) => e.data == null)
                                  ? null
                                  : () async {
                                      FocusScope.of(context).unfocus();

                                      final isValid =
                                          formKey.currentState?.validate() ??
                                              false;
                                      if (!isValid) return;

                                      // If a file item needs upload first, do that here and
                                      // replace its `data` with the returned URL using _updateAdditionalAtIndex/_ById

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ConfirmAdditionalInfoScreen(
                                                  claim: widget.claim,
                                                  additionalInfo:
                                                      _additionalInfo,
                                                )),
                                      );
                                    },
                            ),
                            verticalSpacer(20),
                            const PoweredByFooter(),
                            verticalSpacer(
                                MediaQuery.of(context).padding.bottom + 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final fileImageProvider = StateProvider<File?>((ref) => null);
