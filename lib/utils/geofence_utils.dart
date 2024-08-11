import 'package:geocoding/geocoding.dart';

class GeofenceUtil {
  static Future<Placemark?> _getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final list = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (list.isEmpty) {
        return null;
      } else {
        return list.first;
      }
    } on UnimplementedError {
      return null;
    }
  }

  static Future<Placemark?> getLokasi({
    required double? latitude,
    required double? longitude,
  }) async {
    Placemark? lokasi = await _getAddressFromCoordinates(
      latitude ?? 0,
      longitude ?? 0,
    );

    if (lokasi == null) {
      lokasi = Placemark(
        street: 'LOCATION UKNOWN',
        subAdministrativeArea: '',
        postalCode: '',
      );
    }

    return lokasi;
  }

  static Future<String?> getLokasiStr({
    required double lat,
    required double long,
  }) async {
    Placemark? placeMark = await getLokasi(
      latitude: lat,
      longitude: long,
    );

    if (placeMark != null) {
      return '${placeMark.street}, ${placeMark.locality}, ${placeMark.administrativeArea}. ${placeMark.postalCode}';
    } else {
      return null;
    }
  }
}
