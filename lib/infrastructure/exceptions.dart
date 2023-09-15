import 'dart:developer';

import 'package:face_net_authentication/constants/constants.dart';

class CacheException implements Exception {}

class RestApiException implements Exception {
  RestApiException(this.errorCode);

  final int? errorCode;
}

class RestApiExceptionWithMessage implements Exception {
  RestApiExceptionWithMessage(this.errorCode, this.message);

  final int? errorCode;
  final String? message;
}

class NoConnectionException implements Exception {}

class UnknownException implements Exception {}
