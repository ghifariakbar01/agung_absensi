import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../domain/password_expired_failure.dart';
import 'credentials_storage/credentials_storage.dart';

class PasswordExpiredRepository {
  PasswordExpiredRepository(this._credentialsStorage);

  final CredentialsStorage _credentialsStorage;

  Future<bool> isPasswordExpired() => getPasswordExpiredStorage()
      .then((credentials) => credentials.fold((_) => false, (_) => true));

  Future<Either<PasswordExpiredFailure, String?>>
      getPasswordExpiredStorage() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        return left(PasswordExpiredFailure.empty());
      }

      return right(storedCredentials);
    } on FormatException {
      return left(PasswordExpiredFailure.errorParsing('Error while parsing'));
    } on PlatformException {
      return left(PasswordExpiredFailure.storage());
    }
  }

  Future<Either<PasswordExpiredFailure, Unit>> passwordExpired() async {
    try {
      await _credentialsStorage.save('${DateTime.now()}');

      return right(unit);
    } on PlatformException {
      return left(PasswordExpiredFailure.storage());
    }
  }

  Future<Either<PasswordExpiredFailure, Unit>> clearPasswordExpired() async {
    try {
      await _credentialsStorage.clear();

      return right(unit);
    } on PlatformException {
      return left(PasswordExpiredFailure.storage());
    }
  }
}
