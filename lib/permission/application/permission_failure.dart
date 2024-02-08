import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_failure.freezed.dart';

@freezed
class PermissionFailure with _$PermissionFailure {
  const factory PermissionFailure.withMessage({String? message}) =
      _FailureMessage;
  const factory PermissionFailure.unkown() = _Unknown;
}
