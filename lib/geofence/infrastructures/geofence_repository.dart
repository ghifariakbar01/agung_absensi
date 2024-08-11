import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/infrastructures/credentials_storage/credentials_storage.dart';

import 'package:flutter/services.dart';

import '../../constants/constants.dart';
import '../../domain/geofence_failure.dart';
import '../../infrastructures/exceptions.dart';
import '../application/geofence_response.dart';
import 'geofence_remote_service.dart';

class GeofenceRepository {
  final GeofenceRemoteService _remoteService;
  final CredentialsStorage _credentialsStorage;

  GeofenceRepository(this._remoteService, this._credentialsStorage);

  Future<bool> hasOfflineData() =>
      readGeofenceList().then((credentials) => credentials.fold(
            (_) => false,
            (_) => true,
          ));

  Future<Either<GeofenceFailure, List<GeofenceResponse>>>
      getGeofenceList() async {
    try {
      final geof = await _remoteService.getGeofenceList();

      return right(geof);
    } on FormatException {
      return left(const GeofenceFailure.wrongFormat());
    } on NoConnectionException {
      return left(const GeofenceFailure.noConnection());
    } on RestApiException {
      return left(const GeofenceFailure.server());
    } on RestApiExceptionWithMessage catch (e) {
      return left(GeofenceFailure.server(e.errorCode, e.message));
    } catch (e) {
      return left(GeofenceFailure.server(
        01,
        e.toString(),
      ));
    }
  }

  // ONE
  Future<Either<GeofenceFailure, Unit>> saveGeofence(
      {required List<GeofenceResponse> geofenceList}) async {
    try {
      final String data = jsonEncode(geofenceList);
      await _credentialsStorage.save(data);

      return right(unit);
    } on PlatformException {
      return left(GeofenceFailure.storage(Constants.geofenceStorageError));
    }
  }

  // TWO
  Future<Either<GeofenceFailure, List<GeofenceResponse>>>
      readGeofenceList() async {
    try {
      final list = await _credentialsStorage.read();

      if (list == null) {
        return left(GeofenceFailure.empty());
      } else {
        if (list.isEmpty) {
          return right([]);
        } else {
          final parsedGeofence = await parseGeofenceSaved(savedGeofence: list);

          return right(parsedGeofence);
        }
      }
    } on PlatformException {
      return left(GeofenceFailure.storage(Constants.geofenceStorageError));
    }
  }

  Future<List<GeofenceResponse>> parseGeofenceSaved(
      {required String savedGeofence}) async {
    final parsedData = jsonDecode(savedGeofence);

    if (parsedData is Map<String, dynamic>) {
      final location = GeofenceResponse.fromJson(parsedData);
      return [location];
    } else {
      return (parsedData as List<dynamic>)
          .map((locationData) => GeofenceResponse.fromJson(locationData))
          .toList();
    }
  }
}
