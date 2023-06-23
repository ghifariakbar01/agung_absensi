import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/geofence_failure.dart';
import '../../infrastructure/geofence/geofence_repository.dart';
import 'coordinate_state.dart';
import 'geofence_coordinate_state.dart';
import 'geofence_response.dart';
import 'geofence_state.dart';

class GeofenceNotifier extends StateNotifier<GeofenceState> {
  GeofenceNotifier(
    this._repository,
  ) : super(GeofenceState.initial());

  final GeofenceRepository _repository;

  // Geofence list

  // agung probolinggo :  -6.195435,106.8387355
  // agung cut mutiah : -6.186813,106.834304
  // agung tanjung priok : -6.1099187,106.8874862
  // agung cibitong pool : -6.2774306,107.0663507

  Future<void> getGeofenceList() async {
    Either<GeofenceFailure, List<GeofenceResponse>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _repository.getGeofenceList();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  List<Geofence> geofenceResponseToList(List<GeofenceResponse> geofenceList) {
    final List<Geofence> geofences = [];

    for (var geofence in geofenceList) {
      final geofenceCoordinates =
          coordinates(coordinatesString: geofence.latLong);

      // geofenceCoordinates[0] = latitude
      // geofenceCoordinates[1] = longitude

      geofences.addAll([
        Geofence(
          id: geofence.id.toString(),
          latitude: -geofenceCoordinates[0],
          longitude: geofenceCoordinates[1],
          data: geofence.namaLokasi,
          radius: [
            GeofenceRadius(id: 'radius_100m', length: 100),
          ],
        ),
      ]);

      print(
          'geofence ${geofences.last.data} ${geofences.last.id} ${geofences.last.latitude} ${geofences.last.longitude} ${geofences.last.radius.last.length} ${geofences.last.remainingDistance} ${geofences.last.radius.first.remainingDistance}');

      // log('geofence ${geofenceListStatic.first.data} ${geofenceListStatic.first.id} ${geofenceListStatic.first.latitude} ${geofenceListStatic.first.longitude} ${geofenceListStatic.first.radius.first.length} ${geofenceListStatic.first.remainingDistance} ${geofenceListStatic.first.radius.first.remainingDistance}');
    }

    return geofences;
  }

  List<double> coordinates({required String coordinatesString}) {
    return coordinatesString
        .substring(1, coordinatesString.length - 1)
        .split(',')
        .map((coordinate) => double.parse(coordinate.trim()))
        .toList();
  }

  // Geofence initializatioin

  Future<void> initializeGeoFence(List<Geofence> geofenceListAdditional) async {
    final _geofenceService = initialize();

    _geofenceService.addLocationChangeListener(
      (location) => onLocationChanged(location, geofenceListAdditional),
    );

    _geofenceService.addStreamErrorListener(onErrorStream);

    _geofenceService.addGeofenceList([...geofenceListAdditional]);

    await _geofenceService
        .start([...geofenceListAdditional]).catchError(onErrorStream);
  }

  GeofenceService initialize() {
    // Create a [GeofenceService] instance and set options.
    return GeofenceService.instance.setup(
        interval: 5000,
        accuracy: 100,
        loiteringDelayMs: 60000,
        statusChangeDelayMs: 10000,
        useActivityRecognition: false,
        allowMockLocations: false,
        printDevLog: false,
        geofenceRadiusSortType: GeofenceRadiusSortType.DESC);
  }

  // Geofence listener

  // This function is to be called when the location has changed.
  onLocationChanged(Location location, List<Geofence> coordinates) {
    print('location: ${location.toJson()}');
    state = state.copyWith(currentLocation: location);

    final geofenceCoordinates = state.geofenceCoordinates;

    updateAndChangeNearest(
        coordinates: coordinates,
        designatedCoordinate: location,
        geofenceCoordinates: geofenceCoordinates);
  }

  // This function is used to handle errors that occur in the service.
  void onErrorStream(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

  // Utils

  void stop(GeofenceService _geofenceService,
      List<GeofenceResponse> geofenceList, List<Geofence> geofence) {
    _geofenceService.removeLocationChangeListener(
        onLocationChanged(geofenceList as Location, geofence));
    _geofenceService.removeStreamErrorListener(onErrorStream);
    _geofenceService.clearAllListeners();
    _geofenceService.stop();
  }

  // Remaining distance

  List<GeofenceCoordinate> updateCoordinatesFromGeofence(
      Location designatedCoordinate, List<Geofence> coordinates) {
    List<GeofenceCoordinate> coordinatesupdated = coordinates
        .map((coordinate) => GeofenceCoordinate(
            id: coordinate.id,
            nama: coordinate.data,
            coordinate: Coordinate(
                latitude: coordinate.latitude, longitude: coordinate.longitude),
            remainingDistance:
                calculateDistance(designatedCoordinate, coordinate)))
        .toList();

    for (var geofence in coordinatesupdated) {
      print('geofence ${geofence.id}');
      print('geofence ${geofence.nama}');
      print('geofence ${geofence.coordinate.latitude}');
      print('geofence ${geofence.coordinate.latitude}');
    }

    return coordinatesupdated;
  }

  void changeGeofenceCoordinates(List<GeofenceCoordinate> coordinates) {
    print('coordinates ${coordinates.first} ${coordinates.last}');

    state = state.copyWith(geofenceCoordinates: [...coordinates]);
  }

  getSmallestDistance(List<GeofenceCoordinate> coordinates) {
    return minBy(coordinates,
        (GeofenceCoordinate coordinate) => coordinate.remainingDistance);
  }

  void changeNearest(GeofenceCoordinate coordinate) {
    print('coordinate nearest $coordinate');

    state = state.copyWith(nearestCoordinates: coordinate);
  }

  void updateAndChangeNearest(
      {required Location designatedCoordinate,
      required List<Geofence> coordinates,
      required List<GeofenceCoordinate> geofenceCoordinates}) {
    changeGeofenceCoordinates(
        updateCoordinatesFromGeofence(designatedCoordinate, coordinates));

    changeNearest(getSmallestDistance(geofenceCoordinates));
  }

  double calculateDistance(Location location, Geofence geofence) {
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

  double degreeToRadians(double degree) {
    return degree * pi / 180;
  }
}
