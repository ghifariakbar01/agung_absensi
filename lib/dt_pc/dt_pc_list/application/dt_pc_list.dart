import 'package:freezed_annotation/freezed_annotation.dart';

part 'dt_pc_list.freezed.dart';
part 'dt_pc_list.g.dart';

@freezed
class DtPcList with _$DtPcList {
  const factory DtPcList({
    @JsonKey(name: 'id_dt') int? idDt,
    @JsonKey(name: 'id_user') int? idUser,
    @JsonKey(name: 'ket') String? ket,
    @JsonKey(name: 'dt_tgl') DateTime? dtTgl,
    @JsonKey(name: 'jam') DateTime? jam,
    @JsonKey(name: 'spv_sta') bool? spvSta,
    @JsonKey(name: 'spv_nm') String? spvNm,
    @JsonKey(name: 'spv_tgl') DateTime? spvTgl,
    @JsonKey(name: 'hrd_sta') bool? hrdSta,
    @JsonKey(name: 'hrd_nm') String? hrdNm,
    @JsonKey(name: 'hrd_tgl') DateTime? hrdTgl,
    @JsonKey(name: 'c_date') DateTime? cDate,
    @JsonKey(name: 'c_user') String? cUser,
    @JsonKey(name: 'u_date') DateTime? uDate,
    @JsonKey(name: 'u_user') String? uUser,
    @JsonKey(name: 'kategori') String? kategori,
    @JsonKey(name: 'spv_note') String? spvNote,
    @JsonKey(name: 'hrd_note') String? hrdNote,
    @JsonKey(name: 'periode') String? periode,
    @JsonKey(name: 'btl_sta') bool? btlSta,
    @JsonKey(name: 'btl_nm') String? btlNm,
    @JsonKey(name: 'btl_tgl') DateTime? btlTgl,
    @JsonKey(name: 'IdKary') String? idKary,
    @JsonKey(name: 'fullname') String? fullname,
    @JsonKey(name: 'dept') String? dept,
    @JsonKey(name: 'comp') String? comp,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'email2') String? email2,
    @JsonKey(name: 'jedaspv') int? jedaspv,
    @JsonKey(name: 'jedahr') int? jedahr,
    @JsonKey(name: 'app_spv') String? appSpv,
    @JsonKey(name: 'app_hrd') String? appHrd,
    @JsonKey(name: 'u_by') String? uBy,
    @JsonKey(name: 'c_by') String? cBy,
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
  }) = _DtPcList;

  factory DtPcList.fromJson(Map<String, dynamic> json) =>
      _$DtPcListFromJson(json);
}
