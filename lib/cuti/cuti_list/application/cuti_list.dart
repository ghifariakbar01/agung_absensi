// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cuti_list.freezed.dart';
part 'cuti_list.g.dart';

@freezed
abstract class CutiList with _$CutiList {
  const factory CutiList({
    @JsonKey(name: 'id_cuti') int? idCuti,
    @JsonKey(name: 'id_user') int? idUser,
    @JsonKey(name: 'IdKary') String? idKary,
    @JsonKey(name: 'jenis_cuti') String? jenisCuti,
    @JsonKey(name: 'alasan') String? alasan,
    @JsonKey(name: 'ket') String? ket,
    @JsonKey(name: 'bulan_cuti') String? bulanCuti,
    @JsonKey(name: 'tahun_cuti') String? tahunCuti,
    @JsonKey(name: 'total_hari') int? totalHari,
    @JsonKey(name: 'sisa_cuti') int? sisaCuti,
    @JsonKey(name: 'tgl_start') String? tglStart,
    @JsonKey(name: 'tgl_end') String? tglEnd,
    @JsonKey(name: 'tgl_start_hrd') String? tglStartHrd,
    @JsonKey(name: 'tgl_end_hrd') String? tglEndHrd,
    @JsonKey(name: 'spv_sta') bool? spvSta,
    @JsonKey(name: 'spv_nm') String? spvNm,
    @JsonKey(name: 'spv_tgl') String? spvTgl,
    @JsonKey(name: 'spv_note') String? spvNote,
    @JsonKey(name: 'hrd_sta') bool? hrdSta,
    @JsonKey(name: 'hrd_nm') String? hrdNm,
    @JsonKey(name: 'hrd_tgl') String? hrdTgl,
    @JsonKey(name: 'hrd_note') String? hrdNote,
    @JsonKey(name: 'btl_sta') bool? btlSta,
    @JsonKey(name: 'btl_nm') String? btlNm,
    @JsonKey(name: 'btl_tgl') String? btlTgl,
    @JsonKey(name: 'c_date') String? cDate,
    @JsonKey(name: 'c_user') String? cUser,
    @JsonKey(name: 'u_date') String? uDate,
    @JsonKey(name: 'u_user') String? uUser,
    @JsonKey(name: 'no_telp1') String? noTelp1,
    @JsonKey(name: 'no_telp2') String? noTelp2,
    @JsonKey(name: 'fullname') String? fullname,
    @JsonKey(name: 'pt') String? pt,
    @JsonKey(name: 'dept') String? dept,
  }) = _CutiList;

  factory CutiList.fromJson(Map<String, dynamic> json) =>
      _$CutiListFromJson(json);
}
