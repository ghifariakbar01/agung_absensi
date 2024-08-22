// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_response.freezed.dart';

part 'geofence_response.g.dart';

@freezed
class GeofenceResponse with _$GeofenceResponse {
  const factory GeofenceResponse({
    @JsonKey(name: 'id_geof') required int id,
    @JsonKey(name: 'nm_lokasi') required String namaLokasi,
    @JsonKey(name: 'geof') required String latLong,
    required String radius,
  }) = _GeofenceResponse;

  factory GeofenceResponse.fromJson(Map<String, Object?> json) =>
      _$GeofenceResponseFromJson(json);

  factory GeofenceResponse.inital() => GeofenceResponse(
        id: 2,
        namaLokasi: 'Agung Logistics Cut Mutiah',
        latLong: '-6.1863276,106.8343200',
        radius: '{u0027radius_30mu0027 : 30}',
      );
}
