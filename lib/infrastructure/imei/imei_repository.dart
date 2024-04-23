import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../domain/imei_failure.dart';
import '../credentials_storage/credentials_storage.dart';

class ImeiRepository {
  ImeiRepository(this._credentialsStorage);

  final CredentialsStorage _credentialsStorage;

  Future<Either<ImeiFailure, String?>> getImeiCredentials() async {
    try {
      // debugger();
      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        // debugger();

        return left(ImeiFailure.empty());
      }

      // debugger();

      return right(storedCredentials);
    } on FormatException catch (e) {
      return left(ImeiFailure.errorParsing(e.message));
    } on PlatformException {
      return left(ImeiFailure.storage());
    }
  }

  Future<Either<ImeiFailure, Unit?>> clearImeiCredentials() async {
    try {
      // Bypass Clear Imei for Android Devices
      if (Platform.isAndroid) {
        return right(unit);
      }

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
