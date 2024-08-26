import 'package:freezed_annotation/freezed_annotation.dart';

import '../background/application/saved_location.dart';

part 'absen_failure.freezed.dart';

@freezed
class AbsenFailure with _$AbsenFailure {
  const factory AbsenFailure.server(
      {int? errorCode, String? message, required SavedLocation item}) = _Server;
  const factory AbsenFailure.passwordExpired(SavedLocation item) =
      _PasswordExpired;
  const factory AbsenFailure.passwordWrong(SavedLocation item) = _PasswordWrong;
  const factory AbsenFailure.noConnection(SavedLocation item) = _NoConnection;
}
