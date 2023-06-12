import 'dart:developer';
import 'dart:math';

import 'package:geofence_service/geofence_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../geofence_state.dart';

final geofenceProvider = StateNotifierProvider<GeofenceNotifier, GeofenceState>(
    (ref) => GeofenceNotifier());

class GeofenceNotifier extends StateNotifier<GeofenceState> {
  GeofenceNotifier() : super(GeofenceState.initial());

  static List<Geofence> geofenceList = [
    // Create a [Geofence] list.
    Geofence(
      id: 'stasiun_gondangdia',
      latitude: -6.192780,
      longitude: 106.831146,
      data: 'Stasiun Gondangdia',
      radius: [
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),

    // Create a [Geofence] list.
    Geofence(
      id: 'ptun_jakarta',
      latitude: -6.1960781,
      longitude: 106.8395862,
      data: 'PTUN Jakarta Halte',
      radius: [
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),

    // Create a [Geofence] list.
    Geofence(
      id: 'stasiun_manggarai',
      latitude: -6.2077213,
      longitude: 106.8485659,
      data: 'Stasiun Manggarai',
      radius: [
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),
  ];

  List<double> fillRemainingDistance() {
    final List<double> remaningDistance = [];

    geofenceList.forEach(
        (geofence) => remaningDistance.add(geofence.remainingDistance ?? 0));

    return remaningDistance;
  }

  int findNearestIndex(List<double> remainingDistance) {
    return remainingDistance
        .indexWhere((distance) => distance == findNearest(remainingDistance));
  }

  double findNearest(List<double> remainingDistance) {
    return remainingDistance.reduce(min);
  }

  void changeNearestIndex(int index) {
    state = state.copyWith(nearestIndex: index);
  }

  Future<void> initializeGeoFence() async {
    final _geofenceService = initialize();

    _geofenceService.addGeofenceStatusChangeListener(onGeofenceStatusChanged);

    _geofenceService.addLocationChangeListener(onLocationChanged);

    _geofenceService.addStreamErrorListener(onErrorStream);

    _geofenceService.addGeofenceList(geofenceList);

    state = state.copyWith(geofenceList: geofenceList);

    changeNearestIndex(findNearestIndex(fillRemainingDistance()));

    await _geofenceService.start(geofenceList).catchError(onErrorStream);
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

  // This function is to be called when the geofence status is changed.
  Future<void> onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    final distance = geofence.remainingDistance;

    print('geofence: ${geofence.toJson()}');
    print('geofenceRadius: ${geofenceRadius.toJson()}');
    print('geofenceStatus: ${geofenceStatus.toString()}');
    print('distance: $distance');

    // geofenceStreamController.sink.add(geofence);
  }

// This function is to be called when the activity has changed.
  void onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    // activityStreamController.sink.add(currActivity);
  }

// This function is to be called when the location has changed.
  void onLocationChanged(Location location) {
    print('location: ${location.toJson()}');
    state = state.copyWith(currentLocation: location);

    changeNearestIndex(findNearestIndex(fillRemainingDistance()));
  }

// This function is to be called when a location services status change occurs
// since the service was started.
  void onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
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

  void stop(GeofenceService _geofenceService) {
    _geofenceService
        .removeGeofenceStatusChangeListener(onGeofenceStatusChanged);
    _geofenceService.removeLocationChangeListener(onLocationChanged);
    _geofenceService.removeStreamErrorListener(onErrorStream);
    _geofenceService.clearAllListeners();
    _geofenceService.stop();
  }
}
