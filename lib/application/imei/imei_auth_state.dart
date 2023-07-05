import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/auth_failure.dart';
import '../../domain/user_failure.dart';

part 'imei_auth_state.freezed.dart';

@freezed
class ImeiAuthState with _$ImeiAuthState {
  const factory ImeiAuthState({
    required String imei,
    required bool isGetting,
    required Option<Either<UserFailure, String?>> failureOrSuccessOption,
    required Option<Either<AuthFailure, Unit>> failureOrSuccessOptionClear,
  }) = _ImeiAuthState;

  factory ImeiAuthState.initial() => ImeiAuthState(
      imei: '',
      failureOrSuccessOption: none(),
      failureOrSuccessOptionClear: none(),
      isGetting: false);
}
