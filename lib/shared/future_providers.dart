import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/assets.dart';

import '../user/application/user_model.dart';
import '../user/application/user_notifier.dart';
import '../widgets/v_dialogs.dart';
import 'providers.dart';

final Map<String, String> _mapPT = {
  // 'gs_12': 'http://agungcartrans.co.id:1232/services',
  'gs_12': 'https://www.agunglogisticsapp.co.id:2002/services',
  'gs_14': 'https://agungcartrans.co.id:2601/services',
  'gs_18': 'https://www.agunglogisticsapp.co.id:2002/services',
  'gs_21': 'https://www.agunglogisticsapp.co.id:3603/services',
};

_determineBaseUrl(UserModelWithPassword user) {
  final pt = user.ptServer;
  if (pt == null) {
    throw AssertionError('pt null');
  }

  return _mapPT.entries
      .firstWhere(
        (element) => element.key == pt,
        orElse: () => _mapPT.entries.first,
      )
      .value;
}

// 1. GET AND SET USER
final getUserFutureProvider = FutureProvider<Unit>((ref) async {
  UserNotifier userNotifier = ref.read(userNotifierProvider.notifier);
  String userString = await userNotifier.getUserString();

  // PARSE USER SUCCESS / FAILURE
  if (userString.isNotEmpty) {
    final json = jsonDecode(userString) as Map<String, Object?>;
    final user = UserModelWithPassword.fromJson(json);

    ref.read(dioProviderCuti)
      ..options = BaseOptions(
        connectTimeout: 20000,
        receiveTimeout: 20000,
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
      //
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

/*

  ref.read(initUserStatusNotifierProvider.notifier).letYouThrough();

  ---

  is connected to route notifier, 
  which bypass current route directly to home

*/

// 2. INIT IMEI WITH USER
final imeiInitFutureProvider =
    FutureProvider.family<Unit, BuildContext>((ref, context) async {
  try {
    ref.invalidate(getUserFutureProvider);
    await ref.read(getUserFutureProvider.future);
  } catch (e) {
    throw AssertionError('Error validating user. Error : $e');
  }

  final user = ref.read(userNotifierProvider).user;

  if (user.IdKary!.isNotEmpty) {
    final String? imeiDb;

    try {
      final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
      // 3. GET IMEI DATA
      String imei = await imeiNotifier.getImeiString();

      imeiNotifier.changeSavedImei(imei);

      imeiDb =
          await imeiNotifier.getImeiStringDb(idKary: user.IdKary ?? 'null');

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

final userInitFutureProvider =
    FutureProvider.family<void, BuildContext>((ref, context) async {
  final update = ref.read(userNotifierProvider).failureOrSuccessOptionUpdate;

  if (update != none()) {
    return Future.delayed(
        Duration(seconds: 1),
        () => update.fold(
            () {},
            (either) => either.fold(
                    (failure) => failure.maybeMap(
                          noConnection: (_) => ref
                              .read(initUserStatusNotifierProvider.notifier)
                              .letYouThrough(),
                          orElse: () => showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => VSimpleDialog(
                              label: 'Error',
                              asset: Assets.iconCrossed,
                              labelDescription: failure.maybeMap(
                                orElse: () => '',
                                storage: (_) => 'Storage Penuh',
                                server: (server) =>
                                    '${server.errorCode} ${server.message}',
                              ),
                            ),
                          ),
                        ), (_) async {
                  ref.invalidate(getUserFutureProvider);
                  await ref.read(getUserFutureProvider.future);
                })));
  }
});
