// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel(
      {@JsonKey(name: 'id_user') required int? idUser,
      required String? nama,
      required String? fullname,
      required String? password}) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);

  factory UserModel.initial() =>
      UserModel(fullname: '', idUser: null, nama: '', password: '');
}
