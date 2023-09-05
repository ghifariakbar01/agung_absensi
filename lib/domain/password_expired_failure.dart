import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_expired_failure.freezed.dart';

@freezed
class PasswordExpiredFailure with _$PasswordExpiredFailure {
  const factory PasswordExpiredFailure.errorParsing([String? message]) =
      _ErrorParsing;
  const factory PasswordExpiredFailure.empty() = _Empty;
  const factory PasswordExpiredFailure.unknown(
      [int? errorCode, String? message]) = _Unknown;
  const factory PasswordExpiredFailure.storage() = _Storage;
}
