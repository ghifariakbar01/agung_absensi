import 'dart:convert';
import 'dart:developer' as log;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

import 'package:geofence_service/geofence_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/geofence_failure.dart';
import '../../infrastructure/geofence/geofence_repository.dart';
import '../background/background_item_state.dart';
import '../background/saved_location.dart';
import 'coordinate_state.dart';
import 'geofence_coordinate_state.dart';
import 'geofence_response.dart';
import 'geofence_state.dart';

class GeofenceNotifier extends StateNotifier<GeofenceState> {
  GeofenceNotifier(
    this._repository,
  ) : super(GeofenceState.initial());

  final GeofenceRepository _repository;

  Future<void> getGeofenceList() async {
    Either<GeofenceFailure, List<GeofenceResponse>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _repository.getGeofenceList();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

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
            latitude: -geofenceCoordinates[0],
            longitude: geofenceCoordinates[1],
            data: geofence.namaLokasi,
            radius: radius),
      ]);
    }

    return geofences;
  }

  Future<void> startAutoAbsen({
    required List<GeofenceResponse> geofenceResponseList,
    required List<BackgroundItemState> savedBackgroundItems,
    required Future<void> Function(List<GeofenceResponse>) saveGeofence,
    required Future<void> Function(List<BackgroundItemState>) startAbsen,
  }) async {
    await saveGeofence(geofenceResponseList);
    await startAbsen(savedBackgroundItems);
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
        .substring(1, coordinatesString.length - 1)
        .split(',')
        .map((coordinate) => double.parse(coordinate.trim()))
        .toList();
  }

  // Geofence initializatioin

  Future<void> initializeGeoFence(List<SavedLocation>? savedLocations,
      List<Geofence> geofenceListAdditional,
      {required Function? onError}) async {
    final _geofenceService = initialize();

    if (savedLocations != null) {
      _geofenceService.addLocationChangeListener(
        (location) => onLocationChanged(
          location,
          geofenceListAdditional,
          savedLocations,
        ),
      );
    } else {
      // log.debugger(message: 'called');
      _geofenceService.addLocationChangeListener(
        (location) => onLocationChanged(location, geofenceListAdditional, null),
      );
    }

    _geofenceService.addStreamErrorListener(onErrorStream);

    _geofenceService.addGeofenceList([...geofenceListAdditional]);

    await _geofenceService
        .start([...geofenceListAdditional])
        .catchError(onError ?? () {})
        .onError((error, stackTrace) {
          // log.debugger(message: 'called');

          log.log('error $error stack $stackTrace');
        });
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
  onLocationChanged(
    Location location,
    List<Geofence> coordinates,
    List<SavedLocation>? locations,
  ) {
    print('location: ${location.toJson()}');

    if (locations != null) {
      final geofenceCoordinatesSaved = state.geofenceCoordinatesSaved;

      final designatedCoordinate = convertSavedLocationsToLocations(locations);

      updateAndChangeNearestSaved(
          coordinates: coordinates,
          designatedCoordinate: designatedCoordinate,
          geofenceCoordinatesSaved: geofenceCoordinatesSaved);
    }

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

  void stop(
      GeofenceService _geofenceService,
      List<GeofenceResponse> geofenceList,
      List<Geofence> geofence,
      List<SavedLocation> savedLocations) {
    _geofenceService.removeLocationChangeListener(onLocationChanged(
      geofenceList as Location,
      geofence,
      savedLocations,
    ));
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
            minDistance: coordinate.radius.isNotEmpty
                ? coordinate.radius.first.length
                : 100,
            remainingDistance:
                calculateDistance(designatedCoordinate, coordinate)))
        .toList();

    for (var geofence in coordinatesupdated) {
      // print('geofence ${geofence.id}');
      // print('geofence ${geofence.nama}');
      // print('geofence ${geofence.coordinate.latitude}');
      // print('geofence ${geofence.coordinate.latitude}');
    }

    return coordinatesupdated;
  }

  List<GeofenceCoordinate> updateCoordinatesSavedFromGeofence(
      List<Location> designatedCoordinate, List<Geofence> coordinates) {
    final List<GeofenceCoordinate> coordinatesList = [];

    for (final location in designatedCoordinate) {
      List<GeofenceCoordinate> coordinatesupdated = coordinates
          .map(
            (coordinate) => GeofenceCoordinate(
                id: coordinate.id,
                nama: coordinate.data,
                coordinate: Coordinate(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude),
                minDistance: coordinate.radius.isNotEmpty
                    ? coordinate.radius.first.length
                    : 100,
                remainingDistance: calculateDistance(location, coordinate)),
          )
          .toList();

      for (var geofence in coordinatesupdated) {
        print('geofence ${geofence.id}');
        print('geofence ${geofence.nama}');
        print('geofence ${geofence.coordinate.latitude}');
        print('geofence ${geofence.coordinate.latitude}');
      }

      coordinatesList.addAll(coordinatesupdated);
    }

    return coordinatesList;
  }

  void changeGeofenceCoordinates(List<GeofenceCoordinate> coordinates) {
    // print('coordinates ${coordinates.first} ${coordinates.last}');

    state = state.copyWith(geofenceCoordinates: [...coordinates]);
  }

  void changeGeofenceCoordinatesSaved(List<GeofenceCoordinate> coordinates) {
    print('coordinates ${coordinates.first} ${coordinates.last}');

    state = state.copyWith(geofenceCoordinatesSaved: [...coordinates]);
  }

  getSmallestDistance(List<GeofenceCoordinate> coordinates) {
    return minBy(coordinates,
        (GeofenceCoordinate coordinate) => coordinate.remainingDistance);
  }

  /*
    [
      ['0', 'nama', Coordinate, 59], 
      ['1', 'nama dua', Coordinate, 50], 
      ['2', 'nama tiga', Coordinate, 89], 
      ['3', 'nama empat', Coordinate, 99] 
    ]
  **/

  List<GeofenceCoordinate> getSmallestDistanceSaved(
      List<GeofenceCoordinate> coordinates, List<Location> locations) {
    List<GeofenceCoordinate> coordinateList = [];

    for (int i = 0; i < locations.length; i++) {
      final coordinate = minBy(coordinates,
          (GeofenceCoordinate coordinate) => coordinate.remainingDistance);

      coordinateList.add(coordinate ?? GeofenceCoordinate.initial());
    }

    return coordinateList;
  }

  void changeNearest(GeofenceCoordinate coordinate) {
    state = state.copyWith(nearestCoordinates: coordinate);
  }

  void changeNearestSaved(List<GeofenceCoordinate> coordinates) {
    print('coordinate nearest $coordinates');

    state = state.copyWith(nearestCoordinatesSaved: [...coordinates]);
  }

  List<Location> convertSavedLocationsToLocations(
      List<SavedLocation>? locations) {
    if (locations == null) {
      log.debugger(message: 'called');

      return [];
    }

    return locations.map((savedLocation) {
      return Location(
        latitude: savedLocation.latitude ?? 0.0,
        longitude: savedLocation.longitude ?? 0.0,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        millisecondsSinceEpoch:
            savedLocation.date.millisecondsSinceEpoch.toDouble(),
        timestamp: savedLocation.date,
        isMock: false,
      );
    }).toList();
  }

  void updateAndChangeNearest(
      {required Location designatedCoordinate,
      required List<Geofence> coordinates,
      required List<GeofenceCoordinate> geofenceCoordinates}) {
    changeGeofenceCoordinates(
        updateCoordinatesFromGeofence(designatedCoordinate, coordinates));

    changeNearest(getSmallestDistance(geofenceCoordinates));
  }

  void updateAndChangeNearestSaved(
      {required List<Location> designatedCoordinate,
      required List<Geofence> coordinates,
      required List<GeofenceCoordinate> geofenceCoordinatesSaved}) {
    changeGeofenceCoordinatesSaved(
        updateCoordinatesSavedFromGeofence(designatedCoordinate, coordinates));

    changeNearestSaved(getSmallestDistanceSaved(
        geofenceCoordinatesSaved, designatedCoordinate));
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
