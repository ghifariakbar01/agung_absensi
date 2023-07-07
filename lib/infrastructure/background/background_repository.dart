import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/background_service/saved_location.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/background_failure.dart';
import '../../main.dart';

class BackgroundRepository {
  Future<Either<BackgroundFailure, List<SavedLocation>>>
      getSavedLocations() async {
    try {
      final _sharedPreference = await SharedPreferences.getInstance();

      final savedLocations = _sharedPreference.getString("locations");

      if (savedLocations != null) {
        final savedLocations = await parseLocation(
            savedLocations: _sharedPreference.getString("locations"));

        // debugger(message: 'called');

        return right(savedLocations);
      }

      debugger(message: 'called');

      log('savedLocations ${savedLocations}');

      return right([]);
    } on PlatformException {
      return left(
          BackgroundFailure.unknown('PLATFORM_EXCEPTION', 'Storage penuh'));
    }
  }
}
