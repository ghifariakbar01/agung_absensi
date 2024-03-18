// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riwayat_absen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RiwayatAbsenModel _$$_RiwayatAbsenModelFromJson(Map<String, dynamic> json) =>
    _$_RiwayatAbsenModel(
      tgl: json['tgl'] as String?,
      latitudeMasuk: json['latitude_masuk'] as String?,
      longitudeMasuk: json['longitude_masuk'] as String?,
      latitudeKeluar: json['latitude_keluar'] as String?,
      longitudeKeluar: json['longitude_keluar'] as String?,
      lokasiMasuk: json['lokasi_masuk'] as String?,
      lokasiKeluar: json['lokasi_keluar'] as String?,
      masuk: json['masuk'] as String?,
      pulang: json['pulang'] as String?,
    );

Map<String, dynamic> _$$_RiwayatAbsenModelToJson(
        _$_RiwayatAbsenModel instance) =>
    <String, dynamic>{
      'tgl': instance.tgl,
      'latitude_masuk': instance.latitudeMasuk,
      'longitude_masuk': instance.longitudeMasuk,
      'latitude_keluar': instance.latitudeKeluar,
      'longitude_keluar': instance.longitudeKeluar,
      'lokasi_masuk': instance.lokasiMasuk,
      'lokasi_keluar': instance.lokasiKeluar,
      'masuk': instance.masuk,
      'pulang': instance.pulang,
    };
