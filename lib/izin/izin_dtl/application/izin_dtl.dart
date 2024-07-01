// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'izin_dtl.freezed.dart';
part 'izin_dtl.g.dart';

@freezed
class IzinDtl with _$IzinDtl {
  factory IzinDtl({
    @JsonKey(name: 'id_izin_dtl') required int idIzinDtl,
    @JsonKey(name: 'id_izin') required int idIzin,
    @JsonKey(name: 'id_user') required int idUser,
    @JsonKey(name: 'url_img') required String urlImg,
    @JsonKey(name: 'c_user') required String cUser,
    @JsonKey(name: 'u_date') required String uDate,
    @JsonKey(name: 'c_date') required String cDate,
    @JsonKey(name: 'u_user') required String uUser,
    @JsonKey(name: 'nama_img') required String namaImg,
    // Add the rest of the fields here with their respective data types
  }) = _IzinDetail;

  factory IzinDtl.initial() => IzinDtl(
      idIzinDtl: 0,
      idIzin: 0,
      idUser: 0,
      urlImg: '',
      cUser: '',
      uDate: '',
      cDate: '',
      uUser: '',
      namaImg: '');

  factory IzinDtl.fromJson(Map<String, dynamic> json) =>
      _$IzinDtlFromJson(json);
}
