// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'create_sakit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CreateSakit _$$_CreateSakitFromJson(Map<String, dynamic> json) =>
    _$_CreateSakit(
      jadwalSabtu: json['jdw_sabtu'] as String?,
      hitungLibur: json['hitunglibur'] as int?,
      bulanan: json['bulanan'] as bool? ?? false,
      masuk: json['Masuk'] as String?,
    );

Map<String, dynamic> _$$_CreateSakitToJson(_$_CreateSakit instance) =>
    <String, dynamic>{
      'jdw_sabtu': instance.jadwalSabtu,
      'hitunglibur': instance.hitungLibur,
      'bulanan': instance.bulanan,
      'Masuk': instance.masuk,
    };
