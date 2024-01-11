// GENERATED CODE - DO NOT MODIFY BY HAND

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
      createSakitCuti: json['createSakitCuti'] == null
          ? null
          : CreateSakitCuti.fromJson(
              json['createSakitCuti'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CreateSakitToJson(_$_CreateSakit instance) =>
    <String, dynamic>{
      'jdw_sabtu': instance.jadwalSabtu,
      'hitunglibur': instance.hitungLibur,
      'bulanan': instance.bulanan,
      'Masuk': instance.masuk,
      'createSakitCuti': instance.createSakitCuti,
    };
