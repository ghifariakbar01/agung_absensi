import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../application/background/saved_location.dart';
import '../../domain/background_failure.dart';

class BackgroundRepository {
  Future<List<SavedLocation>> getSaved() => getSavedLocations()
      .then((value) => value.fold((_) => [], (locations) => locations));

  Future<Either<BackgroundFailure, List<SavedLocation>>>
      getSavedLocations() async {
    try {
      final _sharedPreference = await SharedPreferences.getInstance();
      final String? locations = _sharedPreference.getString("locations");

      if (locations != null) {
        final List<SavedLocation> savedLocations =
            await parseLocationJson(savedLocations: locations);

        return right(savedLocations);
      }

      return right([]);
    } catch (e) {
      return left(BackgroundFailure.unknown(e.toString()));
    }
  }

  Future<Either<BackgroundFailure, Unit>> addBackgroundLocation(
      {required SavedLocation savedLocation}) async {
    final _sharedPreference = await SharedPreferences.getInstance();

    final String? locations = _sharedPreference.getString("locations");

    if (locations != null) {
      final savedLocations = await parseLocationJson(savedLocations: locations);

      final List<SavedLocation> processLocation =
          [...savedLocations, savedLocation].toSet().toList();

      final bool isSuccess = await _sharedPreference.setString(
          "locations", jsonEncode(processLocation));

      if (isSuccess == false) {
        return left(BackgroundFailure.unknown(
            'Memori', 'Memori penuh saat menyimpan absen.'));
      }

      return right(unit);
    } else {
      final isSuccess = await _sharedPreference.setString(
          "locations", jsonEncode(savedLocation));

      if (isSuccess == false) {
        return left(BackgroundFailure.unknown(
            'Memori', 'Memori penuh saat menyimpan absen.'));
      }
    }

    return right(unit);
  }
}

Future<List<SavedLocation>> parseLocationJson(
    {required String? savedLocations}) async {
  final parsedData = jsonDecode(savedLocations!);

  if (parsedData is Map<String, dynamic>) {
    final location = SavedLocation.fromJson(parsedData);

    return [location];
  } else {
    return (parsedData as List<dynamic>)
        .map((locationData) => SavedLocation.fromJson(locationData))
        .toList();
  }
}
