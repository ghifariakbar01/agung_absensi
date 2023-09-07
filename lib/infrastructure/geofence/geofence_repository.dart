import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/geofence/geofence_response.dart';
import 'package:face_net_authentication/infrastructure/credentials_storage/credentials_storage.dart';
import 'package:face_net_authentication/infrastructure/geofence/geofence_remote_service.dart';
import 'package:flutter/services.dart';

import '../../domain/geofence_failure.dart';
import '../exceptions.dart';

class GeofenceRepository {
  final GeofenceRemoteService _remoteService;
  final CredentialsStorage _credentialsStorage;

  GeofenceRepository(this._remoteService, this._credentialsStorage);

  Future<Either<GeofenceFailure, List<GeofenceResponse>>>
      getGeofenceList() async {
    try {
      return right(await _remoteService.getGeofenceList());
    } on PasswordWrongException {
      return left(const GeofenceFailure.passwordWrong());
    } on PasswordExpiredException {
      return left(const GeofenceFailure.passwordExpired());
    } on FormatException {
      return left(const GeofenceFailure.wrongFormat());
    } on NoConnectionException {
      return left(const GeofenceFailure.noConnection());
    } on RestApiException {
      return left(const GeofenceFailure.server());
    }
  }

  // ONE
  Future<Either<GeofenceFailure, Unit>> saveGeofence(
      {required List<GeofenceResponse> geofenceList}) async {
    try {
      await _credentialsStorage.save(jsonEncode(geofenceList));

      return right(unit);
    } on PlatformException {
      return left(GeofenceFailure.server(0, 'Storage penuh'));
    }
  }

  // TWO
  Future<Either<GeofenceFailure, List<GeofenceResponse>>>
      readGeofenceList() async {
    try {
      final list = await _credentialsStorage.read();

      if (list == null) {
        return right([]);
      } else {
        final parsedGeofence = await parseGeofenceSaved(savedGeofence: list);

        return right(parsedGeofence);
      }
    } on PlatformException {
      return left(GeofenceFailure.server(0, 'Storage penuh'));
    }
  }

  Future<List<GeofenceResponse>> parseGeofenceSaved(
      {required String? savedGeofence}) async {
    final parsedData = jsonDecode(savedGeofence!);

    // log('parsedData $parsedData ');

    if (parsedData is Map<String, dynamic>) {
      final location = GeofenceResponse.fromJson(parsedData);

      final List<GeofenceResponse> empty = [];

      empty.add(location);

      return empty;
    } else {
      return (parsedData as List<dynamic>)
          .map((locationData) => GeofenceResponse.fromJson(locationData))
          .toList();
    }
  }
}
