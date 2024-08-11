import 'package:freezed_annotation/freezed_annotation.dart';

part 'background_failure.freezed.dart';

@freezed
class BackgroundFailure with _$BackgroundFailure {
  const factory BackgroundFailure.empty() = _Empty;
  const factory BackgroundFailure.unknown(
      [String? errorCode, String? message]) = _Unknown;
  const factory BackgroundFailure.formatException(String message) =
      _FormatException;
}
