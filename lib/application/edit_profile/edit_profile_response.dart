// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_response.freezed.dart';

part 'edit_profile_response.g.dart';

@freezed
class EditProfileResponse with _$EditProfileResponse {
  const factory EditProfileResponse({
    @JsonKey(name: 'id_user') required int? idUser,
    required String? idKary,
    required String? nama,
    required String? fullname,
    @JsonKey(name: 'email') required String? email1,
    required String? email2,
    @JsonKey(name: 'dept_list') required String? deptList,
    required String? picture,
  }) = _EditProfileResponse;

  factory EditProfileResponse.fromJson(Map<String, Object?> json) =>
      _$EditProfileResponseFromJson(json);

  factory EditProfileResponse.initial() => EditProfileResponse(
      fullname: '',
      idUser: null,
      nama: '',
      deptList: '',
      email1: '',
      email2: '',
      idKary: '',
      picture: '');
}




// - nik 
// - nama
// - departemen
// - perusahaan

// - foto
