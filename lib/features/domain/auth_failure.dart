import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.storage() = _Storage;
  const factory AuthFailure.server([int? errorCode, String? message]) = _Server;
  const factory AuthFailure.passwordExpired() = _PasswordExpired;
  const factory AuthFailure.passwordWrong() = _PasswordWrong;
  const factory AuthFailure.noConnection() = _NoConnection;
}
