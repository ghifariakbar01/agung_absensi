import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/background_service/background_item_state.dart';
import 'package:face_net_authentication/application/background_service/background_state.dart';
import 'package:face_net_authentication/domain/background_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/background/background_repository.dart';
import '../../infrastructure/remote_response.dart';
import '../absen/absen_state.dart';
import 'saved_location.dart';

class BackgroundNotifier extends StateNotifier<BackgroundState> {
  BackgroundNotifier(this._backgroundRepository)
      : super(BackgroundState.initial());

  final BackgroundRepository _backgroundRepository;

  Future<void> getSavedLocations() async {
    Either<BackgroundFailure, List<SavedLocation>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _backgroundRepository.getSavedLocations();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  List<SavedLocation>? getSavedLocationsAsList(
      List<BackgroundItemState> items) {
    List<SavedLocation> locations = [];

    log('items ${items.length}');

    log('items ${items}');

    if (items.isNotEmpty) {
      for (final location in items) {
        log('items ${location.savedLocations}');

        locations.add(location.savedLocations);
      }

      return locations;
    }

    return null;
  }

  Future<void> processSavedLocations(
      {required List<SavedLocation> locations,
      required Function(
              {required DateTime date,
              required Function(RemoteResponse<AbsenState>) onAbsen})
          getAbsenSaved,
      required void onProcessed(
          {required List<BackgroundItemState> items})}) async {
    final List<BackgroundItemState> list = [];

    for (int i = 0; i < locations.length; i++) {
      final dateLocation = locations[i].date;

      await getAbsenSaved(
        date: dateLocation,
        onAbsen: (response) {
          response.when(
              withNewData: (responseAbsen) {
                list.add(BackgroundItemState(
                  savedLocations: locations[i],
                  abenStates: responseAbsen,
                ));
              },
              failure: (errorCode, message) =>
                  log('failure background $errorCode $message'));
        },
      );
    }

    log('list is ${list.first.savedLocations.alamat}');

    onProcessed(items: list);
  }

  void changeBackgroundItems(List<BackgroundItemState> backgroundItems) {
    log('list is ${backgroundItems.first.savedLocations.alamat}');

    state = state.copyWith(savedBackgroundItems: [...backgroundItems]);
  }
}
