// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'riwayat_absen_model.freezed.dart';

part 'riwayat_absen_model.g.dart';

@freezed
class RiwayatAbsenModel with _$RiwayatAbsenModel {
  const factory RiwayatAbsenModel(
      {required String? tgl,
      @JsonKey(name: "latitude_masuk") required String? latitudeMasuk,
      @JsonKey(name: "longitude_masuk") required String? longitudeMasuk,
      @JsonKey(name: "latitude_keluar") required String? latitudeKeluar,
      @JsonKey(name: "longitude_keluar") required String? longitudeKeluar,
      @JsonKey(name: "lokasi_masuk") required String? lokasiMasuk,
      @JsonKey(name: "lokasi_keluar") required String? lokasiKeluar,
      required String? masuk,
      required String? pulang}) = _RiwayatAbsenModel;

  factory RiwayatAbsenModel.fromJson(Map<String, Object?> json) =>
      _$RiwayatAbsenModelFromJson(json);
}
