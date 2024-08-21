import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../domain/background_failure.dart';
import '../../utils/geofence_utils.dart';
import '../application/saved_location.dart';

class BackgroundRepository {
  Future<bool> hasSavedLocations() =>
      getSavedLocations().then((value) => value.fold(
            (_) => false,
            (_) => true,
          ));

  Future<Either<BackgroundFailure, List<SavedLocation>>>
      getSavedLocations() async {
    try {
      final _sharedPreference = await SharedPreferences.getInstance();
      final String? locations =
          await _sharedPreference.getString(Constants.keyLocation);

      if (locations != null) {
        try {
          final List<SavedLocation> savedLocations = await parseLocationJson(
            savedLocations: locations,
          );

          return right(savedLocations);
        } on FormatException catch (e) {
          await clear();
          return left(BackgroundFailure.formatException(e.message));
        } catch (e) {
          return left(BackgroundFailure.unknown(e.toString()));
        }
      } else {
        return right([]);
      }
    } catch (e) {
      return left(BackgroundFailure.unknown(e.toString()));
    }
  }

  Future<Either<BackgroundFailure, Unit>> addBackgroundLocation(
      {required SavedLocation savedLocation}) async {
    final _sharedPreference = await SharedPreferences.getInstance();
    final String? locations =
        await _sharedPreference.getString(Constants.keyLocation);

    if (locations != null) {
      final savedLocations = await parseLocationJson(savedLocations: locations);
      final item = savedLocation.copyWith(id: savedLocations.length + 1);

      final List<SavedLocation> processLocation = [
        ...savedLocations,
        item,
      ].toSet().toList();

      try {
        await save(processLocation);
      } on PlatformException catch (e) {
        return left(
          BackgroundFailure.unknown(e.code, e.message),
        );
      }

      return right(unit);
    } else {
      try {
        final item = savedLocation.copyWith(id: 1);
        await save([item]);
      } on PlatformException catch (e) {
        return left(
          BackgroundFailure.unknown(e.code, e.message),
        );
      }

      return right(unit);
    }
  }

  Future<List<SavedLocation>> updateBackgroundLocation(
      {required List<SavedLocation> locations}) async {
    if (locations.isEmpty) {
      return [];
    } else {
      List<SavedLocation> returnLocations = [];

      for (int i = 0; i < locations.length; i++) {
        final item = locations[i];
        // require internet connection
        final alamat = await GeofenceUtil.getLokasiStr(
              lat: item.latitude!,
              long: item.longitude!,
            ) ??
            locations[i].alamat ??
            '-';

        returnLocations.add(
          item.copyWith(alamat: alamat),
        );
      }

      await save(returnLocations);

      return returnLocations;
    }
  }

  Future<Unit> save(
    List<SavedLocation> processLocation,
  ) async {
    final _sharedPreference = await SharedPreferences.getInstance();

    final json = jsonEncode(processLocation);
    final isSuccess = await _sharedPreference.setString(
      Constants.keyLocation,
      json,
    );

    if (isSuccess == false) {
      throw PlatformException(
        code: '1',
        message:
            'Memori penyimpanan anda penuh saat menyimpan absen. Mohon luangkan memori penyimpanan anda dan lakukan absen kembali.',
      );
    } else {
      return unit;
    }
  }

  Future<bool> clear() async {
    final _sharedPreference = await SharedPreferences.getInstance();
    return _sharedPreference.setString(Constants.keyLocation, '');
  }
}

Future<List<SavedLocation>> parseLocationJson(
    {required String savedLocations}) async {
  if (savedLocations.isEmpty) {
    return [];
  }

  final parsedData = jsonDecode(savedLocations);
  return (parsedData as List<dynamic>)
      .map((locationData) => SavedLocation.fromJson(locationData))
      .toList();
}
