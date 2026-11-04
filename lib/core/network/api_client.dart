/// Narrow HTTP port. Concrete client (e.g. `http` / Dio) lives in an adapter
/// after package approval — domain and UI must depend on this contract only.
abstract interface class ApiClient {
  Future<ApiResponse> send(ApiRequest request);
}

final class ApiRequest {
  const ApiRequest({
    required this.method,
    required this.path,
    this.body,
    this.headers = const {},
  });

  final String method;
  final String path;
  final Object? body;
  final Map<String, String> headers;
}

final class ApiResponse {
  const ApiResponse({
    required this.statusCode,
    this.body,
    this.headers = const {},
  });

  final int statusCode;
  final Object? body;
  final Map<String, String> headers;
}
