// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tugas_dinas_dtl.freezed.dart';
part 'tugas_dinas_dtl.g.dart';

@freezed
class TugasDinasDtl with _$TugasDinasDtl {
  factory TugasDinasDtl({
    @JsonKey(name: 'id_dinas_files') required int idDinasFiles,
    @JsonKey(name: 'id_dinas') required int idDinas,
    @JsonKey(name: 'id_user') required int? idUser,
    @JsonKey(name: 'url_img') required String urlImg,
    @JsonKey(name: 'c_user') required String cUser,
    @JsonKey(name: 'u_date') required String uDate,
    @JsonKey(name: 'c_date') required String cDate,
    @JsonKey(name: 'u_user') required String uUser,
    @JsonKey(name: 'nama_img') required String namaImg,
    // Add the rest of the fields here with their respective data types
  }) = _TugasDinasDetail;

  factory TugasDinasDtl.initial() => TugasDinasDtl(
      idDinasFiles: 0,
      idDinas: 0,
      idUser: 0,
      urlImg: '',
      cUser: '',
      uDate: '',
      cDate: '',
      uUser: '',
      namaImg: '');

  factory TugasDinasDtl.fromJson(Map<String, dynamic> json) =>
      _$TugasDinasDtlFromJson(json);
}
