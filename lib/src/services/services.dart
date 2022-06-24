import 'dart:io';
import 'package:http/http.dart' as http;

import 'api_scheme.dart';

class WebServices {
  static const String _basUrl = 'https://staging.api.mycover.ai/v1';
  static const String _initialiseSdkUrl = '$_basUrl/sdk/initialize';
  static const String _buySdkUrl = '$_basUrl/sdk/buy';
  static const String _uploadUrl = '$_basUrl/sdk/upload-file';
  static const String _ussdProviderUrl = '$_basUrl/sdk/ussd-providers';
  static const String _verifyPaymentUrl = '$_basUrl/sdk/verify-transaction';

  static const String productId = 'a72c4e3c-e868-4782-bb35-df6e3344ae6c';
  static const String userId = 'olakunle@mycovergenius.com';

  static initialiseSdk({required String userId, String? productId}) async {
    var data;
    if (productId == '') {
      data = {
        "client_id": userId,
      };
    } else {
      data = {
        "client_id": userId,
        "product_id": [productId],
      };
    }

    return await ApiScheme.initialisePostRequest(
        url: _initialiseSdkUrl, data: data);
  }

  static verifyPayment(String reference,businessId) async {
    var data = {
      "transaction_reference": reference,
    };
    print(data);
    return await ApiScheme.initialisePostRequest(
        url: _verifyPaymentUrl, data: data,apiKey: businessId);
  }

  static uploadFile(context, businessId, File image) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "x-api-id": "$businessId",
    };
    print(_uploadUrl);
    var uri = Uri.parse(_uploadUrl);

    var request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    request.fields['fileType'] = 'image';
    request.headers.addAll(headers);

    var response = await request.send();

    return response;
  }

  static getListData(String url) async {
    return await ApiScheme.initialiseGetRequest(url: '$_basUrl$url');
  }

  static getUssdProvider() async {
    return await ApiScheme.initialiseGetRequest(url: _ussdProviderUrl);
  }

  static buyProduct({
    required String userId,
    required String businessId,
    String? productId,
    payload,
    paymentChannel,
  }) async {
    var data = {
      "payload": payload,
      "payment_channel": paymentChannel,
    };

    return await ApiScheme.initialisePostRequest(
        url: _buySdkUrl, data: data, apiKey: businessId);
  }
}
