import 'package:dartz/dartz.dart';

import 'api_response.dart';

class GenericResponse<T> {
  final bool success;
  final String message;
  final int responseCode;
  final List<String>? errors;
  // final String responseText;
  late final T? data;

  GenericResponse({
    // required this.responseText,
    this.responseCode = 0,
    this.success = false,
    this.message = '',
    this.errors = const [],
    this.data,
  });

  factory GenericResponse.fromJson(
    Either<Failure, Success> response, {
    Function? parseJson,
  }) {
    return response.fold(
      (failure) => GenericResponse(
        // responseText: failure.error.responseText,
        responseCode: failure.error.responseCode,
        errors: failure.error.errors,
        message: failure.error.message,
      ),
      (success) => GenericResponse(
        // responseText: success.data['responseText'],
        responseCode: success.data['responseCode'],
        success: true,
        message: success.data['message'] ?? "",
        data: parseJson != null
            ? parseJson(success.data['data'])
            : success.data['data'] ?? "",
      ),
    );
  }

  static List<String> getErrorMessage(Object? message) {
    if (message is List<String> && message.isNotEmpty) {
      return message;
    }
    if (message is String) return [message];
    return ["Something went wrong, try again!"];
  }
}
