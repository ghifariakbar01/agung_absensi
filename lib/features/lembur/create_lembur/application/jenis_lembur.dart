import 'package:freezed_annotation/freezed_annotation.dart';

part 'jenis_lembur.freezed.dart';
part 'jenis_lembur.g.dart';

@freezed
class JenisLembur with _$JenisLembur {
  const factory JenisLembur({
    String? Kode,
    String? Nama,
    String? Keterangan,
    bool? Khusus,
    bool? Flat,
    @JsonKey(name: 'c_date') String? cDate,
    @JsonKey(name: 'c_user') String? cUser,
    @JsonKey(name: 'u_date') String? uDate,
    @JsonKey(name: 'u_user') String? uUser,
  }) = _JenisLembur;

  factory JenisLembur.fromJson(Map<String, dynamic> json) =>
      _$JenisLemburFromJson(json);
}
