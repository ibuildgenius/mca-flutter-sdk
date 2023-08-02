import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_scheme.dart';

class WebServices {
  static const String _initialiseSdkUrl = '/sdk/initialize';
  static const String _buySdkUrl = '/sdk/buy';
  static const String _uploadUrl = '/sdk/upload-file';
  static const String _ussdProviderUrl = '/sdk/ussd-providers';
  static const String _verifyPaymentUrl = '/sdk/verify-transaction';
  static const String _initiatePurchaseUrl = '/sdk/initiate-purchase';
  static const String _completePurchaseUrl = '/sdk/complete-purchase';
  static const String _purchaseInfoUrl = '/sdk/purchase-info';
  static const String submitInspectionUrl = '/sdk/inspections/vehicle';
  static const String inspectionInfo = '/sdk/inspection-info';

  static getBaseUrl(publicKey) {
    print('===> $publicKey');
    if (publicKey.toString().toLowerCase().contains('test')) {
      return 'https://staging.api.mycover.ai/v1';
    } else {
      return 'https://api.mycover.ai/v1';
    }
  }

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
          "debit_wallet_reference": reference,
          "action": "purchase"
        };
      }
      print('=======> Init data $data');
      print(publicKey);
      return await ApiScheme.initialisePostRequest(
          url: '${getBaseUrl(publicKey)}' + _initialiseSdkUrl,
          data: data,
          token: publicKey);
    }
  }

  static verifyPayment(String reference, businessId, publicKey) async {
    var data = {
      "transaction_reference": reference,
    };
    return await ApiScheme.initialisePostRequest(
        url: '${getBaseUrl(publicKey)}' + _verifyPaymentUrl,
        data: data,
        apiKey: businessId,
        token: publicKey);
  }

  static getProductCategory(String id, token) async {
    return await ApiScheme.initialiseGetRequest(
        url: getBaseUrl(token) + "/products/get-product-category/$id", token: token);
  }

  static getHospitalList(token, routeName) async {
    return await ApiScheme.initialiseGetRequest(url: getBaseUrl(token) + "/products/mcg/flexi-care-hospitals?route_name=$routeName", token: token);
  }

  static uploadFile(context, businessId, File image, token, {fileType}) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "x-api-id": "$businessId",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    print('==>$_uploadUrl');
    var uri = Uri.parse('${getBaseUrl(token)}' + _uploadUrl);

    var request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    request.fields['fileType'] = fileType ?? 'image';
    request.headers.addAll(headers);

    var response = await request.send();

    return response;
  }

  static getListData(String url, publicKey) async {
    return await ApiScheme.initialiseGetRequest(
        url: '${getBaseUrl(publicKey)}' + url, token: publicKey);
  }

  static getPurchaseInfo(businessId, reference, publicKey) async {
    String queryString = 'reference=$reference';

    var requestUrl =
        '${getBaseUrl(publicKey)}' + _purchaseInfoUrl + '?' + queryString;

    return await ApiScheme.initialiseGetRequest(
        url: requestUrl, apiKey: businessId, token: publicKey);
  }

  static getUssdProvider(publicKey) async {
    return await ApiScheme.initialiseGetRequest(
        url: '${getBaseUrl(publicKey)}' + _ussdProviderUrl, token: publicKey);
  }

  static getInspectionInfo(reference, publicKey) async {
    return await ApiScheme.initialiseGetRequest(
        url: '${getBaseUrl(publicKey)}' +
            inspectionInfo +
            '?reference=$reference',
        token: publicKey);
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
        url: '${getBaseUrl(publicKey)}' + _buySdkUrl,
        data: data,
        apiKey: businessId,
        token: publicKey);
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
        url: '${getBaseUrl(publicKey)}' + _initiatePurchaseUrl,
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
    print('Complete puchase ===>  $data');
    return await ApiScheme.initialisePostRequest(
        url: '${getBaseUrl(publicKey)}' + _completePurchaseUrl,
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

    var uri = Uri.parse('${getBaseUrl(token)}' + submitInspectionUrl);

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
