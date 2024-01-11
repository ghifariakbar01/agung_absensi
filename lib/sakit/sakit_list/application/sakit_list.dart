import 'package:freezed_annotation/freezed_annotation.dart';

part 'sakit_list.freezed.dart';
part 'sakit_list.g.dart';

@freezed
class SakitList with _$SakitList {
  factory SakitList({
    @JsonKey(name: 'id_sakit') int? idSakit,
    @JsonKey(name: 'c_user') String? cUser,
    @JsonKey(name: 'payroll') String? payroll,
    @JsonKey(name: 'dept') String? dept,
    @JsonKey(name: 'ket') String? ket,
    @JsonKey(name: 'surat') String? surat,
    @JsonKey(name: 'tgl_start') String? tglStart,
    @JsonKey(name: 'tgl_end') String? tglEnd,
    @JsonKey(name: 'tot_hari') int? totHari,
    @JsonKey(name: 'qty_foto') int? qtyFoto,
    @JsonKey(name: 'spv_sta') bool? spvSta,
    @JsonKey(name: 'spv_tgl') String? spvTgl,
    @JsonKey(name: 'hrd_sta') bool? hrdSta,
    @JsonKey(name: 'hrd_tgl') String? hrdTgl,
  }) = _SakitList;

  factory SakitList.fromJson(Map<String, dynamic> json) =>
      _$SakitListFromJson(json);
}
