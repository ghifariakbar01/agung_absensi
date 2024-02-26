// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserList _$$_UserListFromJson(Map<String, dynamic> json) => _$_UserList(
      idUser: json['id_user'] as int?,
      idDept: json['id_dept'] as int?,
      nama: json['nama'] as String?,
      fullName: json['fullname'] as String?,
      noTelp1: json['no_telp1'] as String?,
      noTelp2: json['no_telp2'] as String?,
    );

Map<String, dynamic> _$$_UserListToJson(_$_UserList instance) =>
    <String, dynamic>{
      'id_user': instance.idUser,
      'id_dept': instance.idDept,
      'nama': instance.nama,
      'fullname': instance.fullName,
      'no_telp1': instance.noTelp1,
      'no_telp2': instance.noTelp2,
    };
