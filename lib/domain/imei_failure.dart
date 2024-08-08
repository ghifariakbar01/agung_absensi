import 'package:freezed_annotation/freezed_annotation.dart';

part 'imei_failure.freezed.dart';

@freezed
class ImeiFailure with _$ImeiFailure {
  const factory ImeiFailure.server([int? errorCode, String? message]) = _Server;
  const factory ImeiFailure.noConnection() = _NoConnection;
  const factory ImeiFailure.storage() = _Storage;
  const factory ImeiFailure.formatException([String? message]) =
      _FormatException;
}
