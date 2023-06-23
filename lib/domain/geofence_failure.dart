import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_failure.freezed.dart';

@freezed
class GeofenceFailure with _$GeofenceFailure {
  const factory GeofenceFailure.server([int? errorCode, String? message]) =
      _Server;
  const factory GeofenceFailure.wrongFormat() = _WrongFormat;

  const factory GeofenceFailure.noConnection() = _NoConnection;
}
