import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/generic_dialog.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/auto_inspection_pageview.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/provider_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/capture_side_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/countdown_timer.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/loading_side_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/selected_image_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/start_side_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/widgets/verify_side_container.dart';

class GadgetVerificationScreen extends StatefulHookConsumerWidget {
  final List<CameraDescription> cameras;
  const GadgetVerificationScreen({super.key, required this.cameras});

  @override
  ConsumerState<GadgetVerificationScreen> createState() =>
      _GadgetVerificationScreenState();
}

class _GadgetVerificationScreenState
    extends ConsumerState<GadgetVerificationScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  File? _imageFile;
  bool isRecording = false;
  XFile? _videoFile;
  late CameraController controller;
  bool showCaptureScreen = false;
  late AnimationController animationController;

  late AnimationController _textController;
  late Animation<double> _textAnimation;
  bool _showText = false;
  int _bounceCount = 0;

  String get timerString {
    Duration duration =
        animationController.duration! * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 5),
    );
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.low,
      enableAudio: false,
      videoBitrate: 1500000,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;

          default:
            break;
        }
      }
    });

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    final bounceCurve = CurvedAnimation(
      parent: _textController,
      curve: Curves.decelerate,
    );

    _textAnimation = Tween<double>(begin: 0, end: -10).animate(bounceCurve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _textController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (_bounceCount < 3) {
            _bounceCount++;
            _textController.forward();
          } else {
            setState(() {
              _showText = false;
              _bounceCount = 0;
            });
          }
        }
      });

    super.initState();
  }

  Future<void> startVideoRecording() async {
    if (!controller.value.isInitialized || isRecording) return;

    setState(() {
      isRecording = true;
    });

    await controller.startVideoRecording();
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller.value.isInitialized || !isRecording) return null;

    final videoFile = await controller.stopVideoRecording();

    setState(() {
      isRecording = false;
      _videoFile = videoFile;
    });

    return videoFile;
  }

  Future<void> checkPermissions() async {
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
      } else {}
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _textController.dispose();
    animationController.dispose();

    super.dispose();
  }

  void startTimer() async {
    if (animationController.isAnimating) {
      return;
    }
    await startVideoRecording();
    animationController.reverse(
        from:
            animationController.value == 0.0 ? 1.0 : animationController.value);

    animationController.addStatusListener((status) async {
      if (status == AnimationStatus.dismissed) {
        stopVideoRecording();
        await GenericDialog().timeUpDialog(
            context: context,
            onOkPressed: () {
              ProviderUtils.resetVerificationProviders(ref);
              Navigator.of(context).pop();
              return false;
            });
      }
    });
  }

  void _startBouncing() {
    setState(() {
      _showText = true;
    });
    _textController.forward();
  }

  Color get timerColor {
    if (animationController.value == 0) {
      return CustomColors.blackColor;
    } else if (animationController.value > 0.66) {
      return CustomColors.primaryBrandColor();
    } else if (animationController.value > 0.33) {
      return CustomColors.lightOrangeBgColor;
    } else {
      return CustomColors.redColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inspectionVM = ref.watch(inspectionVmProvider);
    return Scaffold(
        backgroundColor: Colors.black,
        body: (controller.value.isInitialized)
            ? Column(
                children: [
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? Expanded(
                          child: CameraPreview(
                          controller,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rotate Device",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.whiteColor),
                              ),
                            ],
                          ),
                        ))
                      : Expanded(
                          child: SizedBox(
                          width: double.infinity,
                          child: (getPhoneVerificationStage(ref
                                      .watch(phoneVerificationStepProvider)) ==
                                  VerificationStage.capture)
                              ? SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 10,
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              10,
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Expanded(child: SizedBox()),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: CountdownTimer(
                                                controller: animationController,
                                                timerColor: timerColor,
                                                timerString: timerString,
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                                top: 20,
                                              ),
                                              child: Container(
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: CustomColors
                                                      .transGrayColor,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: ListView.builder(
                                                          itemCount: 4,
                                                          shrinkWrap: true,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final verificationStep =
                                                                ref.watch(
                                                                    verifiedCountProvider);
                                                            final isStepCompleted =
                                                                index <
                                                                    verificationStep;
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          15.0),
                                                              child: Container(
                                                                height: 18,
                                                                width: 18,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: isStepCompleted
                                                                      ? CustomColors
                                                                          .success500Color
                                                                      : CustomColors
                                                                          .grayiconColor
                                                                          .withOpacity(
                                                                              0.9),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Icon(
                                                                  Icons.check,
                                                                  color: CustomColors
                                                                      .whiteColor
                                                                      .withOpacity(
                                                                          0.6),
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: AspectRatio(
                                              aspectRatio:
                                                  controller.value.aspectRatio,
                                              child: CameraPreview(
                                                controller,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .padding
                                                            .top +
                                                        60,
                                                  ),
                                                  child: Center(
                                                    child: (_showText)
                                                        ? SizedBox(
                                                            height: 100,
                                                            child:
                                                                AnimatedBuilder(
                                                              animation:
                                                                  _textAnimation,
                                                              builder: (context,
                                                                  child) {
                                                                return Transform
                                                                    .translate(
                                                                  offset: Offset(
                                                                      0,
                                                                      _textAnimation
                                                                          .value),
                                                                  child: child,
                                                                );
                                                              },
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  style: CustomTextStyles
                                                                      .regular(
                                                                    fontSize:
                                                                        18,
                                                                    color: CustomColors
                                                                        .whiteColor,
                                                                  ),
                                                                  children: const [
                                                                    TextSpan(
                                                                      text:
                                                                          'Ensure the device occupies 80% of the screen',
                                                                    ),
                                                                    // TextSpan(
                                                                    //   text: getBounceTextName(
                                                                    //       ref.watch(
                                                                    //           phoneVerificationStepProvider))[1],
                                                                    //   style: CustomTextStyles
                                                                    //       .w500(
                                                                    //     fontSize:
                                                                    //         18,
                                                                    //     color: CustomColors
                                                                    //         .primaryBrandColor(),
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),
                                      CaptureSideContainer(
                                        isLoading: isLoading,
                                        onTap: isLoading
                                            ? null
                                            : () async {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                final image = await controller
                                                    .takePicture();

                                                _imageFile = File(image.path);

                                                ref
                                                    .read(
                                                        selectedImageFileProvider
                                                            .notifier)
                                                    .state = _imageFile;
                                                if (_imageFile != null) {
                                                  setState(() {
                                                    isLoading = false;
                                                  });

                                                  await inspectionVM
                                                      .updateGadgetCaptureToVerifyStep(
                                                          ref);
                                                }
                                              },
                                      ),
                                    ],
                                  ),
                                )
                              : CameraPreview(
                                  controller,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                              top: MediaQuery.of(context)
                                                      .padding
                                                      .top +
                                                  10,
                                              bottom: 10),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: CountdownTimer(
                                                        controller:
                                                            animationController,
                                                        timerColor: timerColor,
                                                        timerString:
                                                            timerString,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 10.0,
                                                        top: 20,
                                                      ),
                                                      child: Container(
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CustomColors
                                                              .transGrayColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 8.0,
                                                              ),
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount:
                                                                          4,
                                                                      shrinkWrap:
                                                                          true,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        final verificationStep =
                                                                            ref.watch(verifiedCountProvider);
                                                                        final isStepCompleted =
                                                                            index <
                                                                                verificationStep;
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 15.0),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                18,
                                                                            width:
                                                                                18,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: isStepCompleted ? CustomColors.primaryBrandColor() : CustomColors.grayiconColor.withOpacity(0.9),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                Icon(
                                                                              Icons.check,
                                                                              color: CustomColors.whiteColor.withOpacity(0.6),
                                                                              size: 18,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                  ],
                                                ),
                                                Expanded(
                                                    child: (getPhoneVerificationStage(ref.watch(phoneVerificationStepProvider)) ==
                                                                VerificationStage
                                                                    .verify ||
                                                            getPhoneVerificationStage(
                                                                    ref.watch(
                                                                        phoneVerificationStepProvider)) ==
                                                                VerificationStage
                                                                    .loading ||
                                                            getPhoneVerificationStage(
                                                                    ref.watch(
                                                                        phoneVerificationStepProvider)) ==
                                                                VerificationStage
                                                                    .failed)
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            child: SelectedImageContainer(
                                                                controller:
                                                                    controller,
                                                                imageFile:
                                                                    _imageFile),
                                                          )
                                                        : Container()),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      ref.watch(phoneVerificationStepProvider) ==
                                              PhoneVerificationStep
                                                  .verificationLoading
                                          ? const LoadingSideContainer()
                                          : (getPhoneVerificationStage(ref.watch(
                                                          phoneVerificationStepProvider)) ==
                                                      VerificationStage
                                                          .verify ||
                                                  getPhoneVerificationStage(ref.watch(phoneVerificationStepProvider)) == VerificationStage.failed)
                                              ? VerifySideContainer(
                                                  inspectionType:
                                                      InspectionType.gadget,
                                                  step: ref.watch(
                                                      phoneVerificationStepProvider),
                                                  onReCaptureTap: () {
                                                    _startBouncing();
                                                    inspectionVM
                                                        .updateGadgetVerifyToCaptureToStep(
                                                            ref);
                                                  },
                                                  onVerifyTap: () async {
                                                    // stopVideoRecording;
                                                    inspectionVM
                                                        .updateGadgetVerificationStep(
                                                      ref: ref,
                                                      context: context,
                                                      file: _imageFile!,
                                                      videoFile: _videoFile,
                                                      stopVideo:
                                                          stopVideoRecording,
                                                    );
                                                  },
                                                )
                                              : StartSideContainer(
                                                  inspectionType:
                                                      InspectionType.gadget,
                                                  step: ref.watch(
                                                      phoneVerificationStepProvider),
                                                  onTap: () {
                                                    startTimer();
                                                    inspectionVM
                                                        .updateGadgetPreCaptureToCaptureStep(
                                                      ref,
                                                    );
                                                    _startBouncing();
                                                  },
                                                ),
                                    ],
                                  ),
                                ),
                        )),
                ],
              )
            : Container());
  }

  showDialogModal(
      {required BuildContext context,
      required String title,
      required String subTitle,
      final String? okText,
      void Function()? onPressed}) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Material(
              animationDuration: const Duration(milliseconds: 500),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 70,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: onPressed ??
                          () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CarInspectionPageView()),
                                (route) => false);
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.greenColor,
                      ),
                      child: Text(okText ?? "Okay"),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// class LandscapeModeWrapper extends StatefulWidget {
//   final Widget child;

//   const LandscapeModeWrapper({super.key, required this.child});

//   @override
//   State<LandscapeModeWrapper> createState() => _LandscapeModeWrapperState();
// }

// class _LandscapeModeWrapperState extends State<LandscapeModeWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
