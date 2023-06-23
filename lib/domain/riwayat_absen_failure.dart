import 'package:freezed_annotation/freezed_annotation.dart';

part 'riwayat_absen_failure.freezed.dart';

@freezed
class RiwayatAbsenFailure with _$RiwayatAbsenFailure {
  const factory RiwayatAbsenFailure.server([int? errorCode, String? message]) =
      _Server;
  const factory RiwayatAbsenFailure.wrongFormat() = _WrongFormat;

  const factory RiwayatAbsenFailure.noConnection() = _NoConnection;
}
