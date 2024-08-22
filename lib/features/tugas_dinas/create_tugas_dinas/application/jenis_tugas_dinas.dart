import 'package:freezed_annotation/freezed_annotation.dart';

part 'jenis_tugas_dinas.freezed.dart';
part 'jenis_tugas_dinas.g.dart';

@freezed
abstract class JenisTugasDinas with _$JenisTugasDinas {
  const factory JenisTugasDinas({
    required int id,
    required String kode,
    required String kategori,
  }) = _JenisTugasDinas;

  factory JenisTugasDinas.fromJson(Map<String, dynamic> json) =>
      _$JenisTugasDinasFromJson(json);
}
