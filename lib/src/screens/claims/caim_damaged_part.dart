// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/models/damaged_area_parts.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_summary.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/vehicle/vehicle_verification_damaged_part.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/landscape_mode_wrapper.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';

class ClaimDamagedPartScreen extends StatefulHookConsumerWidget {
  final String incidentType;
  final String incidentDate;
  final String incidentTime;
  final List<String> lossType;
  final String incidentLocation;
  final bool isThirdParty;
  final String description;
  final List<String> thirdPartyLossType;
  final String thirdPartyPhoneNumber;
  final String claimType;
  final File? fileLiquidDamage;
  final File? fileDamagedPart;
  final File? fileReceipt;
  final File? policeReport;
  final String? driversLicenseNo;
  final File? driverLicenseFile;

  const ClaimDamagedPartScreen(
      {super.key,
      required this.incidentType,
      required this.incidentDate,
      required this.incidentTime,
      required this.lossType,
      required this.incidentLocation,
      required this.isThirdParty,
      required this.description,
      required this.thirdPartyLossType,
      required this.thirdPartyPhoneNumber,
      required this.claimType,
      this.fileLiquidDamage,
      this.fileDamagedPart,
      this.fileReceipt,
      this.policeReport,
      this.driverLicenseFile,
      this.driversLicenseNo});

  @override
  ConsumerState<ClaimDamagedPartScreen> createState() =>
      _ClaimDamagedPartScreenState();
}

class _ClaimDamagedPartScreenState
    extends ConsumerState<ClaimDamagedPartScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  void _handleBack() {
    // Clear provider safely (immutable write)
    ref.read(vehicleDamagesProvider.notifier).state = const [];
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final claimVM = ref.watch(claimVmProvider);
    final List<Damage> damagePart = ref.watch(vehicleDamagesProvider);

    return PopScope(
      canPop: false, // intercept the back gesture/button
      onPopInvoked: (didPop) {
        if (didPop) return; // if something else already popped, do nothing
        _handleBack(); // clear then pop
      },
      child: Scaffold(
        // backgroundColor: CustomColors.whiteColor,
        body: SafeArea(
            child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              verticalSpacer(20),
              CustomAppbar(
                showHelp: true,
                showLogo: false,
                showBackButton: true,
                onBackTap: Navigator.canPop(context)
                    ? () => Navigator.pop(context)
                    : null,
                // logoUrl: ref.watch(businessDetailsProvider)?.logo,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // verticalSpacer(10),
                      semiBoldText("Provide damage part", fontSize: 20),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            verticalSpacer(25),
                            const InfoBanner(
                              message:
                                  "Make sure you're uploading an accurate angle of the damage",
                            ),
                            verticalSpacer(30.h),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24)),
                                  ),
                                  builder: (_) => const _DamageSidesSheet(),
                                );
                              },
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: semiBoldText('+ Add damaged part',
                                      fontSize: 18.sp,
                                      color: CustomColors.greenColor)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 8,
                          child: SingleChildScrollView(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (damagePart.isNotEmpty)
                                ...damagePart.map((part) {
                                  final far = part.farRangeFile;
                                  final close = part.closeRangeFile;

                                  // Skip cards that don't have both images (or provide placeholders instead)
                                  if (far == null || close == null) {
                                    return const SizedBox.shrink();
                                  }

                                  return DamagePreviewCard(
                                    farImage: FileImage(far),
                                    // no '!' needed after the guard
                                    closeImage: FileImage(close),
                                    // no '!' needed after the guard
                                    chipText:
                                        '${part.damageArea ?? ''} || ${part.damagePart ?? ''}',
                                    onPreviewTap: () async {
                                      final result =
                                          await showDamagePreviewSheet(
                                        damage: part,
                                        context,
                                        title:
                                            '${part.damageArea ?? ''} || ${part.damagePart ?? ''}',
                                        farImage: FileImage(far),
                                        closeImage: FileImage(close),
                                      );

                                      if (result ==
                                          DamagePreviewAction.removed) {
                                        // remove exactly this part from provider state
                                        final notifier = ref.read(
                                            vehicleDamagesProvider.notifier);
                                        final current =
                                            ref.read(vehicleDamagesProvider);
                                        notifier.state = current.where((item) {
                                          final sameArea =
                                              (item.damageArea ?? '')
                                                      .trim()
                                                      .toLowerCase() ==
                                                  (part.damageArea ?? '')
                                                      .trim()
                                                      .toLowerCase();
                                          final samePart =
                                              (item.damagePart ?? '')
                                                      .trim()
                                                      .toLowerCase() ==
                                                  (part.damagePart ?? '')
                                                      .trim()
                                                      .toLowerCase();
                                          return !(sameArea && samePart);
                                        }).toList();
                                      } else if (result ==
                                          DamagePreviewAction.confirmed) {
                                        // if "confirmed" means keep as-is, you may not need to mutate
                                        // If you need to replace/update, do it explicitly here using `part`
                                        final notifier = ref.read(
                                            vehicleDamagesProvider.notifier);
                                        final current =
                                            ref.read(vehicleDamagesProvider);

                                        // Example: de-dup by same area/part, then re-add `part`
                                        final filtered = current.where((item) {
                                          final sameArea =
                                              (item.damageArea ?? '')
                                                      .trim()
                                                      .toLowerCase() ==
                                                  (part.damageArea ?? '')
                                                      .trim()
                                                      .toLowerCase();
                                          final samePart =
                                              (item.damagePart ?? '')
                                                      .trim()
                                                      .toLowerCase() ==
                                                  (part.damagePart ?? '')
                                                      .trim()
                                                      .toLowerCase();
                                          return !(sameArea && samePart);
                                        }).toList();

                                        notifier.state = [...filtered, part];
                                      }
                                    },
                                  );
                                }),
                            ],
                          ))),
                      CustomButton(
                        title: "Continue",
                        isLoading: claimVM.isLoading,
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClaimSummaryScreen(
                                incidentType: widget.incidentType ?? "",
                                incidentDate: widget.incidentDate ?? "",
                                incidentTime: widget.incidentTime ?? "",
                                lossType: widget.lossType,
                                incidentLocation: widget.incidentLocation ?? "",
                                isThirdParty: widget.isThirdParty,
                                description: widget.description ?? " ",
                                thirdPartyLossType: widget.thirdPartyLossType,
                                thirdPartyPhoneNumber:
                                    widget.thirdPartyPhoneNumber ?? "",
                                claimType: "Vehicle",
                                policeReport: widget.policeReport,
                                driversLicenseNo: widget.driversLicenseNo,
                                driverLicenseFile: widget.driverLicenseFile,
                              ),
                            ),
                          );
                        },
                      ),
                      verticalSpacer(25),
                      const PoweredByFooter()
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_rounded,
    this.iconSize = 14,
    this.dotSize = 22,
    this.radius = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.textStyle,
  });

  final String message;

  final IconData icon;
  final double iconSize;
  final double dotSize;
  final double radius;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 44),
      padding: padding,
      decoration: BoxDecoration(
          color: CustomColors.lightGreenColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(width: 0.2, color: CustomColors.greenColor)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular info badge
          SvgPicture.asset(
            ConstantString.infoCircleGreen,
            height: 24.h,
            width: 24.w,
          ),
          SizedBox(width: 16.w),
          // Message
          Expanded(
            child: regularText(message,
                fontSize: 12.sp,
                softWrap: true,
                color: CustomColors.blackTextColor),
          ),
        ],
      ),
    );
  }
}

class _DamageSidesSheet extends ConsumerStatefulWidget {
  const _DamageSidesSheet();

  @override
  ConsumerState<_DamageSidesSheet> createState() => _DamageSidesSheetState();
}

class _DamageSidesSheetState extends ConsumerState<_DamageSidesSheet> {
  DamagedAreaPart? selected;

  Future<void> _onContinue(
      BuildContext sheetContext, DamagedAreaPart selected) async {
    final rootCtx = Navigator.of(sheetContext, rootNavigator: true).context;

    Navigator.pop(sheetContext, selected);

    await Future.microtask(() {});

    await showModalBottomSheet(
      context: rootCtx,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _DamageTypeSheet(side: selected),
    );
  }

  void initState() {
    super.initState();
    selectedTextColor = CustomColors.backTextColor;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleDamagesProvider.notifier).state = const [];
    });
  }

  late Color selectedTextColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 16.w,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 12,
        ),
        child: SizedBox(
          height:
              0.7 * MediaQuery.of(context).size.height, // comfortable height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const SizedBox(width: 4),
                  semiBoldText('Select damaged parts',
                      fontSize: 16.sp, color: CustomColors.primaryText),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: CustomColors.blackColor,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              mediumText(
                'Damaged sides',
                color: CustomColors.formTitleColor,
                fontSize: 14.sp,
              ),
              const SizedBox(height: 8),

              // Dropdown
              DropdownButtonFormField2<DamagedAreaPart?>(
                isExpanded: true,
                value: selected,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: CustomColors.dividerGreyColor, width: 0.1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: CustomColors.dividerGreyColor, width: 0.1),
                  ),
                  filled: true,
                  fillColor: CustomColors.backBorderColor,
                  // soft fill like screenshot
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                onMenuStateChange: (isOpen) {},
                selectedItemBuilder: (context) =>
                    ref.watch(damagedPartsProvider).map((e) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: semiBoldText(e.area,
                        overflow: TextOverflow.ellipsis,
                        color: selectedTextColor,
                        fontSize: 14.sp),
                  );
                }).toList(),
                hint: regularText(
                  'Select damage side',
                  color: CustomColors.checkBoxBorderColor,
                  fontSize: 14.sp,
                ),
                items: ref
                    .watch(damagedPartsProvider)
                    .map((e) => DropdownMenuItem<DamagedAreaPart?>(
                          value: e,
                          child: regularText(e.area,
                              color: CustomColors.checkBoxBorderColor,
                              fontSize: 14.sp),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selected = v),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.black.withOpacity(0.35)),
                  iconSize: 22,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 340,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  elevation: 0,
                  offset: const Offset(0, 8),
                  padding: EdgeInsets.zero,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),

              const Spacer(),
              CustomButton(
                title: 'Continue',
                onTap: selected == null
                    ? null
                    : () => _onContinue(context, selected!),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _DamageTypeSheet extends StatefulWidget {
  const _DamageTypeSheet({required this.side});

  final DamagedAreaPart? side;

  @override
  State<_DamageTypeSheet> createState() => _DamageTypeSheetState();
}

class _DamageTypeSheetState extends State<_DamageTypeSheet> {
  Part? selectedType;
  final Color _selectedTextColor = CustomColors.greenColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const SizedBox(width: 4),
                  semiBoldText('Select damaged parts',
                      fontSize: 16.sp, color: CustomColors.primaryText),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: CustomColors.blackColor,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              mediumText('Damaged sides',
                  color: CustomColors.formTitleColor, fontSize: 14.sp),
              SizedBox(height: 16.h),
              // Show the chosen side (disabled-looking field)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => const _DamageSidesSheet(),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: CustomColors.backBorderColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: CustomColors.dividerGreyColor, width: 1),
                  ),
                  child: regularText(widget.side?.area ?? '',
                      fontSize: 14.sp, color: CustomColors.formTitleColor),
                ),
              ),

              const SizedBox(height: 18),
              semiBoldText('What kind of damage?',
                  fontSize: 18.sp, color: CustomColors.greenColor),
              const SizedBox(height: 12),

              // Pills
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.side!.parts.map((t) {
                  final isSelected = t == selectedType;
                  return _RadioPill(
                    label: t.name,
                    selected: isSelected,
                    onTap: () => setState(() => selectedType = t),
                  );
                }).toList(),
              ),
              const Spacer(),
              CustomButton(
                title: 'Continue',
                onTap: selectedType == null
                    ? null
                    : () async {
                  final selected = Damage(
                    closeRange: '',
                    farRange: '',
                    damageArea: widget.side?.area ?? '',
                    damagePart: selectedType?.name ?? '',
                  );

                  // Close the current sheet first
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    final cameras = await availableCameras();
                    if (!mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LandscapeModeWrapper(
                          child: VehicleVerificationDamagedPartScreen(
                            cameras: cameras,
                            selected: selected,
                          ),
                        ),
                      ),
                    );
                  });
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}

/// Pill with radio look
class _RadioPill extends StatelessWidget {
  const _RadioPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const selectedBorder = Color(0xFF2EC4A6);
    const baseBorder = Color(0xFFD7DBDF);
    final fill = selected ? const Color(0xFFDAF4EE) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? selectedBorder : baseBorder,
            width: 1.4,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedBorder.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // radio circle
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? selectedBorder : const Color(0xFFBFC5CA),
                  width: 1.6,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: selected ? 8 : 0,
                  height: selected ? 8 : 0,
                  decoration: BoxDecoration(
                    color: selected ? selectedBorder : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? CustomColors.greenColor
                    : CustomColors.greyTextColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DamagePreviewCard extends StatelessWidget {
  const DamagePreviewCard({
    super.key,
    required this.farImage,
    required this.closeImage,
    this.leftLabel = 'Far range',
    this.rightLabel = 'Close range',
    this.chipText = 'Front damage || bumper',
    this.onPreviewTap,
    this.radius = 12,
  });

  /// Images (use AssetImage / NetworkImage / FileImage / MemoryImage)
  final ImageProvider farImage;
  final ImageProvider closeImage;

  /// Captions and chip
  final String leftLabel;
  final String rightLabel;
  final String chipText;

  /// Interaction
  final VoidCallback? onPreviewTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    const captionColor = CustomColors.greyTextColor;
    const dividerColor = CustomColors.dividerGreyColor;
    const chipBg = CustomColors.lightOrangeColor;
    const chipBorder = CustomColors.orangeColor;
    const chipTextColor = CustomColors.orangeColor;
    const previewColor = CustomColors.greenColor;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: CustomColors.backBorderColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Images
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: _cardImage(farImage)),
                const SizedBox(width: 12),
                Expanded(child: _cardImage(closeImage)),
              ],
            ),
          ),

          // Captions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Far range',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: captionColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Close range',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: captionColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Divider
          const Divider(height: 0.6, color: dividerColor),

          // Bottom row: chip + link
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Orange chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: chipBorder, width: 0.2),
                  ),
                  child: regularText(chipText,
                      color: chipTextColor, fontSize: 14.sp),
                ),
                const Spacer(),
                // Preview link
                TextButton(
                  onPressed: onPreviewTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: previewColor,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: mediumText('Preview image',
                      color: previewColor, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardImage(ImageProvider provider) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(image: provider, fit: BoxFit.cover),
      ),
    );
  }
}

Future<DamagePreviewAction?> showDamagePreviewSheet(
  BuildContext context, {
  required String title,
  required ImageProvider farImage,
  required ImageProvider closeImage,
  required Damage damage,
}) {
  return showModalBottomSheet<DamagePreviewAction>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    barrierColor: Colors.black.withOpacity(0.45),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _DamagePreviewSheet(
      title: title,
      farImage: farImage,
      closeImage: closeImage,
      dameaged: damage,
    ),
  );
}

class _DamagePreviewSheet extends ConsumerWidget {
  const _DamagePreviewSheet(
      {required this.title,
      required this.farImage,
      required this.closeImage,
      required this.dameaged});

  final String title;
  final ImageProvider farImage;
  final ImageProvider closeImage;
  final Damage dameaged;

  static const _mint = CustomColors.greenColor;
  static const _mintPill = CustomColors.lightGreenColor;
  static const _removeBg = CustomColors.lightRedColor;
  static const _removeText = CustomColors.toastRedColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mq = MediaQuery.of(context);
    final sheetHeight = mq.size.height * 0.8.h; // comfy height
    final List<Damage> damages = ref.watch(vehicleDamagesProvider);

    return SizedBox(
      height: sheetHeight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12, 20.w, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: semiBoldText(
                    title,
                    maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                    fontSize: 16.sp,
                    color: CustomColors.primaryText,
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () =>
                      Navigator.pop(context, DamagePreviewAction.dismissed),
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 24,
                    weight: 1,
                    color: CustomColors.blackColor,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Content scrolls if needed
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _PreviewImage(
                      image: farImage,
                      tagText: 'Far range',
                      tagBg: _mintPill,
                      tagFg: _mint,
                    ),
                    const SizedBox(height: 16),
                    _PreviewImage(
                      image: closeImage,
                      tagText: 'Close range',
                      tagBg: _mintPill,
                      tagFg: _mint,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Bottom actions
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Row(
                children: [
                  Expanded(
                      child: CustomButton(
                          title: 'Remove image',
                          buttonColor: _removeBg,
                          textColor: _removeText,
                          onTap: () {
                            Navigator.pop(context, DamagePreviewAction.removed);
                          })),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      title: 'Cool',
                      buttonColor: _mint,
                      onTap: () =>
                          Navigator.pop(context, DamagePreviewAction.confirmed),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({
    required this.image,
    required this.tagText,
    required this.tagBg,
    required this.tagFg,
  });

  final ImageProvider image;
  final String tagText;
  final Color tagBg;
  final Color tagFg;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(image: image, fit: BoxFit.cover),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tagText,
                  style: TextStyle(
                    color: tagFg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
