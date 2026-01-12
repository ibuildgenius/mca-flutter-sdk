// ignore_for_file: use_build_context_synchronously

// import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:developer';
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
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/vehicle/vehicle_verification_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/auto_inspection_step1.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/widgets/landscape_mode_wrapper.dart';
import 'package:mca_official_flutter_sdk/src/widgets/page_view_container.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';
import 'package:permission_handler/permission_handler.dart';

class CarInspectionPageView extends StatefulHookConsumerWidget {
  const CarInspectionPageView({super.key});

  @override
  ConsumerState<CarInspectionPageView> createState() =>
      _CarInspectionPageViewState();
}

class _CarInspectionPageViewState extends ConsumerState<CarInspectionPageView> {
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
      ref.invalidate(vehicleImageUrlProvider);
      ref.invalidate(vehicleImageProvider);
      ref.invalidate(gadgetImageProvider);
    });
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
                                  "Step on how to inspect",
                                  fontSize: 22,
                                  color: CustomColors.darkTextColor,
                                ),
                              ),

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
                                        text:
                                            "It is important to note all these ",
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
                                            " before starting your Inspection",
                                      ),
                                    ],
                                  ),
                                ),
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
                                        children: List<Widget>.generate(4,
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
                                        child: AnimatedSwitcher(
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Visibility(
                          visible: _currentPage != 3,
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
                                    3, // last page
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
                                _currentPage == 3 ? "Start Inspection" : "Next",
                            onTap: _currentPage == 3
                                ? () async {
                                    var cameraStatus =
                                        await Permission.camera.status;
                                    var locationStatus =
                                        await Permission.location.status;
                                    var microphoneStatus =
                                        await Permission.microphone.status;

                                    if (cameraStatus.isGranted &&
                                        locationStatus.isGranted &&
                                        microphoneStatus.isGranted) {
                                      _getCurrentPosition();
                                    } else {
                                      GenericDialog().permissionRequestDialog(
                                          context: context,
                                          isLoading: isLoading,
                                          onOkPressed: () {
                                            requestPermissions(context);
                                          });
                                    }
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goNextPage() async {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<bool> _ensureAllPermissions() async {
    // Request if not granted
    final statuses = await [
      Permission.camera,
      Permission.location,
      Permission.microphone,
    ].request();

    final cam = statuses[Permission.camera]?.isGranted ?? false;
    final mic = statuses[Permission.microphone]?.isGranted ?? false;
    final loc = statuses[Permission.location]?.isGranted ?? false;

    // Ensure location services (GPS) is actually ON
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) {
      await Geolocator.openLocationSettings();
      return false;
    }

    return cam && mic && loc;
  }

  Future<Position?> _getCurrentPositionWithRetries({
    required int maxRetries,
    required Duration perTryTimeout,
    required Duration backoff,
  }) async {
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        // Add a timeout to avoid hanging forever
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(perTryTimeout);

        return pos; // success
      } on TimeoutException catch (_) {
        debugPrint("⏳ Location attempt $attempt timed out");
      } catch (e) {
        debugPrint("⚠️ Location attempt $attempt failed: $e");
        // Try last known as a graceful fallback
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) return last;
      }

      if (attempt < maxRetries) {
        await Future.delayed(backoff);
      }
    }
    return null; // all attempts failed
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    setState(() {
      isLoading = true;
    });

    const maxRetries = 5;
    int attempt = 0;
    bool success = false;

    try {
      while (attempt < maxRetries && !success) {
        attempt++;
        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
          );

          setState(() => _currentPosition = position);
          await _getAddressFromLatLng(_currentPosition!);

          // ✅ success → stop retrying
          success = true;
          setState(() {
            isLoading = false;
          });
          log('success');
          // navigate after success
          final cameras = await availableCameras();
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LandscapeModeWrapper(
                  child: VehicleVerificationScreen(cameras: cameras),
                ),
              ),
            );
          }
        } catch (e) {
          debugPrint("⚠️ Location attempt $attempt failed: $e");
          if (attempt < maxRetries) {
            await Future.delayed(const Duration(seconds: 5));
          }
        }
      }

      if (!success) {
        // 🚨 all retries failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("We could not verify your location. Please try again."),
            ),
          );
        }
      }
    } catch (e, st) {
      debugPrint("Unexpected location error: $e\n$st");
    } finally {
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
    log('is it $cameraStatus $locationStatus $microphoneStatus');
    if (cameraStatus.isGranted &&
        locationStatus.isGranted &&
        microphoneStatus.isGranted) {
      _getCurrentPosition();
    } else {
      log('request');
      // Request the permissions
      var cameraPermission = await Permission.camera.request();
      var locationPermission = await Permission.location.request();
      var microphonePermission = await Permission.microphone.request();
      log('after request -> cam=$cameraPermission ');

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
      }
    }
  }
}

final List<Widget> pages = [
  const AutoInspectionStep1(
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
  const AutoInspectionStep1(
    key: ValueKey(1),
    content: PageViewContent.secondAutoPage,
    section3text: "front view",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Front View",
  ),
  const AutoInspectionStep1(
    key: ValueKey(2),
    content: PageViewContent.thirdAutoPage,
    section3text: "Left view",
    imageUrl: ConstantString.inspectionWelcome,
    imageTitle: "Left View ( Driver Side )",
  ),
  const AutoInspectionStep1(
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
