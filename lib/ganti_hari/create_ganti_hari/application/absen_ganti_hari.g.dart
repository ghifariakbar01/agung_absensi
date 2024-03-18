// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absen_ganti_hari.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AbsenGantiHari _$$_AbsenGantiHariFromJson(Map<String, dynamic> json) =>
    _$_AbsenGantiHari(
      idAbsen: json['id_absen'] as int,
      nama: json['nama'] as String,
      jdwIn: json['jdw_in'] as String,
      jdwOut: json['jdw_out'] as String,
      creationDate: json['c_date'] as String,
      createdBy: json['c_user'] as String,
      updateDate: json['u_date'] as String,
      updatedBy: json['u_user'] as String,
    );

Map<String, dynamic> _$$_AbsenGantiHariToJson(_$_AbsenGantiHari instance) =>
    <String, dynamic>{
      'id_absen': instance.idAbsen,
      'nama': instance.nama,
      'jdw_in': instance.jdwIn,
      'jdw_out': instance.jdwOut,
      'c_date': instance.creationDate,
      'c_user': instance.createdBy,
      'u_date': instance.updateDate,
      'u_user': instance.updatedBy,
    };
