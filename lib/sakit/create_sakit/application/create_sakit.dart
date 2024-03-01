// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_sakit.freezed.dart';
part 'create_sakit.g.dart';

@freezed
class CreateSakit with _$CreateSakit {
  factory CreateSakit({
    @JsonKey(name: 'jdw_sabtu') String? jadwalSabtu,
    @JsonKey(name: 'hitunglibur') int? hitungLibur,
    @Default(false) bool bulanan,
    @JsonKey(name: 'Masuk') String? masuk,
  }) = _CreateSakit;

  factory CreateSakit.fromJson(Map<String, dynamic> json) =>
      _$CreateSakitFromJson(json);
}
