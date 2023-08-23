// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SavedLocation _$$_SavedLocationFromJson(Map<String, dynamic> json) =>
    _$_SavedLocation(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      alamat: json['alamat'] as String?,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$_SavedLocationToJson(_$_SavedLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'alamat': instance.alamat,
      'date': instance.date.toIso8601String(),
    };
