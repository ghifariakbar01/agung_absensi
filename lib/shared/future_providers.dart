import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/user/user_model.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/imei/imei_notifier.dart';
import '../application/init_user/init_user_status.dart';
import '../application/user/user_notifier.dart';
import '../constants/assets.dart';

import '../pages/widgets/v_dialogs.dart';
import 'providers.dart';

final getUserFutureProvider = FutureProvider<Unit>((ref) async {
  // debugger();
  UserNotifier userNotifier = ref.read(userNotifierProvider.notifier);
  String userString = await userNotifier.getUserString();

  // debugger();

  // PARSE USER SUCCESS / FAILURE
  if (userString.isNotEmpty) {
    final json = jsonDecode(userString) as Map<String, Object?>;
    final user = UserModelWithPassword.fromJson(json);

    // debugger();

    if (json.isNotEmpty) {
      // debugger();

      await ref
          .read(userNotifierProvider.notifier)
          .onUserParsedRaw(ref: ref, userModelWithPassword: user);
      // DON'T REMOVE
      //
    }
  }

  // debugger();

  return unit;
});

final imeiInitFutureProvider =
    FutureProvider.family<Unit, BuildContext>((ref, context) async {
  await ref.read(getUserFutureProvider.future);

  final user = ref.read(userNotifierProvider).user;

  if (user.idKary != null) {
    if (user.idKary!.isNotEmpty) {
      ImeiNotifier imeiNotifier = ref.read(imeiNotifierProvider.notifier);
      String imei = await imeiNotifier.getImeiString();
      await Future.delayed(
          Duration(seconds: 1), () => imeiNotifier.changeSavedImei(imei));

      await ref.read(imeiAuthNotifierProvider.notifier).checkAndUpdateImei();

      String imeiDb =
          await ref.read(imeiNotifierProvider.notifier).getImeiStringDb();

      debugger();
      await ref
          .read(imeiNotifierProvider.notifier)
          .processImei(imei: imeiDb, ref: ref, context: context);
    } else {
      // debugger();

      await ref.read(getUserFutureProvider.future);
    }
  }

  return unit;
});

final userInitFutureProvider =
    FutureProvider.family<Unit, BuildContext>((ref, context) async {
  // debugger();

  bool doNeedProcess = false;
  //
  final userFOSOUpdate = ref.watch(userNotifierProvider
      .select((value) => value.failureOrSuccessOptionUpdate));

  letYouThrough() {
    ref.read(initUserStatusProvider.notifier).state = InitUserStatus.success();
  }

  if (userFOSOUpdate != none()) {
    await Future.delayed(
        Duration(seconds: 1),
        () => userFOSOUpdate.fold(
            () {},
            (either) => either.fold(
                (failure) => failure.maybeMap(
                      noConnection: (_) => letYouThrough(),
                      orElse: () => showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => VSimpleDialog(
                          label: 'Error',
                          labelDescription: failure.maybeMap(
                              server: (server) =>
                                  '${server.errorCode} ${server.message}',
                              storage: (_) => 'storage penuh',
                              orElse: () => ''),
                          asset: Assets.iconCrossed,
                        ),
                      ),
                    ),
                (_) => doNeedProcess = true)));
  }

  if (doNeedProcess) {
    // debugger();
    ref.invalidate(getUserFutureProvider);
    await ref.read(getUserFutureProvider.future);
    // DON'T REMOVE
    //
    // await ref.read(imeiInitFutureProvider(context).future);
  }

  // debugger();

  return unit;
});
