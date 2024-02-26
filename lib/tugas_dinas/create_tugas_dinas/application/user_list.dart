// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_list.freezed.dart';
part 'user_list.g.dart';

@freezed
class UserList with _$UserList {
  factory UserList({
    @JsonKey(name: 'id_user') required int? idUser,
    @JsonKey(name: 'id_dept') required int? idDept,
    required String? nama,
    @JsonKey(name: 'fullname') required String? fullName,
    @JsonKey(name: 'no_telp1') String? noTelp1,
    @JsonKey(name: 'no_telp2') required String? noTelp2,
  }) = _UserList;

  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);

  factory UserList.initial() =>
      UserList(idUser: 0, idDept: 0, nama: '', fullName: '', noTelp2: '');
}
