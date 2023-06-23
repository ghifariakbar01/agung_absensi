import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinate_state.dart';

part 'geofence_coordinate_state.freezed.dart';

@freezed
class GeofenceCoordinate with _$GeofenceCoordinate {
  const factory GeofenceCoordinate(
      {required String id,
      required String nama,
      required Coordinate coordinate,
      required double remainingDistance}) = _GeofenceCoordinate;

  factory GeofenceCoordinate.initial() => GeofenceCoordinate(
      coordinate: Coordinate(
        latitude: 0,
        longitude: 0,
      ),
      id: '',
      nama: '',
      remainingDistance: 0);
}
