import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_failure.freezed.dart';

@freezed
class GeofenceFailure with _$GeofenceFailure {
  const factory GeofenceFailure.empty() = _Empty;
  const factory GeofenceFailure.server([int? errorCode, String? message]) =
      _Server;

  const factory GeofenceFailure.passwordExpired() = _PasswordExpired;
  const factory GeofenceFailure.passwordWrong() = _PasswordWrong;
  const factory GeofenceFailure.wrongFormat() = _WrongFormat;
  const factory GeofenceFailure.noConnection() = _NoConnection;
  const factory GeofenceFailure.storage([String? message]) = _Storage;
}
