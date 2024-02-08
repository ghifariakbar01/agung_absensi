// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GeofenceResponse _$$_GeofenceResponseFromJson(Map<String, dynamic> json) =>
    _$_GeofenceResponse(
      id: json['id_geof'] as int,
      namaLokasi: json['nm_lokasi'] as String,
      latLong: json['geof'] as String,
      radius: json['radius'] as String,
    );

Map<String, dynamic> _$$_GeofenceResponseToJson(_$_GeofenceResponse instance) =>
    <String, dynamic>{
      'id_geof': instance.id,
      'nm_lokasi': instance.namaLokasi,
      'geof': instance.latLong,
      'radius': instance.radius,
    };
