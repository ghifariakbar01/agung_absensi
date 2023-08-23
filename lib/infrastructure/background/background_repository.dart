import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/background/saved_location.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/background_failure.dart';

class BackgroundRepository {
  Future<List<SavedLocation>> getSavedLocationsOneLiner() async {
    final _sharedPreference = await SharedPreferences.getInstance();

    final savedLocations = _sharedPreference.getString("locations");

    if (savedLocations != null) {
      final savedLocations = await parseLocation(
          savedLocations: _sharedPreference.getString("locations"));

      debugger(message: 'called');

      log('savedLocations $savedLocations');

      return savedLocations;
    }

    debugger(message: 'called');

    log('savedLocations $savedLocations');

    return [];
  }

  Future<Either<BackgroundFailure, List<SavedLocation>>>
      getSavedLocations() async {
    try {
      final _sharedPreference = await SharedPreferences.getInstance();

      final savedLocations = _sharedPreference.getString("locations");

      if (savedLocations != null) {
        final savedLocations = await parseLocation(
            savedLocations: _sharedPreference.getString("locations"));

        // debugger(message: 'called');

        log('savedLocations $savedLocations');

        return right(savedLocations);
      }

      log('savedLocations $savedLocations');

      return right([]);
    } on PlatformException {
      return left(
          BackgroundFailure.unknown('PLATFORM_EXCEPTION', 'Storage penuh'));
    }
  }

  Future<Either<BackgroundFailure, Unit>> addBackgroundLocation(
      {required SavedLocation inputData}) async {
    try {
      final _sharedPreference = await SharedPreferences.getInstance();

      switch (_sharedPreference.getString("locations") != null) {
        case true:
          final savedLocations = await parseLocation(
              savedLocations: _sharedPreference.getString("locations"));

          final currentLocations =
              parseSavedLocation(location: jsonEncode(inputData));

          final processLocation =
              [...savedLocations, currentLocations].toSet().toList();

          await _sharedPreference.setString(
              "locations", jsonEncode(processLocation));

          log('savedLocations $savedLocations');
          log('currentLocations $currentLocations');
          return right(unit);

        case false:
          await _sharedPreference.setString("locations", jsonEncode(inputData));

          log('inputData[locations] type ${inputData.runtimeType} ');
          log('inputData[locations] $inputData ');
          log('_sharedPreference.getString("locations") ${_sharedPreference.getString("locations")}');
          return right(unit);
      }

      return left(BackgroundFailure.unknown(
          'UNKNOWN_EXCEPTION', 'Error tidak diketahui'));
    } on PlatformException {
      return left(
          BackgroundFailure.unknown('PLATFORM_EXCEPTION', 'Storage penuh'));
    }
  }

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
