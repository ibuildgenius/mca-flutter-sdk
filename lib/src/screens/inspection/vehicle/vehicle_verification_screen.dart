// ignore_for_file: use_build_context_synchronously

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

class VehicleVerificationScreen extends StatefulHookConsumerWidget {
  final List<CameraDescription> cameras;

  const VehicleVerificationScreen({super.key, required this.cameras});

  @override
  ConsumerState<VehicleVerificationScreen> createState() =>
      _VehicleVerificationScreenState();
}

class _VehicleVerificationScreenState extends ConsumerState<VehicleVerificationScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  File? _imageFile;
  bool isRecording = false;
  XFile? _videoFile;
  late CameraController controller;
  bool showCaptureScreen = false;
  late AnimationController animationController;

  //BOUNCE IN ANIMATION
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

      // imageFormatGroup: ImageFormatGroup.yuv420, // Efficient format
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

    //dddddd

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
        // Navigator.pop(context);
      } else {
        // Handle other errors
      }
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
        // Show your modal here
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
                  //This checks if the device is either in portrait mode or landscape and shows the respective widgets
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
                          child:
                              //This condition checks if the user has reached any of the capture stages, then it shows the capture screen
                              (getVerificationStage(ref
                                          .watch(verificationStepProvider)) ==
                                      VerificationStage.capture)
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        // alignment: Alignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 10,
                                              // left: 4,
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
                                                    timerString: timerString,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Container(
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      color: CustomColors
                                                          .transGrayColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: 7,
                                                                  shrinkWrap:
                                                                      true,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  itemBuilder: (context, index) {
                                                                    final verificationStep = ref.watch(verifiedCountProvider);
                                                                    final isStepCompleted = index < verificationStep;
                                                                    return Padding(
                                                                      padding: const EdgeInsets.only(bottom: 12.0),
                                                                      child: Container(
                                                                        height:
                                                                            21,
                                                                        width:
                                                                            21,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: isStepCompleted
                                                                              ? CustomColors.success500Color
                                                                              : CustomColors.grayiconColor.withOpacity(0.9),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .check,
                                                                          color: CustomColors
                                                                              .whiteColor
                                                                              .withOpacity(0.6),
                                                                          size:
                                                                              18,
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
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: AspectRatio(
                                                  aspectRatio: controller
                                                      .value.aspectRatio,
                                                  child: CameraPreview(
                                                    controller,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
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
                                                                  builder:
                                                                      (context,
                                                                          child) {
                                                                    return Transform
                                                                        .translate(
                                                                      offset: Offset(
                                                                          0,
                                                                          _textAnimation
                                                                              .value),
                                                                      child:
                                                                          child,
                                                                    );
                                                                  },
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      style: CustomTextStyles
                                                                          .regular(
                                                                        // height: 1.8,
                                                                        fontSize:
                                                                            18,
                                                                        color: CustomColors
                                                                            .whiteColor,
                                                                      ),
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                              getBounceTextName(ref.watch(verificationStepProvider))[0],
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              getBounceTextName(ref.watch(verificationStepProvider))[1],
                                                                          style:
                                                                              CustomTextStyles.w500(
                                                                            // height: 1.8,
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                CustomColors.primaryBrandColor(),
                                                                          ),
                                                                        ),
                                                                        // const TextSpan(
                                                                        //   text: "View",
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

                                                    final image =
                                                        await controller
                                                            .takePicture();

                                                    _imageFile =
                                                        File(image.path);

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
                                                          .updateCaptureToVerifyStep(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Expanded(
                                                            child: SizedBox()),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10.0),
                                                          child: CountdownTimer(
                                                            controller:
                                                                animationController,
                                                            timerColor:
                                                                timerColor,
                                                            timerString:
                                                                timerString,
                                                          ),
                                                        ),
                                                        // const Expanded(
                                                        //     child: SizedBox()),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10.0),
                                                          child: Container(
                                                            width: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: CustomColors
                                                                  .transGrayColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8.0),
                                                                  child: ListView
                                                                      .builder(
                                                                          itemCount:
                                                                              7,
                                                                          shrinkWrap:
                                                                              true,
                                                                          padding: EdgeInsets
                                                                              .zero,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            final verificationStep = ref.watch(verifiedCountProvider);
                                                                            final isStepCompleted =
                                                                                index < verificationStep;
                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(bottom: 12.0),
                                                                              child: Container(
                                                                                height: 21,
                                                                                width: 21,
                                                                                decoration: BoxDecoration(
                                                                                  color: isStepCompleted ? CustomColors.primaryBrandColor() : CustomColors.grayiconColor.withOpacity(0.9),
                                                                                  shape: BoxShape.circle,
                                                                                ),
                                                                                child: Icon(
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
                                                        child: (getVerificationStage(ref.watch(verificationStepProvider)) == VerificationStage.verify ||
                                                                getVerificationStage(
                                                                        ref.watch(
                                                                            verificationStepProvider)) ==
                                                                    VerificationStage
                                                                        .loading ||
                                                                getVerificationStage(
                                                                        ref.watch(
                                                                            verificationStepProvider)) ==
                                                                    VerificationStage
                                                                        .failed)
                                                            ? Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                                child:
                                                                    SelectedImageContainer(
                                                                        // height: 200,
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
                                          ref.watch(verificationStepProvider) ==
                                                  CarVerificationStep
                                                      .verificationLoading
                                              ? const LoadingSideContainer()
                                              : (getVerificationStage(ref.watch(
                                                              verificationStepProvider)) ==
                                                          VerificationStage
                                                              .verify ||
                                                      getVerificationStage(
                                                              ref.watch(
                                                                  verificationStepProvider)) == VerificationStage.failed)
                                                  ? VerifySideContainer(
                                                      inspectionType:
                                                          InspectionType
                                                              .vehicle,
                                                      step: ref.watch(
                                                          verificationStepProvider),
                                                      onReCaptureTap: () {
                                                        _startBouncing();
                                                        inspectionVM.updateVerifyToCaptureToStep(
                                                                ref);
                                                      },
                                                      onVerifyTap: () async {
                                                        stopVideoRecording;
                                                        inspectionVM.updateVerificationStep(
                                                          ref: ref,
                                                          context: context,
                                                          file: _imageFile!,
                                                          videoFile: _videoFile,
                                                          stopVideo: stopVideoRecording,
                                                        );
                                                      },
                                                    )
                                                  : StartSideContainer(
                                                      inspectionType: InspectionType.vehicle,
                                                      step: ref.watch(verificationStepProvider),
                                                      onTap: () {
                                                        startTimer();
                                                        inspectionVM
                                                            .updatePreCaptureToCaptureStep(
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

