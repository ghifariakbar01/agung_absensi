import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../domain/auth_failure.dart';
import '../../domain/user_failure.dart';
import '../../domain/value_objects_copy.dart';
import '../credentials_storage/credentials_storage.dart';
import '../exceptions.dart';
import 'auth_remote_service.dart';

class AuthRepository {
  AuthRepository(
    this._credentialsStorage,
    this._remoteService,
  );

  final CredentialsStorage _credentialsStorage;
  final AuthRemoteService _remoteService;

  Future<bool> isSignedIn() => getSignedInCredentials()
      .then((credentials) => credentials.fold((_) => false, (_) => true));

  Future<String> getUserString() => getSignedInCredentials()
      .then((value) => value.fold((_) => '', (userString) => userString ?? ''));

  Future<Either<AuthFailure, Unit>> signOut() async {
    // try {
    //   await _remoteService.signOut();
    // } on RestApiException catch (e) {
    //   return left(AuthFailure.server(e.errorCode));
    // } on NoConnectionException {
    //   // Ignoring
    // }

    return clearCredentialsStorage();
  }

  Future<Either<AuthFailure, Unit>> signInWithIdKaryawanUsernameAndPassword(
      {required UserId userId,
      required Password password,
      required PTName server}) async {
    try {
      final userIdStr = userId.getOrCrash();
      final passwordStr = password.getOrCrash();
      final serverStr = server.getOrCrash();

      final authResponse = await _remoteService.signIn(
          userId: userIdStr, password: passwordStr, server: serverStr);

      return authResponse.when(
        withUser: (user) async {
          final userSave = jsonEncode(user);

          log('jsonEncode(user) ${jsonEncode(user)}');

          await _credentialsStorage.save(userSave);

          return right(unit);
        },
        failure: (errorCode, message) => left(AuthFailure.server(
          errorCode,
          message,
        )),
      );
    } on RestApiException catch (e) {
      return left(AuthFailure.server(e.errorCode));
    } on PasswordWrongException {
      return left(const AuthFailure.passwordWrong());
    } on PasswordExpiredException {
      return left(const AuthFailure.passwordExpired());
    } on NoConnectionException {
      return left(const AuthFailure.noConnection());
    }
  }

  Future<Either<AuthFailure, Unit>> saveUserAfterUpdate(
      {required IdKaryawan idKaryawan,
      required UserId userId,
      required Password password,
      required PTName server}) async {
    try {
      final userIdStr = userId.getOrCrash();
      final passwordStr = password.getOrCrash();
      final serverStr = server.getOrCrash();

      final authResponse = await _remoteService.signIn(
          userId: userIdStr.toString(),
          password: passwordStr,
          server: serverStr);

      return await authResponse.when(
        withUser: (user) async {
          final userSave = jsonEncode(user);

          log('jsonEncode(user) ${jsonEncode(user)}');

          await _credentialsStorage.save(userSave);

          return right(unit);
        },
        failure: (errorCode, message) => left(AuthFailure.server(
          errorCode,
          message,
        )),
      );
    } on RestApiException catch (e) {
      return left(AuthFailure.server(e.errorCode));
    } on PasswordWrongException {
      return left(const AuthFailure.passwordWrong());
    } on PasswordExpiredException {
      return left(const AuthFailure.passwordExpired());
    } on NoConnectionException {
      return left(const AuthFailure.noConnection());
    }
  }

  Future<Either<UserFailure, String?>> getSignedInCredentials() async {
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
}
