// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModelWithPassword _$$_UserModelWithPasswordFromJson(
        Map<String, dynamic> json) =>
    _$_UserModelWithPassword(
      idUser: json['id_user'] as int?,
      IdKary: json['IdKary'] as String?,
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
      passwordUpdate: json['pass_update'] as String?,
      payroll: json['payroll'] as String?,
      fullAkses: json['full_akses'] as bool?,
      lihat: json['lihat'] as String?,
      baru: json['baru'] as String?,
      ubah: json['ubah'] as String?,
      hapus: json['hapus'] as String?,
      spv: json['spv'] as String?,
      mgr: json['mgr'] as String?,
      fin: json['fin'] as String?,
      coo: json['coo'] as String?,
      gm: json['gm'] as String?,
      oth: json['oth'] as String?,
      password: json['password'] as String? ?? '',
      ptServer: json['ptServer'] as String? ?? '',
      isSpvOrHrd: json['isSpvOrHrd'] as bool? ?? false,
    );

Map<String, dynamic> _$$_UserModelWithPasswordToJson(
        _$_UserModelWithPassword instance) =>
    <String, dynamic>{
      'id_user': instance.idUser,
      'IdKary': instance.IdKary,
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
      'pass_update': instance.passwordUpdate,
      'payroll': instance.payroll,
      'full_akses': instance.fullAkses,
      'lihat': instance.lihat,
      'baru': instance.baru,
      'ubah': instance.ubah,
      'hapus': instance.hapus,
      'spv': instance.spv,
      'mgr': instance.mgr,
      'fin': instance.fin,
      'coo': instance.coo,
      'gm': instance.gm,
      'oth': instance.oth,
      'password': instance.password,
      'ptServer': instance.ptServer,
      'isSpvOrHrd': instance.isSpvOrHrd,
    };
