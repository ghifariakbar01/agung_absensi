// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dt_pc_list.freezed.dart';
part 'dt_pc_list.g.dart';

@freezed
abstract class DtPcList with _$DtPcList {
  const factory DtPcList({
    @JsonKey(name: 'id_dt') int? idDt,
    @JsonKey(name: 'id_user') int? idUser,
    String? ket,
    @JsonKey(name: 'dt_tgl') String? dtTgl,
    String? jam,
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
    String? kategori,
    @JsonKey(name: 'spv_note') String? spvNote,
    @JsonKey(name: 'hrd_note') String? hrdNote,
    String? periode,
    @JsonKey(name: 'btl_sta') bool? btlSta,
    @JsonKey(name: 'btl_nm') String? btlNm,
    @JsonKey(name: 'btl_tgl') String? btlTgl,
    @JsonKey(name: 'app_spv') String? appSpv,
    @JsonKey(name: 'app_hrd') String? appHrd,
    @JsonKey(name: 'u_by') String? uBy,
    @JsonKey(name: 'c_by') String? cBy,
    @JsonKey(name: 'idkar') String? idkar,
    @JsonKey(name: 'id_dept') int? idDept,
    String? payroll,
    @JsonKey(name: 'no_telp1') String? noTelp1,
    @JsonKey(name: 'no_telp2') String? noTelp2,
    String? fullname,
    String? dept,
    String? comp,
  }) = _DtPcList;

  factory DtPcList.fromJson(Map<String, dynamic> json) =>
      _$DtPcListFromJson(json);
}
