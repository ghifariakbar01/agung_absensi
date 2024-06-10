import 'package:dartz/dartz.dart';

import '../../domain/edit_failure.dart';
import '../../infrastructures/credentials_storage/credentials_storage.dart';
import '../../infrastructures/exceptions.dart';
import 'edit_profile_remote_service.dart';

class EditProfileRepostiroy {
  EditProfileRepostiroy(
    this._credentialsStorage,
    this._profileRemoteService,
  );

  final CredentialsStorage _credentialsStorage;
  final EditProfileRemoteService _profileRemoteService;

  Future<bool> hasImei({required String idKary}) =>
      getImei(idKary: idKary).then((response) =>
          response.fold((_) => false, (imei) => imei != null ? true : false));

  Future<bool> clearImeiSuccess({required String idKary}) =>
      clearImei(idKary: idKary).then(
        (value) => value.fold((_) => false, (_) => true),
      );

  Future<Either<EditFailure, String?>> getImei({required String idKary}) async {
    try {
      final response = await _profileRemoteService.getImei(idKary: idKary);

      return right(response);
    } on FormatException catch (e) {
      return left(EditFailure.server(0, e.message));
    } on NoConnectionException {
      return left(EditFailure.noConnection());
    } on RestApiExceptionWithMessage catch (e) {
      return left(EditFailure.server(e.errorCode, e.message));
    } on RestApiException catch (e) {
      return left(
          EditFailure.server(e.errorCode, 'RestApi exception get imei'));
    }
  }

  Future<Either<EditFailure, Unit>> clearImei({required String idKary}) async {
    try {
      await _profileRemoteService.clearImei(idKary: idKary);

      // debugger();

      return right(unit);
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

  Future<Either<EditFailure, Unit>> logClearImei({
    required String imei,
    required String nama,
    required String idUser,
  }) async {
    try {
      final response = await _profileRemoteService.logClearImei(
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
      final response = await _profileRemoteService.registerImei(
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

  Future<Either<EditFailure, Unit>> submitEdit({
    required String idKary,
    required String email1,
    required String email2,
    required String noTelp1,
    required String noTelp2,
  }) async {
    try {
      final response = await _profileRemoteService.submitEdit(
        idKary: idKary,
        email1: email1,
        email2: email2,
        noTelp1: noTelp1,
        noTelp2: noTelp2,
      );

      return right(response);
    } on RestApiException catch (restApi) {
      return left(EditFailure.server(restApi.errorCode, 'RestApi exception'));
    } on FormatException {
      return left(EditFailure.server(1, 'Error parse'));
    } on NoConnectionException {
      return left(EditFailure.noConnection());
    }
  }
}
