import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_absen_failure.freezed.dart';

@freezed
class AutoAbsenFailure with _$AutoAbsenFailure {
  const factory AutoAbsenFailure.storage() = _Storage;
  const factory AutoAbsenFailure.server([int? errorCode, String? message]) =
      _Server;
  const factory AutoAbsenFailure.noConnection() = _NoConnection;
}
