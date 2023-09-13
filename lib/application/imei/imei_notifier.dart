import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:face_net_authentication/application/imei/imei_state.dart';
import 'package:uuid/uuid.dart';

import '../../domain/edit_failure.dart';
import '../../domain/imei_failure.dart';
import '../../infrastructure/imei/imei_repository.dart';
import '../../infrastructure/profile/edit_profile_repository.dart';
import '../init_imei/init_imei_status.dart';
import 'imei_auth_state.dart';

class ImeiNotifier extends StateNotifier<ImeiState> {
  ImeiNotifier(this._editProfileRepostiroy, this._imeiRepository)
      : super(ImeiState.initial());

  final EditProfileRepostiroy _editProfileRepostiroy;
  final ImeiRepository _imeiRepository;

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

    failureOrSuccess = await _editProfileRepostiroy.clearImei(imei: state.imei);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionClearRegisterImei: optionOf(failureOrSuccess));
  }

  Future<void> logClearImeiFromDB() async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(
        isGetting: true, failureOrSuccessOptionClearRegisterImei: none());

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
          // await onImeiNotRegistered();

          break;
      }
    }

    debugger();

    if (imeiAuthState == ImeiAuthState.registered()) {
      switch (savedImei.isEmpty) {
        case true:
          debugger(message: 'called');

          await onImeiAlreadyRegistered();
          // await onImeiNotRegistered();

          break;
        case false:
          () async {
            if (imeiDBString == savedImei) {
              debugger(message: 'called');

              onImeiOK();
            } else if (imeiDBString != savedImei) {
              debugger(message: 'called');

              onImeiOK();

              // await onImeiAlreadyRegistered();
              // await onImeiNotRegistered();
            }
          }();
          break;

        default:
      }
    }
  }
}
