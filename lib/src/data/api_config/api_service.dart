import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../globals.dart';
import '../api/api_response.dart';
import '../api/error_response.dart';
import '../api/generic_response.dart';
import 'app_logger.dart';
//HELP

abstract class ApiService {
  late final Dio dio;

  ApiService({String? baseUrl}) {
    final options = BaseOptions(
      baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(
        seconds: 100,
      ),
      receiveTimeout: const Duration(
        seconds: 100,
      ),
    );
    dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          //no internet? reject request
          // if (!await ConnectionStatus.isConnected()) {
          //   handler.reject(
          //     DioError(
          //       requestOptions: options,
          //       error:
          //           "Oops! Looks like you're not connected to the internet. Check your internet connection and try again.",
          //     ),
          //   );
          // } else {

          handler.next(
              options); // Only call next if the request hasn't been rejected
          // }

          // handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 403) {
            handler.resolve(
              Response(
                  requestOptions: response.requestOptions,
                  statusCode: 403,
                  data: {
                    'message':
                        "Forbidden: You do not have access to this resource.",
                  }),
            );
          } else if (response.statusCode == 401) {
            //InactivityRedirect().redirectToLogin(logOutReason: "Error 401",);
          } else {
            handler.next(response);
          }
        },
        onError: (error, handler) async {
          AppLogger.log(error.response);
          if (error.response?.statusCode == 403) {
            //dio.interceptors.requestLock.lock();

            AppLogger.log("LAUNCH REFRESH TOKEN");

            handler.resolve(
              Response(
                  requestOptions: error.requestOptions,
                  statusCode: 403,
                  data: {
                    "message":
                        "Forbidden: You do not have access to this resource",
                  }),
            );
          } else if (error.response?.statusCode == 401) {
            //InactivityRedirect().redirectToLogin(logOutReason: "Error 401");
          } else {
            handler.next(error);
          }
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> getAuthorizedHeader() async {
    var header = {
      "Authorization": "Bearer ${Global.publicKey}",
      "Content-Type": "application/json",
    };

    return header;
  }

  Future<Either<Failure, Success>> get(
    path, {
    bool useToken = true,
    Map<String, dynamic>? data,
    bool isFullPath = false,
    Map<String, dynamic> headers = const {},
  }) async {
    var authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }
    final String fullPath = isFullPath ? path : "/$path";
    return makeRequest(
      dio.request(
        fullPath,
        data: data,
        options: Options(
          method: "GET",
          headers: {
            ...headers,
            ...authorizedHeader,
          },
        ),
      ),
    );
  }

  Future<GenericResponse<T>> getGeneric<T>(
    path, {
    bool useToken = true,
    Map<String, dynamic>? data,
    Map<String, dynamic> headers = const {},
    Function? converter,
  }) async {
    var authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }
    return makeGenericRequest<T>(
        dio.request("/$path",
            data: data,
            options: Options(
              method: "GET",
              headers: {
                ...headers,
                ...authorizedHeader,
              },
            )),
        converter: converter);
  }

  Future<Either<Failure, Success>> post(
    path, {
    bool useToken = true,
    bool useRefreshToken = false,
    dynamic data,
    Map<String, dynamic> headers = const {},
  }) async {
    var authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }
    return makeRequest(dio
        .post(
          "/$path",
          data: data,
          options: Options(
            headers: {
              ...headers,
              ...authorizedHeader,
            },
          ),
        )
        .whenComplete(() => null));
  }

  Future<GenericResponse<T>> postGeneric<T>(
    path, {
    bool useToken = true,
    dynamic data,
    Map<String, dynamic> headers = const {},
    Function? converter,
  }) async {
    var authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }
    return makeGenericRequest<T>(
        dio.post(
          "/$path",
          data: data,
          options: Options(
            headers: {
              ...headers,
              ...authorizedHeader,
            },
          ),
        ),
        converter: converter);
  }

  Future<Either<Failure, Success>> put(
    path, {
    Map<String, dynamic>? data,
    Map<String, dynamic> headers = const {},
    bool useToken = true,
    bool useRefreshToken = false,
  }) async {
    var authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }
    return makeRequest(
      dio.put(
        "/$path",
        data: data,
        options: Options(
          headers: {
            ...headers,
            ...authorizedHeader,
          },
        ),
      ),
    );
  }

  Future<Either<Failure, Success>> patch(
    path, {
    Map<String, dynamic>? data,
    Map<String, dynamic> headers = const {},
    bool useToken = true,
    bool useRefreshToken = false,
  }) async {
    var authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }
    return makeRequest(
      dio.patch(
        "/$path",
        data: data,
        options: Options(
          headers: {
            ...headers,
            ...authorizedHeader,
          },
        ),
      ),
    );
  }

  Future<GenericResponse<T>> patchGeneric<T>(path,
      {Map<String, dynamic>? data,
      Map<String, dynamic> headers = const {},
      bool useToken = true,
      Function? converter}) async {
    var authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }
    return makeGenericRequest<T>(
        dio.patch(
          "/$path",
          data: data,
          options: Options(
            headers: {
              ...headers,
              ...authorizedHeader,
            },
          ),
        ),
        converter: converter);
  }

  Future<Either<Failure, Success>> delete(
    path, {
    Map<String, dynamic>? data,
    Map<String, dynamic> headers = const {},
  }) async {
    var authorizedHeader = await getAuthorizedHeader();

    return makeRequest(
      dio.delete(
        "/$path",
        data: data,
        options: Options(
          headers: {
            ...headers,
            ...authorizedHeader,
          },
        ),
      ),
    );
  }

  Future<GenericResponse<T>> deleteGeneric<T>(path,
      {Map<String, dynamic>? data,
      Map<String, dynamic> headers = const {},
      Function? converter}) async {
    var authorizedHeader = await getAuthorizedHeader();

    return makeGenericRequest<T>(
        dio.delete(
          "/$path",
          data: data,
          options: Options(
            headers: {
              ...headers,
              ...authorizedHeader,
            },
          ),
        ),
        converter: converter);
  }

  Future<Either<Failure, Success>> makeRequest(Future<Response> future) async {
    try {
      var req = await future;
      var data = req.data;

      AppLogger.log(data);
      if (req.statusCode.toString().startsWith('2')) {
        //CHECK THAT STATUS IS NOT FALSE
        // if (data["success"] == true) {
        if (data["responseCode"] == 1) {
          return Right(Success(data));
        } else {
          return Left(
            Failure(
              ApiErrorResponse(
                responseCode: data['responseCode'],
                message: data["responseText"],
                errors: [data["responseText"]],
                data: data,
              ),
            ),
          );
        }
      }

      return Left(Failure.fromMap(data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        return Left(
          Failure(
            ApiErrorResponse(
              message:
                  "Oops. Check your internet connection and try again.${e.message}, ${e.error}",
            ),
          ),
        );
      }

      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          return Left(
            Failure(
              ApiErrorResponse(
                errors: [e.response?.data["responseText"]],
                responseCode: e.response?.data["responseCode"],
                message:
                    e.response?.data["responseText"] ?? "Resource not found",
              ),
            ),
          );
        }

        if (e.response?.data != null && e.response!.data is Map) {
          return Left(Failure.fromMap(e.response!.data));
        }

        return Left(
          Failure(
            ApiErrorResponse(errors: [e.response?.data["responseText"]]),

            // ApiErrorResponse(errors: [e.message.toString()]),
          ),
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        return Left(Failure(
          // ApiErrorResponse(errors: [e.message.toString()]),
          ApiErrorResponse(errors: [e.response?.data["responseText"]]),
        ));
      }
    }
  }

  Future<GenericResponse<T>> makeGenericRequest<T>(Future<Response> future,
      {Function? converter}) async {
    try {
      var req = await future;
      var data = req.data;

      AppLogger.log(data);

      if (req.statusCode.toString().startsWith('2')) {
        T? data0;
        if (data["data"] != null && converter != null) {
          data0 = converter(data["data"]);
        }

        return GenericResponse<T>(
            responseCode: data['responseCode'],
            success: data["success"],
            message: data["message"],
            data: data0);
      }

      return GenericResponse(
          responseCode: data['responseCode'],
          success: data["success"],
          message: data["message"]);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        return GenericResponse(
          message: "Oh dear! Check your internet connection and try again.",
        );
      }

      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          return GenericResponse(message: "Resource not found.");
        }

        // if (e.response?.data != null && e.response!.data is Map) {
        //   // var m = GenericResponse.getErrorMessage(e.response!.data);
        //   // return GenericResponse(
        //   //     message: "Oops. Check your internet connection and try again.");
        //   // return Left(Failure.fromMap(e.response!.data));
        // }

        return GenericResponse(
            responseCode: e.response!.data['responseCode'],
            message: e.response!.data['responseText'],
            errors: [e.response?.data["responseText"]]);
        // e.message.toString()
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        return GenericResponse(errors: [e.response?.data["responseText"]]);
        // e.message.toString()
      }
    }
  }
}
