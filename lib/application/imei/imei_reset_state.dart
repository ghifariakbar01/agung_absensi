import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/imei_failure.dart';

part 'imei_reset_state.freezed.dart';

@freezed
class ImeiResetState with _$ImeiResetState {
  const factory ImeiResetState({
    required bool isClearing,
    required Option<Either<ImeiFailure, Unit?>> failureOrSuccessOption,
  }) = _ImeiResetState;

  factory ImeiResetState.initial() => ImeiResetState(
        isClearing: false,
        failureOrSuccessOption: none(),
      );
}
