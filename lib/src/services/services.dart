import 'package:my_cover_sdk/src/services/api_scheme.dart';
// import 'package:connectivity/connectivity.dart';

class WebServices {
  static const String _basUrl = 'https://staging.api.mycover.ai/v1';
  static const String _initialiseSdkUrl = '$_basUrl/sdk/initialize';
  static const String _buySdkUrl = '$_basUrl/sdk/buy';

  static const String productId = 'a72c4e3c-e868-4782-bb35-df6e3344ae6c';
  static const String userId = 'olakunle@mycovergenius.com';

  static initialiseSdk({
    required String userId,
    String? productId,
  }) async {
    var data;
    if (productId == '') {
      data = {
        "client_id": userId,
      };
    } else {
      data = {
        "client_id": userId,
        "product_id": productId,
      };
    }
    return await ApiScheme.initialisePostRequest(
        url: _initialiseSdkUrl, data: data);
  }

  static getListData(String url) async {
    return await ApiScheme.initialiseGetRequest(url: '$_basUrl$url');
  }

  static buyProduct({
    required String userId,
    required String apiKey,
    String? productId,
    payload,
    paymentChannel,
  }) async {
    //  payload = {
    //   "product_id": "a72c4e3c-e868-4782-bb35-df6e3344ae6c",
    //   "first_name": "Azeez",
    //   "last_name": "Bolu",
    //   "email": "azeez32365@gmail.com",
    //   "phone_number": "09044556744",
    //   "date_of_birth": "1990-12-12",
    //   "address": "Adeolu str Abuja ",
    //   "state": "Federal Capital Territory",
    //   "identification_name": "NIMC Card",
    //   "identification_url": "http://www.mycover.ai",
    //   "bvn": "12345678900",
    //   "registration_number": "jjj74hb",
    //   "vehicle_category": "Car",
    //   "vehicle_cost": 1000000,
    //   "year_of_manufacture": "2007",
    //   "title": "Chief"
    // };

    paymentChannel = {"channel": "ussd", "bank_code": "082", "amount": 1000000};

    var data = {
      "payload": payload,
      "payment_channel": paymentChannel,
    };

    return await ApiScheme.initialisePostRequest(
        url: _buySdkUrl, data: data, apiKey: apiKey);
  }
}
