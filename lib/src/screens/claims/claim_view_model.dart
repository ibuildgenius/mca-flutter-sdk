import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/data/api/generic_response.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/form_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/view_model/base_change_notifier.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/dialogs.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/bank_account_model.dart';
import 'package:mca_official_flutter_sdk/src/models/bank_model.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/models/damaged_area_parts.dart';
import 'package:mca_official_flutter_sdk/src/models/product_details_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/additional_info_submited_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/claim_submitted_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/confirm_policy_info_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/track_claims_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/upload_third_party_document_screen.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/sdk_error_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';

final claimVmProvider =
    ChangeNotifierProvider.autoDispose<ClaimViewModel>((ref) {
  return ClaimViewModel.initWhoAmI();
});

class ClaimViewModel extends BaseChangeNotifier {
  bool _isloading;
  bool _isloadingBanks;
  bool _isNameLoading;
  bool _isImageUploading;

  ClaimViewModel.initWhoAmI()
      : _isloading = false,
        _isNameLoading = false,
        _isloadingBanks = false,
        _isImageUploading = false;

  ClaimViewModel.profile()
      : _isloading = false,
        _isloadingBanks = false,
        _isNameLoading = false,
        _isImageUploading = false;

  bool get isLoading => _isloading;
  bool get isLoadingBanks => _isloadingBanks;
  bool get isNameLoading => _isNameLoading;

  bool get isImageUploading => _isImageUploading;

  set isLoading(bool isloading) {
    _isloading = isloading;
    notifyListeners();
  }

  set isLoadingBanks(bool isloadinBanks) {
    _isloadingBanks = isLoadingBanks;
    notifyListeners();
  }

  set isNameLoading(bool isNameLoading) {
    _isNameLoading = isNameLoading;
    notifyListeners();
  }

  set isImageUploading(bool isImageUploading) {
    _isImageUploading = isImageUploading;
    notifyListeners();
  }

  Future<void> navigateToTrackClaimInfo({
    required WidgetRef ref,
    required BuildContext context,
    required String claimId,
    required String email,
  }) async {
    try {
      isLoading = true;
      final res = await claimRepository.getClaimsInfo(email, claimId);
      if (res.responseCode == 1) {
        // final List<dynamic> list = (res.data['claims'] as List<dynamic>? ?? []);

        // final claims = list
        //     .map((e) => ClaimModel.fromJson(e as Map<String, dynamic>))
        //     .toList();
        ClaimModel claims = ClaimModel.fromJson(res.data);

        isLoading = false;
        // log('my own claims ${claims[0].policy?.meta['vehicle_make']}');

        String? claimType = claims.claimType;
        // print(
        // 'kkkkk ${getProductCategoryFromString(claimType ?? "")} ${claimType} ');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackClaimsScreen(
                      claim: claims,
                      productCategory:
                          getProductCategoryFromString(claimType ?? ""),
                    )));
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<void> navigateToTrackClaims({
    required WidgetRef ref,
    required BuildContext context,
    required String policyId,
  }) async {
    try {
      isLoading = true;
      final res = await claimRepository.getClaimsById(
        policyId,
      );

      if (res.responseCode == 1) {
        final List<dynamic> list = (res.data['claims'] as List<dynamic>? ?? []);

        final claims = list
            .map((e) => ClaimModel.fromJson(e as Map<String, dynamic>))
            .toList();
        // ClaimModel claims = ClaimModel.fromJson(res.data);

        isLoading = false;
        log('my own claims ${claims[0].policy?.meta['vehicle_make']}');

        String? claimType = claims[0].claimType;
        print(
            'kkkkk ${getProductCategoryFromString(claimType ?? "")} $claimType ');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TrackClaimsScreen(
                      claim: claims[0],
                      productCategory:
                          getProductCategoryFromString(claimType ?? ""),
                    )));
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<void> navigateToUploadDocument({
    required WidgetRef ref,
    required BuildContext context,
    required String claimId,
    required String email,
  }) async {
    try {
      isLoading = true;
      final res = await claimRepository.getClaimsInfo(email, claimId);

      if (res.responseCode == 1) {
        // final List<dynamic> list = (res.data['claims'] as List<dynamic>? ?? []);

        // final claims = list
        //     .map((e) => ClaimModel.fromJson(e as Map<String, dynamic>))
        //     .toList();
        ClaimModel claims = ClaimModel.fromJson(res.data);

        isLoading = false;

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UploadThirdPartyDocumentScreen(
                      claim: claims,
                    )));
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<List<DamagedAreaPart>> getDamagedParts(
      {required WidgetRef ref}) async {
    try {
      isLoading = true;

      final res = await claimRepository.getDamagedParts();
      final code = (res.responseCode as int?) ?? 0;
      if (code != 1) {
        throw StateError(res.message.toString() ?? 'Failed to load parts');
      }

      final rawData = res.data;
      final list = rawData is List ? rawData : (rawData?['data'] as List?);

      if (list == null) return const <DamagedAreaPart>[];

      final result = list
          .whereType<Map>() // keep only maps
          .map((e) => DamagedAreaPart.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false);

      ref.read(damagedPartsProvider.notifier).state = result;
      return result;
    } catch (e, st) {
      log('getDamagedParts error: $e');
      log(st.toString());
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> getClaimsById({
    required WidgetRef ref,
    required BuildContext context,
    required String email,
    required String policyNumber,
  }) async {
    try {
      isLoading = true;

      final res = await claimRepository.getClaimsById(Global.policyId);
      final policyRes =
          await claimRepository.getPolicyInfo(email, policyNumber);

      if (!context.mounted) return; // <-- FIRST PROTECTION

      final policy = PolicyModel.fromJson(policyRes.data);

      final productRes = await productRepository.getProductDetailsById(
        productId: policy.productId ?? "",
      );
      final productDetails =
          ProductDetailsModel.fromJson(productRes.data['products'][0]);

      // Not claimable
      if (policy.product?.claimable != true) {
        isLoading = false;
        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SDKErrorScreen(
              error: "Selected product is not claimable, please try again",
            ),
            settings: const RouteSettings(
              arguments: ConstantString.initialScreenKey,
            ),
          ),
        );
        return;
      }

      if (res.responseCode == 1) {
        final claimsJson = res.data['claims'] as List<dynamic>? ?? [];
        final myClaims = claimsJson.map((e) => ClaimModel.fromJson(e)).toList();

        final hasOngoingClaim = myClaims.any(
          (test) => (test.claimStatus ?? '').toLowerCase() != 'paid',
        );

        isLoading = false;
        if (!context.mounted) return;

        // Handle ongoing claim
        if (myClaims.isNotEmpty && hasOngoingClaim) {
          final trackItem = myClaims.firstWhere(
            (test) => (test.claimStatus ?? '').toLowerCase() != 'paid',
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                final claimType = trackItem.claimType;
                return TrackClaimsScreen(
                  claim: trackItem,
                  productCategory:
                      getProductCategoryFromString(claimType ?? ""),
                );
              },
              settings: const RouteSettings(
                arguments: ConstantString.initialScreenKey,
              ),
            ),
          );
        } else {
          // No ongoing claim
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmPolicyInfoScreen(
                policy: policy,
                productDetails: productDetails,
              ),
              settings: const RouteSettings(
                arguments: ConstantString.initialScreenKey,
              ),
            ),
          );
        }
      } else {
        isLoading = false;
        if (!context.mounted) return;

        CustomToast.showErrorMessage(context, res.errors.toString());
      }
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());

      if (!context.mounted) return;

      CustomToast.showErrorMessage(context, "Something went wrong: $e");
    }
  }

  // Future<void> getClaimsById({
  //   required WidgetRef ref,
  //   required BuildContext context,
  //   required String email,
  //   required String policyNumber,
  // }) async {
  //   try {
  //     isLoading = true;
  //
  //     // Fetch claims
  //     final res = await claimRepository.getClaimsById(Global.policyId);
  //     print(Global.productId);
  //
  //     // Fetch policy
  //     final policyRes =
  //         await claimRepository.getPolicyInfo(email, policyNumber);
  //     final policy = PolicyModel.fromJson(policyRes.data);
  //
  //     // Fetch product details
  //     final productRes = await productRepository.getProductDetailsById(
  //       productId: policy.productId ?? "",
  //     );
  //     final productDetails =
  //         ProductDetailsModel.fromJson(productRes.data['products'][0]);
  //
  //     // Check if policy is claimable
  //     if (policy.product?.claimable != true) {
  //       isLoading = false;
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const SDKErrorScreen(
  //             error: "Selected product is not claimable, please try again",
  //           ),
  //           settings: const RouteSettings(
  //             arguments: ConstantString.initialScreenKey,
  //           ),
  //         ),
  //       );
  //       return;
  //     }
  //
  //     // Handle valid response
  //     if (res.responseCode == 1) {
  //       final claimsJson = res.data['claims'] as List<dynamic>? ?? [];
  //       final myClaims = claimsJson.map((e) => ClaimModel.fromJson(e)).toList();
  //
  //       final hasOngoingClaim = myClaims
  //           .any((test) => (test.claimStatus ?? '').toLowerCase() != 'paid');
  //
  //       if (myClaims.isNotEmpty && hasOngoingClaim) {
  //         // Pick the first ongoing claim safely
  //         final trackItem = myClaims.firstWhere(
  //           (test) => (test.claimStatus ?? '').toLowerCase() != 'paid',
  //         );
  //
  //         isLoading = false;
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) {
  //               String? claimType = trackItem.claimType;
  //               return TrackClaimsScreen(
  //                   claim: trackItem,
  //                   productCategory:
  //                       getProductCategoryFromString(claimType ?? ""));
  //             },
  //             settings: const RouteSettings(
  //               arguments: ConstantString.initialScreenKey,
  //             ),
  //           ),
  //         );
  //       } else {
  //         isLoading = false;
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ConfirmPolicyInfoScreen(
  //               policy: policy,
  //               productDetails: productDetails,
  //             ),
  //             settings: const RouteSettings(
  //               arguments: ConstantString.initialScreenKey,
  //             ),
  //           ),
  //         );
  //       }
  //     } else {
  //       isLoading = false;
  //       CustomToast.showErrorMessage(context, res.errors.toString());
  //     }
  //   } catch (e, stacktrace) {
  //     // if (mounted) return;
  //     isLoading = false;
  //     log(e.toString());
  //     log(stacktrace.toString());
  //
  //     CustomToast.showErrorMessage(context, "Something went wrong: $e");
  //   }
  // }

  Future<void> submitAdditionalInfo({
    required WidgetRef ref,
    required BuildContext context,
    required List<AdditionalInfo> additionalInfo,
  }) async {
    isLoading = true;
    try {
      // 1) Upload all files FIRST, in parallel, and replace data with URL
      final List<AdditionalInfo> normalized = await Future.wait(
        additionalInfo.map((info) async {
          final type = info.type?.toLowerCase();

          // If it's a file item and `data` is a File, upload it
          if (type == 'file' && info.data is File) {
            final uploadRes =
                await formRepository.uploadFile(file: info.data as File);

            // Validate upload response
            if (uploadRes.responseCode != 1 ||
                uploadRes.data == null ||
                uploadRes.data['file_url'] == null ||
                (uploadRes.data['file_url'] as String).isEmpty) {
              throw Exception(
                  uploadRes.errors?.toString() ?? 'Failed to upload file');
            }

            final String url = uploadRes.data['file_url'] as String;
            return info.copyWith(data: url);
          }

          // Not a file or already a URL/string, pass through
          return info;
        }),
      );

      // 2) Build payload
      final payload = normalized.map((e) => e.toJson()).toList();

      if (payload.isEmpty) {
        throw Exception('No additional info to submit');
      }

      // 3) Submit to backend
      final res = await claimRepository.uploadAdditionalInfo(
        claimId: Global.claimId,
        payload: payload,
      );

      if (res.responseCode == 1 && res.data?['claim'] != null) {
        final claim = ClaimModel.fromJson(res.data['claim']);

        // Success UI
        isLoading = false;
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdditionalInfoSubmittedScreen(
              claim: claim,
            ),
          ),
        );
      } else {
        throw Exception(
            res.errors?.toString() ?? 'Failed to submit additional info');
      }
    } catch (e, st) {
      isLoading = false;
      log(e.toString());
      log(st.toString());
      CustomToast.showErrorMessage(context, e.toString());
    }
  }

  Future<void> submitVehicleClaim(
      {required WidgetRef ref,
      required BuildContext context,
      required String incidentType,
      required String incidentDate,
      required String incidentTime,
      required List<String> lossType,
      required String incidentLocation,
      required bool isThirdParty,
      required String description,
      required List<String> thirdPartyLossType,
      required String thirdPartyPhoneNumber,
      required String claimType,
      File? policeReport,
      File? selectedDriversLicense,
      List<Damage>? damagePart,
      String? driversLicenseNumber}) async {
    try {
      isLoading = true;

      String? policeReportUrl;
      String? driverLicenseUrl;
      List<Map<String, dynamic>> damages = [];

      if (policeReport != null) {
        final uploadRes = await formRepository.uploadFile(file: policeReport);
        if (uploadRes.responseCode == 1) {
          policeReportUrl = uploadRes.data["file_url"];
        }
      }

      if (selectedDriversLicense != null) {
        final uploadRes =
            await formRepository.uploadFile(file: selectedDriversLicense);

        if (uploadRes.responseCode == 1) {
          driverLicenseUrl = uploadRes.data["file_url"];
        }
      }

      print(lossType);

      damages = await uploadAndSerializeDamages(
          damagePart: damagePart, formRepository: formRepository);

      // if (damagePart?.isNotEmpty ?? false) {
      //   for (Damage i in damagePart ?? []) {
      //     if (i.farRange.isEmpty) {
      //       final uploadRes =
      //           await formRepository.uploadFile(file: i.farRangeFile!);
      //       if (uploadRes.responseCode == 1) {
      //         i.copyWith(farRange: uploadRes.data["file_url"]);
      //       }
      //     }
      //
      //     if (i.closeRange.isEmpty) {
      //       final uploadRes =
      //           await formRepository.uploadFile(file: i.closeRangeFile!);
      //       if (uploadRes.responseCode == 1) {
      //         i.copyWith(closeRange: uploadRes.data["file_url"]);
      //       }
      //     }
      //   }
      //
      //   final validCloseRange =
      //       damagePart?.any((test) => test.closeRange.isNotEmpty);
      //   final validFarRange =
      //       damagePart?.any((test) => test.farRange.isNotEmpty);
      //   if (validFarRange == true && validCloseRange == true) {
      //     damages = damagePart?.map((d) => d.toJson()).toList() ?? [];
      //   }
      // }

      final res = await claimRepository.submitVehicleClaim(
          policyId: Global.policyId,
          claimType: claimType,
          description: description,
          incidentDate: incidentDate,
          incidentTime: incidentTime,
          incidentLocation: incidentLocation,
          incidentType: incidentType,
          thirdPartyPhoneNumber: thirdPartyPhoneNumber,
          isThirdParty: isThirdParty,
          lossType: lossType,
          thirdPartyLossType: thirdPartyLossType,
          policeReportUrl: policeReportUrl,
          driersLicenceNo: driversLicenseNumber,
          driersLicenceUrl: driverLicenseUrl,
          damagedParts: damages);

      if (res.responseCode == 1) {
        ClaimModel claim = ClaimModel.fromJson(res.data["claim"]);

        isLoading = false;
        log('claim $claimType');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClaimSubmittedScreen(
                    claim: claim,
                    submissionStep: incidentType == 'Theft'
                        ? ClaimSubmissionStep.theft
                        : ClaimSubmissionStep.none)));
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      isLoading = false;
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<List<Map<String, dynamic>>> uploadAndSerializeDamages({
    required List<Damage>? damagePart,
    required FormRepository formRepository,
  }) async {
    if (damagePart == null || damagePart.isEmpty) return const [];

    // Helper to ensure a URL exists (reuses existing URL or uploads the file)
    Future<String> ensureUrl({
      required String existingUrl,
      required File? file,
      required String
          fieldName, // "farRange" / "closeRange" (for error messages)
    }) async {
      if (existingUrl.isNotEmpty) return existingUrl;
      if (file == null) {
        throw Exception('Missing $fieldName file and URL.');
      }
      final res = await formRepository.uploadFile(file: file);
      if (res.responseCode != 1) {
        throw Exception('Upload failed for $fieldName.');
      }
      final url = (res.data?['file_url'] as String?) ?? '';
      if (url.isEmpty) {
        throw Exception('Upload returned empty url for $fieldName.');
      }
      return url;
    }

    // Process all items (in parallel) and keep order
    final updated = await Future.wait(damagePart.map((d) async {
      final farUrl = await ensureUrl(
        existingUrl: d.farRange,
        file: d.farRangeFile,
        fieldName: 'farRange',
      );
      final closeUrl = await ensureUrl(
        existingUrl: d.closeRange,
        file: d.closeRangeFile,
        fieldName: 'closeRange',
      );
      return d.copyWith(farRange: farUrl, closeRange: closeUrl);
    }));

    // Finally, serialize
    return updated.map((d) => d.toJson()).toList(growable: false);
  }

  Future<void> submitDeviceClaim({
    required WidgetRef ref,
    required BuildContext context,
    required String incidentType,
    required String incidentDate,
    required String incidentTime,
    required List<String> lossType,
    required String incidentLocation,
    required String description,
    required String claimType,
    File? fileReceipt,
    File? fileDamagedPart,
    File? fileLiquidDamage,
  }) async {
    try {
      // If you’re in a StateNotifier/ChangeNotifier, set state + notify here
      isLoading = true;

      String? damagedPartUrl;
      String? damagedLiquidUrl;
      String? receiptUrl;

      // ✅ use the correct file to derive the name
      if (fileDamagedPart != null) {
        final res = await formRepository.uploadFile(file: fileDamagedPart);

        if (res.responseCode == 1) {
          damagedPartUrl = res.data["file_url"];
        } else {
          CustomToast.showErrorMessage(context, res.errors.toString());
          throw Exception('Failed to upload file');
        }
      }

      if (fileLiquidDamage != null) {
        final res = await formRepository.uploadFile(file: fileLiquidDamage);

        if (res.responseCode == 1) {
          damagedLiquidUrl = res.data["file_url"];
        } else {
          CustomToast.showErrorMessage(context, res.errors.toString());
          throw Exception('Failed to upload file');
        }
      }

      if (fileReceipt != null) {
        final res = await formRepository.uploadFile(file: fileReceipt);

        if (res.responseCode == 1) {
          receiptUrl = res.data["file_url"];
        } else {
          CustomToast.showErrorMessage(context, res.errors.toString());
          throw Exception('Failed to upload file');
        }
      }

      // Consider validating these before the call
      final policyNumber = Global.policyNumber;
      if (policyNumber == null || policyNumber.isEmpty) {
        throw Exception('Missing policy number');
      }
      log('bb $damagedLiquidUrl. $damagedPartUrl');
      final res = await claimRepository.submitDeviceClaim(
        progress: 'submission',
        policyNumber: policyNumber,
        incidentType: incidentType,
        address: incidentLocation,
        date: incidentDate,
        // ensure API’s expected format
        time: incidentTime,
        // ensure API’s expected format
        paymentReceiptUrl: receiptUrl ?? '',
        damageUrl: damagedPartUrl ?? '',
        liquidDamageUrl: damagedLiquidUrl ?? '',
        description: description,
      );

      if (res.responseCode == 1) {
        final claim = ClaimModel.fromJson(res.data['claim']);
        isLoading = false;
        if (!context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClaimSubmittedScreen(
              claim: claim,
              productCategory: ProductCategory.gadget,
            ),
          ),
        );
      } else {
        if (!context.mounted) return;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
    } catch (e, stacktrace) {
      log('submitDeviceClaim error: $e');
      log(stacktrace.toString());
      if (context.mounted) {
        CustomToast.showErrorMessage(context, e.toString());
      }
    } finally {
      isLoading = false;
    }
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

  Future<List<String>> claimBenefits(String policyId) async {
    isLoading = true;
    final res = await claimRepository.claimBenefits(policyId: policyId);
    isLoading = false;
    if (res.success) {
      return [...res.data['benefits']];
    } else {
      return [];
    }
  }

  Future<void> submitThirdPartyClaim({
    required WidgetRef ref,
    required BuildContext context,
    // required String email,
    // required String policyNumber,

    ////
    // required String incidentType,
    required String incidentDate,
    required String incidentTime,
    // required List<String> lossType,
    required String incidentLocation,
    required String description,
    required List<String> thirdPartyLossType,
    required String thirdPartyPhoneNumber,
    // required String claimType,
    required String thirdPartyInsuranceProvider,
    required String thirdPartyFullName,
    required String thirdPartyPolicyNumber,
    required String thirdPartyEmail,
    required bool isThirdPartyInsured,

    ///

    ///
    ///
  }) async {
    try {
      isLoading = true;
      final res = await claimRepository.submitThirdPartyClaim(
          policyId: Global.policyId,
          description: description,
          incidentDate: incidentDate,
          incidentTime: StringUtils.convertToMilitaryTime(incidentTime),
          incidentLocation: incidentLocation,
          thirdPartyPhoneNumber: thirdPartyPhoneNumber,
          thirdPartyInsuranceProvider: thirdPartyInsuranceProvider,
          thirdPartyFullName: thirdPartyFullName,
          thirdPartyPolicyNumber: thirdPartyPolicyNumber,
          thirdPartyEmail: thirdPartyEmail,
          isThirdPartyInsured: isThirdPartyInsured,
          thirdPartyLossType: thirdPartyLossType);

      if (res.responseCode == 1) {
        ClaimModel claim = ClaimModel.fromJson(res.data["claim"]);

        isLoading = false;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClaimSubmittedScreen(
                      claim: claim,
                      submissionStep: ClaimSubmissionStep.thirdPartyClaimLodged,
                    )));
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      isLoading = false;
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<void> submitVehicleClaimEstimate({
    required WidgetRef ref,
    required BuildContext context,
    required int estimateAmount,
    required File selectedInvoice,
  }) async {
    try {
      isLoading = true;
      final uploadRes = await formRepository.uploadFile(file: selectedInvoice);

      if (uploadRes.responseCode == 1) {
        String claimInvoiceUrl = uploadRes.data["file_url"];

        final res = await claimRepository.submitVehicleClaimEstimate(
            claimId: Global.claimId,
            estimateAmount: estimateAmount,
            claimInvoiceUrl: claimInvoiceUrl,
            isCustomerOwnEstimateProvided: true);

        if (res.responseCode == 1) {
          ClaimModel claim = ClaimModel.fromJson(res.data["claim"]);

          isLoading = false;
          final nav = Navigator.of(context, rootNavigator: true);
          if (nav.canPop()) {
            nav.pop();
          }

          if (!(context.mounted)) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClaimSubmittedScreen(
                        claim: claim,
                        submissionStep: ClaimSubmissionStep.repairEstimate,
                      )));
        } else {
          isLoading = false;
          CustomToast.showErrorMessage(context, res.errors.toString());
        }
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, uploadRes.errors.toString());
        throw Exception('Failed to upload file');
      }

      isLoading = false;
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<void> submitDeviceClaimEstimate(
      {required WidgetRef ref,
      required BuildContext context,
      required int estimateAmount,
      required File selectedInvoice,
      required ClaimModel claim}) async {
    try {
      isLoading = true;
      final uploadRes = await formRepository.uploadFile(
        file: selectedInvoice,
      );

      if (uploadRes.responseCode == 1) {
        String claimInvoiceUrl = uploadRes.data["file_url"];

        final res = await claimRepository.submitDeviceClaimEstimate(
            claimId: Global.claimId,
            estimateAmount: estimateAmount,
            claimInvoiceUrl: claimInvoiceUrl,
            claim: claim);

        if (res.responseCode == 1) {
          isLoading = false;
          ClaimModel claim = ClaimModel.fromJson(res.data["claim"]);
          log('claimss');
          // isLoading = false;
          //  Navigator.of(Global.context!).pop();
          final nav = Navigator.of(context, rootNavigator: true);
          if (nav.canPop()) {
            nav.pop();
          }

          if (!(context.mounted)) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClaimSubmittedScreen(
                        claim: claim,
                        submissionStep: ClaimSubmissionStep.repairEstimate,
                      )));
        } else {
          Navigator.of(context).pop();
          isLoading = false;
          CustomToast.showErrorMessage(context, res.errors.toString());
        }
      } else {
        Navigator.of(context).pop();
        isLoading = false;
        CustomToast.showErrorMessage(context, uploadRes.errors.toString());
        throw Exception('Failed to upload file');
      }
      //  Navigator.of(context).pop();
      // Navigator.of(Global.context!).pop();
      isLoading = false;
      // else {}
    } catch (e, stacktrace) {
      Navigator.of(context).pop();
      //Navigator.of(Global.context!).pop();
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<void> getBankList({
    required WidgetRef ref,
    required BuildContext context,
    required ClaimModel claim,
  }) async {
    try {
      ref.read(loadBankListProvider.notifier).state = true;
      final res = await claimRepository.getBankList();

      if (res.responseCode == 1) {
        List<BankModel> banks = (res.data["banks"] as List?)
                ?.where((e) => e != null)
                .map((e) => BankModel.fromJson(e))
                .toList() ??
            [];

        ref.read(bankListProvider.notifier).state = banks;

        // if (shouldNavigate) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => AcceptOfferScreen(
        //                 claim: claim,
        //                 banks: banks,
        //               )));
        // }
      } else {
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      isLoadingBanks = false;
      // else {}
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    } finally {
      ref.read(loadBankListProvider.notifier).state = false;
    }
  }

  Future<void> verifyBankAccount({
    required WidgetRef ref,
    required BuildContext context,
    required String accountNumber,
    required String bankCode,
  }) async {
    try {
      isNameLoading = true;
      final res = await claimRepository.verifyBankAccount(
        accountNumber: accountNumber,
        bankCode: bankCode,
      );

      if (res.responseCode == 1) {
        BankAccountModel bank =
            BankAccountModel.fromJson(res.data["bank_account"]);
        // List<BankModel> banks = (res.data["banks"] as List?)
        //         ?.where((e) => e != null)
        //         .map((e) => BankModel.fromJson(e))
        //         .toList() ??
        //     [];

        ref.read(accountDetailsProvider.notifier).state = bank;
        isNameLoading;

        // if (shouldNavigate) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => AcceptOfferScreen(
        //                 claim: claim,
        //                 banks: banks,
        //               )));
        // }
      } else if (res.errors.toString() == '[Too Many Requests]' ||
          res.errors.toString() == 'Too Many Requests') {
        isNameLoading = false;
      } else {
        isNameLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      isNameLoading = false;
      // else {}
    } catch (e, stacktrace) {
      isNameLoading = false;
      log(e.toString());
      log(stacktrace.toString());

      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<void> acceptClaimOffer({
    required WidgetRef ref,
    required BuildContext context,
    required ClaimModel claim,
    // required String email,
    // required String policyNumber,

    ////

    required String accountNumber,
    required String bankCode,
    required String accountName,
    required String bankName,

    ///

    ///
    ///
  }) async {
    try {
      isLoading = true;
      final res = await claimRepository.acceptClaimOffer(
        // accountName: 'Mercy Joy',
        // //accountName,
        // accountNumber: '1414007010',
        // //accountNumber,
        // bankCode: '044',
        // //bankCode,
        // bankName: 'Access bank',
        // bankName,
        accountName: accountName,
        accountNumber: accountNumber,
        bankCode: bankCode,
        bankName: bankName,
        claimId: claim.id ?? "",
        customerId: claim.customerId ?? "",
        providerId: claim.productId ?? "",
      );

      if (res.responseCode == 1) {
        ref.watch(accountDetailsProvider) == null;
        ClaimModel claim = ClaimModel.fromJson(res.data);

        final nav = Navigator.of(context, rootNavigator: true);
        if (nav.canPop()) {
          nav.pop();
        }

        if (!(context.mounted)) return;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClaimSubmittedScreen(
                      claim: claim,
                      submissionStep: ClaimSubmissionStep.offerAccepted,
                    )));
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      isLoading = false;
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  Future<void> rejectClaimOffer({
    required WidgetRef ref,
    required BuildContext context,
    required ClaimModel claim,
    required String comment,
  }) async {
    try {
      isLoading = true;
      final res = await claimRepository.rejectClaimOffer(
        comment: comment,
        claimId: claim.id ?? "",
        customerId: claim.customerId ?? "",
        providerId: claim.productId ?? "",
      );

      if (res.responseCode == 1) {
        ClaimModel newClaim = ClaimModel.fromJson(res.data);
        log('nowww $claim');
        log('before $newClaim');
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ClaimSubmittedScreen(
                      claim: newClaim,
                      detailedClaim: claim,
                      submissionStep: ClaimSubmissionStep.offerRejected,
                    )));
      } else {
        isLoading = false;
        // Navigator.pop(context);
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      isLoading = false;
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      // Navigator.pop(context);
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }

  // Function to retry a file upload
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

  Future<void> submitThirdPartyClaimInspection({
    required WidgetRef ref,
    required BuildContext context,

    ////
    required File partOne,
    required File partTwo,
    required File partThree,
    required File partFour,
    required int amount,

    ///

    ///
    ///
  }) async {
    const int maxRetries = 3;
    try {
      isLoading = true;
      // Run all uploads in parallel

      // Run all uploads in parallel with retry logic
      final results = await Future.wait([
        uploadWithRetry(partOne, maxRetries),
        uploadWithRetry(partTwo, maxRetries),
        uploadWithRetry(partThree, maxRetries),
        uploadWithRetry(partFour, maxRetries),
      ]);

      final resOne = results[0];
      final resTwo = results[1];
      final resThree = results[2];
      final resFour = results[3];

      final res = await claimRepository.submitThirdPartyClaimInspection(
        amount: amount,
        claimId: Global.claimId,
        evidenceOne: resOne.data["file_url"],
        evidenceTwo: resTwo.data["file_url"],
        evidenceThree: resThree.data["file_url"],
        evidenceFour: resFour.data["file_url"],
      );

      if (res.responseCode == 1) {
        ClaimModel claim = ClaimModel.fromJson(res.data["claim"]);

        isLoading = false;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClaimSubmittedScreen(
                      claim: claim,
                      submissionStep: ClaimSubmissionStep.thirdPartyInspected,
                    )));
      } else {
        isLoading = false;
        CustomToast.showErrorMessage(context, res.errors.toString());
      }
      isLoading = false;
      // else {}
    } catch (e, stacktrace) {
      isLoading = false;
      log(e.toString());
      log(stacktrace.toString());
      CustomToast.showErrorMessage(context, e.toString());
      // return false;
    }
  }
}

final defaultAccountNoProvider = StateProvider<String>((ref) => '');
final bankListProvider = StateProvider<List<BankModel>>((ref) => []);
final loadBankListProvider = StateProvider<bool>((ref) => false);
final damagedPartsProvider = StateProvider<List<DamagedAreaPart>>((ref) => []);
final accountDetailsProvider = StateProvider<BankAccountModel?>((ref) => null);
