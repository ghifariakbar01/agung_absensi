part of 'geofence_state.dart';

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

Geofence dummyGeofence = Geofence(
  id: 'dummy_1',
  latitude: -6.192780,
  longitude: 106.831146,
  radius: [
    GeofenceRadius(id: 'radius_2m', length: 2),
  ],
);
