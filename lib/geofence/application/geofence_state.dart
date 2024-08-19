import 'package:dartz/dartz.dart';
import 'package:geofence_service/geofence_service.dart';
import '../../domain/geofence_failure.dart';
import 'geofence_coordinate_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'geofence_response.dart';

part 'geofence_dummy.dart';

part 'geofence_state.freezed.dart';

@freezed
class GeofenceState with _$GeofenceState {
  const factory GeofenceState({
    required GeofenceService geofenceService,
    required List<GeofenceCoordinate> geofenceCoordinates,
    required GeofenceCoordinate nearestCoordinates,
    required Location currentLocation,
    required bool isGetting,
    required Option<Either<GeofenceFailure, List<GeofenceResponse>>>
        failureOrSuccessOption,
    required Option<Either<GeofenceFailure, List<GeofenceResponse>>>
        failureOrSuccessOptionAfterAbsen,
  }) = _GeofenceState;

  factory GeofenceState.initial() => GeofenceState(
        isGetting: false,
        geofenceCoordinates: [],
        failureOrSuccessOption: none(),
        failureOrSuccessOptionAfterAbsen: none(),
        nearestCoordinates: GeofenceCoordinate.initial(),
        currentLocation: Location.fromJson(dummyLocation),
        geofenceService: GeofenceService.instance.setup(
            interval: 5000,
            accuracy: 100,
            printDevLog: false,
            loiteringDelayMs: 60000,
            allowMockLocations: true,
            statusChangeDelayMs: 10000,
            useActivityRecognition: false,
            geofenceRadiusSortType: GeofenceRadiusSortType.DESC),
      );
}
