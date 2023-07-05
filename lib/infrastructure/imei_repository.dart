import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../domain/auth_failure.dart';
import '../domain/user_failure.dart';
import 'credentials_storage/credentials_storage.dart';

class ImeiRepository {
  ImeiRepository(this._credentialsStorage);

  final CredentialsStorage _credentialsStorage;

  Future<bool> hasImei() => getImeiCredentials()
      .then((credentials) => credentials.fold((_) => false, (_) => true));

  Future<Either<UserFailure, String?>> getImeiCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        return left(UserFailure.empty());
      }

      return right(storedCredentials);
    } on FormatException {
      return left(UserFailure.errorParsing('Error while parsing'));
    } on PlatformException {
      return left(UserFailure.unknown(0, 'Platform exception while reading'));
    }
  }

  Future<Either<AuthFailure, Unit>> clearCredentialsStorage() async {
    try {
      await _credentialsStorage.clear();
      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Unit> saveImei({required String imei}) async {
    await _credentialsStorage.save(imei);
    return unit;
  }
}
