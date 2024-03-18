// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SavedLocation _$$_SavedLocationFromJson(Map<String, dynamic> json) =>
    _$_SavedLocation(
      date: DateTime.parse(json['date'] as String),
      alamat: json['alamat'] as String?,
      idGeof: json['idGeof'] as String?,
      dbDate: DateTime.parse(json['dbDate'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      absenState:
          AbsenState.fromJson(json['absenState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_SavedLocationToJson(_$_SavedLocation instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'alamat': instance.alamat,
      'idGeof': instance.idGeof,
      'dbDate': instance.dbDate.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'absenState': instance.absenState,
    };
