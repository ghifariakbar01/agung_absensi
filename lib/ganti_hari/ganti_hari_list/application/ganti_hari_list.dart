// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ganti_hari_list.freezed.dart';
part 'ganti_hari_list.g.dart';

@freezed
abstract class GantiHariList with _$GantiHariList {
  const factory GantiHariList({
    @JsonKey(name: 'id_dayoff') required int idDayoff,
    @JsonKey(name: 'id_user') required int idUser,
    @JsonKey(name: 'ket') required String ket,
    @JsonKey(name: 'tgl_start') required String tglStart,
    @JsonKey(name: 'tgl_end') required String tglEnd,
    @JsonKey(name: 'spv_sta') required bool spvSta,
    @JsonKey(name: 'spv_nm') required String spvNm,
    @JsonKey(name: 'spv_tgl') required String spvTgl,
    @JsonKey(name: 'hrd_sta') required bool hrdSta,
    @JsonKey(name: 'hrd_nm') required String hrdNm,
    @JsonKey(name: 'hrd_tgl') required String hrdTgl,
    @JsonKey(name: 'c_date') required String cDate,
    @JsonKey(name: 'c_user') required String cUser,
    @JsonKey(name: 'u_date') required String uDate,
    @JsonKey(name: 'u_user') required String uUser,
    @JsonKey(name: 'id_comp') required int idComp,
    @JsonKey(name: 'id_dept') required int idDept,
    @JsonKey(name: 'coo_sta') required bool cooSta,
    @JsonKey(name: 'coo_nm') required String cooNm,
    @JsonKey(name: 'coo_tgl') required String cooTgl,
    @JsonKey(name: 'itten_sta') required bool ittenSta,
    @JsonKey(name: 'report_sta') required bool reportSta,
    @JsonKey(name: 'itten_app_nm') required String ittenAppNm,
    @JsonKey(name: 'report_app_nm') required String reportAppNm,
    @JsonKey(name: 'itten_app_tgl') required String ittenAppTgl,
    @JsonKey(name: 'report_app_tgl') required String reportAppTgl,
    @JsonKey(name: 'id_pemberi') required String idPemberi,
    @JsonKey(name: 'gm_sta') required bool gmSta,
    @JsonKey(name: 'gm_nm') required String gmNm,
    @JsonKey(name: 'gm_tgl') required String gmTgl,
    @JsonKey(name: 'btl_sta') required bool btlSta,
    @JsonKey(name: 'btl_tgl') required String btlTgl,
    @JsonKey(name: 'btl_nm') required String btlNm,
    @JsonKey(name: 'jenis') required bool jenis,
    @JsonKey(name: 'biaya_sta') required bool biayaSta,
    @JsonKey(name: 'biaya_tgl') required String biayaTgl,
    @JsonKey(name: 'biaya_nm') required String biayaNm,
    @JsonKey(name: 'ga_biaya_sta') required bool gaBiayaSta,
    @JsonKey(name: 'ga_biaya_date') required String gaBiayaDate,
    @JsonKey(name: 'ga_biaya_nm') required String gaBiayaNm,
    @JsonKey(name: 'id_mst_dayoff') required String idMstDayoff,
    @JsonKey(name: 'jam_start') required String jamStart,
    @JsonKey(name: 'jam_end') required String jamEnd,
    @JsonKey(name: 'id_absen') required String idAbsen,
    @JsonKey(name: 'IdKary') required String idKary,
    @JsonKey(name: 'spv_app1') required String spvApp1,
    @JsonKey(name: 'hrd_app1') required String hrdApp1,
    @JsonKey(name: 'coo_app1') required String cooApp1,
    @JsonKey(name: 'gm_app1') required String gmApp1,
    @JsonKey(name: 'u_by') required String uBy,
    @JsonKey(name: 'c_by') required String cBy,
    @JsonKey(name: 'level_user') required int levelUser,
    @JsonKey(name: 'no_telp1') required String noTelp1,
    @JsonKey(name: 'no_telp2') required String noTelp2,
    @JsonKey(name: 'fullname') required String fullname,
    @JsonKey(name: 'dept') required String dept,
    @JsonKey(name: 'comp') required String comp,
  }) = _GantiHariList;

  factory GantiHariList.fromJson(Map<String, dynamic> json) =>
      _$GantiHariListFromJson(json);
}
