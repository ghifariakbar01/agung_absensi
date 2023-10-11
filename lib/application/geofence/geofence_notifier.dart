import 'dart:convert';
import 'dart:developer' as log;
import 'dart:developer';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
import 'package:geofence_service/geofence_service.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/geofence_failure.dart';
import '../../infrastructure/geofence/geofence_repository.dart';
import '../background/background_item_state.dart';
import 'coordinate_state.dart';
import 'geofence_coordinate_state.dart';
import 'geofence_response.dart';
import 'geofence_state.dart';

class GeofenceNotifier extends StateNotifier<GeofenceState> {
  GeofenceNotifier(
    this._repository,
  ) : super(GeofenceState.initial());

  final GeofenceRepository _repository;

  GeofenceService get geofenceservice => state.geofenceService;

  Future<void> saveGeofence(List<GeofenceResponse> geofenceResponseList) async {
    Either<GeofenceFailure, Unit> failureOrSuccess;

    state =
        state.copyWith(isGetting: true, failureOrSuccessOptionStorage: none());

    failureOrSuccess =
        await _repository.saveGeofence(geofenceList: geofenceResponseList);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionStorage: optionOf(failureOrSuccess));
  }

  // GET GEOFENCE
  Future<void> getGeofenceList() async {
    Either<GeofenceFailure, List<GeofenceResponse>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _repository.getGeofenceList();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> getGeofenceListFromStorage() async {
    Either<GeofenceFailure, List<GeofenceResponse>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _repository.readGeofenceList();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  List<Geofence> geofenceResponseToList(
      List<GeofenceResponse> geofenceResponseList) {
    final List<Geofence> geofences = [];

    for (var geofence in geofenceResponseList) {
      final geofenceCoordinates =
          coordinates(coordinatesString: geofence.latLong);

      final radius = getRadius(geofence.radius);

      geofences.addAll([
        Geofence(
            id: geofence.id.toString(),
            latitude: geofenceCoordinates[0],
            longitude: geofenceCoordinates[1],
            data: geofence.namaLokasi,
            radius: radius),
      ]);
    }

    return geofences;
  }
  // END

  Future<void> startAutoAbsen({
    required Function showDialogAndLogout,
    required List<GeofenceResponse> geofenceResponseList,
    required List<BackgroundItemState> savedBackgroundItems,
    required Future<void> Function(List<GeofenceResponse>) saveGeofence,
    required Future<void> Function(List<BackgroundItemState>) startAbsen,
  }) async {
    await saveGeofence(geofenceResponseList);
    await this.state.failureOrSuccessOptionStorage.fold(
        () {},
        (either) => either.fold(
            //
            (_) => showDialogAndLogout(),
            //
            (_) => startAbsen(savedBackgroundItems)
            //
            ));
  }

  // Geofence initializatioin

  addGeofenceMockListener(
          {required Function(Location location) mockListener}) =>
      geofenceservice.addLocationChangeListener(mockListener);

  Future<void> initializeGeoFence(
      //
      List<Geofence> geofenceList,
      {required Function(Object a) onError}) async {
    if (geofenceservice.isRunningService) return;

    // debugger();
    geofenceservice.addLocationChangeListener(
      (location) => onLocationChanged(location, geofenceList),
    );

    geofenceservice.addStreamErrorListener(onErrorStream);

    geofenceservice.addGeofenceList([...geofenceList]);

    await geofenceservice
        .start([...geofenceList])
        .catchError(onError)
        .onError((error, stackTrace) {
          // log.debugger(message: 'called');

          log.log('error $error stack $stackTrace');
        });
  }

  onLocationChanged(
    Location location,
    List<Geofence> coordinates,
  ) {
    print('location: ${location.toJson()}');

    state = state.copyWith(currentLocation: location);

    List<GeofenceCoordinate> geofenceCoordinates = geofenceNativeToCoordinate(
        location: location, geofenceNative: coordinates);

    if (coordinates.isNotEmpty) {
      updateAndChangeNearest(
          coordinates: coordinates,
          designatedCoordinate: location,
          geofenceCoordinates: geofenceCoordinates);
    }
  }

  List<GeofenceCoordinate> geofenceNativeToCoordinate(
      {required Location location, required List<Geofence> geofenceNative}) {
    return geofenceNative
        .map((geofence) => GeofenceCoordinate(
              id: geofence.id,
              nama: geofence.data,
              coordinate: Coordinate(
                  latitude: geofence.latitude, longitude: geofence.latitude),
              minDistance: geofence.radius.isNotEmpty
                  ? geofence.radius.first.length
                  : 100,
              remainingDistance: calculateDistance(location, geofence),
            ))
        .toList();
  }

  updateAndChangeNearest(
      {required Location designatedCoordinate,
      required List<Geofence> coordinates,
      required List<GeofenceCoordinate> geofenceCoordinates}) {
    if (coordinates.isNotEmpty) {
      changeGeofenceCoordinates(
          updateCoordinatesFromGeofence(designatedCoordinate, coordinates));
    }

    // GET SMALLEST DISTANCE
    if (geofenceCoordinates.isNotEmpty) {
      changeNearest(getSmallestDistance(geofenceCoordinates));
    }
  }

  changeGeofenceCoordinates(List<GeofenceCoordinate> coordinates) {
    state = state.copyWith(geofenceCoordinates: [...coordinates]);
  }

  getSmallestDistance(List<GeofenceCoordinate> coordinates) {
    // debugger();
    return minBy(coordinates,
        (GeofenceCoordinate coordinate) => coordinate.remainingDistance);
  }

  changeNearest(GeofenceCoordinate coordinate) {
    state = state.copyWith(nearestCoordinates: coordinate);
  }

  // This function is used to handle errors that occur in the service.
  onErrorStream(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

  stop() {
    state.geofenceService.removeStreamErrorListener(onErrorStream);
    state.geofenceService.clearAllListeners();
    state.geofenceService.stop();
  }

  List<GeofenceCoordinate> updateCoordinatesFromGeofence(
      Location designatedCoordinate, List<Geofence> coordinates) {
    List<GeofenceCoordinate> coordinatesupdated = coordinates
        .map((coordinate) => GeofenceCoordinate(
            id: coordinate.id,
            nama: coordinate.data,
            coordinate: Coordinate(
                latitude: coordinate.latitude, longitude: coordinate.longitude),
            minDistance: coordinate.radius.isNotEmpty
                ? coordinate.radius.first.length
                : 100,
            remainingDistance:
                calculateDistance(designatedCoordinate, coordinate)))
        .toList();

    return coordinatesupdated;
  }

  List<GeofenceRadius> getRadius(String response) {
    final List<GeofenceRadius> list = [];

    final clean = response.replaceAll("u0027", "\"").replaceAll("mu0027", "\"");

    final radius = jsonDecode(clean) as Map<String, dynamic>;

    radius.forEach((key, value) {
      list.add(GeofenceRadius(id: key, length: (value as int).toDouble()));
    });

    return list;
  }

  List<double> coordinates({required String coordinatesString}) {
    return coordinatesString
        .split(',')
        .map((coordinate) => double.parse(coordinate.trim()))
        .toList();
  }

  // OVERRIDE GEOFENCE_SERVICE CAULCATE DISTANCE
  double calculateDistance(Location location, Geofence geofence) {
    double degreeToRadians(double degree) {
      return degree * pi / 180;
    }

    const int earthRadius = 6371000; // Earth's radius in meters

    double lat1Radians = degreeToRadians(location.latitude);
    double lat2Radians = degreeToRadians(geofence.latitude);
    double latDiffRadians =
        degreeToRadians(geofence.latitude - location.latitude);
    double lonDiffRadians =
        degreeToRadians(geofence.longitude - location.longitude);

    double a = sin(latDiffRadians / 2) * sin(latDiffRadians / 2) +
        cos(lat1Radians) *
            cos(lat2Radians) *
            sin(lonDiffRadians / 2) *
            sin(lonDiffRadians / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;

    return distance;
  }
}
