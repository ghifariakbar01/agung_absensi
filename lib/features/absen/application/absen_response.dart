// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_response.freezed.dart';

part 'absen_response.g.dart';

@freezed
class Absen with _$Absen {
  const factory Absen({
    @JsonKey(name: 'id_absenmnl') required int idAbsenmnl,
    @JsonKey(name: 'id_user') required int idUser,
    required String? tgl,
    @JsonKey(name: 'latitude_masuk') required String? latitudeMasuk,
    @JsonKey(name: 'longtitude_masuk') required String? longtitudeMasuk,
    @JsonKey(name: 'latitude_keluar') required String? latitudeKeluar,
    @JsonKey(name: 'longtitude_keluar') required String? longtitudeKeluar,
  }) = _Absen;

  factory Absen.fromJson(Map<String, Object?> json) => _$AbsenFromJson(json);
}
