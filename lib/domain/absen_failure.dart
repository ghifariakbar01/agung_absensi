import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_failure.freezed.dart';

@freezed
class AbsenFailure with _$AbsenFailure {
  const factory AbsenFailure.server([int? errorCode, String? message]) =
      _Server;
  const factory AbsenFailure.passwordExpired() = _PasswordExpired;
  const factory AbsenFailure.passwordWrong() = _PasswordWrong;
  const factory AbsenFailure.noConnection() = _NoConnection;
}
