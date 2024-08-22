// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mst_karyawan_cuti.freezed.dart';
part 'mst_karyawan_cuti.g.dart';

@freezed
class MstKaryawanCuti with _$MstKaryawanCuti {
  factory MstKaryawanCuti({
    @JsonKey(name: 'id_mst_cuti') int? idMstCuti,
    @JsonKey(name: 'open_date') DateTime? openDate,
    @JsonKey(name: 'close_date') DateTime? closeDate,
    @JsonKey(name: 'tahun_cuti_tidak_baru') String? tahunCutiTidakBaru,
    @JsonKey(name: 'tahun_cuti_baru') String? tahunCutiBaru,
    @JsonKey(name: 'cuti_tidak_baru') int? cutiTidakBaru,
    @JsonKey(name: 'cuti_baru') int? cutiBaru,
    @JsonKey(name: 'date_open') int? dateOpen,
    @JsonKey(name: 'cuti_aktif') int? cutiAktif,
  }) = _MstKaryawanCuti;

  factory MstKaryawanCuti.fromJson(Map<String, dynamic> json) =>
      _$MstKaryawanCutiFromJson(json);

  factory MstKaryawanCuti.initial() => MstKaryawanCuti();

  factory MstKaryawanCuti.crossed() => MstKaryawanCuti(
        idMstCuti: 0,
        cutiBaru: 0,
        cutiTidakBaru: 0,
        openDate: DateTime.now(),
        closeDate: DateTime.now(),
        tahunCutiBaru: DateTime.now().year.toString(),
        tahunCutiTidakBaru: DateTime.now().year.toString(),
        dateOpen: 0,
        cutiAktif: 0,
      );
}
