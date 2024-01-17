// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sakit_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SakitList _$$_SakitListFromJson(Map<String, dynamic> json) => _$_SakitList(
      idSakit: json['id_sakit'] as int?,
      idUser: json['id_user'] as int?,
      cUser: json['c_user'] as String?,
      cDate: json['c_date'] as String?,
      payroll: json['payroll'] as String?,
      dept: json['dept'] as String?,
      ket: json['ket'] as String?,
      surat: json['surat'] as String?,
      tglStart: json['tgl_start'] as String?,
      tglEnd: json['tgl_end'] as String?,
      totHari: json['tot_hari'] as int?,
      qtyFoto: json['qty_foto'] as int?,
      spvSta: json['spv_sta'] as bool?,
      spvTgl: json['spv_tgl'] as String?,
      hrdSta: json['hrd_sta'] as bool?,
      hrdTgl: json['hrd_tgl'] as String?,
    );

Map<String, dynamic> _$$_SakitListToJson(_$_SakitList instance) =>
    <String, dynamic>{
      'id_sakit': instance.idSakit,
      'id_user': instance.idUser,
      'c_user': instance.cUser,
      'c_date': instance.cDate,
      'payroll': instance.payroll,
      'dept': instance.dept,
      'ket': instance.ket,
      'surat': instance.surat,
      'tgl_start': instance.tglStart,
      'tgl_end': instance.tglEnd,
      'tot_hari': instance.totHari,
      'qty_foto': instance.qtyFoto,
      'spv_sta': instance.spvSta,
      'spv_tgl': instance.spvTgl,
      'hrd_sta': instance.hrdSta,
      'hrd_tgl': instance.hrdTgl,
    };
