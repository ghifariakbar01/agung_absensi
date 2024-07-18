import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/domain/background_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructures/background_repository.dart';
import 'background_state.dart';
import 'saved_location.dart';

class BackgroundNotifier extends StateNotifier<BackgroundState> {
  BackgroundNotifier(this._backgroundRepository)
      : super(BackgroundState.initial());

  final BackgroundRepository _backgroundRepository;

  void changeBackgroundItems(List<SavedLocation> backgroundItems) {
    state = state.copyWith(savedBackgroundItems: [...backgroundItems]);
  }

  Future<void> addSavedLocation({required SavedLocation savedLocation}) async {
    Either<BackgroundFailure, Unit> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOptionSave: none());

    failureOrSuccess = await _backgroundRepository.addBackgroundLocation(
        savedLocation: savedLocation);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionSave: optionOf(failureOrSuccess));
  }

  Future<void> getSavedLocations() async {
    Either<BackgroundFailure, List<SavedLocation>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _backgroundRepository.getSavedLocations();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<List<SavedLocation>> _parseLocation(
      {required String? savedLocations}) async {
    final parsedData = jsonDecode(savedLocations!);

    // Log.info('parsedData $parsedData ');

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

  Future<void> removeLocationFromSaved(
    SavedLocation currentLocation,
  ) async {
    final _sharedPreference = await SharedPreferences.getInstance();
    final _loc = await _sharedPreference.getString("locations");

    if (_loc != null) {
      final savedLocations = await _parseLocation(
        savedLocations: _loc,
      );

      final processLocation = savedLocations
          .where((location) => location.date != currentLocation.date)
          .toSet()
          .toList();

      await _sharedPreference.setString(
          "locations", jsonEncode(processLocation));
    }
  }
}
