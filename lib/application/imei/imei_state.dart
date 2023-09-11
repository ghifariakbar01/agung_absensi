import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/edit_failure.dart';
import '../../domain/imei_failure.dart';

part 'imei_state.freezed.dart';

@freezed
class ImeiState with _$ImeiState {
  const factory ImeiState({
    required String imei,
    required bool isGetting,
    required Option<Either<ImeiFailure, String?>> failureOrSuccessOption,
    required Option<Either<EditFailure, String?>> failureOrSuccessOptionGetImei,
    required Option<Either<EditFailure, Unit?>>
        failureOrSuccessOptionClearRegisterImei,
  }) = _ImeiState;

  factory ImeiState.initial() => ImeiState(
      imei: '',
      isGetting: false,
      failureOrSuccessOption: none(),
      failureOrSuccessOptionGetImei: none(),
      failureOrSuccessOptionClearRegisterImei: none());
}
