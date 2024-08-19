import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/utils/logging.dart';
import 'package:geofence_service/geofence_service.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/geofence_failure.dart';

import '../infrastructures/geofence_repository.dart';
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

  Future<bool> hasOfflineData() => _repository.hasOfflineData();

  Future<List<GeofenceResponse>> getGeofenceStorage() =>
      _repository.readGeofenceList().then((value) => value.fold(
            (_) => [],
            (r) => r,
          ));

  void resetFOSO() {
    state = state.copyWith(
      failureOrSuccessOption: none(),
      failureOrSuccessOptionAfterAbsen: none(),
    );
  }

  Future<Either<GeofenceFailure, Unit>> saveGeofence(
      List<GeofenceResponse> geofenceResponseList) async {
    return _repository.saveGeofence(geofenceList: geofenceResponseList);
  }

  Future<void> getGeofenceListAfterAbsen() async {
    Either<GeofenceFailure, List<GeofenceResponse>> failureOrSuccess;

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOptionAfterAbsen: none(),
    );

    failureOrSuccess = await _repository.getGeofenceList();

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOptionAfterAbsen: optionOf(failureOrSuccess),
    );
  }

  Future<void> getGeofenceList() async {
    Either<GeofenceFailure, List<GeofenceResponse>> failureOrSuccess;

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOption: none(),
    );

    failureOrSuccess = await _repository.getGeofenceList();

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }

  Future<void> getGeofenceListFromStorageAfterAbsen() async {
    Either<GeofenceFailure, List<GeofenceResponse>> failureOrSuccess;

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOptionAfterAbsen: none(),
    );

    Log.info('geofence got 1');
    failureOrSuccess = await _repository.readGeofenceList();
    Log.info('geofence got 2');

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOptionAfterAbsen: optionOf(failureOrSuccess),
    );
  }

  Future<void> getGeofenceListFromStorage() async {
    Either<GeofenceFailure, List<GeofenceResponse>> failureOrSuccess;

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOption: none(),
    );

    Log.info('geofence got 1');
    failureOrSuccess = await _repository.readGeofenceList();
    Log.info('geofence got 2');

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    );
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

  Future<void> initializeGeoFence(
    List<Geofence> geofenceList, {
    required Function(Object a) onError,
    required Function(Location location) mockListener,
    bool isRestart = false,
  }) async {
    if (geofenceservice.isRunningService) {
      if (isRestart == false) {
        return;
      } else {
        if (geofenceservice.isRunningService) {
          stop();
          await state.geofenceService.stop();
        }
      }
    }

    final list = [...geofenceList];

    geofenceservice.addLocationChangeListener(
      (location) => onLocationChanged(
        location,
        list,
      ),
    );

    if (geofenceservice.isRunningService) {
      Log.info('running');
    }

    geofenceservice.addLocationChangeListener(mockListener);

    geofenceservice.addStreamErrorListener(onErrorStream);
    geofenceservice.addGeofenceList(list);

    return geofenceservice.start().catchError(onError);
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

  stop() async {
    state.geofenceService.clearAllListeners();
    state.geofenceService.clearGeofenceList();
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
      list.add(GeofenceRadius(
        id: key,
        length: (value as int).toDouble(),
      ));
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
