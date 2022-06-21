import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiScheme{

  static _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw (jsonDecode(response.body)['responseText']);

      case 401:
        throw 'Unauthorized request - ${jsonDecode(response.body)['responseText']}';

      case 403:
        throw 'Forbidden Error - ${jsonDecode(response.body)['responseText']}';
      case 404:
        throw 'Not Found - ${jsonDecode(response.body)['responseText']}';

      case 422:
        throw 'Unable to process - ${jsonDecode(response.body)['responseText']}';

      case 500:
        throw 'Server error - ${jsonDecode(response.body)['responseText']}';
      default:
        throw 'Error occurred with code : $response';
    }
  }

  static _isRequestSuccessful(int? statusCode) {
    return statusCode! >= 200 && statusCode < 300;
  }

  static _makeGetRequest({apiUrl, token}) async {
    final uri = Uri.parse(apiUrl);
    print(apiUrl);

    var headers;
    if (token != null) {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
    } else {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    }
    return await http.get(uri, headers: headers);
  }

  static _makePostRequest({apiUrl, data, token, apiKey}) async {
    final uri = Uri.parse(apiUrl);
    final jsonString = json.encode(data);
    print(data);
    print(apiUrl);
    print(apiKey);

    var headers;
    if (token != null) {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'x-api-id': '$apiKey',
      };
    } else if (apiKey == null) {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    } else {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-api-id': '$apiKey',

      };
    }
    return await http.post(uri, body: jsonString, headers: headers);
  }



  static initialisePostRequest(
      {required Map<String, dynamic> data,
        required String url,
        token,
        apiKey}) async {
    // if (await _checkConnectivity()) {
    try {
      var response = await _makePostRequest(
          apiUrl: url, data: data, token: token, apiKey: apiKey);
      var body = jsonDecode(response.body);
      print('response.statusCode');
      print(response.statusCode);
      print(response.body);
      if (_isRequestSuccessful(response.statusCode)) {
        return body;
      } else {
        return _handleError(response);
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
    // } else {
    //   return 'Check your internet connection';
    // }
  }



  static initialiseGetRequest({required String url, token}) async {
    // if (await _checkConnectivity()) {
    try {
      var response = await _makeGetRequest(apiUrl: url, token: token);
      var body = jsonDecode(response.body);
      print(response.statusCode);
      if (_isRequestSuccessful(response.statusCode)) {
        return body;
      } else {
        return _handleError(response);
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

}