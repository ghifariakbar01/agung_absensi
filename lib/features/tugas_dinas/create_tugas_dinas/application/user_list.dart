// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_list.freezed.dart';
part 'user_list.g.dart';

@freezed
class UserList with _$UserList {
  factory UserList({
    @JsonKey(name: 'id_user') required int? idUser,
    required String? nama,
    required String? fullname,
  }) = _UserList;

  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);

  factory UserList.initial() => UserList(idUser: 0, nama: '', fullname: '');
}
