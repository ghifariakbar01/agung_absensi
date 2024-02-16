// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'izin_list.freezed.dart';
part 'izin_list.g.dart';

@freezed
abstract class IzinList with _$IzinList {
  const factory IzinList({
    @JsonKey(name: 'id_izin') int? idIzin,
    @JsonKey(name: 'id_user') int? idUser,
    String? ket,
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
    @JsonKey(name: 'hrd_note') String? hrdNote,
    @JsonKey(name: 'spv_note') String? spvNote,
    @JsonKey(name: 'tgl_start_hrd') String? tglStartHrd,
    @JsonKey(name: 'tgl_end_hrd') String? tglEndHrd,
    @JsonKey(name: 'tot_hari') int? totHari,
    @JsonKey(name: 'btl_sta') bool? btlSta,
    @JsonKey(name: 'btl_tgl') String? btlTgl,
    @JsonKey(name: 'btl_nm') String? btlNm,
    @JsonKey(name: 'id_mst_izin') int? idMstIzin,
    int? qtyfoto,
    String? namaIzin,
    @JsonKey(name: 'app_spv') String? appSpv,
    @JsonKey(name: 'app_hrd') String? appHrd,
    @JsonKey(name: 'u_by') String? uBy,
    @JsonKey(name: 'c_by') String? cBy,
    @JsonKey(name: 'idkar') String? idkar,
    @JsonKey(name: 'no_telp1') String? noTelp1,
    @JsonKey(name: 'no_telp2') String? noTelp2,
    String? fullname,
    String? dept,
    String? comp,
  }) = _IzinList;

  factory IzinList.fromJson(Map<String, dynamic> json) =>
      _$IzinListFromJson(json);
}
