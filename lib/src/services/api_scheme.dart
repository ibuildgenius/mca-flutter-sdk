import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiScheme {
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

  static _makeGetRequest({apiUrl, token, apiKey}) async {
    final uri = Uri.parse(apiUrl);

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'x-api-id': '$apiKey',
    };

    return await http.get(uri, headers: headers);
  }

  static _makePostRequest({apiUrl, data, token, apiKey}) async {
    final uri = Uri.parse(apiUrl);
    final jsonString = json.encode(data);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'x-api-id': '$apiKey',
    };
    return await http.post(uri, body: jsonString, headers: headers);
  }

  static initialisePostRequest(
      {required Map<String, dynamic> data,
      required String url,
      apiKey,
      required String token}) async {

    try {
      var response =
          await _makePostRequest(apiUrl: url, data: data, token: token);
      var body = jsonDecode(response.body);
      if (_isRequestSuccessful(response.statusCode)) {
        return body;
      } else {
        return _handleError(response);
      }
    } catch (e) {
      return e.toString();
    }
  }

  static initialiseGetRequest({required String url, token, apiKey}) async {
    try {
      var response = await _makeGetRequest(apiUrl: url, token: token);
      var body = jsonDecode(response.body);
      if (_isRequestSuccessful(response.statusCode)) {
        return body;
      } else {
        return _handleError(response);
      }
    } catch (e) {
      return e.toString();
    }
  }
}
