import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/assets.dart';

import '../user/application/user_model.dart';
import '../user/application/user_notifier.dart';
import '../widgets/v_dialogs.dart';
import 'providers.dart';

part 'future_providers.g.dart';

// for refresh on home page
@riverpod
class GetUserNotifier extends _$GetUserNotifier {
  @override
  FutureOr<Unit> build() async {
    UserNotifier userNotifier = ref.read(userNotifierProvider.notifier);
    String userString = await userNotifier.getUserString();

    // PARSE USER SUCCESS / FAILURE
    if (userString.isNotEmpty) {
      final json = jsonDecode(userString) as Map<String, Object?>;
      final user = UserModelWithPassword.fromJson(json);

      if (json.isNotEmpty) {
        await ref
            .read(userNotifierProvider.notifier)
            .onUserParsedRaw(ref: ref, userModelWithPassword: user);
      }
    }
    log('GetUserNotifier Here');

    return unit;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      UserNotifier userNotifier = ref.read(userNotifierProvider.notifier);
      String userString = await userNotifier.getUserString();

      // PARSE USER SUCCESS / FAILURE
      if (userString.isNotEmpty) {
        final json = jsonDecode(userString) as Map<String, Object?>;
        final user = UserModelWithPassword.fromJson(json);

        if (json.isNotEmpty) {
          await ref
              .read(userNotifierProvider.notifier)
              .onUserParsedRaw(ref: ref, userModelWithPassword: user);
        }
      }
      log('GetUserNotifier Here');

      return unit;
    });
  }
}

// 1. GET AND SET USER
final getUserFutureProvider = FutureProvider<Unit>((ref) async {
  UserNotifier userNotifier = ref.read(userNotifierProvider.notifier);
  String userString = await userNotifier.getUserString();

  // PARSE USER SUCCESS / FAILURE
  if (userString.isNotEmpty) {
    final json = jsonDecode(userString) as Map<String, Object?>;
    final user = UserModelWithPassword.fromJson(json);

    if (json.isNotEmpty) {
      await ref
          .read(userNotifierProvider.notifier)
          .onUserParsedRaw(ref: ref, userModelWithPassword: user);
    }
  }

  return unit;
});

// 2. INIT IMEI WITH USER
final imeiInitFutureProvider =
    FutureProvider.family<Unit, BuildContext>((ref, context) async {
  log('imeiInitFutureProvider -- 1');
  final res = await ref.refresh(getUserFutureProvider.future);

  if (res.runtimeType == Unit) {
    await ref.read(getUserFutureProvider.future);

    log('imeiInitFutureProvider -- 2');

    final user = ref.read(userNotifierProvider).user;

    if (user.IdKary != null) {
      if (user.IdKary!.isNotEmpty) {
        log('imeiInitFutureProvider -- 3');

        // final imeiNotifier = ref.read(imeiNotifierProvider.notifier);

        // // // 3. GET IMEI DATA
        // // String imei = await imeiNotifier.getImeiString();

        // // log('imeiInitFutureProvider -- 4');

        // // await Future.delayed(
        // //     Duration(seconds: 1), () => imeiNotifier.changeSavedImei(imei));

        // // log('imeiInitFutureProvider -- 5');

        // // String imeiDb = await ref
        // //     .read(imeiNotifierProvider.notifier)
        // //     .getImeiStringDb(idKary: user.IdKary ?? 'null');

        // // log('imeiInitFutureProvider -- 6');

        // // await ref
        // //     .read(imeiAuthNotifierProvider.notifier)
        // //     .checkAndUpdateImei(imeiDb: imeiDb);

        log('imeiInitFutureProvider -- 7');

        ref.read(initUserStatusNotifierProvider.notifier).letYouThrough();

        // 4. PROCESS IMEI DATA
        // IF OFFLINE FROM USER INIT
        // final isOfflineFromInit = ref.read(absenOfflineModeProvider);

        // if (!isOfflineFromInit) {
        //   await ref
        //       .read(imeiNotifierProvider.notifier)
        //       .processImei(imei: imeiDb, ref: ref, context: context);
        // } else {
        //   ref.read(initUserStatusNotifierProvider.notifier).letYouThrough();
        //   return unit;
        // }
      } else {
        await ref.read(getUserFutureProvider.future);
        ref.read(initUserStatusNotifierProvider.notifier).letYouThrough();
        return unit;
      }
    }

    return unit;
  } else {
    throw AssertionError(
        'ref.refresh(getUserFutureProvider.future) is not a Unit');
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
                              server: (server) =>
                                  '${server.errorCode} ${server.message}',
                              storage: (_) => 'Storage Penuh',
                              orElse: () => ''),
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
