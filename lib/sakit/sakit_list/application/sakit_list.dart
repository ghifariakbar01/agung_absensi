// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sakit_list.freezed.dart';
part 'sakit_list.g.dart';

@freezed
class SakitList with _$SakitList {
  factory SakitList({
    @JsonKey(name: 'id_sakit') int? idSakit,
    @JsonKey(name: 'id_user') int? idUser,
    @JsonKey(name: 'id_dept') int? idDept,
    @JsonKey(name: 'c_user') String? cUser,
    @JsonKey(name: 'c_date') String? cDate,
    @JsonKey(name: 'u_date') String? uDate,
    @JsonKey(name: 'no_telp1') String? noTelp1,
    @JsonKey(name: 'no_telp2') String? noTelp2,
    @JsonKey(name: 'payroll') String? payroll,
    @JsonKey(name: 'fullname') String? fullname,
    @JsonKey(name: 'comp') String? comp,
    @JsonKey(name: 'dept') String? dept,
    @JsonKey(name: 'ket') String? ket,
    @JsonKey(name: 'surat') String? surat,
    @JsonKey(name: 'btl_sta') bool? batalStatus,
    @JsonKey(name: 'btl_nm') String? batalNama,
    @JsonKey(name: 'tgl_start') String? tglStart,
    @JsonKey(name: 'tgl_end') String? tglEnd,
    @JsonKey(name: 'tot_hari') int? totHari,
    @JsonKey(name: 'qty_foto') int? qtyFoto,
    @JsonKey(name: 'spv_sta') bool? spvSta,
    @JsonKey(name: 'spv_tgl') String? spvTgl,
    @JsonKey(name: 'spv_note') String? spvNote,
    @JsonKey(name: 'hrd_sta') bool? hrdSta,
    @JsonKey(name: 'hrd_tgl') String? hrdTgl,
    @JsonKey(name: 'hrd_note') String? hrdNote,
  }) = _SakitList;

  factory SakitList.fromJson(Map<String, dynamic> json) =>
      _$SakitListFromJson(json);
}
