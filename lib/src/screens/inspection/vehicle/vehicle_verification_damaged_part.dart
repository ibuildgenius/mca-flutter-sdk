import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/models/damaged_area_parts.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/capture_side_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/loading_side_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/selected_image_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/start_side_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/verify_side_container.dart';

class VehicleVerificationDamagedPartScreen extends StatefulHookConsumerWidget {
  final List<CameraDescription> cameras;
  final Damage selected;

  const VehicleVerificationDamagedPartScreen({
    super.key,
    required this.cameras,
    required this.selected,
  });

  @override
  ConsumerState<VehicleVerificationDamagedPartScreen> createState() =>
      _VehicleVerificationDamagedPartScreenState();
}

class _VehicleVerificationDamagedPartScreenState
    extends ConsumerState<VehicleVerificationDamagedPartScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  File? _imageFile;
  CameraController? _controller;

  // Bounce hint animation
  late final AnimationController _textController;
  late final Animation<double> _textAnimation;
  bool _showText = false;
  int _bounceCount = 0;

  @override
  void initState() {
    super.initState();

    // --- Camera (init in a helper to use async/await cleanly) ---
    _initCamera();

    // --- Bounce overlay ---
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    final bounceCurve =
    CurvedAnimation(parent: _textController, curve: Curves.decelerate);
    _textAnimation = Tween<double>(begin: 0, end: -10).animate(bounceCurve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _textController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (_bounceCount < 3) {
            _bounceCount++;
            _textController.forward();
          } else {
            if (mounted) {
              setState(() {
                _showText = false;
                _bounceCount = 0;
              });
            }
          }
        }
      });

    // ❗ Move *all* provider work to next frame to avoid the Riverpod initState assertion.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // 1) Add/replace the selected damage item (immutable update, no duplicates)
      final damagesNotifier = ref.read(vehicleDamagesProvider.notifier);
      final current = List<Damage>.from(ref.read(vehicleDamagesProvider));
      final idx = current.indexWhere((d) =>
      (d.damageArea ?? '').trim().toLowerCase() ==
          (widget.selected.damageArea ?? '').trim().toLowerCase() &&
          (d.damagePart ?? '').trim().toLowerCase() ==
              (widget.selected.damagePart ?? '').trim().toLowerCase());

      if (idx >= 0) {
        current[idx] = widget.selected;
      } else {
        current.add(widget.selected);
      }
      damagesNotifier.state = current;

      // 2) Update VM step
      ref.read(inspectionVmProvider).updateDamagedPartStep(
        ref: ref,
        area: widget.selected.damageArea,
      );

      // 3) If you need to reset any counters, invalidate safely here (not in initState)
      ref.invalidate(verifiedCountProvider);
    });
  }

  Future<void> _initCamera() async {
    try {
      if (widget.cameras.isEmpty) return;
      final ctrl = CameraController(
        widget.cameras.first,
        ResolutionPreset.low,
        enableAudio: false,
      );
      await ctrl.initialize();
      if (!mounted) {
        await ctrl.dispose();
        return;
      }
      setState(() => _controller = ctrl);
    } catch (_) {
      // Optionally handle CameraException
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _startBouncing() {
    setState(() => _showText = true);
    _textController.forward();
  }

  Future<void> _onCapture(InspectionViewModel inspectionVM) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => isLoading = true);
    final shot = await _controller!.takePicture();
    _imageFile = File(shot.path);

    ref.read(selectedImageFileProvider.notifier).state = _imageFile;

    setState(() => isLoading = false);
    if (_imageFile != null) {
      await inspectionVM.updateCaptureToVerifyStep(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inspectionVM = ref.watch(inspectionVmProvider);

    // Read once per build — avoids inconsistent reads
    final step = ref.watch(verificationStepProvider);
    final stage = getVerificationStage(step);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.black,
      body: (_controller?.value.isInitialized ?? false)
          ? Column(
        children: [
          if (isPortrait)
            Expanded(
              child: CameraPreview(
                _controller!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rotate Device",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Row(
                children: [
                  // ---------- Left rail (2 steps) ----------
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                      top: MediaQuery.of(context).padding.top + 10,
                      bottom: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(child: SizedBox()),
                        Container(
                          width: 30,
                          decoration: BoxDecoration(
                            color: CustomColors.transGrayColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ListView.builder(
                              itemCount: 2,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final done = index <
                                    ref.watch(verifiedCountProvider);
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 12.0),
                                  child: Container(
                                    height: 21,
                                    width: 21,
                                    decoration: BoxDecoration(
                                      color: done
                                          ? CustomColors.success500Color
                                          : CustomColors.grayiconColor
                                          .withOpacity(0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: CustomColors.whiteColor
                                          .withOpacity(0.6),
                                      size: 18,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),

                  // ---------- Middle: camera or selected image ----------
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: Builder(
                        builder: (_) {
                          final showImage =
                              stage == VerificationStage.verify ||
                                  stage == VerificationStage.loading ||
                                  stage == VerificationStage.failed;

                          if (showImage) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: SelectedImageContainer(
                                controller: _controller!,
                                imageFile: _imageFile,
                              ),
                            );
                          }

                          // Live camera with optional bouncing hint
                          return CameraPreview(
                            _controller!,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top +
                                    60,
                              ),
                              child: Center(
                                child: _showText
                                    ? SizedBox(
                                  height: 100,
                                  child: AnimatedBuilder(
                                    animation: _textAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          0,
                                          _textAnimation.value,
                                        ),
                                        child: child,
                                      );
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                        CustomTextStyles.regular(
                                          fontSize: 18,
                                          color: CustomColors
                                              .whiteColor,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: getBounceTextName(
                                                step)[0],
                                          ),
                                          TextSpan(
                                            text: getBounceTextName(
                                                step)[1],
                                            style: CustomTextStyles
                                                .w500(
                                              fontSize: 18,
                                              color: CustomColors
                                                  .primaryBrandColor(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ---------- Right panel: driven by stage ----------
                  RightPanel(
                    stage: stage,
                    step: step,
                    isLoading: isLoading,
                    onStart: () {
                      inspectionVM.updatePreCaptureToCaptureStep(ref);
                      _startBouncing();
                    },
                    onCapture: () => _onCapture(inspectionVM),
                    onReCapture: () {
                      _startBouncing();
                      inspectionVM.updateVerifyToCaptureToStep(ref);
                    },
                    onVerify: () async {
                      if (_imageFile == null) return;

                      final notifier =
                      ref.read(vehicleDamagesProvider.notifier);
                      final currentList = List<Damage>.from(
                          ref.read(vehicleDamagesProvider));

                      // find matching item by (area + part)
                      final idx = currentList.indexWhere((d) =>
                      (d.damageArea ?? '').trim().toLowerCase() ==
                          (widget.selected.damageArea ?? '')
                              .trim()
                              .toLowerCase() &&
                          (d.damagePart ?? '').trim().toLowerCase() ==
                              (widget.selected.damagePart ?? '')
                                  .trim()
                                  .toLowerCase());

                      // base item (existing or new)
                      final base =
                      idx >= 0 ? currentList[idx] : widget.selected;

                      // Consider slot filled if we have a URL/string OR a File
                      final hasFar =
                          (base.farRange?.isNotEmpty == true) ||
                              base.farRangeFile != null;
                      final hasClose =
                          (base.closeRange?.isNotEmpty == true) ||
                              base.closeRangeFile != null;

                      Damage updated = base;

                      // 1) fill FAR first
                      if (!hasFar) {
                        updated = base.copyWith(farRangeFile: _imageFile);
                        if (idx >= 0) {
                          currentList[idx] = updated;
                        } else {
                          currentList.add(updated);
                        }
                        notifier.state = currentList;

                        // ask for second shot (keep user in flow)
                        ref
                            .read(inspectionVmProvider)
                            .updateDamagedPartStep(
                          ref: ref,
                          area: updated.damageArea,
                        );
                        return;
                      }

                      // 2) then fill CLOSE
                      if (!hasClose) {
                        updated =
                            base.copyWith(closeRangeFile: _imageFile);
                        if (idx >= 0) {
                          currentList[idx] = updated;
                        } else {
                          currentList.add(updated);
                        }
                        notifier.state = currentList;

                        // done with this damage item
                        if (mounted) {
                          Navigator.of(context).pop(updated);
                        }
                        return;
                      }

                      // 3) both present already: just ensure state is up-to-date
                      if (idx >= 0) {
                        currentList[idx] = base;
                      } else {
                        currentList.add(base);
                      }
                      notifier.state = currentList;
                      if (mounted) {
                        Navigator.of(context).pop(base);
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      )
          : const SizedBox.shrink(),
    );
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({
    super.key,
    required this.stage,
    required this.step,
    required this.isLoading,
    required this.onStart,
    required this.onCapture,
    required this.onReCapture,
    required this.onVerify,
  });

  final VerificationStage stage;
  final CarVerificationStep step;
  final bool isLoading;

  final VoidCallback onStart;
  final VoidCallback onCapture;
  final VoidCallback onReCapture;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    switch (stage) {
      case VerificationStage.capture:
        return CaptureSideContainer(
          isLoading: isLoading,
          onTap: onCapture,
        );
      case VerificationStage.loading:
        return const LoadingSideContainer();
      case VerificationStage.verify:
      case VerificationStage.failed:
        return VerifySideContainer(
          inspectionType: InspectionType.vehicle,
          step: step,
          onReCaptureTap: onReCapture,
          onVerifyTap: onVerify,
        );
      default: // pre-capture
        return StartSideContainer(
          inspectionType: InspectionType.vehicle,
          step: step,
          onTap: onStart,
        );
    }
  }
}





// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
// import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
// import 'package:mca_official_flutter_sdk/src/models/damaged_area_parts.dart';
// import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';
// import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
// import 'package:mca_official_flutter_sdk/src/widgets/widgets/capture_side_container.dart';
// import 'package:mca_official_flutter_sdk/src/widgets/widgets/loading_side_container.dart';
// import 'package:mca_official_flutter_sdk/src/widgets/widgets/selected_image_container.dart';
// import 'package:mca_official_flutter_sdk/src/widgets/widgets/start_side_container.dart';
// import 'package:mca_official_flutter_sdk/src/widgets/widgets/verify_side_container.dart';
//
// class VehicleVerificationDamagedPartScreen extends StatefulHookConsumerWidget {
//   final List<CameraDescription> cameras;
//   final Damage selected;
//
//   const VehicleVerificationDamagedPartScreen({
//     super.key,
//     required this.cameras,
//     required this.selected,
//   });
//
//   @override
//   ConsumerState<VehicleVerificationDamagedPartScreen> createState() =>
//       _VehicleVerificationDamagedPartScreenState();
// }
//
// class _VehicleVerificationDamagedPartScreenState
//     extends ConsumerState<VehicleVerificationDamagedPartScreen>
//     with TickerProviderStateMixin {
//   bool isLoading = false;
//   File? _imageFile;
//   late CameraController controller;
//
//   // Bounce hint animation
//   late AnimationController _textController;
//   late Animation<double> _textAnimation;
//   bool _showText = false;
//   int _bounceCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // --- Camera ---
//     controller = CameraController(
//       widget.cameras.first,
//       ResolutionPreset.low,
//       enableAudio: false,
//     );
//     controller.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});
//     }).catchError((Object e) {
//       // handle CameraException if you want
//     });
//
//     // --- Bounce overlay ---
//     _textController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     final bounceCurve =
//         CurvedAnimation(parent: _textController, curve: Curves.decelerate);
//     _textAnimation = Tween<double>(begin: 0, end: -10).animate(bounceCurve)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _textController.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           if (_bounceCount < 3) {
//             _bounceCount++;
//             _textController.forward();
//           } else {
//             if (mounted) {
//               setState(() {
//                 _showText = false;
//                 _bounceCount = 0;
//               });
//             }
//           }
//         }
//       });
//
//     // --- Defer provider writes until after first build ---
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//
//       // 1) Add/replace the selected item in the damages list (no duplicates)
//       final damagesNotifier = ref.read(vehicleDamagesProvider.notifier);
//       final list = List<Damage>.from(ref.read(vehicleDamagesProvider));
//
//       final idx = list.indexWhere((d) =>
//           d.damageArea == widget.selected.damageArea &&
//           d.damagePart == widget.selected.damagePart);
//
//       if (idx >= 0) {
//         // replace existing entry with the latest selected
//         list[idx] = widget.selected;
//       } else {
//         // append if new
//         list.add(widget.selected);
//       }
//       damagesNotifier.state = list; // reassign to notify listeners
//
//       // 2) Update VM state
//       ref.read(inspectionVmProvider).updateDamagedPartStep(
//             ref: ref,
//             area: widget.selected.damageArea,
//           );
//     });
//
//     ref.invalidate(verifiedCountProvider);
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     _textController.dispose();
//     super.dispose();
//   }
//
//   void _startBouncing() {
//     setState(() => _showText = true);
//     _textController.forward();
//   }
//
//   Future<void> _onCapture(InspectionViewModel inspectionVM) async {
//     setState(() => isLoading = true);
//     final shot = await controller.takePicture();
//     _imageFile = File(shot.path);
//
//     ref.read(selectedImageFileProvider.notifier).state = _imageFile;
//
//     setState(() => isLoading = false);
//     if (_imageFile != null) {
//       await inspectionVM.updateCaptureToVerifyStep(ref);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final inspectionVM = ref.watch(inspectionVmProvider);
//
//     // Read once per build — avoids inconsistent reads
//     final step = ref.watch(verificationStepProvider);
//     final stage = getVerificationStage(step);
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: controller.value.isInitialized
//           ? Column(
//               children: [
//                 // If portrait: ask to rotate
//                 if (isPortrait)
//                   Expanded(
//                     child: CameraPreview(
//                       controller,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Rotate Device",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.w600,
//                               color: CustomColors.whiteColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 else
//                   // Landscape main layout
//                   Expanded(
//                     child: Row(
//                       children: [
//                         // ---------- Left rail (2 steps) ----------
//                         Padding(
//                           padding: EdgeInsets.only(
//                             right: 10,
//                             top: MediaQuery.of(context).padding.top + 10,
//                             bottom: 10,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Expanded(child: SizedBox()),
//                               Container(
//                                 width: 30,
//                                 decoration: BoxDecoration(
//                                   color: CustomColors.transGrayColor,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: ListView.builder(
//                                     itemCount: 2,
//                                     shrinkWrap: true,
//                                     padding: EdgeInsets.zero,
//                                     itemBuilder: (context, index) {
//                                       final done = index <
//                                           ref.watch(verifiedCountProvider);
//                                       return Padding(
//                                         padding:
//                                             const EdgeInsets.only(bottom: 12.0),
//                                         child: Container(
//                                           height: 21,
//                                           width: 21,
//                                           decoration: BoxDecoration(
//                                             color: done
//                                                 ? CustomColors.success500Color
//                                                 : CustomColors.grayiconColor
//                                                     .withOpacity(0.9),
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Icon(
//                                             Icons.check,
//                                             color: CustomColors.whiteColor
//                                                 .withOpacity(0.6),
//                                             size: 18,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               const Expanded(child: SizedBox()),
//                             ],
//                           ),
//                         ),
//
//                         // ---------- Middle: camera or selected image ----------
//                         Expanded(
//                           child: AspectRatio(
//                             aspectRatio: controller.value.aspectRatio,
//                             child: Builder(
//                               builder: (_) {
//                                 final showImage =
//                                     stage == VerificationStage.verify ||
//                                         stage == VerificationStage.loading ||
//                                         stage == VerificationStage.failed;
//
//                                 if (showImage) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10.0),
//                                     child: SelectedImageContainer(
//                                       controller: controller,
//                                       imageFile: _imageFile,
//                                     ),
//                                   );
//                                 }
//
//                                 // Live camera with optional bouncing hint
//                                 return CameraPreview(
//                                   controller,
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                       top: MediaQuery.of(context).padding.top +
//                                           60,
//                                     ),
//                                     child: Center(
//                                       child: _showText
//                                           ? SizedBox(
//                                               height: 100,
//                                               child: AnimatedBuilder(
//                                                 animation: _textAnimation,
//                                                 builder: (context, child) {
//                                                   return Transform.translate(
//                                                     offset: Offset(0,
//                                                         _textAnimation.value),
//                                                     child: child,
//                                                   );
//                                                 },
//                                                 child: RichText(
//                                                   text: TextSpan(
//                                                     style: CustomTextStyles
//                                                         .regular(
//                                                       fontSize: 18,
//                                                       color: CustomColors
//                                                           .whiteColor,
//                                                     ),
//                                                     children: [
//                                                       TextSpan(
//                                                         text: getBounceTextName(
//                                                             step)[0],
//                                                       ),
//                                                       TextSpan(
//                                                         text: getBounceTextName(
//                                                             step)[1],
//                                                         style: CustomTextStyles
//                                                             .w500(
//                                                           fontSize: 18,
//                                                           color: CustomColors
//                                                               .primaryBrandColor(),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           : const SizedBox.shrink(),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//
//                         // ---------- Right panel: driven by stage ----------
//
//                         RightPanel(
//                           stage: stage,
//                           step: step,
//                           isLoading: isLoading,
//                           onStart: () {
//                             inspectionVM.updatePreCaptureToCaptureStep(ref);
//                             _startBouncing();
//                           },
//                           onCapture: () => _onCapture(inspectionVM),
//                           onReCapture: () {
//                             _startBouncing();
//                             inspectionVM.updateVerifyToCaptureToStep(ref);
//                           },
//                           onVerify: () async {
//                             if (_imageFile == null) return;
//
//                             // read once inside a callback
//                             final notifier =
//                                 ref.read(vehicleDamagesProvider.notifier);
//                             final currentList = List<Damage>.from(
//                                 ref.read(vehicleDamagesProvider));
//
//                             // find matching item by (area + part)
//                             final idx = currentList.indexWhere((d) =>
//                                 d.damageArea == widget.selected.damageArea &&
//                                 d.damagePart == widget.selected.damagePart);
//
//                             // base item to work with (existing or the selected one)
//                             final base =
//                                 idx >= 0 ? currentList[idx] : widget.selected;
//
//                             // consider a slot filled if we have either a URL/string or a File
//                             final hasFar =
//                                 (base.farRange.isNotEmpty ?? false) ||
//                                     base.farRangeFile != null;
//                             final hasClose =
//                                 (base.closeRange.isNotEmpty ?? false) ||
//                                     base.closeRangeFile != null;
//
//                             Damage updated = base;
//
//                             // 1) fill FAR first
//                             if (!hasFar) {
//                               updated = base.copyWith(farRangeFile: _imageFile);
//                               // replace-or-insert
//                               if (idx >= 0) {
//                                 currentList[idx] = updated;
//                               } else {
//                                 currentList.add(updated);
//                               }
//                               notifier.state = currentList;
//
//                               // ask for second shot (keep user in flow)
//                               ref
//                                   .read(inspectionVmProvider)
//                                   .updateDamagedPartStep(
//                                       ref: ref, area: updated.damageArea);
//                               return;
//                             }
//
//                             // 2) then fill CLOSE
//                             if (!hasClose) {
//                               updated =
//                                   base.copyWith(closeRangeFile: _imageFile);
//                               if (idx >= 0) {
//                                 currentList[idx] = updated;
//                               } else {
//                                 currentList.add(updated);
//                               }
//                               notifier.state = currentList;
//
//                               // done with this damage item
//                               Navigator.of(context).pop(updated);
//                               return;
//                             }
//
//                             // 3) both present already: just make sure we store the latest base and close
//                             if (idx >= 0) {
//                               currentList[idx] = base;
//                             } else {
//                               currentList.add(base);
//                             }
//                             notifier.state = currentList;
//                             Navigator.of(context).pop(base);
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//               ],
//             )
//           : const SizedBox.shrink(),
//     );
//   }
// }
//
// class RightPanel extends StatelessWidget {
//   const RightPanel({
//     super.key,
//     required this.stage,
//     required this.step,
//     required this.isLoading,
//     required this.onStart,
//     required this.onCapture,
//     required this.onReCapture,
//     required this.onVerify,
//   });
//
//   final VerificationStage stage;
//   final CarVerificationStep step;
//   final bool isLoading;
//
//   final VoidCallback onStart;
//   final VoidCallback onCapture;
//   final VoidCallback onReCapture;
//   final VoidCallback onVerify;
//
//   @override
//   Widget build(BuildContext context) {
//     switch (stage) {
//       case VerificationStage.capture:
//         return CaptureSideContainer(
//           isLoading: isLoading,
//           onTap: onCapture,
//         );
//
//       case VerificationStage.loading:
//         return const LoadingSideContainer();
//
//       case VerificationStage.verify:
//       case VerificationStage.failed:
//         return VerifySideContainer(
//           inspectionType: InspectionType.vehicle,
//           step: step,
//           onReCaptureTap: onReCapture,
//           onVerifyTap: onVerify,
//         );
//
//       default: // pre-capture
//         return StartSideContainer(
//           inspectionType: InspectionType.vehicle,
//           step: step,
//           onTap: onStart,
//         );
//     }
//   }
// }
