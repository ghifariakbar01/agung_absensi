// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sakit_dtl.freezed.dart';
part 'sakit_dtl.g.dart';

@freezed
class SakitDtl with _$SakitDtl {
  factory SakitDtl({
    @JsonKey(name: 'id_sakit_dtl') required int idSakitDtl,
    @JsonKey(name: 'id_sakit') required int idSakit,
    @JsonKey(name: 'id_user') required int idUser,
    @JsonKey(name: 'url_img') required String urlImg,
    @JsonKey(name: 'c_user') required String cUser,
    @JsonKey(name: 'u_date') required String uDate,
    @JsonKey(name: 'c_date') required String cDate,
    @JsonKey(name: 'u_user') required String uUser,
    @JsonKey(name: 'nama_img') required String namaImg,
    // Add the rest of the fields here with their respective data types
  }) = _SakitDetail;

  factory SakitDtl.initial() => SakitDtl(
      idSakitDtl: 0,
      idSakit: 0,
      idUser: 0,
      urlImg: '',
      cUser: '',
      uDate: '',
      cDate: '',
      uUser: '',
      namaImg: '');

  factory SakitDtl.fromJson(Map<String, dynamic> json) =>
      _$SakitDtlFromJson(json);
}
