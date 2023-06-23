import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/geofence/geofence_response.dart';
import 'package:face_net_authentication/infrastructure/geofence/geofence_remote_service.dart';

import '../../domain/geofence_failure.dart';
import '../exceptions.dart';

class GeofenceRepository {
  final GeofenceRemoteService _remoteService;

  GeofenceRepository(this._remoteService);

  Future<Either<GeofenceFailure, List<GeofenceResponse>>>
      getGeofenceList() async {
    try {
      return right(await _remoteService.getGeofenceList());
    } on FormatException {
      return left(GeofenceFailure.wrongFormat());
    } on NoConnectionException {
      return left(GeofenceFailure.noConnection());
    } on RestApiException {
      return left(GeofenceFailure.server());
    }
  }
}
