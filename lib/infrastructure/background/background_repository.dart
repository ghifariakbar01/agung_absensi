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
    final _sharedPreference = await SharedPreferences.getInstance();

    final String? savedLocations = _sharedPreference.getString("locations");

    if (savedLocations != null) {
      final List<SavedLocation> savedLocations = await parseLocation(
          savedLocations: _sharedPreference.getString("locations"));

      return right(savedLocations);
    }

    return right([]);
  }

  Future<Either<BackgroundFailure, Unit>> addBackgroundLocation(
      {required SavedLocation inputData}) async {
    final _sharedPreference = await SharedPreferences.getInstance();

    switch (_sharedPreference.getString("locations") != null) {
      case true:
        final savedLocations = await parseLocation(
            savedLocations: _sharedPreference.getString("locations"));

        final currentLocations =
            parseSavedLocation(location: jsonEncode(inputData));

        final List<SavedLocation> processLocation =
            [...savedLocations, currentLocations].toSet().toList();

        final saveToSharedPrefs = await _sharedPreference.setString(
            "locations", jsonEncode(processLocation));

        if (saveToSharedPrefs == false) {
          return left(BackgroundFailure.unknown(
              'Memori', 'Memori penuh saat menyimpan absen.'));
        }

        return right(unit);

      case false:
        final saveToSharedPrefs = await _sharedPreference.setString(
            "locations", jsonEncode(inputData));

        if (saveToSharedPrefs == false) {
          return left(BackgroundFailure.unknown(
              'Memori', 'Memori penuh saat menyimpan absen.'));
        }

        return right(unit);
    }

    return left(BackgroundFailure.unknown(
        'Error', 'Error saat menyimpan absen di addBackgroundLocation'));
  }

// log('savedLocations $savedLocations');
// log('currentLocations $currentLocations');

// log('inputData[locations] type ${inputData.runtimeType} ');
// log('inputData[locations] $inputData ');
// log('_sharedPreference.getString("locations") ${_sharedPreference.getString("locations")}');

  Future<List<SavedLocation>> parseLocation(
      {required String? savedLocations}) async {
    final parsedData = jsonDecode(savedLocations!);

    // log('parsedData $parsedData ');

    if (parsedData is Map<String, dynamic>) {
      final location = SavedLocation.fromJson(parsedData);

      final List<SavedLocation> empty = [];

      empty.add(location);

      return empty;
    } else {
      return (parsedData as List<dynamic>)
          .map((locationData) => SavedLocation.fromJson(locationData))
          .toList();
    }
  }

  SavedLocation parseSavedLocation({required String location}) {
    return SavedLocation.fromJson(jsonDecode(location));
  }
}
