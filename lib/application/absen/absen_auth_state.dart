import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/absen_failure.dart';
import '../background/background_item_state.dart';

part 'absen_auth_state.freezed.dart';

@freezed
class AbsenAuthState with _$AbsenAuthState {
  const factory AbsenAuthState({
    required bool isSubmitting,
    required BackgroundItemState backgroundItemState,
    required Option<Either<AbsenFailure, Unit>> failureOrSuccessOption,
    required Option<Either<AbsenFailure, Unit>> failureOrSuccessOptionSaved,
  }) = _AbsenAuth;

  factory AbsenAuthState.initial() => AbsenAuthState(
      isSubmitting: false,
      backgroundItemState: BackgroundItemState.initial(),
      failureOrSuccessOption: none(),
      failureOrSuccessOptionSaved: none());
}
