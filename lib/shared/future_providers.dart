import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/helper.dart';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/infrastructures/auth_repository.dart';
import '../constants/constants.dart';
import '../features/cross_auth/application/cross_auth_notifier.dart';
import '../features/ip/application/ip_notifier.dart';
import '../features/user/application/user_model.dart';
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
  //
  AuthRepository _repo = ref.read(authRepositoryProvider);
  final userString = await _repo.getUserString();

  final json = jsonDecode(userString) as Map<String, Object?>;
  final user = UserModelWithPassword.fromJson(json);

  if (user.IdKary == null) {
    final helper = HelperImpl();
    await helper.storageDebugMode(ref, isDebug: true);
    throw AssertionError('Error validating user. IdKary user is null');
  }

  await ref.read(crossAuthNotifierProvider.notifier).obliterate();

  try {
    // ignore: unused_result
    await ref.refresh(getUserFutureProvider.future);
  } catch (e) {
    final helper = HelperImpl();
    await helper.storageDebugMode(ref, isDebug: true);
    throw AssertionError('Error validating user. Error : $e');
  }

  try {
    final String ptServer = user.ptServer ?? '';
    ref.read(ipNotifierProvider.notifier).initUrlFromPtServer(ptServer);
  } catch (e) {
    throw AssertionError('Error while initUrlFromPtServer');
  }

  ref.read(initUserStatusNotifierProvider.notifier).letYouThrough();

  return unit;
});
