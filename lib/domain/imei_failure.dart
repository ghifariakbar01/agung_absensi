import 'package:freezed_annotation/freezed_annotation.dart';

part 'imei_failure.freezed.dart';

@freezed
class ImeiFailure with _$ImeiFailure {
  const factory ImeiFailure.errorParsing([String? message]) = _ErrorParsing;
  const factory ImeiFailure.empty() = _Empty;
  const factory ImeiFailure.unknown([int? errorCode, String? message]) =
      _Unknown;
  const factory ImeiFailure.storage() = _Storage;
}
