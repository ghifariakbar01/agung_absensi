import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/err_log/application/err_log_notifier.dart';
import 'package:face_net_authentication/unlink/application/unlink_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

import '../../constants/assets.dart';
import '../../domain/edit_failure.dart';
import '../../domain/imei_failure.dart';
import '../../edit_profile/infrastructure/edit_profile_repository.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../tc/application/shared/tc_providers.dart';
import '../../user/application/user_model.dart';
import '../../utils/dialog_helper.dart';
import '../infrastructure/imei_repository.dart';

import '../../widgets/v_dialogs.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';

import 'imei_auth_state.dart';
import 'imei_state.dart';

class ImeiNotifier extends StateNotifier<ImeiState> {
  ImeiNotifier(this._editProfileRepostiroy, this._imeiRepository)
      : super(ImeiState.initial());

  final EditProfileRepostiroy _editProfileRepostiroy;
  final ImeiRepository _imeiRepository;

  Future<String> getImeiString() => _imeiRepository
      .getImeiCredentials()
      .then((value) => value.fold((_) => '', (imei) => imei ?? ''));

  Future<String> getImeiStringDb({required String idKary}) =>
      _editProfileRepostiroy
          .getImei(idKary: idKary)
          .then((value) => value.fold((_) => '', (imei) => imei ?? ''));

  Future<bool> clearImeiSuccess({required String idKary}) async =>
      await _editProfileRepostiroy.clearImeiSuccess(idKary: idKary);

  String generateImei() => Uuid().v4();

  changeSavedImei(String imei) {
    // debugger();
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

  Future<void> getImeiCredentials() async {
    Either<ImeiFailure, String?> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _imeiRepository.getImeiCredentials();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> clearImeiFromDB({required String idKary}) async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(
        isGetting: true, failureOrSuccessOptionClearRegisterImei: none());

    failureOrSuccess = await _editProfileRepostiroy.clearImei(idKary: idKary);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionClearRegisterImei: optionOf(failureOrSuccess));
  }

  Future<void> logClearImeiFromDB({
    required String nama,
    required String idUser,
  }) async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(
        isGetting: true, failureOrSuccessOptionClearRegisterImei: none());

    failureOrSuccess = await _editProfileRepostiroy.logClearImei(
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
        await _editProfileRepostiroy.registerImei(imei: imei, idKary: idKary);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionClearRegisterImei: optionOf(failureOrSuccess));
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
    required String? savedImei,
    required String? imeiDBString,
    required String? appleUsername,
    required ImeiAuthState imeiAuthState,
    required Future<void> onImeiNotRegistered(),
    required Future<void> onImeiAlreadyRegistered(),
  }) async {
    log('imei condition ${savedImei != null} ${savedImei!.isEmpty} ');

    if (imeiAuthState == ImeiAuthState.empty()) {
      switch (savedImei.isEmpty) {
        case true:
          // debugger(message: 'called');

          await onImeiNotRegistered();
          break;

        case false:
          // debugger(message: 'called');

          await _onImeiTester(
            onImeiOK,
            onImeiNotRegistered,
            onImeiAlreadyRegistered,
            appleUsername,
          );

          break;
      }
    }

    // debugger();

    if (imeiAuthState == ImeiAuthState.registered()) {
      switch (savedImei.isEmpty) {
        case true:
          // debugger(message: 'called');
          // FOR APPLE REVIEW
          await _onImeiTester(
            onImeiOK,
            onImeiNotRegistered,
            onImeiAlreadyRegistered,
            appleUsername,
          );

          break;
        case false:
          () async {
            if (imeiDBString == savedImei) {
              // debugger(message: 'called');

              onImeiOK();
            } else if (imeiDBString != savedImei) {
              // debugger(message: 'called');
              // FOR APPLE REVIEW
              await _onImeiTester(
                onImeiOK,
                onImeiNotRegistered,
                onImeiAlreadyRegistered,
                appleUsername,
              );
            }
          }();
          break;

        default:
      }
    }
  }

  Future<void> _onImeiTester(
    Function onImeiOK,
    Future<void> onImeiNotRegistered(),
    Future<void> onImeiAlreadyRegistered(),
    String? appleUsername,
  ) async {
    if (appleUsername != null) {
      if (appleUsername == 'Ghifar' || appleUsername == 'Alfin') {
        await onImeiNotRegistered();
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

  Future<void> processImei(
      {required Ref ref,
      required String imei,
      required BuildContext context}) async {
    final UserModelWithPassword user = ref.read(userNotifierProvider).user;
    final ImeiAuthState imeiAuthState = ref.read(imeiAuthNotifierProvider);
    final String savedImei = ref.read(imeiNotifierProvider).imei;

    final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
    String generatedImeiString = imeiNotifier.generateImei();

    return imeiNotifier.onImei(
        imeiDBString: imei,
        savedImei: savedImei,
        appleUsername: user.nama,
        imeiAuthState: imeiAuthState,
        onImeiOK: () =>
            ref.read(initUserStatusNotifierProvider.notifier).letYouThrough(),
        onImeiAlreadyRegistered: () => _onImeiAlreadyRegistered(
            ref: ref, context: context, imeiDb: imei, imeiSaved: savedImei),
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
    return ref.read(editProfileNotifierProvider.notifier).registerAndShowDialog(
        signUp: () => ref.read(imeiNotifierProvider.notifier).registerImei(
            imei: generatedImeiString, idKary: user.IdKary ?? 'null'),
        getImei: () =>
            ref.read(imeiNotifierProvider.notifier).getImeiCredentials(),
        onImeiComplete: () => ref
            .read(editProfileNotifierProvider.notifier)
            .onEditProfile(
                saveUser: () => ref
                    .read(userNotifierProvider.notifier)
                    .saveUserAfterUpdate(user: user),
                onUser: () =>
                    ref.read(userNotifierProvider.notifier).getUser()),
        areYouSuccessOrNot: () async {
          await ref
              .read(userNotifierProvider.notifier)
              .saveUserAfterUpdate(user: user);

          await ref
              .read(userNotifierProvider)
              .failureOrSuccessOptionUpdate
              .fold(
                  () {},
                  (either) => either.fold((failure) async {
                        return failure.maybeWhen(
                            noConnection: ref
                                .read(initUserStatusNotifierProvider.notifier)
                                .letYouThrough,
                            orElse: () async {
                              final String errMessage = failure.maybeWhen(
                                orElse: () => '',
                                server: (errorCode, message) =>
                                    'Error Kode $errorCode : $message',
                                passwordWrong: () =>
                                    'Password yang anda masukkan salah',
                                storage: () =>
                                    'Mohon maaf storage anda penuh. Mohon luangkan storage anda agar bisa menyimpan Installation ID. Terimakasih',
                              );

                              await ref
                                  .read(errLogControllerProvider.notifier)
                                  .sendLog(
                                      imeiDb: imei,
                                      imeiSaved: savedImei,
                                      errMessage: errMessage);

                              return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => VSimpleDialog(
                                  label: 'Error',
                                  labelDescription: errMessage,
                                  asset: Assets.iconCrossed,
                                ),
                              ).then((_) async {
                                ref
                                    .read(
                                        initUserStatusNotifierProvider.notifier)
                                    .hold();
                                await ref
                                    .read(userNotifierProvider.notifier)
                                    .logout();
                              });
                            });
                      },
                          (_) => ref
                              .read(userNotifierProvider.notifier)
                              .getUser()
                              .then((_) => showSuccessDialog(context).then(
                                  (_) => ref
                                      .read(initUserStatusNotifierProvider
                                          .notifier)
                                      .letYouThrough()))));
        });
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
          showDialog: () => DialogHelper.showCustomDialog(msg, context),
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
