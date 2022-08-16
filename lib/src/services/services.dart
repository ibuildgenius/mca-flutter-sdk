import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_scheme.dart';

class WebServices {
  static const String _baseUrl = 'https://staging.api.mycover.ai/v1';
  static const String _initialiseSdkUrl = '$_baseUrl/sdk/initialize';
  static const String _buySdkUrl = '$_baseUrl/sdk/buy';
  static const String _uploadUrl = '$_baseUrl/sdk/upload-file';
  static const String _ussdProviderUrl = '$_baseUrl/sdk/ussd-providers';
  static const String _verifyPaymentUrl = '$_baseUrl/sdk/verify-transaction';
  static const String _initiatePurchaseUrl = '$_baseUrl/sdk/initiate-purchase';
  static const String _completePurchaseUrl = '$_baseUrl/sdk/complete-purchase';
  static const String _purchaseInfoUrl = '$_baseUrl/sdk/purchase-info';
  static const String submitInspectionUrl = '$_baseUrl/sdk/inspections/vehicle';
  static const String inspectionInfo = '$_baseUrl/sdk/inspection-info';

  static initialiseSdk(
      {required String publicKey,
      List? productId,
      paymentOption,
      reference}) async {
    var data;
    if (paymentOption == 'wallet' && (reference == '' || reference == null)) {
      return 'Reference must not be empty for a wallet payment option';
    } else {
      if (productId!.isEmpty) {
        data = {
          "payment_option": paymentOption,
          "debit_wallet_reference": reference
        };
      } else {
        data = {
          "product_id": productId,
          "payment_option": paymentOption,
          "debit_wallet_reference": reference
        };
      }
print('=======> Initi data $data');
print(publicKey);
      return await ApiScheme.initialisePostRequest(
          url: _initialiseSdkUrl, data: data, token: publicKey);
    }
  }

  static verifyPayment(String reference, businessId, publicKey) async {
    var data = {
      "transaction_reference": reference,
    };
    return await ApiScheme.initialisePostRequest(
        url: _verifyPaymentUrl,
        data: data,
        apiKey: businessId,
        token: publicKey);
  }

  static uploadFile(context, businessId, File image, token, {fileType}) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "x-api-id": "$businessId",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    print(_uploadUrl);
    var uri = Uri.parse(_uploadUrl);

    var request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    request.fields['fileType'] = fileType ?? 'image';
    request.headers.addAll(headers);

    var response = await request.send();

    return response;
  }

  static getListData(String url, publicKey) async {
    return await ApiScheme.initialiseGetRequest(
        url: '$_baseUrl$url', token: publicKey);
  }

  static getPurchaseInfo(businessId, reference, publicKey) async {
    String queryString = 'reference=$reference';

    var requestUrl = _purchaseInfoUrl + '?' + queryString;

    return await ApiScheme.initialiseGetRequest(
        url: requestUrl, apiKey: businessId, token: publicKey);
  }

  static getUssdProvider(publicKey) async {
    return await ApiScheme.initialiseGetRequest(
        url: _ussdProviderUrl, token: publicKey);
  }

  static getInspectionInfo(reference,publicKey) async {
    return await ApiScheme.initialiseGetRequest(
        url: inspectionInfo+'?reference=$reference', token: publicKey);
  }

  static buyProduct({
    required String userId,
    required String businessId,
    required String publicKey,
    String? productId,
    payload,
    paymentChannel,
  }) async {
    var data = {
      "payload": payload,
      "payment_channel": paymentChannel,
    };

    return await ApiScheme.initialisePostRequest(
        url: _buySdkUrl, data: data, apiKey: businessId, token: publicKey);
  }

  static initiatePurchase({
    required String businessId,
    required String publicKey,
    String? productId,
    instanceId,
    payload,
    paymentChannel,
    debitWalletReference,
  }) async {
    var data = {
      "payload": payload,
      'debit_wallet_reference': debitWalletReference,
      'instance_id': instanceId,
      "payment_channel": paymentChannel,
    };

print(data);
    return await ApiScheme.initialisePostRequest(
        url: _initiatePurchaseUrl,
        data: data,
        apiKey: businessId,
        token: publicKey);
  }

  static completePurchase(
      {required String businessId,
      required String publicKey,
      String? reference,
      payload}) async {
    var data = {
      "payload": payload,
      "reference": reference,
    };
    print(data);
    return await ApiScheme.initialisePostRequest(
        url: _completePurchaseUrl,
        data: data,
        apiKey: businessId,
        token: publicKey);
  }

  static inspection(
      {token,
      required String policyId,
      required String timeStamp,
      required File interior,
      required File dashboard,
      required File frontSide,
      required File backSide,
      required File leftSide,
      required File rightSide,
      required File chassisNumber,
      required String address,
      required String reference,
      required String businessId,
      required String lon,
      required String lat,
      required String inspectionType,
      required String videoUrl}) async {
    print('Submittion token $token');

    Map<String, String> headers = {
      "Accept": "application/json",
      "x-api-id": "$businessId",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    print('submitting endpoint $submitInspectionUrl');

    var uri = Uri.parse(submitInspectionUrl);

    var request = http.MultipartRequest("POST", uri);

    request.files
        .add(await http.MultipartFile.fromPath('interior', interior.path));
    request.files
        .add(await http.MultipartFile.fromPath('front_side', frontSide.path));
    request.files
        .add(await http.MultipartFile.fromPath('back_side', backSide.path));
    request.files
        .add(await http.MultipartFile.fromPath('left_side', leftSide.path));
    request.files
        .add(await http.MultipartFile.fromPath('right_side', rightSide.path));
    request.files
        .add(await http.MultipartFile.fromPath('dashboard', dashboard.path));
    request.files.add(
        await http.MultipartFile.fromPath('chasis_number', chassisNumber.path));

    request.headers.addAll(headers);

    // "policy_id": "string",
    // "inspection_type": "string",
    // "timestamp": "string",
    // "address": "string",
    // "longitude": "string",
    // "latitude": "string",
    // "video_url": "string"

    request.fields['policy_id'] = policyId;
    request.fields['inspection_type'] = inspectionType;
    request.fields['reference'] = reference;
    request.fields['timestamp'] = timeStamp;
    request.fields['address'] = address;
    request.fields['video_url'] = videoUrl;
    request.fields['longitude'] = lon.toString();
    request.fields['latitude'] = lat.toString();


    print(request.fields);

    var response = await request.send();
    print(response.statusCode);
    print(response.reasonPhrase);

    return response;
  }
}
