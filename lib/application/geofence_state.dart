import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geofence_service/geofence_service.dart';

part 'geofence_state.freezed.dart';

const dummyLocation = {
  "latitude": -36.1863351,
  "longitude": 126.8343027,
  "accuracy": 13.517000198364258,
  "altitude": 35.10000228881836,
  "heading": 78.23506927490234,
  "speed": 0.21314042806625366,
  "speedAccuracy": 0.0,
  "millisecondsSinceEpoch": 1686304123124.0,
  "timestamp": "2023-06-09 16:48:43.124",
  "isMock": false
};

@freezed
class GeofenceState with _$GeofenceState {
  const factory GeofenceState({
    required List<Geofence> geofenceList,
    required List<double> remainingDistance,
    required int nearestIndex,
    required Location currentLocation,
  }) = _GeofenceState;

  factory GeofenceState.initial() => GeofenceState(
      geofenceList: [
        Geofence(
          id: 'stasiun_1',
          latitude: -6.192780,
          longitude: 106.831146,
          radius: [
            GeofenceRadius(id: 'radius_2m', length: 2),
          ],
        ),
      ],
      currentLocation: Location.fromJson(dummyLocation),
      nearestIndex: 0,
      remainingDistance: []);
}
