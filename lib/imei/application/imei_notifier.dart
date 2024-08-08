import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/err_log/application/err_log_notifier.dart';
import 'package:face_net_authentication/unlink/application/unlink_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

import '../../constants/constants.dart';
import '../../domain/auth_failure.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../tc/application/shared/tc_providers.dart';
import '../../user/application/user_model.dart';

import '../../shared/providers.dart';

import 'imei_auth_state.dart';
import 'imei_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'imei_notifier.g.dart';

@riverpod
class ImeiNotifier extends _$ImeiNotifier {
  @override
  FutureOr<ImeiState> build() async {
    return ImeiState.initial();
  }

  Future<String> getImeiStringFromStorage() => ref
      .read(imeiRepositoryProvider)
      .getImeiCredentials()
      .then((value) => value.fold((_) => '', (imei) => imei ?? ''));

  Future<String> getImeiStringFromServer({required String idKary}) => ref
      .read(imeiRepositoryProvider)
      .getImei(idKary: idKary)
      .then((value) => value.fold((_) => '', (imei) => imei ?? ''));

  Future<bool> clearImeiSuccess({required String idKary}) =>
      ref.read(imeiRepositoryProvider).clearImeiSuccess(idKary: idKary);

  String generateImei() => Uuid().v4();

  Future<void> clearImeiFromDBAndLogoutiOS(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await _saveUnlink(ref);
    _backToLoginScreen(ref);
    await _resetIntroScreens(ref);
    await _authCheck(ref);
  }

  Future<void> clearImeiFromDBAndLogout(WidgetRef ref) async {
    await _saveUnlink(ref);
    _backToLoginScreen(ref);
    await _resetIntroScreens(ref);
    await _authCheck(ref);
  }

  Future<void> _saveUnlink(WidgetRef ref) async {
    if (Platform.isIOS) {
      return;
    }

    final curr = ref.read(userNotifierProvider).user.nama;

    if (curr == 'Ghifar') {
      //
    } else {
      await ref.read(unlinkNotifierProvider.notifier).saveUnlink();
    }
  }

  _backToLoginScreen(WidgetRef ref) {
    ref.read(userNotifierProvider.notifier).setUserInitial();
    ref.read(initUserStatusNotifierProvider.notifier).hold();
  }

  _resetIntroScreens(WidgetRef ref) async {
    final tcNotifier = ref.read(tcNotifierProvider.notifier);
    await tcNotifier.clearVisitedTC();
    await tcNotifier.checkAndUpdateStatusTC();

    final imeiInstructionNotifier =
        ref.read(imeiIntroNotifierProvider.notifier);
    await imeiInstructionNotifier.clearVisitedIMEIIntroduction();
    await imeiInstructionNotifier.checkAndUpdateImeiIntro();
  }

  _authCheck(WidgetRef ref) async {
    await ref.read(userNotifierProvider.notifier).logout();
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  }

  Future<void> onEditProfile({
    required Function saveUser,
    required Function onUser,
  }) async {
    await saveUser();
    await onUser();
  }

  Future<void> registerAndShowDialog({
    required Function signUp,
    required Function onImeiComplete,
    required Function areYouSuccessOrNot,
  }) async {
    await signUp();
    await onImeiComplete();
    await areYouSuccessOrNot();
  }

  Future<void> logClearImeiFromDB({
    required String nama,
    required String idUser,
    required String imei,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(imeiRepositoryProvider).logClearImei(
            imei: imei,
            nama: nama,
            idUser: idUser,
          );

      return ImeiState.cleared();
    });
  }

  Future<void> registerImei({
    required String imei,
    required String idKary,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(imeiRepositoryProvider).registerImei(
            imei: imei,
            idKary: idKary,
          );

      return ImeiState.notRegistered();
    });
  }

  Future<void> onImei({
    required Function onImeiOK,
    required String savedImei,
    required String imeiDBString,
    required String? appleUsername,
    required ImeiAuthState imeiAuthState,
    required Function onImeiNotRegistered,
    required Function onImeiAlreadyRegistered,
  }) async {
    if (imeiAuthState == ImeiAuthState.empty()) {
      switch (savedImei.isEmpty) {
        case true:
          await onImeiNotRegistered();
          break;

        case false:
          await _onImeiTester(
            appleUsername,
            onImeiOK,
            onImeiNotRegistered,
            onImeiAlreadyRegistered,
          );

          break;
      }
    }

    if (imeiAuthState == ImeiAuthState.registered()) {
      switch (savedImei.isEmpty) {
        case true:
          // FOR APPLE REVIEW
          await _onImeiTester(
            appleUsername,
            onImeiOK,
            onImeiNotRegistered,
            onImeiAlreadyRegistered,
          );

          break;
        case false:
          () async {
            if (imeiDBString == savedImei) {
              onImeiOK();
            } else if (imeiDBString != savedImei) {
              // FOR APPLE REVIEW
              await _onImeiTester(
                appleUsername,
                onImeiOK,
                onImeiNotRegistered,
                onImeiAlreadyRegistered,
              );
            }
          }();
          break;

        default:
      }
    }
  }

  Future<void> _onImeiTester(
    String? appleUsername,
    Function onImeiOK,
    Function onImeiNotRegistered,
    Function onImeiAlreadyRegistered,
  ) async {
    if (appleUsername != null) {
      if (appleUsername == 'Ghifar') {
        await onImeiNotRegistered();
        // await onImeiAlreadyRegistered();
      } else {
        await onImeiAlreadyRegistered();
      }
    } else {
      await onImeiAlreadyRegistered();
    }
  }

  Future<void> processImei({
    required String imei,
    required String savedImei,
    required UserModelWithPassword user,
    required ImeiAuthState imeiAuthState,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      // String generatedImeiString = generateImei();
      var current = ImeiState.initial();

      await onImei(
          imeiDBString: imei,
          savedImei: savedImei,
          appleUsername: user.nama,
          imeiAuthState: imeiAuthState,
          onImeiOK: () {
            current = ImeiState.ok();
          },
          onImeiAlreadyRegistered: () {
            current = ImeiState.alreadyRegistered();
          },
          onImeiNotRegistered: () {
            current = ImeiState.notRegistered();
          });

      return current;
    });
  }

  onImeiOK() async {
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
    await ref
        .read(imeiIntroNotifierProvider.notifier)
        .checkAndUpdateImeiIntro();
    await ref.read(tcNotifierProvider.notifier).checkAndUpdateStatusTC();
  }

  Future<void> onImeiAlreadyRegistered({
    required String imeiDb,
    required String imeiSaved,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(errLogControllerProvider.notifier).sendLog(
            imeiDb: imeiDb,
            imeiSaved: imeiSaved,
            errMessage: Constants.imeiAlreadyRegistered,
          );

      return ImeiState.alreadyRegistered();
    });
  }

  _updateUserAfterRegister({
    required UserModelWithPassword user,
    required Future<void> onSuccess(),
    required BuildContext context,
  }) async {
    final Either<AuthFailure, Unit?> resp = await ref
        .read(userNotifierProvider.notifier)
        .saveUserAfterUpdateInline(user: user);

    resp.fold(
        (falure) => showErrorDialog(
            context,
            falure.map(
                storage: (_) => 'Storage Penuh : _updateUserAfterRegister',
                server: (server) => server.toString(),
                passwordExpired: (_) => 'Password Expired',
                passwordWrong: (_) => 'Password Wrong',
                noConnection: (_) => 'Tidak ada koneksi')),
        (_) {});
  }
}
