// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absen_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Absen _$$_AbsenFromJson(Map<String, dynamic> json) => _$_Absen(
      idAbsenmnl: json['id_absenmnl'] as int,
      idUser: json['id_user'] as int,
      tgl: json['tgl'] as String?,
      latitudeMasuk: json['latitude_masuk'] as String?,
      longtitudeMasuk: json['longtitude_masuk'] as String?,
      latitudeKeluar: json['latitude_keluar'] as String?,
      longtitudeKeluar: json['longtitude_keluar'] as String?,
    );

Map<String, dynamic> _$$_AbsenToJson(_$_Absen instance) => <String, dynamic>{
      'id_absenmnl': instance.idAbsenmnl,
      'id_user': instance.idUser,
      'tgl': instance.tgl,
      'latitude_masuk': instance.latitudeMasuk,
      'longtitude_masuk': instance.longtitudeMasuk,
      'latitude_keluar': instance.latitudeKeluar,
      'longtitude_keluar': instance.longtitudeKeluar,
    };
