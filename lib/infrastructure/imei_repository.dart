import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../domain/imei_failure.dart';
import 'credentials_storage/credentials_storage.dart';

class ImeiRepository {
  ImeiRepository(this._credentialsStorage);

  final CredentialsStorage _credentialsStorage;

  Future<bool> hasImei() => getImeiCredentials()
      .then((credentials) => credentials.fold((_) => false, (_) => true));

  Future<Either<ImeiFailure, String?>> getImeiCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        return left(ImeiFailure.empty());
      }

      return right(storedCredentials);
    } on FormatException {
      return left(ImeiFailure.errorParsing('Error while parsing'));
    } on PlatformException {
      return left(ImeiFailure.unknown(0, 'Platform exception while reading'));
    }
  }
}
