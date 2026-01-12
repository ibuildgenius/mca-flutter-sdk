class ApiErrorResponse {
  final String message;
  final int responseCode;
  final List<String>? errors;
  final Map<String, dynamic>? data;

  const ApiErrorResponse(
      {this.message = "Request failed",
      this.responseCode = 0,
      this.errors = const [],
      this.data = const {}});
}
