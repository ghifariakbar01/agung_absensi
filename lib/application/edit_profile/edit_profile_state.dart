import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/edit_failure.dart';
import '../../domain/value_objects_copy.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState(
          {required Nama fullname,
          required Email email1,
          required Email email2,
          required NoHP telp1,
          required NoHP telp2,
          required bool isSubmitting,
          required bool showErrorMessages,
          required Option<Either<EditFailure, String?>>
              failureOrSuccessOptionGettingImei,
          required Option<Either<EditFailure, Unit>> failureOrSuccessOption}) =
      _EditProfileState;

  factory EditProfileState.initial() => EditProfileState(
        fullname: Nama(''),
        email1: Email(''),
        email2: Email(''),
        telp1: NoHP(''),
        telp2: NoHP(''),
        isSubmitting: false,
        showErrorMessages: false,
        failureOrSuccessOptionGettingImei: none(),
        failureOrSuccessOption: none(),
      );
}
