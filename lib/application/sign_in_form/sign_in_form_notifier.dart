import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/validator.dart';
import '../../domain/auth_failure.dart';
import '../../domain/value_objects_copy.dart';

import '../../infrastructure/auth/auth_repository.dart';
import '../remember_me/remember_me_state.dart';

part 'sign_in_form_notifier.freezed.dart';
part 'sign_in_form_state.dart';

class SignInFormNotifier extends StateNotifier<SignInFormState> {
  SignInFormNotifier(this._repository) : super(SignInFormState.initial());

  final AuthRepository _repository;

  String get saveStr => 'remember_me';

  changeAllData({
    required String userStr,
    required bool isChecked,
    required bool isKaryawan,
    required String ptNameStr,
    required String passwordStr,
    required String idKaryawanStr,
  }) {
    state = state.copyWith(
      isChecked: isChecked,
      isKaryawan: isKaryawan,
      ptDropdownSelected: ptNameStr,
      failureOrSuccessOption: none(),
      //
      userId: UserId(userStr),
      password: Password(passwordStr),
      idKaryawan: IdKaryawan(idKaryawanStr),
    );
  }

  changeInitializeNamaPT({required String namaPT}) {
    final ptMapWithName = state.ptMap.entries.firstWhereOrNull(
      (ptMap) =>
          ptMap.value.firstWhereOrNull((ptName) => ptName == namaPT) != null,
    );

    if (ptMapWithName != null) {
      final serverName = ptMapWithName.key;

      changePTNameAndDropdown(
        changePTName: () => changePTName(serverName),
        changeDropdownSelected: () => changeDropdownSelected(namaPT),
      );
    }
  }

  changeIdKaryawan(String idKaryawanStr) {
    state = state.copyWith(
      idKaryawan: IdKaryawan(idKaryawanStr),
      failureOrSuccessOption: none(),
    );
  }

  changePTName(String ptNameStr) {
    state = state.copyWith(
      ptServerSelected: PTName(ptNameStr),
      failureOrSuccessOption: none(),
    );
  }

  changeEmail(String emailStr) {
    state = state.copyWith(
      email: Email(emailStr),
      failureOrSuccessOption: none(),
    );
  }

  changeUserId(String userStr) {
    state = state.copyWith(
      userId: UserId(userStr),
      failureOrSuccessOption: none(),
    );
  }

  changePassword(String passwordStr) {
    state = state.copyWith(
      password: Password(passwordStr),
      failureOrSuccessOption: none(),
    );
  }

  changeDropdownSelected(String dropdownStr) {
    state = state.copyWith(
        ptDropdownSelected: dropdownStr, failureOrSuccessOption: none());
  }

  changePTNameAndDropdown({
    required void Function() changePTName,
    required void Function() changeDropdownSelected,
  }) {
    changePTName();
    changeDropdownSelected();
  }

  Future<void> initializeAndRedirect({
    required Function initializeSavedLocations,
    required Function initializeGeofenceList,
    required Function redirect,
  }) async {
    await initializeSavedLocations();
    await initializeGeofenceList();
    await redirect();
  }

  Future<void> signInAndRemember({
    required Function init,
    required Function signIn,
    required Function clearSaved,
    required Function showDialogAndLogout,
    required Future<Either<AuthFailure, Unit>> Function() remember,
  }) async {
    await init();
    await signIn();
    if (!state.isChecked) {
      await clearSaved();
    } else {
      final result = await remember();
      result.fold(
          // if remember failed
          (_) => showDialogAndLogout(),
          // if remember success
          (_) {});
    }
  }

  void changeIsKaryawan(bool isKaryawan) {
    state = state.copyWith(isKaryawan: isKaryawan);
  }

  /// [rememberInfo] and should use [Either] and handle error when thrown

  Future<Either<AuthFailure, Unit>> rememberInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final save = await prefs.setString(
        '$saveStr',
        jsonEncode(RememberMeModel(
          isKaryawan: state.isKaryawan,
          ptName: state.ptDropdownSelected,
          nama: state.userId.getOrLeave(''),
          nik: state.idKaryawan.getOrLeave(''),
          password: state.password.getOrLeave(''),
        )));

    if (save == true) {
      return right(unit);
    } else {
      return left(AuthFailure.storage());
    }
  }

  Future<void> clearInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('$saveStr') != null) {
      await prefs.remove(
        '$saveStr',
      );
    }
  }

  Future<void> signInWithUserIdEmailAndPasswordACT() async {
    Either<AuthFailure, Unit>? signInFailureOrSuccess;

    if (isValid) {
      state = state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      );

      signInFailureOrSuccess =
          await _repository.signInWithIdKaryawanUsernameAndPasswordACT(
              userId: state.userId,
              password: state.password,
              server: state.ptServerSelected);
    }

    state = state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      failureOrSuccessOption: optionOf(signInFailureOrSuccess),
    );
  }

  Future<void> signInWithUserIdEmailAndPasswordARV() async {
    Either<AuthFailure, Unit>? signInFailureOrSuccess;

    if (isValid) {
      state = state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      );

      signInFailureOrSuccess =
          await _repository.signInWithIdKaryawanUsernameAndPasswordARV(
              userId: state.userId,
              password: state.password,
              server: state.ptServerSelected);
    }

    state = state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      failureOrSuccessOption: optionOf(signInFailureOrSuccess),
    );
  }

  bool get isValid {
    final values = [state.userId, state.password, state.ptServerSelected];

    return Validator.validate(values);
  }
}
