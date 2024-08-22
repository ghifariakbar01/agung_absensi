import 'package:freezed_annotation/freezed_annotation.dart';

part 'izin_list.freezed.dart';
part 'izin_list.g.dart';

@freezed
class IzinList with _$IzinList {
  const factory IzinList({
    @JsonKey(name: 'id_izin') int? idIzin,
    @JsonKey(name: 'id_user') int? idUser,
    @JsonKey(name: 'ket') String? ket,
    @JsonKey(name: 'tgl_start') DateTime? tglStart,
    @JsonKey(name: 'tgl_end') DateTime? tglEnd,
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
    @JsonKey(name: 'hrd_note') String? hrdNote,
    @JsonKey(name: 'spv_note') String? spvNote,
    @JsonKey(name: 'tgl_start_hrd') DateTime? tglStartHrd,
    @JsonKey(name: 'tgl_end_hrd') DateTime? tglEndHrd,
    @JsonKey(name: 'tot_hari') int? totHari,
    @JsonKey(name: 'btl_sta') bool? btlSta,
    @JsonKey(name: 'btl_tgl') DateTime? btlTgl,
    @JsonKey(name: 'btl_nm') String? btlNm,
    @JsonKey(name: 'id_mst_izin') int? idMstIzin,
    @JsonKey(name: 'idkary') String? idkary,
    @JsonKey(name: 'fullname') String? fullname,
    @JsonKey(name: 'dept') String? dept,
    @JsonKey(name: 'comp') String? comp,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'email2') String? email2,
    @JsonKey(name: 'jedaspv') int? jedaspv,
    @JsonKey(name: 'jedahr') int? jedahr,
    @JsonKey(name: 'qtyfoto') int? qtyfoto,
    @JsonKey(name: 'app_spv') String? appSpv,
    @JsonKey(name: 'app_hrd') String? appHrd,
    @JsonKey(name: 'u_by') String? uBy,
    @JsonKey(name: 'c_by') String? cBy,
    @JsonKey(name: 'is_edit') bool? isEdit,
    @JsonKey(name: 'is_delete') bool? isDelete,
    @JsonKey(name: 'is_spv') bool? isSpv,
    @JsonKey(name: 'spv_msg') String? spvMsg,
    @JsonKey(name: 'is_hr') bool? isHr,
    @JsonKey(name: 'hr_msg') String? hrMsg,
    @JsonKey(name: 'is_btl') bool? isBtl,
    @JsonKey(name: 'btl_msg') String? btlMsg,
  }) = _IzinList;

  factory IzinList.fromJson(Map<String, dynamic> json) =>
      _$IzinListFromJson(json);
}
