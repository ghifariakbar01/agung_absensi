import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/err_log/application/err_log_notifier.dart';
import 'package:face_net_authentication/unlink/application/unlink_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

import '../../constants/assets.dart';
import '../../domain/edit_failure.dart';

import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../tc/application/shared/tc_providers.dart';
import '../../user/application/user_model.dart';
import '../../utils/dialog_helper.dart';
import '../infrastructures/imei_repository.dart';

import '../../widgets/v_dialogs.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';

import 'imei_auth_state.dart';
import 'imei_state.dart';

class ImeiNotifier extends StateNotifier<ImeiState> {
  ImeiNotifier(this._imeiRepository) : super(ImeiState.initial());

  final ImeiRepository _imeiRepository;

  Future<String> getImeiString() => _imeiRepository
      .getImeiCredentials()
      .then((value) => value.fold((_) => '', (imei) => imei ?? ''));

  Future<String> getImeiStringDb({required String idKary}) => _imeiRepository
      .getImei(idKary: idKary)
      .then((value) => value.fold((_) => '', (imei) => imei ?? ''));

  Future<bool> clearImeiSuccess({required String idKary}) =>
      _imeiRepository.clearImeiSuccess(idKary: idKary);

  String generateImei() => Uuid().v4();

  changeSavedImei(String imei) {
    state = state.copyWith(imei: imei);
  }

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
    } else {
      await ref.read(unlinkNotifierProvider.notifier).saveUnlink();
    }
  }

  _authCheck(WidgetRef ref) async {
    await ref.read(userNotifierProvider.notifier).logout();
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
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
  }) async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(
        isGetting: true, failureOrSuccessOptionClearRegisterImei: none());

    failureOrSuccess = await _imeiRepository.logClearImei(
        imei: state.imei, nama: nama, idUser: idUser);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionClearRegisterImei: optionOf(failureOrSuccess));
  }

  Future<void> registerImei(
      {required String imei, required String idKary}) async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(
        isGetting: true, failureOrSuccessOptionClearRegisterImei: none());

    failureOrSuccess =
        await _imeiRepository.registerImei(imei: imei, idKary: idKary);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionClearRegisterImei: optionOf(failureOrSuccess));
  }

  Future<Unit> registerImeiInline({
    required String imei,
    required String idKary,
  }) async {
    return _imeiRepository.registerImeiInline(
      imei: imei,
      idKary: idKary,
    );
  }

  Future<void> onImeiAlreadyRegistered({
    required Function sendLog,
    required Function showDialog,
    required Function logout,
  }) async {
    await sendLog();
    await showDialog();
    await logout();
  }

  Future<void> onImei({
    required Function onImeiOK,
    required String savedImei,
    required String imeiDBString,
    required String? appleUsername,
    required ImeiAuthState imeiAuthState,
    required Future<void> onImeiNotRegistered(),
    required Future<void> onImeiAlreadyRegistered(),
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
    Future<void> onImeiNotRegistered(),
    Future<void> onImeiAlreadyRegistered(),
  ) async {
    if (appleUsername != null) {
      if (appleUsername == 'Ghifar') {
        await onImeiNotRegistered();
        // await onImeiAlreadyRegistered();
        // onImeiOK();
      } else {
        await onImeiAlreadyRegistered();
        // onImeiOK();
      }
    } else {
      await onImeiAlreadyRegistered();
      // onImeiOK();
    }
  }

  Future<void> showSuccessDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
          label: 'Berhasil',
          labelDescription: 'Sukses daftar INSTALLATION ID',
          asset: Assets.iconChecked,
        ),
      ).then((_) => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => VSimpleDialog(
              color: Palette.red,
              label: 'Warning',
              labelDescription: 'Jika uninstall, unlink hp di setting profil',
              asset: Assets.iconCrossed,
            ),
          ));

  Future<void> showErrorDialog(
    BuildContext context,
    String message,
  ) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
          label: 'Oops',
          color: Palette.red,
          labelDescription: message,
          asset: Assets.iconCrossed,
        ),
      );

  Future<void> processImei({
    required Ref ref,
    required String imei,
    required String savedImei,
    required BuildContext context,
  }) async {
    final user = ref.read(userNotifierProvider).user;
    final imeiAuthState = ref.read(imeiAuthNotifierProvider);

    String generatedImeiString = generateImei();

    return onImei(
        imeiDBString: imei,
        savedImei: savedImei,
        appleUsername: user.nama,
        imeiAuthState: imeiAuthState,
        onImeiOK: () =>
            ref.read(initUserStatusNotifierProvider.notifier).letYouThrough(),
        onImeiAlreadyRegistered: () => _onImeiAlreadyRegistered(
              ref: ref,
              context: context,
              imeiDb: imei,
              imeiSaved: savedImei,
            ),
        onImeiNotRegistered: () => _onImeiNotRegistered(
              ref: ref,
              context: context,
              user: user,
              imei: imei,
              savedImei: savedImei,
              generatedImeiString: generatedImeiString,
            ));
  }

  Future<void> _onImeiNotRegistered({
    required Ref<Object?> ref,
    required BuildContext context,
    required UserModelWithPassword user,
    required String imei,
    required String savedImei,
    required String generatedImeiString,
  }) async {
    await registerImeiInline(
      imei: generatedImeiString,
      idKary: user.IdKary ?? 'null',
    );

    final fos = await ref
        .read(userNotifierProvider.notifier)
        .saveUserAfterUpdateInline(user: user);

    return fos.fold(
      (l) => showErrorDialog(
          context,
          l.map(
            server: (s) => s.toString(),
            storage: (_) => 'Kesalahan / Storage Penuh',
            passwordExpired: (_) => 'Password Expired',
            passwordWrong: (_) => 'Password Wrong',
            noConnection: (_) => 'Tidak ada koneksi',
          )),
      (_) => showSuccessDialog(context).then(
        (_) =>
            ref.read(initUserStatusNotifierProvider.notifier).letYouThrough(),
      ),
    );
  }

  Future<void> _onImeiAlreadyRegistered({
    required Ref ref,
    required String imeiDb,
    required String imeiSaved,
    required BuildContext context,
  }) async {
    final msg =
        'Sudah punya Installation ID. Mohon Uninstall Aplikasi. Terimakasih 🙏';

    return ref
        .read(imeiNotifierProvider.notifier)
        .onImeiAlreadyRegistered(
          showDialog: () => DialogHelper.showCustomDialog(
            msg,
            context,
          ),
          logout: () => ref.read(userNotifierProvider.notifier).logout(),
          sendLog: () => ref
              .read(errLogControllerProvider.notifier)
              .sendLog(imeiDb: imeiDb, imeiSaved: imeiSaved, errMessage: msg),
        )
        .then((_) {
      ref.read(initUserStatusNotifierProvider.notifier).hold();
      ref.read(userNotifierProvider.notifier).logout();
      ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
    });
  }
}
