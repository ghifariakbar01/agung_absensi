// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SavedLocation _$$_SavedLocationFromJson(Map<String, dynamic> json) =>
    _$_SavedLocation(
      idGeof: json['idGeof'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      alamat: json['alamat'] as String?,
      date: DateTime.parse(json['date'] as String),
      dbDate: DateTime.parse(json['dbDate'] as String),
    );

Map<String, dynamic> _$$_SavedLocationToJson(_$_SavedLocation instance) =>
    <String, dynamic>{
      'idGeof': instance.idGeof,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'alamat': instance.alamat,
      'date': instance.date.toIso8601String(),
      'dbDate': instance.dbDate.toIso8601String(),
    };
