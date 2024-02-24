// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_manual_list.freezed.dart';
part 'absen_manual_list.g.dart';

@freezed
class AbsenManualList with _$AbsenManualList {
  factory AbsenManualList({
    @JsonKey(name: 'id_absenmnl') required int idAbsenmnl,
    @JsonKey(name: 'id_user') required int idUser,
    required String tgl,
    @JsonKey(name: 'jam_awal') required String jamAwal,
    @JsonKey(name: 'jam_akhir') required String jamAkhir,
    required String ket,
    @JsonKey(name: 'c_date') required String cDate,
    @JsonKey(name: 'c_user') required String cUser,
    @JsonKey(name: 'u_date') required String uDate,
    @JsonKey(name: 'u_user') required String uUser,
    @JsonKey(name: 'spv_sta') required bool spvSta,
    @JsonKey(name: 'spv_nm') required String spvNm,
    @JsonKey(name: 'spv_tgl') required String spvTgl,
    @JsonKey(name: 'hrd_sta') required bool hrdSta,
    @JsonKey(name: 'hrd_nm') required String hrdNm,
    @JsonKey(name: 'hrd_tgl') required String hrdTgl,
    @JsonKey(name: 'btl_sta') required bool btlSta,
    @JsonKey(name: 'btl_nm') required String? btlNm,
    @JsonKey(name: 'btl_tgl') required String? btlTgl,
    @JsonKey(name: 'spv_note') required String spvNote,
    @JsonKey(name: 'hrd_note') required String hrdNote,
    required String periode,
    @JsonKey(name: 'jenis_absen') required String jenisAbsen,
    @JsonKey(name: 'latitude_masuk') required dynamic latitudeMasuk,
    @JsonKey(name: 'longtitude_masuk') required dynamic longtitudeMasuk,
    @JsonKey(name: 'latitude_keluar') required dynamic latitudeKeluar,
    @JsonKey(name: 'longtitude_keluar') required dynamic longtitudeKeluar,
    @JsonKey(name: 'lokasi_masuk') required dynamic lokasiMasuk,
    @JsonKey(name: 'lokasi_keluar') required dynamic lokasiKeluar,
    @JsonKey(name: 'app_spv') required String appSpv,
    @JsonKey(name: 'app_hrd') required String appHrd,
    @JsonKey(name: 'u_by') required String uBy,
    @JsonKey(name: 'c_by') required String cBy,
    @JsonKey(name: 'idkar') required String idKar,
    @JsonKey(name: 'id_dept') required int idDept,
    required String payroll,
    @JsonKey(name: 'no_telp1') required String noTelp1,
    @JsonKey(name: 'no_telp2') required String noTelp2,
    @JsonKey(name: 'fullname') required String fullname,
    required String dept,
    required String comp,
  }) = _AbsenManualList;

  factory AbsenManualList.fromJson(Map<String, dynamic> json) =>
      _$AbsenManualListFromJson(json);
}
