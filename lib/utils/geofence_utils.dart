import 'package:geocoding/geocoding.dart';

class GeofenceUtil {
  static Future<Placemark?> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    final list = await placemarkFromCoordinates(latitude, longitude);

    if (list.isNotEmpty) {
      return list.first;
    }

    return null;
  }

//
  static Future<Placemark?> getLokasi({
    required double? latitude,
    required double? longitude,
  }) async {
    Placemark? lokasi =
        await _getAddressFromCoordinates(latitude ?? 0, longitude ?? 0);

    if (lokasi == null) {
      lokasi = Placemark(
          street: 'LOCATION UKNOWN', subAdministrativeArea: '', postalCode: '');
    }

    return lokasi;
  }
}
