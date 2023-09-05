import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/password_expired_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_expired_notifier_state.freezed.dart';

@freezed
class PasswordExpiredNotifierState with _$PasswordExpiredNotifierState {
  const factory PasswordExpiredNotifierState({
    required bool isExpired,
    required Option<Either<PasswordExpiredFailure, Unit>>
        failureOrSuccessOption,
    required Option<Either<PasswordExpiredFailure, Unit>>
        failureOrSuccessOptionClear,
  }) = _PasswordExpiredNotifierState;

  factory PasswordExpiredNotifierState.initial() =>
      PasswordExpiredNotifierState(
          isExpired: false,
          failureOrSuccessOption: none(),
          failureOrSuccessOptionClear: none());
}
