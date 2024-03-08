import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/assets.dart';

import '../user/application/user_model.dart';
import '../user/application/user_notifier.dart';
import '../widgets/v_dialogs.dart';
import 'providers.dart';

// 1. GET AND SET USER
final getUserFutureProvider = FutureProvider<Unit>((ref) async {
  UserNotifier userNotifier = ref.read(userNotifierProvider.notifier);
  String userString = await userNotifier.getUserString();

  // PARSE USER SUCCESS / FAILURE
  if (userString.isNotEmpty) {
    final json = jsonDecode(userString) as Map<String, Object?>;
    final user = UserModelWithPassword.fromJson(json);

    if (user.staf == null) {
      // IF USER STAFF NULL LOGOUT, MAKE USER LOGIN AGAIN
      await ref.read(userNotifierProvider.notifier).logout();
      return unit;
    }

    if (json.isNotEmpty) {
      await ref
          .read(userNotifierProvider.notifier)
          .onUserParsedRaw(ref: ref, userModelWithPassword: user);
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
    log('imeiInitFutureProvider -- 1');
    ref.invalidate(getUserFutureProvider);
    await ref.read(getUserFutureProvider.future);
  } catch (e) {
    throw AssertionError('Error validating user. Error : $e');
  }

  log('imeiInitFutureProvider -- 2');
  final user = ref.read(userNotifierProvider).user;
  final hasIdKary = user.IdKary != null;
  if (hasIdKary) {
    //
    if (user.IdKary!.isNotEmpty) {
      final String? imeiDb;

      try {
        log('imeiInitFutureProvider -- 3');
        final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
        // 3. GET IMEI DATA
        String imei = await imeiNotifier.getImeiString();
        log('imeiInitFutureProvider -- 4 -- getImeiString');
        await Future.delayed(
            Duration(seconds: 1), () => imeiNotifier.changeSavedImei(imei));
        log('imeiInitFutureProvider -- 5 -- getImeiStringDb');
        imeiDb =
            await imeiNotifier.getImeiStringDb(idKary: user.IdKary ?? 'null');
        log('imeiInitFutureProvider -- 6 -- checkAndUpdateImei');
        await ref
            .read(imeiAuthNotifierProvider.notifier)
            .checkAndUpdateImei(imeiDb: imeiDb);
        log('imeiInitFutureProvider -- 7');
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
  } else {
    throw AssertionError('Error validating user. IdKary user null');
  }
});

final userInitFutureProvider =
    FutureProvider.family<Unit, BuildContext>((ref, context) async {
  bool doNeedProcess = false;
  //
  final userFOSOUpdate = ref.watch(userNotifierProvider
      .select((value) => value.failureOrSuccessOptionUpdate));

  if (userFOSOUpdate != none()) {
    await Future.delayed(
        Duration(seconds: 1),
        () => userFOSOUpdate.fold(
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
                          labelDescription: failure.maybeMap(
                            orElse: () => '',
                            storage: (_) => 'Storage Penuh',
                            server: (server) =>
                                '${server.errorCode} ${server.message}',
                          ),
                          asset: Assets.iconCrossed,
                        ),
                      ),
                    ),
                (_) => doNeedProcess = true)));
  }

  if (doNeedProcess) {
    ref.invalidate(getUserFutureProvider);
    await ref.read(getUserFutureProvider.future);
    // DON'T REMOVE
    //
    // await ref.read(imeiInitFutureProvider(context).future);
  }

  return unit;
});
