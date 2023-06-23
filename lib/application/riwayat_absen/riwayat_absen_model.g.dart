// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riwayat_absen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RiwayatAbsenModel _$$_RiwayatAbsenModelFromJson(Map<String, dynamic> json) =>
    _$_RiwayatAbsenModel(
      tgl: json['tgl'] as String?,
      jamAwal: json['jam_awal'] as String?,
      jamAkhir: json['jam_akhir'] as String?,
      lokasiMasuk: json['lokasi_masuk'] as String?,
      lokasiKeluar: json['lokasi_keluar'] as String?,
    );

Map<String, dynamic> _$$_RiwayatAbsenModelToJson(
        _$_RiwayatAbsenModel instance) =>
    <String, dynamic>{
      'tgl': instance.tgl,
      'jam_awal': instance.jamAwal,
      'jam_akhir': instance.jamAkhir,
      'lokasi_masuk': instance.lokasiMasuk,
      'lokasi_keluar': instance.lokasiKeluar,
    };
