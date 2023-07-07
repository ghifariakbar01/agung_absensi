import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/imei_failure.dart';

part 'imei_auth_state.freezed.dart';

@freezed
class ImeiAuthState with _$ImeiAuthState {
  const factory ImeiAuthState({
    required String imei,
    required bool isGetting,
    required Option<Either<ImeiFailure, String?>> failureOrSuccessOption,
  }) = _ImeiAuthState;

  factory ImeiAuthState.initial() => ImeiAuthState(
        imei: '',
        isGetting: false,
        failureOrSuccessOption: none(),
      );
}
