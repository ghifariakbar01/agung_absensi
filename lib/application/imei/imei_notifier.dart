import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:uuid/uuid.dart';

import '../../constants/assets.dart';
import '../../domain/edit_failure.dart';
import '../../domain/imei_failure.dart';
import '../../infrastructure/imei/imei_repository.dart';
import '../../infrastructure/profile/edit_profile_repository.dart';
import '../../pages/widgets/v_dialogs.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../init_user/init_user_status.dart';
import '../user/user_model.dart';
import 'imei_auth_state.dart';
import 'imei_state.dart';

class ImeiNotifier extends StateNotifier<ImeiState> {
  ImeiNotifier(this._editProfileRepostiroy, this._imeiRepository)
      : super(ImeiState.initial());

  final EditProfileRepostiroy _editProfileRepostiroy;
  final ImeiRepository _imeiRepository;

  Future<String> getImeiString() => _imeiRepository
      .getImeiCredentials()
      .then((value) => value.fold((l) => '', (imei) => imei ?? ''));

  Future<String> getImeiStringDb() => _editProfileRepostiroy
      .getImei()
      .then((value) => value.fold((l) => '', (imei) => imei ?? ''));

  Future<bool> clearImeiSuccess() async =>
      await _editProfileRepostiroy.clearImeiSuccess();

  String generateImei() => Uuid().v4();

  changeSavedImei(String imei) {
    // debugger();
    state = state.copyWith(imei: imei);
  }

  resetSavedImei() {
    state = state.copyWith(imei: '');
  }

  Future<void> getImeiCredentials() async {
    Either<ImeiFailure, String?> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _imeiRepository.getImeiCredentials();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> getImei() async {
    Either<EditFailure, String?> failureOrSuccess;

    state =
        state.copyWith(isGetting: true, failureOrSuccessOptionGetImei: none());

    failureOrSuccess = await _editProfileRepostiroy.getImei();

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionGetImei: optionOf(failureOrSuccess));
  }

  Future<void> clearImeiFromDB() async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(
        isGetting: true, failureOrSuccessOptionClearRegisterImei: none());

    failureOrSuccess = await _editProfileRepostiroy.clearImei();

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionClearRegisterImei: optionOf(failureOrSuccess));
  }

  Future<void> logClearImeiFromDB() async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(isGetting: true);

    failureOrSuccess =
        await _editProfileRepostiroy.logClearImei(imei: state.imei);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionClearRegisterImei: optionOf(failureOrSuccess));
  }

  Future<void> registerImei({required String imei}) async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(
        isGetting: true, failureOrSuccessOptionClearRegisterImei: none());

    failureOrSuccess = await _editProfileRepostiroy.registerImei(imei: imei);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionClearRegisterImei: optionOf(failureOrSuccess));
  }

  Future<void> onImeiAlreadyRegistered({
    required Function showDialog,
    required Function logout,
  }) async {
    await showDialog();
    await logout();
  }

  Future<void> onImei({
    required ImeiAuthState imeiAuthState,
    required String? savedImei,
    required String? imeiDBString,
    required Function onImeiOK,
    required Future<void> onImeiNotRegistered(),
    required Future<void> onImeiAlreadyRegistered(),
  }) async {
    log('imei condition ${savedImei != null} ${savedImei!.isEmpty} ');

    if (imeiAuthState == ImeiAuthState.empty()) {
      switch (savedImei.isEmpty) {
        case true:
          debugger(message: 'called');

          await onImeiNotRegistered();
          break;

        case false:
          debugger(message: 'called');

          await onImeiAlreadyRegistered();
          // onImeiOK();
          // await onImeiNotRegistered();

          break;
      }
    }

    // debugger();

    if (imeiAuthState == ImeiAuthState.registered()) {
      switch (savedImei.isEmpty) {
        case true:
          debugger(message: 'called');

          await onImeiAlreadyRegistered();
          // onImeiOK();
          // await onImeiNotRegistered();

          break;
        case false:
          () async {
            if (imeiDBString == savedImei) {
              debugger(message: 'called');

              onImeiOK();
            } else if (imeiDBString != savedImei) {
              debugger(message: 'called');

              await onImeiAlreadyRegistered();
              // onImeiOK();
              // await onImeiNotRegistered();
            }
          }();
          break;

        default:
      }
    }
  }

  Future<void> showSuccessDialog(BuildContext context) {
    return showDialog(
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
            asset: Assets.iconChecked,
          ),
        ));
  }

  Future<void> showFailedDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => VSimpleDialog(
        label: 'Gagal',
        labelDescription: 'Sudah punya INSTALLATION ID',
        asset: Assets.iconCrossed,
      ),
    );
  }

  // TAU LAH SUSAH KONTOL
  Future<void> processImei(
      //
      {
      //
      required String imei,
      required Ref ref,
      required BuildContext context}) async {
    //
    void letYouThrough() {
      ref.read(initUserStatusProvider.notifier).state =
          InitUserStatus.success();
    }

    void hold() {
      ref.read(initUserStatusProvider.notifier).state = InitUserStatus.init();
    }
    //

    ImeiAuthState imeiAuthState = ref.read(imeiAuthNotifierProvider);
    String savedImei =
        ref.read(imeiNotifierProvider.select((value) => value.imei));
    UserModelWithPassword user =
        ref.read(userNotifierProvider.select((value) => value.user));

    debugger();

    await ref.read(imeiNotifierProvider.notifier).onImei(
        savedImei: savedImei,
        imeiAuthState: imeiAuthState,
        imeiDBString: imei,
        onImeiNotRegistered: () async {
          final generatedImeiString =
              ref.read(imeiNotifierProvider.notifier).generateImei();

          // debugger();

          await ref
              .read(editProfileNotifierProvider.notifier)
              .registerAndShowDialog(
                  register: () =>
                      ref.read(imeiNotifierProvider.notifier).registerImei(
                          imei: generatedImeiString),
                  getImeiCredentials: () =>
                      ref
                          .read(imeiNotifierProvider.notifier)
                          .getImeiCredentials(),
                  onImeiComplete: () => ref
                      .read(editProfileNotifierProvider.notifier)
                      .onEditProfile(
                          saveUser: () => ref
                              .read(userNotifierProvider.notifier)
                              .saveUserAfterUpdate(user: user),
                          onUser: () => ref
                              .read(userNotifierProvider.notifier)
                              .getUser()),
                  showDialog: () => showSuccessDialog(context));

          // debugger();
          letYouThrough();
        },
        onImeiOK: () => letYouThrough(),
        onImeiAlreadyRegistered: () async {
          await ref.read(imeiNotifierProvider.notifier).onImeiAlreadyRegistered(
                showDialog: () => showFailedDialog(context),
                logout: () => ref.read(userNotifierProvider.notifier).logout(),
              );

          hold();
          // debugger();
        });
  }
}
