import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_error_state.freezed.dart';

@freezed
class GeofenceErrorState with _$GeofenceErrorState {
  factory GeofenceErrorState.ALREADY_STARTED() = _AlreadyStarted;
  factory GeofenceErrorState.LOCATION_SERVICES_DISABLED() =
      _LocationServicesDisabled;
  factory GeofenceErrorState.LOCATION_PERMISSION_DENIED() =
      _LocationPermissionDenied;
  factory GeofenceErrorState.LOCATION_PERMISSION_PERMANENTLY_DENIED() =
      _LocationPermissionPermanentlyDenied;
}
