import 'package:freezed_annotation/freezed_annotation.dart';

part 'lembur_list.freezed.dart';
part 'lembur_list.g.dart';

@freezed
class LemburList with _$LemburList {
  const factory LemburList({
    @JsonKey(name: 'id_lmbr') int? idLmbr,
    @JsonKey(name: 'id_user') int? idUser,
    String? ket,
    @JsonKey(name: 'lmbr_tgl') String? lmbrTgl,
    @JsonKey(name: 'jam_awal') String? jamAwal,
    @JsonKey(name: 'spv_sta') bool? spvSta,
    @JsonKey(name: 'spv_nm') String? spvNm,
    @JsonKey(name: 'spv_tgl') String? spvTgl,
    @JsonKey(name: 'hrd_sta') bool? hrdSta,
    @JsonKey(name: 'hrd_nm') String? hrdNm,
    @JsonKey(name: 'hrd_tgl') String? hrdTgl,
    @JsonKey(name: 'c_date') String? cDate,
    @JsonKey(name: 'c_user') String? cUser,
    @JsonKey(name: 'u_date') String? uDate,
    @JsonKey(name: 'u_user') String? uUser,
    @JsonKey(name: 'jam_akhir') String? jamAkhir,
    @JsonKey(name: 'spv_note') String? spvNote,
    @JsonKey(name: 'hrd_note') String? hrdNote,
    String? kategori,
    @JsonKey(name: 'btl_sta') bool? btlSta,
    @JsonKey(name: 'btl_nm') String? btlNm,
    @JsonKey(name: 'btl_tgl') String? btlTgl,
    @JsonKey(name: 'gm_sta') bool? gmSta,
    @JsonKey(name: 'gm_nm') String? gmNm,
    @JsonKey(name: 'gm_tgl') String? gmTgl,
    @JsonKey(name: 'gm_note') String? gmNote,
    @JsonKey(name: 'IdKary') String? idKary,
    String? fullname,
    String? dept,
    String? comp,
    String? email,
    String? email2,
    @JsonKey(name: 'jam_lbr') int? jamLbr,
    @JsonKey(name: 'app_spv') String? appSpv,
    @JsonKey(name: 'app_hrd') String? appHrd,
    @JsonKey(name: 'u_by') String? uBy,
    @JsonKey(name: 'c_by') String? cBy,
    int? jedaspv,
    int? jedahr,
    @JsonKey(name: 'is_edit') bool? isEdit,
    @JsonKey(name: 'is_delete') bool? isDelete,
    @JsonKey(name: 'is_spv_note') bool? isSpvNote,
    @JsonKey(name: 'is_hr_note') bool? isHrNote,
    @JsonKey(name: 'is_spv') bool? isSpv,
    @JsonKey(name: 'spv_msg') String? spvMsg,
    @JsonKey(name: 'is_hr') bool? isHr,
    @JsonKey(name: 'hr_msg') String? hrMsg,
    @JsonKey(name: 'is_btl') bool? isBtl,
    @JsonKey(name: 'btl_msg') String? btlMsg,
    String? masuk,
    String? pulang,
  }) = _LemburList;

  factory LemburList.fromJson(Map<String, dynamic> json) =>
      _$LemburListFromJson(json);
}
