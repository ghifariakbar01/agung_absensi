// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
class UserModelWithPassword with _$UserModelWithPassword {
  const factory UserModelWithPassword(
      {@JsonKey(name: 'id_user') required int? idUser,
      required String? idKary,
      @JsonKey(name: 'imei_hp') required String? imeiHp,
      required String? nama,
      required String? fullname,
      @JsonKey(name: 'no_telp1') required String? noTelp1,
      @JsonKey(name: 'no_telp2') required String? noTelp2,
      required String? email1,
      required String? email2,
      @JsonKey(name: 'dept_list') required String? deptList,
      required String? photo,
      required String? password}) = _UserModelWithPassword;

  factory UserModelWithPassword.fromJson(Map<String, Object?> json) =>
      _$UserModelWithPasswordFromJson(json);

  factory UserModelWithPassword.initial() => UserModelWithPassword(
      fullname: '',
      idUser: null,
      nama: '',
      password: '',
      deptList: '',
      email1: '',
      email2: '',
      idKary: '',
      photo: '',
      noTelp1: '',
      noTelp2: '',
      imeiHp: '');
}




// - nik 
// - nama
// - departemen
// - perusahaan

// - foto
