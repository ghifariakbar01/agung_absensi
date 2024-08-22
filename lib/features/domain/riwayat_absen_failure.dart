import 'package:freezed_annotation/freezed_annotation.dart';

part 'riwayat_absen_failure.freezed.dart';

@freezed
class RiwayatAbsenFailure with _$RiwayatAbsenFailure {
  const factory RiwayatAbsenFailure.server([int? errorCode, String? message]) =
      _Server;
  const factory RiwayatAbsenFailure.wrongFormat([String? message]) =
      _WrongFormat;
  const factory RiwayatAbsenFailure.passwordExpired() = _PasswordExpired;
  const factory RiwayatAbsenFailure.passwordWrong() = _PasswordWrong;
  const factory RiwayatAbsenFailure.storage() = _Storage;

  const factory RiwayatAbsenFailure.noConnection() = _NoConnection;
}
