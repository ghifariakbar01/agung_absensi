import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  void changeAllData(
      {required String ptNameStr,
      required String idKaryawanStr,
      required String userStr,
      required String passwordStr,
      required bool isKaryawan,
      required bool isChecked}) {
    state = state.copyWith(
        idKaryawan: IdKaryawan(idKaryawanStr),
        userId: UserId(userStr),
        password: Password(passwordStr),
        ptDropdownSelected: ptNameStr,
        failureOrSuccessOption: none(),
        isKaryawan: isKaryawan,
        isChecked: isChecked);
  }

  void changeInitializeNamaPT({required String namaPT}) {
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

  void changeIdKaryawan(String idKaryawanStr) {
    state = state.copyWith(
      idKaryawan: IdKaryawan(idKaryawanStr),
      failureOrSuccessOption: none(),
    );
  }

  void changePTName(String ptNameStr) {
    state = state.copyWith(
      ptServerSelected: PTName(ptNameStr),
      failureOrSuccessOption: none(),
    );
  }

  void changeEmail(String emailStr) {
    state = state.copyWith(
      email: Email(emailStr),
      failureOrSuccessOption: none(),
    );
  }

  void changeUserId(String userStr) {
    state = state.copyWith(
      userId: UserId(userStr),
      failureOrSuccessOption: none(),
    );
  }

  void changePassword(String passwordStr) {
    state = state.copyWith(
      password: Password(passwordStr),
      failureOrSuccessOption: none(),
    );
  }

  void changeDropdownSelected(String dropdownStr) {
    state = state.copyWith(
        ptDropdownSelected: dropdownStr, failureOrSuccessOption: none());
  }

  void changePTNameAndDropdown({
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

  Future<void> signInWithUserIdEmailAndPassword() async {
    Either<AuthFailure, Unit>? signInFailureOrSuccess;

    if (isValid) {
      state = state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      );

      signInFailureOrSuccess =
          await _repository.signInWithIdKaryawanUsernameAndPassword(
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
