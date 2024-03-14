// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'alasan_cuti.freezed.dart';
part 'alasan_cuti.g.dart';

@freezed
class AlasanCuti with _$AlasanCuti {
  factory AlasanCuti({
    required int id_emergency,
    required String alasan,
    required String kode,
  }) = _AlasanCuti;

  factory AlasanCuti.fromJson(Map<String, dynamic> json) =>
      _$AlasanCutiFromJson(json);
}
