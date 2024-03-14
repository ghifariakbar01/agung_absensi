// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'recent_absen_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RecentAbsenState _$$_RecentAbsenStateFromJson(Map<String, dynamic> json) =>
    _$_RecentAbsenState(
      savedLocation:
          SavedLocation.fromJson(json['savedLocation'] as Map<String, dynamic>),
      dateAbsen: DateTime.parse(json['dateAbsen'] as String),
      jenisAbsen: $enumDecode(_$JenisAbsenEnumMap, json['jenisAbsen']),
    );

Map<String, dynamic> _$$_RecentAbsenStateToJson(_$_RecentAbsenState instance) =>
    <String, dynamic>{
      'savedLocation': instance.savedLocation,
      'dateAbsen': instance.dateAbsen.toIso8601String(),
      'jenisAbsen': _$JenisAbsenEnumMap[instance.jenisAbsen]!,
    };

const _$JenisAbsenEnumMap = {
  JenisAbsen.absenIn: 'absenIn',
  JenisAbsen.absenOut: 'absenOut',
  JenisAbsen.unknown: 'unknown',
};
