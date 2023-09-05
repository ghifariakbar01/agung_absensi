import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/edit_failure.dart';
import 'package:face_net_authentication/infrastructure/profile/edit_profile_remote_service.dart';

import '../credentials_storage/credentials_storage.dart';
import '../exceptions.dart';

class EditProfileRepostiroy {
  EditProfileRepostiroy(this._profileRemoteService, this._credentialsStorage);

  final CredentialsStorage _credentialsStorage;
  final EditProfileRemoteService _profileRemoteService;

  Future<Either<EditFailure, String?>> getImei() async {
    try {
      final response = await _profileRemoteService.getImei();

      return right(response);
    } on RestApiExceptionWithMessage catch (e) {
      return left(EditFailure.server(e.errorCode, e.message));
    } on RestApiException catch (e) {
      return left(
          EditFailure.server(e.errorCode, 'RestApi exception get imei'));
    } on FormatException catch (e) {
      return left(EditFailure.server(0, e.message));
    } on PasswordExpiredException {
      return left(const EditFailure.passwordExpired());
    } on NoConnectionException {
      return left(const EditFailure.noConnection());
    }
  }

  Future<Either<EditFailure, Unit>> clearImei() async {
    try {
      final response = await _profileRemoteService.clearImei();

      return right(response);
    } on RestApiException catch (restApi) {
      return left(EditFailure.server(
          restApi.errorCode, 'RestApi exception clearing imei'));
    } on FormatException {
      return left(EditFailure.server(1, 'Error parse clearing imei'));
    } on NoConnectionException {
      return left(EditFailure.noConnection());
    }
  }

  Future<Either<EditFailure, Unit>> registerImei({required String imei}) async {
    try {
      final response = await _profileRemoteService.registerImei(imei: imei);

      return response.when(
          withImei: (imei) async {
            await _credentialsStorage.save(imei);

            return right(unit);
          },
          failure: ((errorCode, message) =>
              left(EditFailure.server(errorCode, message))));
    } on RestApiException catch (restApi) {
      return left(EditFailure.server(
          restApi.errorCode, 'RestApi exception register imei'));
    } on FormatException {
      return left(EditFailure.server(1, 'Error parse register imei'));
    } on NoConnectionException {
      return left(EditFailure.noConnection());
    }
  }

  Future<Either<EditFailure, Unit>> submitEdit({
    required String noTelp1,
    required String noTelp2,
    required String email1,
    required String email2,
  }) async {
    try {
      final response = await _profileRemoteService.submitEdit(
          noTelp1: noTelp1, noTelp2: noTelp2, email1: email1, email2: email2);

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
