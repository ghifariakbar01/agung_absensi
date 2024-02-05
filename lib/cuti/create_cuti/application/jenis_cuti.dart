import 'package:freezed_annotation/freezed_annotation.dart';

part 'jenis_cuti.freezed.dart';
part 'jenis_cuti.g.dart';

@freezed
class JenisCuti with _$JenisCuti {
  factory JenisCuti({
    required int id_jns_cuti,
    required String nama,
    required String inisial,
  }) = _JenisCuti;

  factory JenisCuti.fromJson(Map<String, dynamic> json) =>
      _$JenisCutiFromJson(json);
}
