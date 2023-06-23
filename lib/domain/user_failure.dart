import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_failure.freezed.dart';

@freezed
class UserFailure with _$UserFailure {
  const factory UserFailure.errorParsing([String? message]) = _ErrorParsing;
  const factory UserFailure.empty() = _Empty;
  const factory UserFailure.unknown([int? errorCode, String? message]) =
      _Unknown;
}
