// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'sakit_dtl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SakitDetail _$$_SakitDetailFromJson(Map<String, dynamic> json) =>
    _$_SakitDetail(
      idSakitDtl: json['id_sakit_dtl'] as int,
      idSakit: json['id_sakit'] as int,
      idUser: json['id_user'] as int,
      urlImg: json['url_img'] as String,
      cUser: json['c_user'] as String,
      uDate: json['u_date'] as String,
      cDate: json['c_date'] as String,
      uUser: json['u_user'] as String,
      namaImg: json['nama_img'] as String,
    );

Map<String, dynamic> _$$_SakitDetailToJson(_$_SakitDetail instance) =>
    <String, dynamic>{
      'id_sakit_dtl': instance.idSakitDtl,
      'id_sakit': instance.idSakit,
      'id_user': instance.idUser,
      'url_img': instance.urlImg,
      'c_user': instance.cUser,
      'u_date': instance.uDate,
      'c_date': instance.cDate,
      'u_user': instance.uUser,
      'nama_img': instance.namaImg,
    };
