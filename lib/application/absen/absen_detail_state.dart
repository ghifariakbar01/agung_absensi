import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_detail_state.freezed.dart';

part 'absen_detail_state.g.dart';

@freezed
class RiwayatAbsenDetailState with _$RiwayatAbsenDetailState {
  const factory RiwayatAbsenDetailState(
          {@JsonKey(name: 'id_absenmnl') required int idAbsenmnl,
          @JsonKey(name: 'id_user') required int idUser,
          required String? tgl,
          @JsonKey(name: 'jam_awal') required String? jamAwal,
          @JsonKey(name: 'jam_akhir') required String? jamAkhir,
          required String? ket,
          @JsonKey(name: 'c_date') required String? cDate,
          @JsonKey(name: 'c_user') required String? cUser,
          @JsonKey(name: 'spv_nm') required String? spvNm,
          @JsonKey(name: 'spv_tgl') required String? spvTgl,
          @JsonKey(name: 'hrd_nm') required String? hrdNm,
          @JsonKey(name: 'hrd_tgl') required String? hrdTgl,
          @JsonKey(name: 'btl_sta') required bool? btlSta,
          @JsonKey(name: 'btl_tgl') required String? btlTgl,
          @JsonKey(name: 'spv_note') required String? spvNote,
          @JsonKey(name: 'hrd_note') required String? hrdNote,
          @JsonKey(name: 'latitude_masuk') required String? latitudeMasuk,
          @JsonKey(name: 'longtitude_masuk') required String? longitudeMasuk,
          @JsonKey(name: 'latitude_keluar') required String? latitudeKeluar,
          @JsonKey(name: 'longtitude_keluar') required String? longitudeKeluar,
          @JsonKey(name: 'lokasi_masuk') required String? lokasiMasuk,
          @JsonKey(name: 'lokasi_keluar') required String? lokasiKeluar}) =
      _RiwayatAbsenDetailState;

  factory RiwayatAbsenDetailState.initial() => RiwayatAbsenDetailState(
        idAbsenmnl: 0,
        idUser: 0,
        tgl: null,
        jamAwal: null,
        jamAkhir: null,
        ket: null,
        cDate: null,
        cUser: null,
        spvNm: null,
        spvTgl: null,
        hrdNm: null,
        hrdTgl: null,
        btlSta: false,
        btlTgl: null,
        spvNote: null,
        hrdNote: null,
        latitudeMasuk: null,
        longitudeMasuk: null,
        latitudeKeluar: null,
        longitudeKeluar: null,
        lokasiMasuk: null,
        lokasiKeluar: null,
      );

  factory RiwayatAbsenDetailState.fromJson(Map<String, dynamic> json) =>
      _$RiwayatAbsenDetailStateFromJson(json);
}
