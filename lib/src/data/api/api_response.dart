import 'error_response.dart';

abstract class ApiResponse {}

class Success extends ApiResponse {
  final Map<String, dynamic> data;

  Success(this.data);
}

class Failure extends ApiResponse {
  final ApiErrorResponse error;

  Failure(this.error);

  factory Failure.fromMap(Map<String, dynamic> json) {
    // List<dynamic> errors = json['errors']; // assume json is a Map

    // List<String> errorStrings =
    //     errors.map((error) => error.toString()).toList();

    return Failure(
      ApiErrorResponse(
          message: "",
          // errors: errorStrings,
          responseCode: json['responseCode'],
          errors: getErrorMessage(json['responseText'] ?? ['errors']),
          data: json),
    );
  }

  static List<String> getErrorMessage(Object? message) {
    if ((message is List<String>) && message.isNotEmpty) {
      return message;
    }
    if (message is List<dynamic>) {
      // Convert List<dynamic> to List<String>
      return message.map((item) => item.toString()).toList();
    }
    if (message is String) return [message];
    return ["Something went wrong, try again!"];
  }
}
