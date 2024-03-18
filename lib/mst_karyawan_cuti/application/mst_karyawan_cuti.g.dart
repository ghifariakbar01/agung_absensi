// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mst_karyawan_cuti.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MstKaryawanCuti _$$_MstKaryawanCutiFromJson(Map<String, dynamic> json) =>
    _$_MstKaryawanCuti(
      idMstCuti: json['id_mst_cuti'] as int?,
      openDate: json['open_date'] == null
          ? null
          : DateTime.parse(json['open_date'] as String),
      closeDate: json['close_date'] == null
          ? null
          : DateTime.parse(json['close_date'] as String),
      tahunCutiTidakBaru: json['tahun_cuti_tidak_baru'] as String?,
      tahunCutiBaru: json['tahun_cuti_baru'] as String?,
      cutiTidakBaru: json['cuti_tidak_baru'] as int?,
      cutiBaru: json['cuti_baru'] as int?,
    );

Map<String, dynamic> _$$_MstKaryawanCutiToJson(_$_MstKaryawanCuti instance) =>
    <String, dynamic>{
      'id_mst_cuti': instance.idMstCuti,
      'open_date': instance.openDate?.toIso8601String(),
      'close_date': instance.closeDate?.toIso8601String(),
      'tahun_cuti_tidak_baru': instance.tahunCutiTidakBaru,
      'tahun_cuti_baru': instance.tahunCutiBaru,
      'cuti_tidak_baru': instance.cutiTidakBaru,
      'cuti_baru': instance.cutiBaru,
    };
