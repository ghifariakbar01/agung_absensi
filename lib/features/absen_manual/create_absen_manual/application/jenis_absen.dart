// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'jenis_absen.freezed.dart';
part 'jenis_absen.g.dart';

@freezed
class JenisAbsen with _$JenisAbsen {
  factory JenisAbsen({
    required String Kode,
    required String Nama,
    required bool aktif,
  }) = _JenisAbsen;

  factory JenisAbsen.fromJson(Map<String, dynamic> json) =>
      _$JenisAbsenFromJson(json);
}
