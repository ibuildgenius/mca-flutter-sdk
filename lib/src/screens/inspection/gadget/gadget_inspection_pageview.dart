// ignore_for_file: use_build_context_synchronously

// import 'package:camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/generic_dialog.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/gadget/gadget_claim_first_form_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/gadget/gadget_verification_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/gadget_inspection_step.dart';
import 'package:mca_official_flutter_sdk/src/widgets/landscape_mode_wrapper.dart';
import 'package:mca_official_flutter_sdk/src/widgets/page_view_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';
import 'package:permission_handler/permission_handler.dart';

class GadgetInspectionPageView extends StatefulHookConsumerWidget {
  const GadgetInspectionPageView({super.key});

  @override
  ConsumerState<GadgetInspectionPageView> createState() =>
      _GadgetInspectionPageViewState();
}

class _GadgetInspectionPageViewState
    extends ConsumerState<GadgetInspectionPageView> {
  final PageController _pageController = PageController();
  Position? _currentPosition;
  bool isLoading = false;

  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(verificationStepProvider);
      ref.invalidate(phoneVerificationStepProvider);
      ref.invalidate(verifiedCountProvider);
      ref.invalidate(retryCountProvider);
      ref.invalidate(selectedImageFileProvider);
      ref.invalidate(animationControllerProvider);
      ref.invalidate(damagePartNameProvider);
      ref.invalidate(receiptImageProvider);
      ref.invalidate(gadgetImageProvider);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                verticalSpacer(20),
                SizedBox(
                  height: 70,
                  child: CustomAppbar(
                    showBackButton: true,
                    showLogo: false,
                    onBackTap: Navigator.canPop(context)
                        ? () => Navigator.pop(context)
                        : null,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              verticalSpacer(5),
                              GestureDetector(
                                onTap: () {},
                                child: semiBoldText(
                                  "Start your inspection",
                                  fontSize: 22,
                                  color: CustomColors.darkTextColor,
                                ),
                              ),

                              // Text(
                              //   "Step on how to inspect",
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //       fontSize: 24.sp,
                              //       fontWeight: FontWeight.w600,
                              //       color: CustomColors.gray700Color),
                              // ),
                              verticalSpacer(25),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: CustomTextStyles.regular(
                                      fontSize: 16,
                                      color: CustomColors.blackTextColor,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: "Follow these ",
                                      ),
                                      TextSpan(
                                        text: "STEP",
                                        style: CustomTextStyles.semiBold(
                                          fontSize: 16,
                                          color: CustomColors.purple500Color,
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            " to conduct your inspection successfully.",
                                      ),
                                    ],
                                  ),
                                ),

                                //  RichText(
                                //   textAlign: TextAlign.center,
                                //   text: TextSpan(
                                //     style: TextStyle(
                                //         height: 1.3,
                                //         fontSize: 14.sp,
                                //         color: CustomColors.blackTextColor),
                                //     children: [
                                //       const TextSpan(
                                //         text: '',
                                //       ),
                                //       TextSpan(
                                //         text: "STEP",
                                //         style: TextStyle(
                                //             fontSize: 14.sp,
                                //             fontWeight: FontWeight.w700,
                                //             color: CustomColors.purple500Color),
                                //       ),
                                //       const TextSpan(
                                //         text: " before starting your Inspection",
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ),
                              verticalSpacer(25),
                              Container(
                                decoration: BoxDecoration(
                                    // color: CustomColors.purple50Color,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: [
                                      verticalSpacer(10),
                                      Row(
                                        // scrollDirection: Axis.horizontal, shrinkWrap: true,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List<Widget>.generate(2,
                                            (int index) {
                                          return GestureDetector(
                                            onTap: index == _currentPage
                                                ? null
                                                : () {
                                                    _pageController
                                                        .animateToPage(
                                                      index, // last page
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.ease,
                                                    );
                                                  },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              height: 30,
                                              width: (index == _currentPage)
                                                  ? 70
                                                  : 30,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        (index == _currentPage)
                                                            ? 15
                                                            : 15),
                                                color: CustomColors
                                                    .backBorderColor,
                                              ),
                                              child: (index == _currentPage)
                                                  ? Center(
                                                      child: RichText(
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: TextSpan(
                                                          style:
                                                              CustomTextStyles
                                                                  .regular(
                                                            fontSize: 16,
                                                            color: CustomColors
                                                                .blackTextColor,
                                                          ),
                                                          children: [
                                                            const TextSpan(
                                                              text: "STEP  ",
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${index + 1}",
                                                              style:
                                                                  CustomTextStyles
                                                                      .w500(
                                                                fontSize: 16,
                                                                color: CustomColors
                                                                    .purple500Color,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                      (index + 1).toString(),
                                                      style:
                                                          CustomTextStyles.w500(
                                                        fontSize: 16,
                                                        color: CustomColors
                                                            .checkBoxBorderColor,
                                                      ),
                                                    )),
                                            ),
                                          );
                                        }),
                                      ),
                                      verticalSpacer(40),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child:

                                            //  PageView(
                                            //   controller: _pageController,
                                            //   onPageChanged: (int page) {
                                            //     setState(() {
                                            //       _currentPage = page;
                                            //     });
                                            //   },
                                            //   children: const [
                                            //     PageViewContainer(
                                            //       content:
                                            //           PageViewContent.displayPlainColor,
                                            //       section1Text: "Park your Vehicle in a ",
                                            //       section2Text: "well-lit, shaded, ",
                                            //       section3text: "and ",
                                            //       section4Text: "spacious area",
                                            //       section5Text: ", ensuring there are ",
                                            //       section6Text: "no obstructions.",
                                            //       imageUrl:
                                            //           ConstantString.inspectionWelcome,
                                            //     ),
                                            //     PageViewContainer(
                                            //       content:
                                            //           PageViewContent.displayGreenColor,
                                            //       section3text: "front view",
                                            //       imageUrl:
                                            //           ConstantString.inspectionWelcome,
                                            //       imageTitle: "Front View",
                                            //     ),
                                            //     PageViewContainer(
                                            //       content:
                                            //           PageViewContent.displayGreenColor,
                                            //       section3text: "Left view",
                                            //       imageUrl:
                                            //           ConstantString.inspectionWelcome,
                                            //       imageTitle: "Left View ( Driver Side )",
                                            //     ),
                                            //     PageViewContainer(
                                            //       content:
                                            //           PageViewContent.displayGreenColor,
                                            //       section3text: "Back view",
                                            //       imageUrl:
                                            //           ConstantString.inspectionWelcome,
                                            //       imageTitle: "Back View",
                                            //     ),
                                            //     PageViewContainer(
                                            //       content:
                                            //           PageViewContent.displayGreenColor,
                                            //       section3text: "Right view",
                                            //       imageUrl:
                                            //           ConstantString.inspectionWelcome,
                                            //       imageTitle: "Right View",
                                            //     ),
                                            //     PageViewContainer(
                                            //       content:
                                            //           PageViewContent.displayTextAndList,
                                            //       section3text: "Chassis number",
                                            //       imageUrl:
                                            //           ConstantString.inspectionWelcome,
                                            //       imageTitle: "Chassis number",
                                            //     ),
                                            //     PageViewContainer(
                                            //       content:
                                            //           PageViewContent.displayGreenColor,
                                            //       section3text: "Dashboard",
                                            //       imageUrl:
                                            //           ConstantString.inspectionWelcome,
                                            //       imageTitle: "Vehicle Dashboard",
                                            //     ),
                                            //     PageViewContainer(
                                            //       content:
                                            //           PageViewContent.displayGreenColor,
                                            //       section3text: "Interior Back",
                                            //       imageUrl:
                                            //           ConstantString.inspectionWelcome,
                                            //       imageTitle: "Vehicle Back View",
                                            //     ),
                                            //   ],
                                            // ),

                                            AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return FadeTransition(
                                                opacity: animation,
                                                child: child);
                                          },
                                          child: Align(
                                            key: ValueKey<int>(_currentPage),
                                            alignment: Alignment.topCenter,
                                            child: pages[_currentPage],
                                          ),
                                          // child: pages[_currentPage],
                                        ),
                                      ),
                                      verticalSpacer(30),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                child: PageView(
                                  controller: _pageController,
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _currentPage = page;
                                    });
                                  },
                                  children: const [
                                    SizedBox.shrink(),
                                    SizedBox.shrink(),
                                  ],
                                ),
                              ),

                              //This calculates and substracts the bottom padding
                              verticalSpacer(
                                  (MediaQuery.of(context).padding.bottom) + 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              left: 0,
              right: 0,
              child:

                  //  SizedBox(
                  //   child: SizedBox(
                  //     // height: 60,
                  //     child: CustomButton(
                  //       onTap: _currentPage == 7
                  //           ? () async {
                  //               // List<CameraDescription> cameras =
                  //               //     await availableCameras();

                  //               // Navigator.push(
                  //               //     context,
                  //               //     MaterialPageRoute(
                  //               //       builder: (context) =>
                  //               //           VehicleVerificationScreen(
                  //               //         cameras: cameras,
                  //               //       ),
                  //               //     ));
                  //             }
                  //           : () {
                  //               _pageController.nextPage(
                  //                 duration: const Duration(milliseconds: 300),
                  //                 curve: Curves.ease,
                  //               );
                  //             },
                  //       title: _currentPage == 7 ? "Start Inspection" : "Next Step",
                  //       height: 50.h,
                  //       // color: CustomColors.greenColor,
                  //       fontSize: 16,
                  //       // titleColor: CustomColors.whiteColor,
                  //       // fontWeight: FontWeight.w500,
                  //     ),
                  //   ),

                  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Visibility(
                          visible: _currentPage != 1,
                          child: Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: CustomButton(
                                title: "Skip",
                                buttonColor: CustomColors.dividerGreyColor,
                                textColor: CustomColors.backTextColor,
                                fontSize: 14,
                                onTap: () {
                                  _pageController.animateToPage(
                                    1, // last page
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomButton(
                            isLoading: isLoading,
                            title:
                                _currentPage == 1 ? "Start Inspection" : "Next",
                            onTap: _currentPage == 1
                                ? () async {
                                    var cameraStatus =
                                        await Permission.camera.status;
                                    var locationStatus =
                                        await Permission.location.status;
                                    // var microphoneStatus =
                                    //     await Permission.microphone.status;
                                    print(
                                        'granted ${cameraStatus.isGranted} ${locationStatus.isGranted}');
                                    if (cameraStatus.isGranted &&
                                        locationStatus.isGranted) {
                                      _getCurrentPosition();
                                    } else {
                                      GenericDialog().permissionRequestDialog(
                                          context: context,
                                          isLoading: isLoading,
                                          onOkPressed: () {
                                            requestPermissions(context);
                                          });
                                    }

                                    // List<CameraDescription> cameras =
                                    //     await availableCameras();

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           VehicleVerificationScreen(
                                    //         cameras: cameras,
                                    //       ),
                                    //     ));
                                  }
                                : () {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpacer(5),
                  const PoweredByFooter(),
                  verticalSpacer(5),
                ],
              ),

              //     Row(
              //   children: [
              //     Visibility(
              //       visible: _currentPage != 3,
              //       child: Expanded(
              //         child: CustomButton(
              //           onTap: () {
              //             _pageController.animateToPage(
              //               3, // last page
              //               duration: const Duration(milliseconds: 300),
              //               curve: Curves.ease,
              //             );
              //           },
              //           title: "Skip",
              //           height: 50.h,
              //           // color: CustomColors.whiteColor,
              //           fontSize: 16,
              //           // titleColor: CustomColors.gray700Color,
              //           // fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: CustomButton(
              //         onTap: _currentPage == 3
              //             ? () async {
              //                 // List<CameraDescription> cameras =
              //                 //     await availableCameras();

              //                 // Navigator.push(
              //                 //     context,
              //                 //     MaterialPageRoute(
              //                 //       builder: (context) =>
              //                 //           VehicleVerificationScreen(
              //                 //         cameras: cameras,
              //                 //       ),
              //                 //     ));
              //               }
              //             : () {
              //                 _pageController.nextPage(
              //                   duration: const Duration(milliseconds: 300),
              //                   curve: Curves.ease,
              //                 );
              //               },
              //         title:
              //             _currentPage == 7 ? "Start Inspection" : "Next Step",
              //         height: 50.h,
              //         // color: CustomColors.greenColor,
              //         fontSize: 16,
              //         // titleColor: CustomColors.whiteColor,
              //         // fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
  
    if (!hasPermission) return;
    setState(() {
      isLoading = true;
    });
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        setState(() => _currentPosition = position);
        await _getAddressFromLatLng(_currentPosition!);
        setState(() {
          isLoading = false;
        });
        List<CameraDescription> cameras = await availableCameras();

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandscapeModeWrapper(
                child: GadgetVerificationScreen(
                  cameras: cameras,
                ),
              ),
            ));
      }).catchError((e) {
        debugPrint(e);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    Global.inspectionLatitude = _currentPosition!.latitude.toString();
    Global.inspectionLongitude = _currentPosition!.longitude.toString();
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        Global.inspectionAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await GenericDialog().locationDisabledDialog(
          isLoading: isLoading,
          context: context,
          onOkPressed: () {
            Geolocator.openLocationSettings();
            //  Navigator.of(context).pop();
            return false;
          });
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> requestPermissions(BuildContext context) async {
    var cameraStatus = await Permission.camera.status;
    var locationStatus = await Permission.location.status;
    var microphoneStatus = await Permission.microphone.status;

    if (cameraStatus.isGranted &&
        locationStatus.isGranted &&
        microphoneStatus.isGranted) {
      _getCurrentPosition();
    } else {
      // Request the permissions
      var cameraPermission = await Permission.camera.request();
      var locationPermission = await Permission.location.request();
      var microphonePermission = await Permission.microphone.request();

      if (cameraPermission.isGranted &&
          locationPermission.isGranted &&
          microphonePermission.isGranted) {
        _getCurrentPosition();
        // If all permissions are granted, navigate to the new screen
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => NewScreen()));
      } else {
        // If any permission is denied, show a modal
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permissions required'),
              content: const Text('Please accept all permissions to proceed.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Retry'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    requestPermissions(context);
                  },
                ),
                TextButton(
                  child: const Text('Settings'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                ),
              ],
            );
          },
        );
        // // If any permission is denied, show a modal
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: const Text('Permissions required'),
        //       content: const Text('Please accept all permissions to proceed.'),
        //       actions: <Widget>[
        //         TextButton(
        //           child: const Text('OK'),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    }
  }
}

final List<Widget> pages = [
  const GadgetInspectionStep(
    key: ValueKey(0),
    content: PageViewContent.firstAutoPage,
    section1Text: "Park your Vehicle in a ",
    section2Text: "well-lit, shaded, ",
    section3text: "and ",
    section4Text: "spacious area",
    section5Text: ", ensuring there are ",
    section6Text: "no obstructions.",
    imageUrl: ConstantString.inspectionWelcome,
  ),
  const GadgetInspectionStep(
    key: ValueKey(1),
    content: PageViewContent.secondAutoPage,
    section3text: "front view",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Front View",
  ),
  const GadgetInspectionStep(
    key: ValueKey(2),
    content: PageViewContent.thirdAutoPage,
    section3text: "Left view",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Left View ( Driver Side )",
  ),
  const GadgetInspectionStep(
    key: ValueKey(3),
    content: PageViewContent.fourthAutoPage,
    section3text: "Back view",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Back View",
  ),
  const PageViewContainer(
    key: ValueKey(4),
    content: PageViewContent.displayGreenColor,
    section3text: "Right view",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Right View",
  ),
  const PageViewContainer(
    key: ValueKey(5),
    content: PageViewContent.displayTextAndList,
    section3text: "Chassis number",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Chassis number",
  ),
  const PageViewContainer(
    key: ValueKey(6),
    content: PageViewContent.displayGreenColor,
    section3text: "Dashboard",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Vehicle Dashboard",
  ),
  const PageViewContainer(
    key: ValueKey(7),
    content: PageViewContent.displayGreenColor,
    section3text: "Interior Back",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Vehicle Back View",
  ),
];
