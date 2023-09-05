import 'package:freezed_annotation/freezed_annotation.dart';

part 'init_geofence_status.freezed.dart';

@freezed
class InitGeofenceStatus with _$InitGeofenceStatus {
  const factory InitGeofenceStatus.init() = _Init;
  const factory InitGeofenceStatus.failure() = _Failure;
  const factory InitGeofenceStatus.success() = _Success;
}
