// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'edit_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EditProfileResponse _$$_EditProfileResponseFromJson(
        Map<String, dynamic> json) =>
    _$_EditProfileResponse(
      idUser: json['id_user'] as int?,
      idKary: json['idKary'] as String?,
      nama: json['nama'] as String?,
      fullname: json['fullname'] as String?,
      email1: json['email'] as String?,
      email2: json['email2'] as String?,
      deptList: json['dept_list'] as String?,
      picture: json['picture'] as String?,
    );

Map<String, dynamic> _$$_EditProfileResponseToJson(
        _$_EditProfileResponse instance) =>
    <String, dynamic>{
      'id_user': instance.idUser,
      'idKary': instance.idKary,
      'nama': instance.nama,
      'fullname': instance.fullname,
      'email': instance.email1,
      'email2': instance.email2,
      'dept_list': instance.deptList,
      'picture': instance.picture,
    };
