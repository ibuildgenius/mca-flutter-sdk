import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

late Timer timer;

class GenericDialog {
  Future<void> showSimplePopup(
      {required BuildContext context,
      required String policyNumber,
      String? title,
      bool showTitle = true,
      String content = "",
      Widget? customIcon,
      Widget? contentBody,
      TextAlign? textAlign,
      String? okText,
      Function()? onOkPressed,
      Function()? onNoPressed,
      Color? footerColor}) async {
    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            actionsPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding:
                const EdgeInsets.only(top: 35, bottom: 25, left: 15, right: 10),
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ConstantString.cautionIcon,
                      package: 'mca_official_flutter_sdk',
                    ),
                    verticalSpacer(25),
                    semiBoldText(
                      "Ongoing Claim",
                      fontSize: 18.sp,
                      color: CustomColors.blackColor,
                    ),
                    verticalSpacer(20.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "There is currently an ongoing claim on this policy ",
                            style: CustomTextStyles.regular(
                                color: CustomColors.blackColor,
                                fontSize: 15,
                                height: 1.4),
                          ),
                          TextSpan(
                            text: "($policyNumber)",
                            style: CustomTextStyles.semiBold(
                                fontSize: 15,
                                color: CustomColors.primaryBrandColor(),
                                height: 1.4),
                          ),
                          TextSpan(
                            text:
                                " . Would you like to proceed to track the claim?",
                            style: CustomTextStyles.regular(
                                color: CustomColors.blackColor,
                                fontSize: 15,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(60.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: "No, Close",
                            buttonColor: CustomColors.dividerGreyColor,
                            textColor: CustomColors.backTextColor,
                            fontSize: 13.sp,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        horizontalSpacer(10.w),
                        Expanded(
                          child: CustomButton(
                            title: "Yes, Track claim",
                            // buttonColor: CustomColors.redExitColor,
                            onTap: onOkPressed ??
                                () {
                                  // var result = {
                                  //   'context': context,
                                  // };

                                  // Global.onClose == null
                                  //     ? null
                                  //     : Global.onClose!(result);

                                  Navigator.pop(context);
                                },
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    verticalSpacer(10)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showGenericSimplePopup({
    required BuildContext context,
    required String title,
    // bool isLoading = false,
    double? horizontalPadding,
    String content = "",
    Widget? contentBody,
    String? okText,
    String? cancelText,
    Function()? onOkPressed,
    Function()? onNoPressed,
    // ValueNotifier<bool>? loadingNotifier,
  }) async {
    // final ValueNotifier<bool> loadingNotifier0 =
    //     loadingNotifier ?? ValueNotifier(isLoading);

    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer(builder: (context, ref, child) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: AlertDialog(
              // insetPadding: horizontalPadding == null
              //     ? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0)
              //     : EdgeInsets.symmetric(horizontal: horizontalPadding),

              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              elevation: 0,
              actionsPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              contentPadding: const EdgeInsets.only(
                  top: 30, bottom: 25, left: 20, right: 20),
              content: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: SvgPicture.asset(
                          ConstantString.cautionIcon,
                          package: 'mca_official_flutter_sdk',
                        ),
                      ),
                      semiBoldText(
                        title,
                        fontSize: 18.sp,
                        color: CustomColors.blackColor,
                        textAlign: TextAlign.left,
                      ),
                      verticalSpacer(20),
                      contentBody ??
                          regularText(
                            content,
                            color: CustomColors.formTitleColor,
                            fontSize: 15,
                          ),
                      verticalSpacer(60.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: cancelText ?? "No, go back",
                              buttonColor: CustomColors.dividerGreyColor,
                              textColor: CustomColors.backTextColor,
                              fontSize: 13.sp,
                              onTap: onNoPressed ??
                                  () {
                                    Navigator.pop(context);
                                  },
                            ),
                          ),
                          horizontalSpacer(10.w),
                          Expanded(
                            child: CustomButton(
                              isLoading: ref.watch(claimVmProvider).isLoading,
                              title: okText ?? "Ok, continue",
                              // buttonColor: CustomColors.redExitColor,
                              onTap: onOkPressed ??
                                  () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  },
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                      verticalSpacer(10)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> showExitDialog(
      {required BuildContext context,
      String? title,
      bool showTitle = true,
      String content = "",
      Widget? customIcon,
      Widget? contentBody,
      TextAlign? textAlign,
      String? okText,
      Function()? onOkPressed,
      Function()? onNoPressed,
      Color? footerColor}) async {
    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            actionsPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding:
                const EdgeInsets.only(top: 35, bottom: 25, left: 15, right: 10),
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ConstantString.roundCautionIcon,
                      package: 'mca_official_flutter_sdk',
                    ),
                    verticalSpacer(25),
                    semiBoldText(
                      "Exit Page",
                      fontSize: 18.sp,
                      color: CustomColors.redExitColor,
                    ),
                    verticalSpacer(20.h),
                    regularText(
                        "Before exiting this page, please be aware that proceeding will result in the loss of any previously submitted data. Are you sure you want to continue?",
                        color: CustomColors.formTitleColor,
                        fontSize: 14.sp,
                        textAlign: TextAlign.center),
                    verticalSpacer(80.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: "No, Go back",
                            buttonColor: CustomColors.dividerGreyColor,
                            textColor: CustomColors.backTextColor,
                            fontSize: 13.sp,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        horizontalSpacer(10.w),
                        Expanded(
                          child: CustomButton(
                            title: "Yes, Exit page",
                            buttonColor: CustomColors.redExitColor,
                            onTap: () {
                              // var result = {
                              //   'context': context,
                              // };

                              // Global.onClose == null
                              //     ? null
                              //     : Global.onClose!(result);

                              Navigator.pop(context);
                              onOkPressed?.call();
                            },
                            // () {
                            //   // var result = {
                            //   //   'context': context,
                            //   // };

                            //   // Global.onClose == null
                            //   //     ? null
                            //   //     : Global.onClose!(result);

                            //   Navigator.pop(context);
                            //   onOkPressed?.call();
                            // },
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    verticalSpacer(10)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showSelectImageDialog(
      {required BuildContext context,
      String? title,
      bool showTitle = true,
      String content = "",
      Widget? customIcon,
      Widget? contentBody,
      TextAlign? textAlign,
      String? okText,
      Function()? onCameraPressed,
      Function()? onGalleryPressed,
      Color? footerColor}) async {
    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(25.r),
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColors.whiteColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 70.h),
                      child: Row(
                        children: [
                          ImageOptionContainer(
                            icon: ConstantString.cameraIcon,
                            title: "Camera",
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              await onCameraPressed?.call();
                            },
                          ),
                          const Spacer(),
                          ImageOptionContainer(
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              await onGalleryPressed?.call();
                            },
                            icon: ConstantString.galleryIcon,
                            title: "Gallery",
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(10)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showSelectImageDialog2({
    required BuildContext context,
    String? title,
    bool showTitle = true,
    String content = "",
    Widget? customIcon,
    Widget? contentBody,
    TextAlign? textAlign,
    String? okText,
    Future<void> Function()? onCameraPressed,
    Future<void> Function()? onGalleryPressed,
    Color? footerColor,
  }) async {
    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(25.r),
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColors.whiteColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 70.h),
                      child: Row(
                        children: [
                          ImageOptionContainer(
                            icon: ConstantString.cameraIcon,
                            title: "Camera",
                            onTap: () async {
                              if (onCameraPressed != null) {
                                await onCameraPressed();
                              }
                              if (context.mounted) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            },
                          ),
                          const Spacer(),
                          ImageOptionContainer(
                            icon: ConstantString.galleryIcon,
                            title: "Gallery",
                            onTap: () async {
                              if (onGalleryPressed != null) {
                                await onGalleryPressed();
                              }
                              if (context.mounted) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> previewImageDialog({
    required BuildContext context,
    required File selectedImage,
    String? title,
    Function()? onOkPressed,
    Function()? onNoPressed,
  }) async {
    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: CustomColors.whiteColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10.0, left: 10, top: 10, bottom: 20),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.file(
                        selectedImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    verticalSpacer(25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            ConstantString.bulbIcon,
                            height: 30,
                            package: 'mca_official_flutter_sdk',
                          ),
                          horizontalSpacer(5.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Tips:  ",
                                    style: CustomTextStyles.semiBold(
                                      fontSize: 14.sp,
                                      color: CustomColors.blackTextColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "Take in good lighting and ensure that the subject is well-framed",
                                    style: CustomTextStyles.regular(
                                      fontSize: 13.sp,
                                      color: CustomColors.blackTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomButton(
                              title: "Cancel",
                              buttonColor: CustomColors.dividerGreyColor,
                              textColor: CustomColors.backTextColor,
                              fontSize: 14.sp,
                              onTap: onNoPressed ??
                                  () {
                                    Navigator.pop(context);
                                  },
                            ),
                          ),
                          horizontalSpacer(10.w),
                          Expanded(
                            flex: 2,
                            child: CustomButton(
                              title: "Submit",
                              onTap: onOkPressed ??
                                  () {
                                    Navigator.pop(context);
                                  },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> permissionRequestDialog({
    required BuildContext context,
    String? title,
    required bool isLoading,
    Function()? onOkPressed,
    Function()? onNoPressed,
  }) async {
    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Container(
                  // height:  MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: CustomColors.whiteColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 10.0, left: 10, top: 10, bottom: 20),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 450, // max height constraint
                        ),
                        child: Material(
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Expanded(
                              //   child: Image.file(
                              //     selectedImage,
                              //     fit: BoxFit.fill,
                              //   ),
                              // ),
                              verticalSpacer(25),
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomColors.lightPrimaryBrandColor(),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      ConstantString.permissionRequestIcon,
                                      height: 30,
                                      // ignore: deprecated_member_use
                                      color: CustomColors.primaryBrandColor(),
                                      package: 'mca_official_flutter_sdk',
                                    ),
                                  ),
                                ),
                              ),
                              verticalSpacer(15),
                              semiBoldText(
                                "Permission Request",
                                fontSize: 21,
                                color: CustomColors.primaryBrandColor(),
                              ),
                              verticalSpacer(15),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: regularText(
                                  "This feature needs some permission to carry out this inspection.",
                                  color: CustomColors.tipTextColor,
                                  fontSize: 16,
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              verticalSpacer(25),

                              const Divider(
                                color: CustomColors.lightDividerGreyColor,
                                thickness: 0.8,
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: mediumText(
                                  "Device Camera",
                                  color: CustomColors.blueTextColor,
                                  fontSize: 17,
                                ),
                              ),

                              const Divider(
                                color: CustomColors.lightDividerGreyColor,
                                thickness: 0.8,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: mediumText(
                                  "Device Location",
                                  color: CustomColors.blueTextColor,
                                  fontSize: 17,
                                ),
                              ),

                              const Divider(
                                color: CustomColors.lightDividerGreyColor,
                                thickness: 0.8,
                              ),

                              verticalSpacer(35),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        title: "Deny",
                                        buttonColor:
                                            CustomColors.dividerGreyColor,
                                        textColor: CustomColors.backTextColor,
                                        fontSize: 14.sp,
                                        onTap: onNoPressed ??
                                            () {
                                              Navigator.pop(context);
                                            },
                                      ),
                                    ),
                                    horizontalSpacer(10.w),
                                    Expanded(
                                      child: CustomButton(
                                          isLoading: isLoading,
                                          title: "Allow",
                                          onTap: () {
                                            Navigator.of(
                                              context,
                                            ).pop();
                                            onOkPressed?.call();
                                          }
                                          // onOkPressed ??
                                          //     () {
                                          //       Navigator.pop(context);
                                          //     },
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> locationDisabledDialog({
    required BuildContext context,
    required bool isLoading,
    Function()? onOkPressed,
    Function()? onNoPressed,
  }) async {
    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Container(
              // height:  MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: CustomColors.whiteColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10.0, left: 10, top: 10, bottom: 20),
                child: LayoutBuilder(builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 400, // max height constraint
                    ),
                    child: Material(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Expanded(
                          //   child: Image.file(
                          //     selectedImage,
                          //     fit: BoxFit.fill,
                          //   ),
                          // ),
                          verticalSpacer(25),
                          Container(
                            decoration: BoxDecoration(
                              color: CustomColors.disabledOrangeColor
                                  .withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SvgPicture.asset(
                                  ConstantString.locationDisabledIcon,
                                  height: 30,
                                  package: 'mca_official_flutter_sdk',
                                ),
                              ),
                            ),
                          ),
                          verticalSpacer(25),
                          semiBoldText(
                            "Location Disabled",
                            fontSize: 21,
                            color: CustomColors.orangeColor,
                          ),
                          verticalSpacer(25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: regularText(
                              "It seems like your device's location is currently disabled, and in order to proceed with this process, we require your location. Please ensure that your device's location is turned on.",
                              color: CustomColors.tipTextColor,
                              fontSize: 16,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          verticalSpacer(25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    title: "Ok, Turn on Location",
                                    onTap: () {
                                      Navigator.pop(context);
                                      onOkPressed?.call();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> timeUpDialog({
    required BuildContext context,
    Function()? onOkPressed,
    Function()? onNoPressed,
  }) async {
    return showDialog<void>(
      barrierColor: CustomColors.blackColor.withOpacity(0.75),
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Container(
              // height:  MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: CustomColors.whiteColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10.0, left: 10, top: 10, bottom: 10),
                child: LayoutBuilder(builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxHeight: 300, // max height constraint
                        maxWidth: 400),
                    child: Material(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Expanded(
                          //   child: Image.file(
                          //     selectedImage,
                          //     fit: BoxFit.fill,
                          //   ),
                          // ),
                          // verticalSpacer(5),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color:
                          //         CustomColors.redTimeUpColor.withOpacity(0.3),
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Center(
                          //       child: SvgPicture.asset(
                          //         ConstantString.timerIcon,
                          //         height: 30,
                          //         package: 'mca_official_flutter_sdk',
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          verticalSpacer(10),
                          Image.asset(
                            ConstantString.timeUp,
                            height: 35,
                            package: 'mca_official_flutter_sdk',
                          ),

                          verticalSpacer(25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: regularText(
                              "You have exceeded the time allocated to complete this inspection, you may need to go back to re-conduct this inspection",
                              color: CustomColors.tipTextColor,
                              fontSize: 16,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          verticalSpacer(30),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    title: "Re-conduct inspection",
                                    onTap: onOkPressed ??
                                        () {
                                          Navigator.pop(context);
                                        },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ImageOptionContainer extends StatelessWidget {
  const ImageOptionContainer({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  final String title, icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border:
                  Border.all(color: CustomColors.blackColor.withOpacity(0.12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!, // Darker shadow
                  offset: const Offset(4, 4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Colors.white, // Lighter shadow
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                package: 'mca_official_flutter_sdk',
              ),
            ),
          ),
          verticalSpacer(20.h),
          mediumText(
            title,
            fontSize: 15.sp,
          ),
        ],
      ),
    );
  }
}
