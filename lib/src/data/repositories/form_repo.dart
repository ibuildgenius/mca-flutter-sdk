// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mca_official_flutter_sdk/src/constants/api_endpoints.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';

import '../api/generic_response.dart';
import '../api_config/api_service.dart';
import '../api_config/local_cache.dart';

abstract class FormRepository {
  Future<GenericResponse> getListData(String dataUrl, {String? dependsOnId});
  Future<GenericResponse> fetchProductPrice(
      Map<String, dynamic> payload, String productId);

  Future<GenericResponse> uploadFile({required File file, String? fileType});
  Future<GenericResponse> completePurchase(
    Map<String, dynamic> payload,
  );
}

class FormRepositoryImpl extends ApiService implements FormRepository {
  late LocalCache cache;
  FormRepositoryImpl({
    required this.cache,
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  @override
  Future<GenericResponse> getListData(String dataUrl,
      {String? dependsOnId}) async {
    String url = dataUrl;
    if (dependsOnId != null) {
      url = "$dataUrl/$dependsOnId";
    }
    var res = await get(url, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> fetchProductPrice(
      Map<String, dynamic> payload, String productId) async {
    var requestData = {
      "payload": payload,
    };

    var res = await post(ApiEndpoints.fetchProductPrice,
        data: requestData, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> uploadFile(
      {required File file, String? fileType}) async {
    FormData requestData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
      'fileType': fileType ?? "image",
    });
    var res = await post(ApiEndpoints.uploadFile,
        data: requestData,
        useToken: true,
        headers: {
          "Content-Type": "multipart/form-data",
        });
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> completePurchase(
    Map<String, dynamic> payload,
  ) async {
    var requestData = {
      "payload": payload,
      "reference": Global.reference,
    };

    var res = await post(ApiEndpoints.completePurchase,
        data: requestData, useToken: true);
    return GenericResponse.fromJson(res);
  }
}
