import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_state.freezed.dart';

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState.completed() = _Completed;
  const factory PermissionState.initial() = _Initial;
}
