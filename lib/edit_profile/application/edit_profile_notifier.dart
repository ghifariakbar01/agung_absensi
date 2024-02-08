import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/edit_failure.dart';
import 'package:face_net_authentication/domain/value_objects_copy.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/validator.dart';
import '../infrastructure/edit_profile_repository.dart';
import 'edit_profile_state.dart';

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier(
    this._editProfileRepostiroy,
  ) : super(EditProfileState.initial());

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
    required Function signUp,
    required Function getImei,
    required Function onImeiComplete,
    required Function areYouSuccessOrNot,
  }) async {
    await signUp();
    await getImei();
    await onImeiComplete();
    await areYouSuccessOrNot();

    // READ FROM failureOrSuccessOptionUpdate
  }

  Future<void> submitEdit({required String idKary}) async {
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
          idKary: idKary,
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
