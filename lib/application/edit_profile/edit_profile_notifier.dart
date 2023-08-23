import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/imei/imei_state.dart';
import 'package:face_net_authentication/domain/edit_failure.dart';
import 'package:face_net_authentication/domain/value_objects_copy.dart';
import 'package:face_net_authentication/infrastructure/profile/edit_profile_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/validator.dart';
import 'edit_profile_state.dart';

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier(this._editProfileRepostiroy)
      : super(EditProfileState.initial());

  final EditProfileRepostiroy _editProfileRepostiroy;

  void changeFullname(String fullNameStr) {
    state = state.copyWith(fullname: Nama(fullNameStr));
  }

  void changePhone1(String phoneStr) {
    state = state.copyWith(telp1: NoHP(phoneStr));
  }

  void changePhone2(String phoneStr) {
    state = state.copyWith(telp2: NoHP(phoneStr));
  }

  void changeEmail1(String emailStr) {
    state = state.copyWith(email1: Email(emailStr));
  }

  void changeEmail2(String emailStr) {
    state = state.copyWith(email2: Email(emailStr));
  }

  Future<void> onEditProfile(
      {required Function saveUser, required Function onUser}) async {
    await saveUser();
    await onUser();
  }

  Future<void> onImeiAlreadyRegistered(
      {required Function showDialog,
      required Function logout,
      required Function checkAndUpdateAuthStatus,
      required Function redirect}) async {
    await showDialog();
    await logout();
    await checkAndUpdateAuthStatus();
    await redirect();
  }

  Future<void> onImei({
    required ImeiState imeiDBState,
    required String? savedImei,
    required String? imeiDBString,
    required Future<void> onImeiNotRegistered(),
    required Future<void> onImeiAlreadyRegistered(),
  }) async {
    log('imei condition ${savedImei != null} ${savedImei!.isEmpty} ');

    if (imeiDBState == ImeiState.empty()) {
      switch (savedImei.isEmpty) {
        case true:
          await onImeiNotRegistered();
          break;

        case false:
          // debugger(message: 'called');

          // await onImeiAlreadyRegistered();
          await onImeiNotRegistered();

          break;
      }
    }

    if (imeiDBState == ImeiState.registered()) {
      switch (savedImei.isEmpty) {
        case true:
          debugger(message: 'called');
          // await onImeiAlreadyRegistered();
          await onImeiNotRegistered();

          break;
        case false:
          () async {
            if (imeiDBString == savedImei) {
              return;
            } else if (imeiDBString != savedImei) {
              debugger(message: 'called');

              // await onImeiAlreadyRegistered();

              await onImeiNotRegistered();
            }
          }();
          break;

        default:
      }
    }
  }

  void changeEditProfile(
      {required String noTelp1,
      required String noTelp2,
      required String email1,
      required String email2,
      required Function onChanged}) {
    changePhone1(noTelp1);
    changePhone2(noTelp2);
    changeEmail1(email1);
    changeEmail2(email2);
    onChanged();
  }

  Future<void> registerAndShowDialog({
    required Function register,
    required Function getImeiCredentials,
    required Function onImeiComplete,
    required Function showDialog,
  }) async {
    await register();
    await getImeiCredentials();
    await onImeiComplete();
    await showDialog();
  }

  Future<void> getImei() async {
    Either<EditFailure, String?> failureOrSuccess;

    state = state.copyWith(
        isSubmitting: true, failureOrSuccessOptionGettingImei: none());

    failureOrSuccess = await _editProfileRepostiroy.getImei();

    state = state.copyWith(
        isSubmitting: false,
        failureOrSuccessOptionGettingImei: optionOf(failureOrSuccess));
  }

  Future<void> clearImei() async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(isSubmitting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _editProfileRepostiroy.clearImei();

    state = state.copyWith(
        isSubmitting: false,
        failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> registerImei({required String imei}) async {
    Either<EditFailure, Unit>? failureOrSuccess;

    state = state.copyWith(isSubmitting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _editProfileRepostiroy.registerImei(imei: imei);

    state = state.copyWith(
        isSubmitting: false,
        failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> submitEdit() async {
    Either<EditFailure, Unit>? failureOrSuccess;

    if (isValid) {
      final noTelp1Str = state.telp1.getOrCrash();
      final noTelp2Str = state.telp2.getOrLeave('');
      final email1Str = state.email1.getOrCrash();
      final email2Str = state.email2.getOrLeave('');

      state = state.copyWith(
          isSubmitting: true,
          showErrorMessages: false,
          failureOrSuccessOption: none());

      failureOrSuccess = await _editProfileRepostiroy.submitEdit(
          noTelp1: noTelp1Str,
          noTelp2: noTelp2Str,
          email1: email1Str,
          email2: email2Str);
    }

    state = state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  bool get isValid {
    final values = [
      state.telp1,
      state.email1,
    ];

    return Validator.validate(values);
  }
}
