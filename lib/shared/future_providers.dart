import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/infrastructures/auth_repository.dart';
import '../constants/constants.dart';
import '../cross_auth/application/cross_auth_notifier.dart';
import '../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../user/application/user_model.dart';
import 'providers.dart';

_determineBaseUrl(UserModelWithPassword user) {
  final pt = user.ptServer;
  if (pt == null) {
    throw AssertionError('pt null');
  }

  return Constants.ptMap.entries
      .firstWhere(
        (element) => element.key == pt,
        orElse: () => Constants.ptMap.entries.first,
      )
      .value;
}

// 1. GET AND SET USER
final getUserFutureProvider = FutureProvider<Unit>((ref) async {
  AuthRepository _repo = ref.read(authRepositoryProvider);
  final userString = await _repo.getUserString();

  final userNotifier = ref.read(userNotifierProvider.notifier);

  // PARSE USER SUCCESS / FAILURE
  if (userString.isNotEmpty) {
    final json = jsonDecode(userString) as Map<String, Object?>;
    final user = UserModelWithPassword.fromJson(json);

    ref.read(dioProviderCuti)
      ..options = BaseOptions(
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        validateStatus: (status) {
          return true;
        },
        baseUrl: _determineBaseUrl(user),
      )
      ..interceptors.add(ref.read(authInterceptorTwoProvider));

    ref.read(dioProviderCutiServer)
      ..options = BaseOptions(
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        validateStatus: (status) {
          return true;
        },
        baseUrl: _determineBaseUrl(user),
      );

    if (user.IdKary == null) {
      // IF USER ID KARYAWAN NULL LOGOUT, MAKE USER LOGIN AGAIN
      await ref.read(userNotifierProvider.notifier).logout();
      return unit;
    }

    if (user.staf == null) {
      // IF USER STAFF NULL LOGOUT, MAKE USER LOGIN AGAIN
      await userNotifier.logout();
      return unit;
    }

    final ptServer = user.ptServer;
    // IF USER PT_SERVER TESTING
    if (ptServer != null) {
      if (ptServer.toLowerCase() == 'gs_testing') {
        await userNotifier.logout();
        return unit;
      }
    }

    if (json.isNotEmpty) {
      await userNotifier.onUserParsedRaw(ref: ref, user: user);
      return unit;
    }

    throw AssertionError('Error while getUserFutureProvider');
  } else {
    throw AssertionError(
        'Error while getUserFutureProvider : userString empty');
  }
});

// 2. INIT IMEI WITH USER
final imeiInitFutureProvider =
    FutureProvider.family<Unit, BuildContext>((ref, context) async {
  try {
    AuthRepository _repo = ref.read(authRepositoryProvider);
    final userString = await _repo.getUserString();

    final json = jsonDecode(userString) as Map<String, Object?>;
    final user = UserModelWithPassword.fromJson(json);

    final _data = await ref.read(isUserCrossedProvider.future);

    if (user.IdKary!.isEmpty) {
      // uncross
      final _isCrossed = _data.when(
        crossed: () => true,
        notCrossed: () => false,
      );

      final _ptMap = await ref
          .read(firebaseRemoteConfigNotifierProvider.notifier)
          .getPtMap();

      if (_isCrossed) {
        await ref.read(crossAuthNotifierProvider.notifier).uncrossStl(
              url: _ptMap,
              userId: user.nama!,
              password: user.password!,
            );
      }
    } else {}
  } catch (e) {
    throw AssertionError('Error validating cross server. Error : $e');
  }

  try {
    ref.invalidate(getUserFutureProvider);
    await ref.read(getUserFutureProvider.future);
  } catch (e) {
    throw AssertionError('Error validating user. Error : $e');
  }

  AuthRepository _repo = ref.read(authRepositoryProvider);
  final userString = await _repo.getUserString();

  final json = jsonDecode(userString) as Map<String, Object?>;
  final user = UserModelWithPassword.fromJson(json);

  if (user.IdKary!.isNotEmpty) {
    final String? imeiDb;

    try {
      final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
      // 3. GET IMEI DATA
      String imei = await imeiNotifier.getImeiString();

      await Future.delayed(
        Duration(seconds: 1),
        () => imeiNotifier.changeSavedImei(imei),
      );

      imeiDb = await imeiNotifier.getImeiStringDb(
        idKary: user.IdKary ?? 'null',
      );

      await ref
          .read(imeiAuthNotifierProvider.notifier)
          .checkAndUpdateImei(imeiDb: imeiDb);
    } catch (e) {
      throw AssertionError('Error validating imei. Error : $e');
    }

    // 4. PROCESS IMEI DATA
    // IF OFFLINE FROM USER INIT
    final isOfflineFromInit = ref.read(absenOfflineModeProvider);

    if (!isOfflineFromInit) {
      await ref
          .read(imeiNotifierProvider.notifier)
          .processImei(imei: imeiDb, ref: ref, context: context);

      return unit;
    } else {
      // IF CURRENT APP IS OFFLINE
      ref.read(initUserStatusNotifierProvider.notifier).letYouThrough();
      return unit;
    }
  } else {
    throw AssertionError('Error validating user. IdKary user is empty');
  }
});
