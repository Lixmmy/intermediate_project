class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() {
    return 'message';
  }
}

class DoesNotFoundTokenException implements Exception {
  final String message;

  DoesNotFoundTokenException(this.message);

  @override
  String toString() {
    return 'message';
  }
}
