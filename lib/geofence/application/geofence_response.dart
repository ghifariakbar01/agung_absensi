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
}
