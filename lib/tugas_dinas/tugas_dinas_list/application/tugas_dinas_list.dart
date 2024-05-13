// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tugas_dinas_list.freezed.dart';
part 'tugas_dinas_list.g.dart';

@freezed
class TugasDinasList with _$TugasDinasList {
  factory TugasDinasList({
    @JsonKey(name: 'id_dinas') required int idDinas,
    @JsonKey(name: 'id_user') required int idUser,
    @JsonKey(name: 'id_comp') required int? idComp,
    @JsonKey(name: 'id_dept') required int? idDept,
    @JsonKey(name: 'id_pemberi') required int? idPemberi,
    @JsonKey(name: 'level_user') required int? levelUser,
    @JsonKey(name: 'id_dept1') required int? idDept1,
    required String? ket,
    @JsonKey(name: 'tgl_start') required String? tglStart,
    @JsonKey(name: 'tgl_end') required String? tglEnd,
    @JsonKey(name: 'spv_sta') required bool? spvSta,
    @JsonKey(name: 'spv_nm') required String? spvNm,
    @JsonKey(name: 'spv_tgl') required String? spvTgl,
    @JsonKey(name: 'hrd_sta') required bool? hrdSta,
    @JsonKey(name: 'hrd_nm') required String? hrdNm,
    @JsonKey(name: 'hrd_tgl') required String? hrdTgl,
    @JsonKey(name: 'c_date') required String? cDate,
    @JsonKey(name: 'c_user') required String? cUser,
    @JsonKey(name: 'u_date') required String? uDate,
    @JsonKey(name: 'u_user') required String? uUser,
    required String? kategori,
    required String? perusahaan,
    required String? lokasi,
    @JsonKey(name: 'coo_sta') required bool? cooSta,
    @JsonKey(name: 'coo_nm') required String? cooNm,
    @JsonKey(name: 'coo_tgl') required String? cooTgl,
    @JsonKey(name: 'itten_sta') required bool? ittenSta,
    @JsonKey(name: 'report_sta') required bool? reportSta,
    @JsonKey(name: 'itten_app_nm') required dynamic ittenAppNm,
    @JsonKey(name: 'report_app_nm') required dynamic reportAppNm,
    @JsonKey(name: 'itten_app_tgl') required String? ittenAppTgl,
    @JsonKey(name: 'report_app_tgl') required String? reportAppTgl,
    @JsonKey(name: 'gm_sta') required bool? gmSta,
    @JsonKey(name: 'gm_nm') required String? gmNm,
    @JsonKey(name: 'gm_tgl') required String? gmTgl,
    @JsonKey(name: 'btl_sta') required bool? btlSta,
    @JsonKey(name: 'btl_tgl') required dynamic btlTgl,
    @JsonKey(name: 'btl_nm') required dynamic btlNm,
    @JsonKey(name: 'jenis') required bool? jenis,
    @JsonKey(name: 'biaya_sta') required bool? biayaSta,
    @JsonKey(name: 'biaya_tgl') required dynamic biayaTgl,
    @JsonKey(name: 'biaya_nm') required dynamic biayaNm,
    @JsonKey(name: 'ga_biaya_sta') required bool? gaBiayaSta,
    @JsonKey(name: 'ga_biaya_date') required dynamic gaBiayaDate,
    @JsonKey(name: 'ga_biaya_nm') required dynamic gaBiayaNm,
    @JsonKey(name: 'jam_start') required String? jamStart,
    @JsonKey(name: 'jam_end') required String? jamEnd,
    @JsonKey(name: 'app_spv') required String? appSpv,
    @JsonKey(name: 'app_hrd') required String? appHrd,
    @JsonKey(name: 'u_by') required String? uBy,
    @JsonKey(name: 'c_by') required String? cBy,
    @JsonKey(name: 'pemberi_name') required String? pemberiName,
    @JsonKey(name: 'pemberi_fullname') required String? pemberiFullname,
    @JsonKey(name: 'idkar') required String? idKar,
    required String? payroll,
    required String? noTelp1,
    @JsonKey(name: 'no_telp2') required String? noTelp2,
    required String? fullname,
    required String? dept,
    required String? comp,
  }) = _TugasDinasList;

  factory TugasDinasList.fromJson(Map<String, dynamic> json) =>
      _$TugasDinasListFromJson(json);
}
