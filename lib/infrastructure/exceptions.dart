import 'dart:developer';

import 'package:face_net_authentication/constants/constants.dart';

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

class PasswordWrongException implements Exception {
  PasswordWrongException(this.errorCode, this.message);

  final int? errorCode;
  final String? message;
}

class RestApiExceptionWithMessage implements Exception {
  RestApiExceptionWithMessage(this.errorCode, this.message);

  final int? errorCode;
  final String? message;
}

class ExceptionDeterminate {
  //
  static Exception? throwByCode({
    required int errorCode,
    required String message,
  }) {
    //

    switch (errorCode) {
      case Constants.passWrongCode:
        return PasswordWrongException(errorCode, message);
      case Constants.passExpCode:
        return PasswordExpiredException(errorCode, message);
      default:
        return null;
    }
    //
  }
}

class NoConnectionException implements Exception {}

class UnknownException implements Exception {}
