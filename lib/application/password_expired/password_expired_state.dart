import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_expired_state.freezed.dart';

@freezed
class PasswordExpiredState with _$PasswordExpiredState {
  const factory PasswordExpiredState.initial() = _Initial;
  const factory PasswordExpiredState.expired() = _Expired;
  const factory PasswordExpiredState.notExpired() = _NotExpired;
}
