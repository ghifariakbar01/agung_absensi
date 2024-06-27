// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cuti_list.freezed.dart';
part 'cuti_list.g.dart';

@freezed
class CutiList with _$CutiList {
  const factory CutiList({
    @JsonKey(name: 'id_cuti') required int? idCuti,
    @JsonKey(name: 'id_user') required int? idUser,
    @JsonKey(name: 'IdKary') required String? idKary,
    @JsonKey(name: 'jenis_cuti') required String? jenisCuti,
    @JsonKey(name: 'alasan') required String? alasan,
    @JsonKey(name: 'ket') required String? ket,
    @JsonKey(name: 'bulan_cuti') required String? bulanCuti,
    @JsonKey(name: 'tahun_cuti') required String? tahunCuti,
    @JsonKey(name: 'total_hari') required int? totalHari,
    @JsonKey(name: 'sisa_cuti') required int? sisaCuti,
    @JsonKey(name: 'tgl_start') required DateTime? tglStart,
    @JsonKey(name: 'tgl_end') required DateTime? tglEnd,
    @JsonKey(name: 'tgl_start_hrd') required DateTime? tglStartHrd,
    @JsonKey(name: 'tgl_end_hrd') required DateTime? tglEndHrd,
    @JsonKey(name: 'spv_sta') required bool? spvSta,
    @JsonKey(name: 'spv_nm') required String? spvNm,
    @JsonKey(name: 'spv_tgl') required DateTime? spvTgl,
    @JsonKey(name: 'spv_note') required String? spvNote,
    @JsonKey(name: 'hrd_sta') required bool? hrdSta,
    @JsonKey(name: 'hrd_nm') required String? hrdNm,
    @JsonKey(name: 'hrd_tgl') required DateTime? hrdTgl,
    @JsonKey(name: 'hrd_note') required String? hrdNote,
    @JsonKey(name: 'btl_sta') required bool? btlSta,
    @JsonKey(name: 'btl_nm') required String? btlNm,
    @JsonKey(name: 'btl_tgl') required DateTime? btlTgl,
    @JsonKey(name: 'c_date') required DateTime? cDate,
    @JsonKey(name: 'c_user') required String? cUser,
    @JsonKey(name: 'u_date') required DateTime? uDate,
    @JsonKey(name: 'u_user') required String? uUser,
    @JsonKey(name: 'saldo_awal') required int? saldoAwal,
    @JsonKey(name: 'saldo_akhir') required int? saldoAkhir,
    @JsonKey(name: 'fullname') required String? fullname,
    @JsonKey(name: 'dept') required String? dept,
    @JsonKey(name: 'email') required String? email,
    @JsonKey(name: 'email2') required String? email2,
    @JsonKey(name: 'comp') required String? comp,
    @JsonKey(name: 'open_date') required int? openDate,
    @JsonKey(name: 'app_spv') required String? appSpv,
    @JsonKey(name: 'app_hrd') required String? appHrd,
    @JsonKey(name: 'u_by') required String? uBy,
    @JsonKey(name: 'c_by') required String? cBy,
    @JsonKey(name: 'jedaspv') required int? jedaspv,
    @JsonKey(name: 'jedahr') required int? jedahr,
    @JsonKey(name: 'is_edit') required bool? isEdit,
    @JsonKey(name: 'is_delete') required bool? isDelete,
    @JsonKey(name: 'is_spv') required bool? isSpv,
    @JsonKey(name: 'spv_msg') required String? spvMsg,
    @JsonKey(name: 'is_hr') required bool? isHr,
    @JsonKey(name: 'hr_msg') required String? hrMsg,
    @JsonKey(name: 'is_btl') required bool? isBtl,
    @JsonKey(name: 'btl_msg') required String? btlMsg,
  }) = _CutiList;

  factory CutiList.fromJson(Map<String, dynamic> json) =>
      _$CutiListFromJson(json);
}
