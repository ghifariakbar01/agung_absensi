import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../domain/edit_failure.dart';
import '../../domain/imei_failure.dart';
import '../../infrastructures/credentials_storage/credentials_storage.dart';
import '../../infrastructures/exceptions.dart';
import 'imei_remote_service.dart';

class ImeiRepository {
  ImeiRepository(this._credentialsStorage, this._remoteService);

  final CredentialsStorage _credentialsStorage;
  final ImeiRemoteService _remoteService;

  Future<bool> hasImei({required String idKary}) =>
      getImei(idKary: idKary).then((response) =>
          response.fold((_) => false, (imei) => imei != null ? true : false));

  Future<bool> clearImeiSuccess({required String idKary}) =>
      _clearImei(idKary: idKary)
          .then((value) => value.fold((_) => false, (_) => true));

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

  Future<Either<EditFailure, String?>> getImei({required String idKary}) async {
    try {
      final response = await _remoteService.getImei(idKary: idKary);

      return right(response);
    } on FormatException catch (e) {
      return left(EditFailure.server(0, e.message));
    } on NoConnectionException {
      return left(EditFailure.noConnection());
    } on RestApiExceptionWithMessage catch (e) {
      return left(EditFailure.server(e.errorCode, e.message));
    } on RestApiException catch (e) {
      return left(EditFailure.server(
        e.errorCode,
        'RestApi exception get imei',
      ));
    }
  }

  Future<Either<EditFailure, Unit>> _clearImei({required String idKary}) async {
    try {
      await _remoteService.clearImei(idKary: idKary);

      return right(unit);
    } on FormatException {
      return left(EditFailure.server(1, 'Error parse clearing imei'));
    } on NoConnectionException {
      return left(EditFailure.noConnection());
    } on RestApiExceptionWithMessage catch (e) {
      return left(EditFailure.server(e.errorCode, e.message));
    } on RestApiException catch (e) {
      return left(EditFailure.server(
        e.errorCode,
        'RestApi exception clearing imei',
      ));
    } catch (e) {
      return left(EditFailure.server(404, e.toString()));
    }
  }

  Future<Either<EditFailure, Unit>> logClearImei({
    required String imei,
    required String nama,
    required String idUser,
  }) async {
    try {
      final response = await _remoteService.logClearImei(
        imei: imei,
        nama: nama,
        idUser: idUser,
      );

      return right(response);
    } on RestApiExceptionWithMessage catch (restApi) {
      return left(EditFailure.server(restApi.errorCode, restApi.message));
    } on RestApiException catch (restApi) {
      return left(EditFailure.server(
          restApi.errorCode, 'RestApi exception clearing imei'));
    } on FormatException {
      return left(EditFailure.server(1, 'Error parse clearing imei'));
    } on NoConnectionException {
      return left(EditFailure.noConnection());
    }
  }

  Future<Either<EditFailure, Unit>> registerImei({
    required String imei,
    required String idKary,
  }) async {
    try {
      final response = await _remoteService.registerImei(
        imei: imei,
        idKary: idKary,
      );

      return response.when(withImei: (imei) async {
        await _credentialsStorage.save(imei);

        return right(unit);
      }, failure: ((errorCode, message) {
        return left(EditFailure.server(errorCode, message));
      }));
    } on RestApiException catch (e) {
      return left(
          EditFailure.server(e.errorCode, 'RestApi exception register imei'));
    } on FormatException catch (e) {
      return left(EditFailure.server(1, e.message));
    } on NoConnectionException {
      return left(EditFailure.noConnection());
    }
  }

  Future<Unit> registerImeiInline({
    required String imei,
    required String idKary,
  }) async {
    try {
      final response = await _remoteService.registerImei(
        imei: imei,
        idKary: idKary,
      );

      return response.when(withImei: (imei) async {
        await _credentialsStorage.save(imei);

        return unit;
      }, failure: ((errorCode, message) {
        throw EditFailure.server(errorCode, message);
      }));
    } catch (e) {
      rethrow;
    }
  }
}
