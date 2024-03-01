// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wa_head.freezed.dart';
part 'wa_head.g.dart';

@freezed
abstract class WaHead with _$WaHead {
  factory WaHead({
    @JsonKey(name: 'id_user_head') int? idUserHead,
    @JsonKey(name: 'idkary') String? idKary,
    @JsonKey(name: 'id_dept') int? idDept,
    @JsonKey(name: 'nama') String? nama,
    @JsonKey(name: 'telp1') String? telp1,
    @JsonKey(name: 'telp2') String? telp2,
  }) = _WaHead;

  factory WaHead.fromJson(Map<String, dynamic> json) => _$WaHeadFromJson(json);
}
