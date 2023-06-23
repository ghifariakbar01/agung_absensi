import 'package:geocoding/geocoding.dart';

Future<Placemark?> getAddressFromCoordinates(
    double latitude, double longitude) async {
  final list = await placemarkFromCoordinates(latitude, longitude);

  if (list.isNotEmpty) {
    return list.first;
  }

  return null;
}
