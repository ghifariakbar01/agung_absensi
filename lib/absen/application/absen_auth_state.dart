import 'package:dartz/dartz.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../background/application/saved_location.dart';
import '../../domain/absen_failure.dart';

part 'absen_auth_state.freezed.dart';

@freezed
class AbsenAuthState with _$AbsenAuthState {
  const factory AbsenAuthState({
    required bool isSubmitting,
    required SavedLocation backgroundItemState,
    required Option<Either<AbsenFailure, Unit>> failureOrSuccessOption,
    required Option<Either<AbsenFailure, Unit>> failureOrSuccessOptionSaved,
  }) = _AbsenAuth;

  factory AbsenAuthState.initial() => AbsenAuthState(
        isSubmitting: false,
        failureOrSuccessOption: none(),
        failureOrSuccessOptionSaved: none(),
        backgroundItemState: SavedLocation.initial(),
      );
}
