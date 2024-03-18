// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ganti_hari_list.freezed.dart';
part 'ganti_hari_list.g.dart';

@freezed
abstract class GantiHariList with _$GantiHariList {
  const factory GantiHariList({
    @JsonKey(name: 'id_dayoff') int? idDayOff,
    @JsonKey(name: 'id_user') int? idUser,
    @JsonKey(name: 'ket') String? ket,
    @JsonKey(name: 'tgl_start') String? tglStart,
    @JsonKey(name: 'tgl_end') String? tglEnd,
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
    @JsonKey(name: 'kategori') String? kategori,
    @JsonKey(name: 'perusahaan') String? perusahaan,
    @JsonKey(name: 'lokasi') String? lokasi,
    @JsonKey(name: 'coo_sta') bool? cooSta,
    @JsonKey(name: 'coo_nm') String? cooNm,
    @JsonKey(name: 'coo_tgl') String? cooTgl,
    @JsonKey(name: 'id_comp') int? idComp,
    @JsonKey(name: 'id_dept') int? idDept,
    @JsonKey(name: 'itten_sta') bool? ittenSta,
    @JsonKey(name: 'report_sta') bool? reportSta,
    @JsonKey(name: 'itten_app_nm') String? ittenAppNm,
    @JsonKey(name: 'report_app_nm') String? reportAppNm,
    @JsonKey(name: 'itten_app_tgl') String? ittenAppTgl,
    @JsonKey(name: 'report_app_tgl') String? reportAppTgl,
    @JsonKey(name: 'id_pemberi') String? idPemberi,
    @JsonKey(name: 'gm_sta') bool? gmSta,
    @JsonKey(name: 'gm_nm') String? gmNm,
    @JsonKey(name: 'gm_tgl') String? gmTgl,
    @JsonKey(name: 'btl_sta') bool? btlSta,
    @JsonKey(name: 'btl_tgl') String? btlTgl,
    @JsonKey(name: 'btl_nm') String? btlNm,
    @JsonKey(name: 'jenis') bool? jenis,
    @JsonKey(name: 'biaya_sta') bool? biayaSta,
    @JsonKey(name: 'biaya_tgl') String? biayaTgl,
    @JsonKey(name: 'biaya_nm') String? biayaNm,
    @JsonKey(name: 'ga_biaya_sta') bool? gaBiayaSta,
    @JsonKey(name: 'ga_biaya_date') String? gaBiayaDate,
    @JsonKey(name: 'ga_biaya_nm') String? gaBiayaNm,
    @JsonKey(name: 'id_mst_dayoff') int? idMstDayOff,
    @JsonKey(name: 'jam_start') String? jamStart,
    @JsonKey(name: 'jam_end') String? jamEnd,
    @JsonKey(name: 'id_absen') int? idAbsen,
    @JsonKey(name: 'IdKary') String? idKary,
    @JsonKey(name: 'level_user') int? levelUser,
    @JsonKey(name: 'no_telp1') String? noTelp1,
    @JsonKey(name: 'no_telp2') String? noTelp2,
    @JsonKey(name: 'fullname') String? fullname,
    @JsonKey(name: 'dept') String? dept,
    @JsonKey(name: 'comp') String? comp,
  }) = _GantiHariList;

  factory GantiHariList.fromJson(Map<String, dynamic> json) =>
      _$GantiHariListFromJson(json);
}
