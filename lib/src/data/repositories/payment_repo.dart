// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'package:mca_official_flutter_sdk/src/constants/api_endpoints.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';

import '../api/generic_response.dart';
import '../api_config/api_service.dart';
import '../api_config/local_cache.dart';

abstract class PaymentRepository {
  Future<GenericResponse> initiateGatewayPurchase({
    required Map<String, dynamic> paymentChannel,
    required Map<String, dynamic> payload,
  });
  Future<GenericResponse> initiateWalletPurchase({
    required Map<String, dynamic> payload,
  });
  Future<GenericResponse> getUssdProviders();
  Future<GenericResponse> verifyPayment({
    required String reference,
  });
  Future<GenericResponse> getPurchaseInfo(String reference);
}

class PaymentRepositoryImpl extends ApiService implements PaymentRepository {
  late LocalCache cache;
  PaymentRepositoryImpl({
    required this.cache,
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  @override
  Future<GenericResponse> initiateGatewayPurchase({
    required Map<String, dynamic> paymentChannel,
    required Map<String, dynamic> payload,
  }) async {
    var requestData = {
      "payload": payload,
      "payment_channel": paymentChannel,
      'instance_id': Global.businessDetails?.instanceId ?? "",
    };

    var res = await post(ApiEndpoints.initiatePurchase,
        data: requestData, useToken: true);

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getUssdProviders() async {
    var res = await get(ApiEndpoints.getUssdProviders, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> verifyPayment({
    required String reference,
  }) async {
    var requestData = {
      "transaction_reference": reference,
    };

    var res = await post(ApiEndpoints.verifyPayment,
        data: requestData, useToken: true);

    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getPurchaseInfo(String reference) async {
    String query = "?reference=$reference";
    var res = await get(ApiEndpoints.getPurchaseInfo + query, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> initiateWalletPurchase(
      {required Map<String, dynamic> payload}) async {
    var requestData = {
      "payload": payload,
      'reference': Global.reference,
      'instance_id': Global.businessDetails?.instanceId ?? "",
    };

    var res = await post(ApiEndpoints.initiatePurchase,
        data: requestData, useToken: true);

    return GenericResponse.fromJson(res);
  }
}
