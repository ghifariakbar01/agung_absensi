import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/infrastructures/cache_storage/imei_storage.dart';
import 'package:flutter/services.dart';

import '../../domain/imei_failure.dart';
import '../../infrastructures/cache_storage/imei_checked_storage.dart';
import '../../infrastructures/exceptions.dart';
import '../application/imei_register_state.dart';
import 'imei_remote_service.dart';

class ImeiRepository {
  ImeiRepository(
    this._credentialsStorage,
    this._checkedStorage,
    this._remoteService,
  );

  final ImeiSecureCredentialsStorage _credentialsStorage;
  final ImeiCheckedStorage _checkedStorage;
  final ImeiRemoteService _remoteService;

  Future<bool> hasImei({required String idKary}) =>
      getImei(idKary: idKary).then((response) => response.fold(
            (_) => false,
            (imei) => imei != null ? true : false,
          ));

  Future<bool> hasCheckedImei() =>
      getHasCheckedImei().then((response) => response.fold(
            (_) => false,
            (checked) => checked != null ? true : false,
          ));

  Future<bool> clearImeiSuccess({required String idKary}) =>
      _clearImei(idKary: idKary)
          .then((value) => value.fold((_) => false, (_) => true));

  Future<Either<ImeiFailure, String?>> getImeiCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        return left(ImeiFailure.storage());
      }

      return right(storedCredentials);
    } on PlatformException {
      return left(ImeiFailure.storage());
    } on FormatException catch (e) {
      return left(ImeiFailure.formatException(e.message));
    } catch (_) {
      rethrow;
    }
  }

  Future<Either<ImeiFailure, Unit?>> clearImeiCredentials() async {
    try {
      if (Platform.isAndroid) {
        return right(unit);
      }

      final storedCredentials = await _credentialsStorage.read();

      if (storedCredentials == null) {
        return left(const ImeiFailure.storage());
      }

      await _credentialsStorage.clear();
      return right(unit);
    } on PlatformException {
      return left(const ImeiFailure.storage());
    } catch (_) {
      rethrow;
    }
  }

  Future<Either<ImeiFailure, String?>> getImei({required String idKary}) async {
    try {
      final response = await _remoteService.getImei(idKary: idKary);
      return right(response);
    } on RestApiExceptionWithMessage catch (e) {
      return left(ImeiFailure.server(e.errorCode, e.message));
    } on RestApiException catch (e) {
      return left(ImeiFailure.server(
        e.errorCode,
        'RestApi exception get imei',
      ));
    } on NoConnectionException {
      return left(ImeiFailure.noConnection());
    } on FormatException catch (e) {
      return left(ImeiFailure.formatException(e.message));
    } catch (_) {
      rethrow;
    }
  }

  Future<Either<ImeiFailure, Unit?>> getHasCheckedImei() async {
    try {
      final response = await _checkedStorage.read();

      if (response == null) {
        return left(ImeiFailure.storage());
      } else {
        return right(unit);
      }
    } on PlatformException {
      return left(ImeiFailure.storage());
    } on FormatException catch (e) {
      return left(ImeiFailure.formatException(e.message));
    } catch (_) {
      rethrow;
    }
  }

  Future<Either<ImeiFailure, Unit>> _clearImei({required String idKary}) async {
    try {
      await _remoteService.clearImei(idKary: idKary);

      return right(unit);
    } on RestApiExceptionWithMessage catch (e) {
      return left(ImeiFailure.server(e.errorCode, e.message));
    } on RestApiException catch (e) {
      return left(ImeiFailure.server(
        e.errorCode,
        'RestApi exception clearing imei',
      ));
    } on FormatException catch (e) {
      return left(ImeiFailure.formatException(e.message));
    } on NoConnectionException {
      return left(ImeiFailure.noConnection());
    } catch (e) {
      rethrow;
    }
  }

  Future<Unit> logClearImei({
    required String imei,
    required String nama,
    required String idUser,
  }) async {
    return _remoteService.logClearImei(
      imei: imei,
      nama: nama,
      idUser: idUser,
    );
  }

  Future<Either<ImeiFailure, Unit>> registerImei({
    required String imei,
    required String idKary,
  }) async {
    final ImeiRegisterResponse response = await _remoteService.registerImei(
      imei: imei,
      idKary: idKary,
    );

    return response.when(withImei: (imei) async {
      try {
        await _credentialsStorage.save(imei);

        return right(unit);
      } on FormatException catch (e) {
        return left(ImeiFailure.formatException(e.message));
      } on PlatformException {
        return left(ImeiFailure.storage());
      }
    }, failure: ((errorCode, message) {
      //
      if (errorCode == 404) {
        return left(ImeiFailure.noConnection());
      } else {
        return left(ImeiFailure.server(
          errorCode,
          message,
        ));
      }
    }));
  }
}
