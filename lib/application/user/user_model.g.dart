// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModelWithPassword _$$_UserModelWithPasswordFromJson(
        Map<String, dynamic> json) =>
    _$_UserModelWithPassword(
      idUser: json['id_user'] as int?,
      idKary: json['idKary'] as String?,
      ktp: json['ktp'] as String?,
      deptList: json['dept'] as String?,
      company: json['comp'] as String?,
      jabatan: json['jbt'] as String?,
      imeiHp: json['imei_hp'] as String?,
      nama: json['nama'] as String?,
      fullname: json['fullname'] as String?,
      noTelp1: json['no_telp1'] as String?,
      noTelp2: json['no_telp2'] as String?,
      email: json['email'] as String?,
      email2: json['email2'] as String?,
      photo: json['photo'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$$_UserModelWithPasswordToJson(
        _$_UserModelWithPassword instance) =>
    <String, dynamic>{
      'id_user': instance.idUser,
      'idKary': instance.idKary,
      'ktp': instance.ktp,
      'dept': instance.deptList,
      'comp': instance.company,
      'jbt': instance.jabatan,
      'imei_hp': instance.imeiHp,
      'nama': instance.nama,
      'fullname': instance.fullname,
      'no_telp1': instance.noTelp1,
      'no_telp2': instance.noTelp2,
      'email': instance.email,
      'email2': instance.email2,
      'photo': instance.photo,
      'password': instance.password,
    };
