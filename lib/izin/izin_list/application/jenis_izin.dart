import 'package:freezed_annotation/freezed_annotation.dart';

part 'jenis_izin.freezed.dart';
part 'jenis_izin.g.dart';

@freezed
abstract class JenisIzin with _$JenisIzin {
  const factory JenisIzin({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'id_mst_izin') int? idMstIzin,
    String? nama,
    double? qty,
    String? tipe,
  }) = _JenisIzin;

  factory JenisIzin.fromJson(Map<String, dynamic> json) =>
      _$JenisIzinFromJson(json);
}
