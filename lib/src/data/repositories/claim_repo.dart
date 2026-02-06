// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mca_official_flutter_sdk/src/constants/api_endpoints.dart';
import 'package:mca_official_flutter_sdk/src/data/api/generic_response.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';

import '../api_config/api_service.dart';
import '../api_config/local_cache.dart';

abstract class ClaimRepository {
  Future<GenericResponse> submitVehicleClaim(
      {required String policyId,
      required String claimType,
      required String description,
      required String incidentDate,
      required String incidentTime,
      required String incidentLocation,
      required String incidentType,
      required String thirdPartyPhoneNumber,
      required bool isThirdParty,
      required List<String> lossType,
      required List<String> thirdPartyLossType,
      String? policeReportUrl,
      String? driersLicenceNo,
      String? driersLicenceUrl,
      List<Map<String, dynamic>>? damagedParts});

  Future<GenericResponse> submitDeviceClaim(
      {required String progress,
      required String policyNumber,
      required String incidentType,
      required String address,
      required String date,
      required String time,
      required String paymentReceiptUrl,
      required String description,
      required String damageUrl,
      required String liquidDamageUrl});

  Future<GenericResponse> claimBenefits({required String policyId});

  Future<GenericResponse> submitAutoClaimInspection({
    // required File file,
    required Map<String, File> vehicleImages,
    required String videoUrl,
    required String address,
    required String longitude,
    required String latitude,
    String? inspectionType,
    String? timeStamp,
    String? policyId,
    String? claimId,
    String? reference,
  });

  Future<GenericResponse> submitDeviceClaimInspection({
    required Map<String, File> deviceImages,
    required String videoUrl,
    required String address,
    required String longitude,
    required String latitude,
    required String frontImage,
    required String backImage,
    required String sideImage,
    required String serialNumberImage,
    String? inspectionType,
    String? timeStamp,
    String? policyId,
    String? claimId,
    String? reference,
  });

  Future<GenericResponse> verifyClaimImageAI({
    required File file,
    required String action,
    required String vehicleSection,
    String? claimId,
    String? policyId,
    bool bypass = false,
  });

  Future<GenericResponse> getClaimsById(String policyId);

  Future<GenericResponse> getClaimsInfo(String email, String claimsId);

  Future<GenericResponse> getPolicyInfo(String email, String policyNumber);

  Future<GenericResponse> getDamagedParts();

  Future<GenericResponse> submitVehicleClaimEstimate(
      {required String claimId,
      required int estimateAmount,
      required String claimInvoiceUrl,
      required bool isCustomerOwnEstimateProvided});

  Future<GenericResponse> submitDeviceClaimEstimate(
      {required String claimId,
      required int estimateAmount,
      required String claimInvoiceUrl,
      required ClaimModel claim});

  Future<GenericResponse> uploadAdditionalInfo({
    required String claimId,
    required List<Map<String, dynamic>> payload,
  });

  Future<GenericResponse> getBankList();

  Future<GenericResponse> verifyBankAccount({
    required String accountNumber,
    required String bankCode,
  });

  Future<GenericResponse> acceptClaimOffer({
    required String accountName,
    required String accountNumber,
    required String bankCode,
    required String bankName,
    required String claimId,
    required String customerId,
    required String providerId,
  });

  Future<GenericResponse> rejectClaimOffer({
    required String comment,
    required String claimId,
    required String customerId,
    required String providerId,
  });

  Future<GenericResponse> getPolicyById(String policyId);

  Future<GenericResponse> submitThirdPartyClaim({
    required String policyId,
    required String description,
    required String incidentDate,
    required String incidentTime,
    required String incidentLocation,
    required String thirdPartyPhoneNumber,
    required String thirdPartyInsuranceProvider,
    required String thirdPartyFullName,
    required String thirdPartyPolicyNumber,
    required String thirdPartyEmail,
    required bool isThirdPartyInsured,
    required List<String> thirdPartyLossType,
  });

  Future<GenericResponse> submitThirdPartyClaimInspection({
    required int amount,
    required String claimId,
    required String evidenceOne,
    required String evidenceTwo,
    required String evidenceThree,
    required String evidenceFour,
  });
}

class ClaimRepositoryImpl extends ApiService implements ClaimRepository {
  late LocalCache cache;

  ClaimRepositoryImpl({
    required this.cache,
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  @override
  Future<GenericResponse> submitVehicleClaim(
      {required String policyId,
      required String claimType,
      required String description,
      required String incidentDate,
      required String incidentTime,
      required String incidentLocation,
      required String incidentType,
      required String thirdPartyPhoneNumber,
      required bool isThirdParty,
      required List<String> lossType,
      required List<String> thirdPartyLossType,
      String? policeReportUrl,
      String? driersLicenceNo,
      String? driersLicenceUrl,
      List<Map<String, dynamic>>? damagedParts}) async {
    var requestData = {
      'claim_type': claimType,
      "description": description,
      'incident_date': incidentDate,
      'incident_location': incidentLocation,
      "incident_time": incidentTime,
      "incident_type": incidentType,
      "is_third_party": isThirdParty,
      'loss_type': lossType,
      'third_party_loss_type': thirdPartyLossType,
      'third_party_phone_number': thirdPartyPhoneNumber,
      'third_party_full_name': "FUhad Aminu",
      'policy_id': policyId,
      'progress': "submission",
      'police_report': policeReportUrl,
      'driver_license': driersLicenceNo,
      'driver_license_url': driersLicenceUrl,
      'damage_part': damagedParts
    };

    var res = await post(ApiEndpoints.submitVehicleClaim,
        data: requestData, useToken: true
        // headers: {
        //   "Content-Type": "multipart/form-data",
        // },
        );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitDeviceClaim(
      {required String progress,
      required String policyNumber,
      required String incidentType,
      required String address,
      required String date,
      required String time,
      required String paymentReceiptUrl,
      String? damageUrl,
      required String description,
      String? liquidDamageUrl}) async {
    final List<Map<String, String>> damages = [];

    final dUrl = (damageUrl ?? '').trim();
    if (dUrl.isNotEmpty) {
      damages.add({
        'damage_part': 'Screen Damage',
        'image': dUrl,
      });
    }

    final lUrl = (liquidDamageUrl ?? '').trim();
    if (lUrl.isNotEmpty) {
      damages.add({
        'damage_part': 'Liquid Damage',
        'image': lUrl,
      });
    }
    final Map<String, dynamic> requestData = {
      'progress': progress,
      'policy_number': policyNumber,
      'incident_type': incidentType,
      'payment_receipt': paymentReceiptUrl,
      'description': description,
      'address': address,
      'date': date,
      'time': time,
    };

    if (damages.isNotEmpty) {
      requestData['damages'] = damages;
    }

    // var requestData = {
    //   "progress": progress,
    //   'policy_number': policyNumber,
    //   'incident_type': incidentType,
    //   'payment_receipt': paymentReceiptUrl,
    //   'description': description,
    //   'address': address,
    //   'date': date,
    //   'time': time,

    //   // 'damages': [
    //   //   if (damageUrl != null)
    //   //     {
    //   //       'damage_part': 'Screen Damage',
    //   //       'image': damageUrl ?? '',
    //   //     },
    //   //   if (liquidDamageUrl != null)
    //   //     {
    //   //       'damage_part': 'Liquid Damage',
    //   //       'image': liquidDamageUrl ?? '',
    //   //     }
    //   // ]
    // };
    // if (damages.isNotEmpty) {
    //   requestData['damages'] = damages;
    // }
    var res = await post(ApiEndpoints.submitGadgetClaim,
        data: requestData, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitDeviceClaimInspection({
    required Map<String, File> deviceImages,
    required String videoUrl,
    required String address,
    required String longitude,
    required String latitude,
    required String frontImage,
    required String backImage,
    required String sideImage,
    required String serialNumberImage,
    String? inspectionType,
    String? timeStamp,
    String? policyId,
    String? claimId,
    String? reference,
  }) async {
    var requestData = {
      // "inspection_device_type": 'Gadget',
      "action": "inspection",
      'policy_id': policyId,
      'policy_number': Global.policyNumber,
      'timestamp': timeStamp,
      "geolocation": address,
      "inspection_device_type": inspectionType,
      "inspection_duration": "string",
      'video_url': videoUrl,
      'progress': 'inspection',
      'bypass': 'true',
      'claim_id': claimId,
      'claim_type': Global.claim?.claimType,
      "description": Global.claim?.claimDescription,
      'incident_date': Global.claim?.gadgetClaimMeta["date"],
      'incident_location': Global.claim?.gadgetClaimMeta["address"],
      "incident_time": Global.claim?.gadgetClaimMeta["time"],
      "incident_type": Global.claim?.gadgetClaimMeta["incident_type"],
      'serial_number_image': serialNumberImage,
      'front_image': frontImage,
      'back_image': backImage,
      'side_image': sideImage,
    };

    var res = await post(ApiEndpoints.submitGadgetClaimsInspection,
        data: requestData,
        useToken: true,
        headers: {
          "Content-Type": "multipart/form-data",
        });

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getClaimsById(String policyId) async {
    String query = "/$policyId";
    var res = await get(ApiEndpoints.getClaimsById + query, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getDamagedParts() async {
    var res = await get(ApiEndpoints.getDamagedPart, useToken: true);
    print(res);

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getPolicyById(String policyId) async {
    String query = "/$policyId";
    var res = await get(ApiEndpoints.getPolicyById + query, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getPolicyInfo(
      String email, String policyNumber) async {
    var requestData = {
      'email': email,
      "policy_number": policyNumber,
    };
    var res = await post(ApiEndpoints.getPolicyInfo,
        data: requestData, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> verifyClaimImageAI({
    required File file,
    required String action,
    required String vehicleSection,
    String? claimId,
    String? policyId,
    bool bypass = false,
  }) async {
    FormData requestData;
    if (bypass == true) {
      requestData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
        "vehicle_section": vehicleSection,
        'action': action,
        'policy_id': policyId,
        'bypass': 'true',
        'claim_id': claimId,
        // "inspection_type": vehicleSection,
      });
    } else {
      requestData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
        "vehicle_section": vehicleSection,
        'action': action,
        'policy_id': policyId,
        'claim_id': claimId,
        // "inspection_type": vehicleSection,
      });
    }

    var res = await post(ApiEndpoints.verifyClaimImageAI,
        data: requestData,
        useToken: true,
        headers: {
          "Content-Type": "multipart/form-data",
        });

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitAutoClaimInspection({
    // required File file,
    required Map<String, File> vehicleImages,
    required String videoUrl,
    required String address,
    required String longitude,
    required String latitude,
    String? inspectionType,
    String? timeStamp,
    String? policyId,
    String? claimId,
    String? reference,
  }) async {
    var requestData = {
      "action": "inspection",
      'policy_id': policyId,
      // 'claim_id': claimId,
      // "claim_type": "Vehicle",
      'timestamp': timeStamp,
      "geolocation": address,
      "inspection_device_type": inspectionType,
      "inspection_duration": "string",
      'video_url': videoUrl,
      'progress': 'inspection',
      'bypass': 'true',
      'claim_id': claimId,
      'claim_type': Global.claim?.claimType,
      "description": Global.claim?.claimDescription,
      'incident_date': Global.claim?.vehicleClaimMeta["date"],
      'incident_location': Global.claim?.vehicleClaimMeta["address"],
      "incident_time": Global.claim?.vehicleClaimMeta["time"],
      "incident_type": Global.claim?.vehicleClaimMeta["incident_type"],
      "is_third_party": Global.claim?.vehicleClaimMeta["is_third_party"],
      'loss_type': Global.claim?.vehicleClaimMeta["loss_type"],
      'third_party_loss_type':
          Global.claim?.vehicleClaimMeta["third_party_loss_type"],
      'third_party_phone_number':
          Global.claim?.vehicleClaimMeta["third_party_phone_number"],
      'third_party_full_name': "FUhad Aminu",
    };

    var res = await post(ApiEndpoints.submitAutoClaims,
        data: requestData,
        useToken: true,
        headers: {
          "Content-Type": "multipart/form-data",
        });

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitVehicleClaimEstimate({
    required String claimId,
    required int estimateAmount,
    required String claimInvoiceUrl,
    required bool isCustomerOwnEstimateProvided,
  }) async {
    var requestData = {
      'claim_id': claimId,
      'estimate_amount': estimateAmount,
      'claim_invoice_url': claimInvoiceUrl,
      'progress': 'repair_estimate',
      'is_customer_own_estimate_provided': isCustomerOwnEstimateProvided
    };

    var res = await post(
      ApiEndpoints.submitVehicleClaimEstimate,
      data: requestData,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getBankList() async {
    var res = await get(
      ApiEndpoints.getBankList,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitDeviceClaimEstimate(
      {required String claimId,
      required int estimateAmount,
      required String claimInvoiceUrl,
      required ClaimModel claim}) async {
    print(claim);
    final Map<String, dynamic> requestData = {
      "claim_invoice_url": claimInvoiceUrl, // String
      "estimate_amount": estimateAmount, // int / double
      "progress": "repair_estimate", // String
      "claim_id": claimId, // String
      "policy_number": Global.policyNumber, // String
      "estimate_amount_breakdown": [
        // List of maps
        {
          "amount": 2000,
          "damage_part": "battery",
          "type": "Replacement",
        },
        // {
        //   "amount": 2000,
        //   "damage_part": "Left power button",
        //   "type": "Repair",
        // },
      ],
      "claim_type": "Gadget", // String
      "is_customer_own_estimate_provided": true, // bool
      "workmanship_charge": claim.gadgetClaimMeta, // optional field
    };
    // var requestData = {
    //   'claim_id': claimId,
    //   'estimate_amount': estimateAmount,
    //   'claim_invoice_url': claimInvoiceUrl,
    //   'progress': "repair_estimate"
    // };

    var res = await post(
      ApiEndpoints.submitDevoiceClaimEstimate,
      data: requestData,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> verifyBankAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    var requestData = {
      'account_number': accountNumber,
      'bank_code': bankCode,
    };

    var res = await post(
      ApiEndpoints.verifyBankAccount,
      data: requestData,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> acceptClaimOffer({
    required String accountName,
    required String accountNumber,
    required String bankCode,
    required String bankName,
    required String claimId,
    required String customerId,
    required String providerId,
  }) async {
    var requestData = {
      'account_name': accountName,
      'account_number': accountNumber,
      'bank_code': bankCode,
      'bank_name': bankName,
      'claim_id': claimId,
      'claim_payment_method': "bank transfer",
      'customer_id': customerId,
      'provider_id': providerId,
    };

    var res = await put(
      ApiEndpoints.acceptClaimOffer,
      data: requestData,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> rejectClaimOffer({
    required String comment,
    required String claimId,
    required String customerId,
    required String providerId,
  }) async {
    var requestData = {
      'claim_id': claimId,
      'comment': comment,
      'comment_type': "Offer",
      'customer_id': customerId,
      'provider_id': providerId,
    };

    var res = await put(
      ApiEndpoints.rejectClaimOffer,
      data: requestData,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitThirdPartyClaim({
    required String policyId,
    required String description,
    required String incidentDate,
    required String incidentTime,
    required String incidentLocation,
    required String thirdPartyPhoneNumber,
    required String thirdPartyInsuranceProvider,
    required String thirdPartyFullName,
    required String thirdPartyPolicyNumber,
    required String thirdPartyEmail,
    required bool isThirdPartyInsured,
    required List<String> thirdPartyLossType,
  }) async {
    var requestData = {
      'claim_type': "Vehicle",
      "description": description,
      'incident_date': incidentDate,
      'incident_location': incidentLocation,
      "incident_time": incidentTime,
      "incident_type": "Accidental damage",
      "is_third_party": true,
      'loss_type': ["Collision"],
      'policy_id': policyId,
      'is_third_party_insured': isThirdPartyInsured,
      'progress': "submission",
      'third_party_email': thirdPartyEmail,
      'third_party_full_name': thirdPartyFullName,
      'third_party_policy_number': thirdPartyPolicyNumber,
      'third_party_loss_type': thirdPartyLossType,
      'third_party_phone_number': thirdPartyPhoneNumber,
      'third_party_insurance_provider': thirdPartyInsuranceProvider
    };

    var res = await post(
      ApiEndpoints.submitVehicleClaim,
      data: requestData,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitThirdPartyClaimInspection({
    required int amount,
    required String claimId,
    required String evidenceOne,
    required String evidenceTwo,
    required String evidenceThree,
    required String evidenceFour,
  }) async {
    var requestData = {
      'amount': amount,
      'claim_id': claimId,
      "evidence_one": evidenceOne,
      'evidence_two': evidenceTwo,
      'evidence_three': evidenceThree,
      "evidence_four": evidenceFour,
      "progress": "third_party_inspection",
    };

    var res = await post(
      ApiEndpoints.submitThirdPartyAutoClaimInspection,
      data: requestData,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> claimBenefits({required String policyId}) async {
    var res = await get(
      '${ApiEndpoints.fetchClaimWithPolicyId}/$policyId',
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> uploadAdditionalInfo(
      {required String claimId,
      required List<Map<String, dynamic>> payload}) async {
    var requestData = {
      'additional_info': payload,
      'claim_id': claimId,
    };

    var res = await post(
      ApiEndpoints.submitAdditionalInfo,
      data: requestData,
      useToken: true,
    );

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getClaimsInfo(String email, String claimsId) async {
    var requestData = {"claim_id": claimsId, "email": email};
    var res = await post(ApiEndpoints.getClaimInfo,
        data: requestData, useToken: true);
    return GenericResponse.fromJson(res);
  }
}
