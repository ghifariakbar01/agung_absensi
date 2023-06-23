import 'package:freezed_annotation/freezed_annotation.dart';

part 'riwayat_absen_model.freezed.dart';

part 'riwayat_absen_model.g.dart';

@freezed
class RiwayatAbsenModel with _$RiwayatAbsenModel {
  const factory RiwayatAbsenModel(
          {required String? tgl,
          @JsonKey(name: 'jam_awal') required String? jamAwal,
          @JsonKey(name: 'jam_akhir') required String? jamAkhir,
          @JsonKey(name: 'lokasi_masuk') required String? lokasiMasuk,
          @JsonKey(name: 'lokasi_keluar') required String? lokasiKeluar}) =
      _RiwayatAbsenModel;

  factory RiwayatAbsenModel.fromJson(Map<String, Object?> json) =>
      _$RiwayatAbsenModelFromJson(json);
}
