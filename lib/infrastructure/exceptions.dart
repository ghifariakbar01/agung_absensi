class CacheException implements Exception {}

class RestApiException implements Exception {
  RestApiException(this.errorCode);

  final int? errorCode;
}

class PasswordExpiredException implements Exception {
  PasswordExpiredException(this.errorCode, this.message);

  final int? errorCode;
  final String? message;
}

class RestApiExceptionWithMessage implements Exception {
  RestApiExceptionWithMessage(this.errorCode, this.message);

  final int? errorCode;
  final String? message;
}

class NoConnectionException implements Exception {}

class UnknownException implements Exception {}
