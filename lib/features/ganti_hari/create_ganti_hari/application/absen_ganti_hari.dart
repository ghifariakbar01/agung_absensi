// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_ganti_hari.freezed.dart';
part 'absen_ganti_hari.g.dart';

@freezed
abstract class AbsenGantiHari with _$AbsenGantiHari {
  const factory AbsenGantiHari({
    @JsonKey(name: 'id_absen') required int idAbsen,
    @JsonKey(name: 'nama') required String nama,
    @JsonKey(name: 'jdw_in') required String jdwIn,
    @JsonKey(name: 'jdw_out') required String jdwOut,
    @JsonKey(name: 'c_date') required String creationDate,
    @JsonKey(name: 'c_user') required String createdBy,
    @JsonKey(name: 'u_date') required String updateDate,
    @JsonKey(name: 'u_user') required String updatedBy,
  }) = _AbsenGantiHari;

  factory AbsenGantiHari.fromJson(Map<String, dynamic> json) =>
      _$AbsenGantiHariFromJson(json);
}
