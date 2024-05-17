import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../domain/auth_failure.dart';
import '../../domain/user_failure.dart';
import '../../domain/value_objects_copy.dart';

import '../../infrastructures/credentials_storage/credentials_storage.dart';
import '../../infrastructures/exceptions.dart';
import '../../user/application/user_model.dart';
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
    return clearCredentialsStorage();
  }

  Future<void> saveUser(UserModelWithPassword user) async {
    final _encode = jsonEncode(user);
    return _credentialsStorage.save(_encode);
  }

  Future<Either<AuthFailure, Unit>> signInWithIdKaryawanUsernameAndPasswordACT({
    required PTName server,
    required UserId userId,
    required Password password,
  }) async {
    try {
      final serverStr = server.getOrCrash();
      final userIdStr = userId.getOrCrash();
      final passwordStr = password.getOrCrash();

      final authResponse = await _remoteService.signInACT(
        server: serverStr,
        userId: userIdStr,
        password: passwordStr,
      );

      return await authResponse.when(
        withUser: (user) async {
          await saveUser(user);
          await saveUser(user);

          return right(unit);
        },
        failure: (errorCode, message) {
          return left(AuthFailure.server(
            errorCode,
            message,
          ));
        },
      );
    } on RestApiException catch (e) {
      return left(AuthFailure.server(e.errorCode));
    } on NoConnectionException {
      return left(const AuthFailure.noConnection());
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> signInWithIdKaryawanUsernameAndPasswordARV({
    required PTName server,
    required UserId userId,
    required Password password,
  }) async {
    try {
      final serverStr = server.getOrCrash();
      final userIdStr = userId.getOrCrash();
      final passwordStr = password.getOrCrash();

      final authResponse = await _remoteService.signInARV(
        server: serverStr,
        userId: userIdStr,
        password: passwordStr,
      );

      return await authResponse.when(
        withUser: (user) async {
          String userSave = jsonEncode(user);
          await _credentialsStorage.save(userSave);
          await _credentialsStorage.save(userSave);
          await _credentialsStorage.save(userSave);

          return right(unit);
        },
        failure: (errorCode, message) {
          return left(AuthFailure.server(
            errorCode,
            message,
          ));
        },
      );
    } on RestApiException catch (e) {
      return left(AuthFailure.server(e.errorCode));
    } on NoConnectionException {
      return left(const AuthFailure.noConnection());
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> saveUserAfterUpdate({
    required PTName server,
    required UserId userId,
    required Password password,
  }) async {
    try {
      final serverStr = server.getOrCrash();

      if (serverStr == 'gs_18') {
        //
        return signInWithIdKaryawanUsernameAndPasswordARV(
            server: server, userId: userId, password: password);
      } else {
        //
        return signInWithIdKaryawanUsernameAndPasswordACT(
            server: server, userId: userId, password: password);
      }
    } on RestApiException catch (e) {
      return left(AuthFailure.server(e.errorCode));
    } on PlatformException {
      return left(const AuthFailure.storage());
    } on NoConnectionException {
      return left(const AuthFailure.noConnection());
    }
  }

  Future<Unit> saveUserPayrollOnCreateFormSakit({
    required PTName server,
    required UserId userId,
    required Password password,
  }) async {
    final serverStr = server.getOrCrash();
    final userIdStr = userId.getOrCrash();
    final passwordStr = password.getOrCrash();

    if (serverStr == 'gs_18') {
      final authResponse = await _remoteService.signInARV(
          userId: userIdStr.toString(),
          password: passwordStr,
          server: serverStr);

      return await authResponse.when(
        withUser: (user) async {
          String userSave = jsonEncode(user);
          await _credentialsStorage.save(userSave);
          await _credentialsStorage.save(userSave);
          await _credentialsStorage.save(userSave);

          return unit;
        },
        failure: (errorCode, message) {
          throw AuthFailure.server(
            errorCode,
            message,
          );
        },
      );
    } else {
      final authResponse = await _remoteService.signInACT(
          userId: userIdStr.toString(),
          password: passwordStr,
          server: serverStr);

      return await authResponse.when(
        withUser: (user) async {
          String userSave = jsonEncode(user);
          await _credentialsStorage.save(userSave);
          await _credentialsStorage.save(userSave);
          await _credentialsStorage.save(userSave);

          return unit;
        },
        failure: (errorCode, message) {
          throw AuthFailure.server(
            errorCode,
            message,
          );
        },
      );
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

  // LOGOUT
  // try {
  //   await _remoteService.signOut();
  // } on RestApiException catch (e) {
  //   return left(AuthFailure.server(e.errorCode));
  // } on NoConnectionException {
  //   // Ignoring
  // }
}
