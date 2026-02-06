// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mca_official_flutter_sdk/src/constants/api_endpoints.dart';

import '../api/generic_response.dart';
import '../api_config/api_service.dart';
import '../api_config/local_cache.dart';

abstract class InspectionRepository {

  Future<GenericResponse> verifyImageAI({
    required File file,
    required String action,
    required String vehicleSection,
    String? claimId,
    String? policyId,
    bool bypass = false,
  });

  Future<GenericResponse> submitAutoInspection({
    // required File file,
    required Map<String, File> vehicleImages,
    required String videoUrl,
    required String address,
    required String longitude,
    required String latitude,
    required String inspectionType,
    required String timeStamp,
    String? policyId,
    String? reference,
  });
  Future<GenericResponse> submitGadgetInspection({
    // required File file,
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
    String? reference,
  });
}

class InspectionRepositoryImpl extends ApiService
    implements InspectionRepository {
  late LocalCache cache;
  InspectionRepositoryImpl({
    required this.cache,
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  @override
  Future<GenericResponse> verifyImageAI({
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

    var res = await post(ApiEndpoints.verifyImageAI,
        data: requestData,
        useToken: true,
        headers: {
          "Content-Type": "multipart/form-data",
        });

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitAutoInspection ({
    // required File file,
    required Map<String, File> vehicleImages,
    required String videoUrl,
    required String address,
    required String longitude,
    required String latitude,
    String? inspectionType,
    String? timeStamp,
    String? policyId,
    String? reference,
  }) async {
    var requestData = {
      'reference': reference,
      "action": "inspection",
      'policy_id': policyId,
      'timestamp': timeStamp,
      "geolocation": address,
      "inspection_device_type": inspectionType,
      "inspection_duration": "string",
      'video_url': videoUrl,
    };

    var res = await post(ApiEndpoints.submitAutoInspection,
        data: requestData,
        useToken: true,
        headers: {
          "Content-Type": "multipart/form-data",
        });

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> submitGadgetInspection({
    // required File file,
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
    String? reference,
  }) async {
    var requestData = {
      'reference': reference,
      'policy_id': policyId,
      "front_image": frontImage,
      "back_image": backImage,
      "side_image": sideImage,
      "serial_number_image": serialNumberImage,
      "action": "inspection",
      'timestamp': timeStamp,
      "geolocation": address,
      "inspection_device_type": inspectionType,
      "inspection_duration": "string",
      'video_url': videoUrl,
    };

    var res = await post(ApiEndpoints.submitGadgetInspection,
        data: requestData,
        useToken: true,
        headers: {
          "Content-Type": "multipart/form-data",
        });

    return GenericResponse.fromJson(res);
  }
}
