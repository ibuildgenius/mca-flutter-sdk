// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/data/api/generic_response.dart';
import 'package:mca_official_flutter_sdk/src/data/view_model/base_change_notifier.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/damaged_area_parts.dart';
import 'package:mca_official_flutter_sdk/src/models/inspection_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/gadget/gadget_inspection_summary.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_success_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/vehicle/vehicle_inspection_summary.dart';
import 'package:video_compress/video_compress.dart';

final inspectionVmProvider =
    ChangeNotifierProvider.autoDispose<InspectionViewModel>((ref) {
  return InspectionViewModel.initWhoAmI();
});

class InspectionViewModel extends BaseChangeNotifier {
  bool _isloading;
  bool _isImageUploading;

  InspectionViewModel.initWhoAmI()
      : _isloading = false,
        _isImageUploading = false;

  InspectionViewModel.profile()
      : _isloading = false,
        _isImageUploading = false;

  bool get isLoading => _isloading;

  bool get isImageUploading => _isImageUploading;

  set isLoading(bool isloading) {
    _isloading = isloading;
    notifyListeners();
  }

  set isImageUploading(bool isImageUploading) {
    _isImageUploading = isImageUploading;
    notifyListeners();
  }

  Future<String?> uploadFile({
    required String name,
    required File file,
    required WidgetRef ref,
    required BuildContext context,
    String? fileType,
  }) async {
    try {
      isImageUploading = true;
      final res =
          await formRepository.uploadFile(file: file, fileType: fileType);

      if (res.responseCode == 1) {
        isImageUploading = false;
        return res.data["file_url"];
      } else {
        isImageUploading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      isImageUploading = false;
      log(e.toString());
      CustomToast.showErrorMessage(
          context, "Request Failed, Please try again later");
    }
    return null;
  }

  Future<void> uploadVideo({
    required WidgetRef ref,
    required BuildContext context,
    required File videoFile,
  }) async {
    // Set loading state at the very beginning
    isLoading = true;
    ref.read(showProgressProvider.notifier).state = true;
    log('before compression');
    try {
      File compressedVideo;
      try {
        await VideoCompress.setLogLevel(0);
        final MediaInfo? video = await VideoCompress.compressVideo(
          videoFile.path,
          quality: VideoQuality.LowQuality,
          deleteOrigin: false,
          includeAudio: false,
        );

        if (video == null || video.path == null) {
          throw Exception("Video compression failed.");
        }
        compressedVideo = File(video.path!);
      } catch (e) {
        log("Video compression error: $e");
        CustomToast.showErrorMessage(
            context, "Video compression failed. Please try again.");
        return; // Exit on compression failure
      }

      // Step 2: Video Upload
      String? videoUrl = await uploadFile(
        name: "inspection",
        file: compressedVideo,
        ref: ref,
        context: context,
        fileType: 'video',
      );

      // Check if upload was successful. The `uploadFile` method is
      // assumed to handle its own retries internally.
      if (videoUrl == null) {
        CustomToast.showErrorMessage(
            context, "Video upload failed. Please try again.");
        return; // Exit on upload failure
      }
      log('submit insoection');
      // Step 3: Submit Inspection Data to Backend
      final res = Global.transactionType == TransactionType.claim
          ? await claimRepository.submitAutoClaimInspection(
              vehicleImages: ref.watch(vehicleImageProvider),
              videoUrl: videoUrl,
              address: Global.inspectionAddress,
              longitude: Global.inspectionLongitude,
              latitude: Global.inspectionLatitude,
              policyId: Global.policyId,
              claimId: Global.claimId,
              inspectionType: InspectionType.vehicle.toString().split('.')[1],
              timeStamp: DateTime.now().toString(),
            )
          : await inspectionRepository.submitAutoInspection(
              vehicleImages: ref.watch(vehicleImageProvider),
              videoUrl: videoUrl,
              address: Global.inspectionAddress,
              longitude: Global.inspectionLongitude,
              latitude: Global.inspectionLatitude,
              policyId: Global.policyId,
              inspectionType: InspectionType.vehicle.toString().split('.')[1],
              timeStamp: DateTime.now().toString(),
            );

      if (res.responseCode == 1) {
        ref.read(progressProvider.notifier).state = 0.0;
        final policy = InspectionModel.fromJson(res.data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InspectionSuccessScreenScreen(inspection: policy),
          ),
        );
      } else {
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
    } catch (e, stack) {
      // This catch block handles any other unexpected errors
      log("Unexpected error during video process: $e\n$stack");
      CustomToast.showErrorMessage(context, "An unexpected error occurred: $e");
    } finally {
      // Always reset loading states when the function is complete,
      // whether it succeeds or fails.
      isLoading = false;
      ref.read(showProgressProvider.notifier).state = false;
    }
  }

  Future<GenericResponse<dynamic>> uploadWithRetry(
      File file, int maxRetries) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      final res = await formRepository.uploadFile(file: file);
      if (res.responseCode == 1) {
        return res;
      }
      attempts++;
    }
    throw Exception('Failed to upload file after $maxRetries attempts');
  }

  Future<void> uploadGadgetVideo({
    required WidgetRef ref,
    required BuildContext context,
    required File videoFile,
  }) async {
    const int maxRetries = 3;
    try {
      isLoading = true;
      // await compressVideo(videoFile.path);
      await VideoCompress.setLogLevel(0);
      ref.read(showProgressProvider.notifier).state = true;

      final MediaInfo? video = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
        includeAudio: false,
      );

      File compressedVideo =
          video == null ? videoFile : File(video.path.toString());

      String? videoUrl = await uploadFile(
        name: "inspection",
        file: compressedVideo,
        ref: ref,
        context: context,
        fileType: 'video',
      );
      ref.read(showProgressProvider.notifier).state = false;

      // Run all uploads in parallel with retry logic
      final results = await Future.wait([
        uploadWithRetry(ref.watch(gadgetImageProvider)['front']!, maxRetries),
        uploadWithRetry(ref.watch(gadgetImageProvider)['back']!, maxRetries),
        uploadWithRetry(ref.watch(gadgetImageProvider)['side']!, maxRetries),
        uploadWithRetry(
            ref.watch(gadgetImageProvider)['settings']!, maxRetries),
      ]);

      final resOne = results[0];
      final resTwo = results[1];
      final resThree = results[2];
      final resFour = results[3];

      final res = Global.transactionType == TransactionType.claim
          ? await claimRepository.submitDeviceClaimInspection(
              deviceImages: ref.watch(gadgetImageProvider),
              videoUrl: videoUrl ?? "",
              address: Global.inspectionAddress,
              longitude: Global.inspectionLongitude,
              latitude: Global.inspectionLatitude,
              policyId: Global.policyId,
              claimId: Global.claimId,
              inspectionType: InspectionType.gadget.toString().split('.')[1],
              timeStamp: DateTime.now().toString(),
              frontImage: resOne.data["file_url"],
              backImage: resTwo.data["file_url"],
              sideImage: resThree.data["file_url"],
              serialNumberImage: resFour.data["file_url"],
            )
          : await inspectionRepository.submitGadgetInspection(
              videoUrl: videoUrl ?? "",
              address: Global.inspectionAddress,
              longitude: Global.inspectionLongitude,
              latitude: Global.inspectionLatitude,
              policyId: Global.policyId,
              inspectionType: InspectionType.gadget.toString().split('.')[1],
              timeStamp: DateTime.now().toString(),
              frontImage: resOne.data["file_url"],
              backImage: resTwo.data["file_url"],
              sideImage: resThree.data["file_url"],
              serialNumberImage: resFour.data["file_url"],
            );

      if (res.responseCode == 1) {
        ref.read(progressProvider.notifier).state = 0.0;
        InspectionModel policy = InspectionModel.fromJson(
          res.data,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    InspectionSuccessScreenScreen(inspection: policy)));
        isLoading = false;
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      // submitInspection(context);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      isLoading = false;
      log(e.toString());
      CustomToast.showErrorMessage(context, e.toString());
    }
  }

  Future<bool> submitInspection({
    required WidgetRef ref,
    required BuildContext context,
    required File file,
    required String vehicleSection,
    String? claimId,
    String? policyId,
  }) async {
    try {
      isLoading = true;
      final res = await inspectionRepository.verifyImageAI(
        file: file,
        action: 'inspection',
        vehicleSection: vehicleSection,
        policyId: Global.policyId, //"4a8cdaff-464b-4b45-86f8-ef3640fa741a",
        // bypass: ref.watch(retryCountProvider) > 1 ? true : false,
        // bypass: true,
      );
      if (res.data != null) {
        var data = res.data;

        if (data.containsKey('is_valid_image') &&
            data['is_valid_image'] == true &&
            data.containsKey('image_url') &&
            data['image_url'].isNotEmpty) {
          isLoading = false;
          ref.read(vehicleImageUrlProvider.notifier).state[vehicleSection] =
              data['image_url'];
          ref.read(vehicleImageProvider.notifier).state[vehicleSection] = file;
          ref.read(retryCountProvider.notifier).state = 0;
          return true;
        } else {
          ref.read(retryCountProvider.notifier).state++;
          isLoading = false;
          return false;
        }
      } else {
        ref.read(retryCountProvider.notifier).state++;
        isLoading = false;
        return false;
      }
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      return false;
    }
  }

  Future<bool> verifyInspectionImageAI({
    required WidgetRef ref,
    required BuildContext context,
    required File file,
    required String vehicleSection,
    String? claimId,
    String? policyId,
  }) async {
    const int maxAttempts = 5;
    int attempt = 0;

    while (attempt < maxAttempts) {
      isLoading = true;
      attempt++;
      ref.read(retryCountProvider.notifier).state = attempt;

      try {
        final res = await inspectionRepository.verifyImageAI(
          file: file,
          action: 'inspection',
          vehicleSection: vehicleSection,
          policyId: policyId,
          bypass: attempt > 1,
          // bypass after first failure
          claimId: claimId,
        );

        final data = res.data;
        final isValidImage = data is Map &&
            data['is_valid_image'] == true &&
            data['image_url'] is String &&
            (data['image_url'] as String).isNotEmpty;

        if (isValidImage) {
          final imageUrl = (data['image_url'] as String);

          // ✅ success
          ref.read(vehicleImageUrlProvider.notifier).state[vehicleSection] =
              imageUrl;
          ref.read(vehicleImageProvider.notifier).state[vehicleSection] = file;
          ref.read(retryCountProvider.notifier).state = 0; // reset retries
          return true;
        }

        // ❌ failed this attempt; try again if we have attempts left
        if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 1)); // simple backoff
          continue;
        }
        return false;
      } catch (e, st) {
        // Non-retryable or unexpected error; surface and stop
        log('verifyInspectionImageAI error: $e');
        log(st.toString());
        CustomToast.showErrorMessage(context, e.toString());
        return false;
      } finally {
        isLoading = false; // always clear per attempt
      }
    }

    return false; // failsafe
  }

  Future<void> updatePreCaptureToCaptureStep(WidgetRef ref) async {
    var currentStep = ref.watch(verificationStepProvider);
    print(currentStep);
    if (currentStep == CarVerificationStep.frontSidePreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.frontSideCapture;
    } else if (currentStep == CarVerificationStep.chasisNumberPreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.chasisNumberCapture;
    } else if (currentStep == CarVerificationStep.leftSidePreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.leftSideCapture;
    } else if (currentStep == CarVerificationStep.backSidePreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.backSideCapture;
    } else if (currentStep == CarVerificationStep.rightSidePreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.rightSideCapture;
    } else if (currentStep == CarVerificationStep.dashboardPreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.dashboardCapture;
    } else if (currentStep == CarVerificationStep.interiorPreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.interiorCapture;
    } else if (currentStep == CarVerificationStep.interiorPreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.interiorCapture;
    } else if (currentStep == CarVerificationStep.interiorPreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.interiorCapture;
    } else if (currentStep == CarVerificationStep.interiorPreCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.interiorCapture;
    }
  }

  Future<void> updateCaptureToVerifyStep(WidgetRef ref) async {
    var currentStep = ref.watch(verificationStepProvider);
    print(currentStep);

    if (currentStep == CarVerificationStep.frontSideCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.frontSideVerify;
    } else if (currentStep == CarVerificationStep.chasisNumberCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.chasisNumberVerify;
    } else if (currentStep == CarVerificationStep.leftSideCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.leftSideVerify;
    } else if (currentStep == CarVerificationStep.backSideCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.backSideVerify;
    } else if (currentStep == CarVerificationStep.rightSideCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.rightSideVerify;
    } else if (currentStep == CarVerificationStep.dashboardCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.dashboardVerify;
    } else if (currentStep == CarVerificationStep.interiorCapture) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.interiorVerify;
    }
  }

  Future<void> updateVerifyToCaptureToStep(WidgetRef ref) async {
    var currentStep = ref.watch(verificationStepProvider);

    // var currentStep = ref.watch(verificationStepProvider);
    if (currentStep == CarVerificationStep.frontSideVerify ||
        currentStep == CarVerificationStep.frontSideFailed) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.frontSideCapture;
    } else if (currentStep == CarVerificationStep.chasisNumberVerify ||
        currentStep == CarVerificationStep.chasisNumberFailed) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.chasisNumberCapture;
    } else if (currentStep == CarVerificationStep.leftSideVerify ||
        currentStep == CarVerificationStep.leftSideFailed) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.leftSideCapture;
    } else if (currentStep == CarVerificationStep.backSideVerify ||
        currentStep == CarVerificationStep.backSideFailed) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.backSideCapture;
    } else if (currentStep == CarVerificationStep.rightSideVerify ||
        currentStep == CarVerificationStep.rightSideFailed) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.rightSideCapture;
    } else if (currentStep == CarVerificationStep.dashboardVerify ||
        currentStep == CarVerificationStep.dashboardFailed) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.dashboardCapture;
    } else if (currentStep == CarVerificationStep.interiorVerify ||
        currentStep == CarVerificationStep.interiorFailed) {
      ref.read(verificationStepProvider.notifier).state =
          CarVerificationStep.interiorCapture;
    }
  }

  Future<bool> verifyClaimImageAI({
    required WidgetRef ref,
    required BuildContext context,
    required File file,
    required String vehicleSection,
    String? claimId,
    String? policyId,
  }) async {
    const maxAttempts = 5;
    int attempt = 0;

    while (attempt < maxAttempts) {
      isLoading = true;
      attempt++;
      ref.read(retryCountProvider.notifier).state = attempt;

      try {
        final res = await claimRepository.verifyClaimImageAI(
          file: file,
          action: 'claim',
          vehicleSection: vehicleSection,
          policyId: policyId,
          bypass: attempt > 1,
          // bypass after first failure
          claimId: claimId,
        );

        final data = res.data;
        final isValidImage = data is Map &&
            data['is_valid_image'] == true &&
            data['image_url'] is String &&
            (data['image_url'] as String).isNotEmpty;

        if (isValidImage) {
          final imageUrl = (data['image_url'] as String);

          // ✅ success
          ref.read(vehicleImageUrlProvider.notifier).state[vehicleSection] =
              imageUrl;
          ref.read(vehicleImageProvider.notifier).state[vehicleSection] = file;
          ref.read(retryCountProvider.notifier).state = 0; // reset retries
          return true;
        }

        // ❌ failed this attempt
        if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 1)); // backoff
          continue;
        }
        return false;
      } catch (e, stacktrace) {
        log(e.toString());
        log(stacktrace.toString());
        CustomToast.showErrorMessage(context, e.toString());
        return false; // non-retryable (or you can choose to retry on specific errors)
      } finally {
        isLoading = false; // always clear even on early return/throw
      }
    }

    return false; // failsafe
  }

  void updateDamagedPartStep({required WidgetRef ref, required String area}) {
    // var currentStep = ref.watch(verificationStepProvider);
    switch (area) {
      case 'Front':
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.frontSidePreCapture;
      case 'Left':
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.leftSidePreCapture;
      case 'Right':
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.rightSidePreCapture;
      case 'Back':
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.backSidePreCapture;
      case 'Interior':
      case 'Roof':
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.interiorPreCapture;
      // case 'Roof':
      //   ref.read(verificationStepProvider.notifier).state =
      //       CarVerificationStep.roofPrecaputer;

      // default:
      //   ref.read(verificationStepProvider.notifier).state =
      //       CarVerificationStep.;
    }
  }

  Future<void> updateVerificationStep(
      {required WidgetRef ref,
      required BuildContext context,
      required File file,
      // Future<XFile?>? stopVideo,
      final Future<XFile?>? Function()? stopVideo,
      XFile? videoFile}) async {
    var currentStep = ref.watch(verificationStepProvider);

    ref.read(verificationStepProvider.notifier).state =
        CarVerificationStep.verificationLoading;

    bool status = Global.transactionType == TransactionType.claim
        ? await verifyClaimImageAI(
            ref: ref,
            context: context,
            file: file,
            vehicleSection: getEndpointName(currentStep),
            policyId: Global.policyId,
            claimId: Global.claimId,
          )
        : await verifyInspectionImageAI(
            ref: ref,
            context: context,
            file: file,
            vehicleSection: getEndpointName(currentStep),
            policyId: Global.policyId,
            claimId: Global.claimId,
          );
    if (status == true) {
      if (currentStep == CarVerificationStep.frontSideVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.chasisNumberPreCapture;
        ref.read(verifiedCountProvider.notifier).state = 1;
      } else if (currentStep == CarVerificationStep.chasisNumberVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.leftSidePreCapture;
        ref.read(verifiedCountProvider.notifier).state = 2;
      } else if (currentStep == CarVerificationStep.leftSideVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.backSidePreCapture;
        ref.read(verifiedCountProvider.notifier).state = 3;
      } else if (currentStep == CarVerificationStep.backSideVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.rightSidePreCapture;

        ref.read(verifiedCountProvider.notifier).state = 4;
      } else if (currentStep == CarVerificationStep.rightSideVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.dashboardPreCapture;
        ref.read(verifiedCountProvider.notifier).state = 5;
      } else if (currentStep == CarVerificationStep.dashboardVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.interiorPreCapture;
        ref.read(verifiedCountProvider.notifier).state = 6;
      } else if (currentStep == CarVerificationStep.interiorVerify) {
        final videoFile = stopVideo == null ? null : await stopVideo();
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.verificationCompleted;
        ref.read(verifiedCountProvider.notifier).state = 7;
        if (videoFile != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VeicleInspectionSummaryScreen(
                        videoFile: videoFile,
                      )));
        }
      }
    } else {
      if (currentStep == CarVerificationStep.frontSideVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.frontSideFailed;
      } else if (currentStep == CarVerificationStep.chasisNumberVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.chasisNumberFailed;
      } else if (currentStep == CarVerificationStep.leftSideVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.leftSideFailed;
      } else if (currentStep == CarVerificationStep.backSideVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.backSideFailed;
      } else if (currentStep == CarVerificationStep.rightSideVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.rightSideFailed;
      } else if (currentStep == CarVerificationStep.dashboardVerify) {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.dashboardFailed;
      } else {
        ref.read(verificationStepProvider.notifier).state =
            CarVerificationStep.interiorFailed;
      }
    }
  }

  //GADGET

  Future<void> updateGadgetPreCaptureToCaptureStep(WidgetRef ref) async {
    var currentStep = ref.watch(phoneVerificationStepProvider);
    if (currentStep == PhoneVerificationStep.phoneFrontPreCapture) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneFrontCapture;
    } else if (currentStep == PhoneVerificationStep.phoneBackPreCapture) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneBackCapture;
    } else if (currentStep == PhoneVerificationStep.phoneSettingsPreCapture) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneSettingsCapture;
    } else if (currentStep == PhoneVerificationStep.phoneSidePreCapture) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneSideCapture;
    }
  }

  Future<void> updateGadgetCaptureToVerifyStep(WidgetRef ref) async {
    var currentStep = ref.watch(phoneVerificationStepProvider);

    if (currentStep == PhoneVerificationStep.phoneFrontCapture) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneFrontVerify;
    } else if (currentStep == PhoneVerificationStep.phoneBackCapture) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneBackVerify;
    } else if (currentStep == PhoneVerificationStep.phoneSettingsCapture) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneSettingsVerify;
    } else if (currentStep == PhoneVerificationStep.phoneSideCapture) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneSideVerify;
    }
  }

  Future<void> updateGadgetVerificationStep(
      {required WidgetRef ref,
      required BuildContext context,
      required File file,
      // Future<XFile?>? stopVideo,
      final Future<XFile?>? Function()? stopVideo,
      XFile? videoFile}) async {
    var currentStep = ref.watch(phoneVerificationStepProvider);

    ref.read(gadgetImageProvider.notifier).state[getEndpointName(currentStep)] =
        file;

    if (currentStep == PhoneVerificationStep.phoneFrontVerify) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneBackPreCapture;
      ref.read(verifiedCountProvider.notifier).state = 1;
    } else if (currentStep == PhoneVerificationStep.phoneBackVerify) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneSettingsPreCapture;
      ref.read(verifiedCountProvider.notifier).state = 2;
    } else if (currentStep == PhoneVerificationStep.phoneSettingsVerify) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneSidePreCapture;
      ref.read(verifiedCountProvider.notifier).state = 3;
    } else if (currentStep == PhoneVerificationStep.phoneSideVerify) {
      // ref.read(phoneVerificationStepProvider.notifier).state =
      final videoFile = stopVideo == null ? null : await stopVideo();

      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.verificationCompleted;
      ref.read(verifiedCountProvider.notifier).state = 4;
      if (videoFile != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GadgetInspectionSummaryScreen(
                      videoFile: videoFile,
                    )));
      }
    }
  }

  Future<void> updateGadgetVerifyToCaptureToStep(WidgetRef ref) async {
    var currentStep = ref.watch(phoneVerificationStepProvider);

    if (currentStep == PhoneVerificationStep.phoneFrontVerify) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneFrontCapture;
    } else if (currentStep == PhoneVerificationStep.phoneBackVerify) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneBackCapture;
    } else if (currentStep == PhoneVerificationStep.phoneSettingsVerify) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneSettingsCapture;
    } else if (currentStep == PhoneVerificationStep.phoneSideVerify) {
      ref.read(phoneVerificationStepProvider.notifier).state =
          PhoneVerificationStep.phoneSideCapture;
    }
  }
}

final verificationStepProvider = StateProvider<CarVerificationStep>(
    (ref) => CarVerificationStep.frontSidePreCapture);

final phoneVerificationStepProvider = StateProvider<PhoneVerificationStep>(
    (ref) => PhoneVerificationStep.phoneFrontPreCapture);

final verifiedCountProvider = StateProvider<int>((ref) => 0);
final retryCountProvider = StateProvider<int>((ref) => 0);

final selectedImageFileProvider = StateProvider<File?>((ref) => null);

final animationControllerProvider =
    StateProvider<AnimationController?>((ref) => null);

final vehicleImageUrlProvider = StateProvider<Map<String, String>>((ref) => {});

final vehicleImageProvider = StateProvider<Map<String, File>>((ref) => {});

final gadgetImageProvider = StateProvider<Map<String, File>>((ref) => {});
final vehicleDamagesProvider = StateProvider<List<Damage>>((ref) => []);
