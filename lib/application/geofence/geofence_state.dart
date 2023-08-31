import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/geofence/geofence_response.dart';
import 'package:face_net_authentication/domain/geofence_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geofence_service/geofence_service.dart';

import 'geofence_coordinate_state.dart';

part 'geofence_dummy.dart';

part 'geofence_state.freezed.dart';

@freezed
class GeofenceState with _$GeofenceState {
  const factory GeofenceState(
      {required GeofenceService geofenceService,
      //
      required List<GeofenceCoordinate> geofenceCoordinates,
      required GeofenceCoordinate nearestCoordinates,
      required Location currentLocation,
      //
      required List<GeofenceCoordinate> geofenceCoordinatesSaved,
      required List<GeofenceCoordinate> nearestCoordinatesSaved,
      //
      required bool isGetting,
      required Option<Either<GeofenceFailure, List<GeofenceResponse>>>
          failureOrSuccessOption,
      // GEOFENCE STORAGE ACTIVITY
      required Option<Either<GeofenceFailure, Unit>>
          failureOrSuccessOptionStorage}) = _GeofenceState;

  factory GeofenceState.initial() => GeofenceState(
        isGetting: false,
        geofenceCoordinates: [],
        geofenceCoordinatesSaved: [],
        nearestCoordinatesSaved: [],
        failureOrSuccessOption: none(),
        failureOrSuccessOptionStorage: none(),
        nearestCoordinates: GeofenceCoordinate.initial(),
        currentLocation: Location.fromJson(dummyLocation),
        geofenceService: GeofenceService.instance.setup(
            interval: 5000,
            accuracy: 100,
            loiteringDelayMs: 60000,
            statusChangeDelayMs: 10000,
            useActivityRecognition: false,
            allowMockLocations: false,
            printDevLog: false,
            geofenceRadiusSortType: GeofenceRadiusSortType.DESC),
      );
}
