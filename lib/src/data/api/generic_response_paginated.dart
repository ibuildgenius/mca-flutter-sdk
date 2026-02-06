import 'package:dartz/dartz.dart';

import 'api_response.dart';

class PaginatedResponse<T> {
  late final T? data;
  bool hasNextPage;

  PaginatedResponse({
    this.data,
    this.hasNextPage = false,
  });

  factory PaginatedResponse.fromJson(
    Either<Failure, Success> response, {
    Function? parseJson,
  }) {
    return response.fold(
      (failure) => PaginatedResponse(),
      (success) => PaginatedResponse(
          data: parseJson != null
              ? parseJson(success.data['data'])
              : success.data['data'] ?? "",
          hasNextPage: success.data['hasNextPage'] ?? false),
    );
  }
}
