import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_sakit_cuti.freezed.dart';
part 'create_sakit_cuti.g.dart';

@freezed
class CreateSakitCuti with _$CreateSakitCuti {
  factory CreateSakitCuti({
    @JsonKey(name: 'id_mst_cuti') int? idMstCuti,
    @JsonKey(name: 'open_date') DateTime? openDate,
    @JsonKey(name: 'close_date') DateTime? closeDate,
    @JsonKey(name: 'tahun_cuti_tidak_baru') String? tahunCutiTidakBaru,
    @JsonKey(name: 'tahun_cuti_baru') String? tahunCutiBaru,
    @JsonKey(name: 'cuti_tidak_baru') int? cutiTidakBaru,
    @JsonKey(name: 'cuti_baru') int? cutiBaru,
  }) = _CreateSakit;

  factory CreateSakitCuti.fromJson(Map<String, dynamic> json) =>
      _$CreateSakitCutiFromJson(json);
}
