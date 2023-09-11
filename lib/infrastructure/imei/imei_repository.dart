import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../domain/imei_failure.dart';
import '../credentials_storage/credentials_storage.dart';

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
    } on FormatException catch (e) {
      return left(ImeiFailure.errorParsing(e.message));
    } on PlatformException {
      return left(ImeiFailure.storage());
    }
  }

  Future<Either<ImeiFailure, Unit?>> clearImeiCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        return left(const ImeiFailure.empty());
      }

      await _credentialsStorage.clear();

      return right(unit);
    } on PlatformException {
      return left(const ImeiFailure.storage());
    }
  }
}
