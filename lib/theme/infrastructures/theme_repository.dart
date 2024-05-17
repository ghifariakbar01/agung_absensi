import 'package:dartz/dartz.dart';

import 'package:flutter/services.dart';

import '../../infrastructures/credentials_storage/credentials_storage.dart';

// '','dark', 'light'

class ThemeRepository {
  ThemeRepository(this._credentialsStorage);

  final CredentialsStorage _credentialsStorage;

  Future<String?> getTheme() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        return null;
      }

      return storedCredentials;
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on PlatformException {
      throw PlatformException(code: 'Something Wrong with Storage');
    }
  }

  Future<Unit> saveTheme(String mode) async {
    try {
      await _credentialsStorage.save(mode);

      return unit;
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on PlatformException {
      throw PlatformException(
          code: 'Something Wrong with Storage While Saving Theme');
    }
  }

  Future<Unit?> clearImeiCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        return null;
      }

      await _credentialsStorage.clear();

      return unit;
    } on PlatformException {
      throw PlatformException(code: 'Something Wrong with Storage');
    }
  }
}
