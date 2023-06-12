import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_state.freezed.dart';

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState({
    required bool isAuthorized,
    required bool cameraAuthorized,
    required bool locationAuthorized,
  }) = _PermissionState;

  factory PermissionState.initial() => PermissionState(
        cameraAuthorized: false,
        isAuthorized: false,
        locationAuthorized: false,
      );
}
