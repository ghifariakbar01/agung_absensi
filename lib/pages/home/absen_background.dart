import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/background_service/saved_location.dart';
import '../../application/geofence/geofence_response.dart';
import '../../constants/assets.dart';
import '../../domain/background_failure.dart';
import '../../domain/geofence_failure.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import '../widgets/v_dialogs.dart';

class AbsenBackground extends ConsumerWidget {
  const AbsenBackground();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Option<Either<BackgroundFailure, List<SavedLocation>>>>(
        backgroundNotifierProvider.select(
          (state) => state.failureOrSuccessOption,
        ),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (failure) => AlertHelper.showSnackBar(
                          context,
                          message: failure.map(
                            empty: (_) => '',
                            unknown: (value) =>
                                'Error ${value.errorCode} ${value.message} ',
                          ),
                        ), (savedLocations) {
                  // debugger(message: 'called');

                  if (savedLocations.isNotEmpty) {
                    // debugger(message: 'called');

                    log('savedLocations $savedLocations');

                    final bgItems = ref
                        .read(backgroundNotifierProvider.notifier)
                        .getBackgroundItemsAsList(savedLocations);

                    ref
                        .read(backgroundNotifierProvider.notifier)
                        .changeBackgroundItems(bgItems ?? []);
                  } else {
                    log('empty savedLocation');

                    ref
                        .read(backgroundNotifierProvider.notifier)
                        .changeBackgroundItems([]);

                    // debugger(message: 'called');
                  }
                })));

    ref.listen<Option<Either<GeofenceFailure, List<GeofenceResponse>>>>(
      geofenceProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
            (failure) => failure.maybeWhen(
                  noConnection: () => {},
                  orElse: () => failure.maybeWhen(
                    orElse: () {},
                    server: (errorCode, message) => showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => VSimpleDialog(
                            label: 'Error',
                            labelDescription: 'Error server geofence',
                            asset: Assets.iconCrossed,
                            color: Colors.red)),
                    wrongFormat: () => showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => VSimpleDialog(
                            label: 'Error',
                            labelDescription: 'Error parsing geofence',
                            asset: Assets.iconCrossed,
                            color: Colors.red)),
                  ),
                ), (geofenceList) async {
          final geofence = ref
              .read(geofenceProvider.notifier)
              .geofenceResponseToList(geofenceList);

          final locations = ref
              .read(backgroundNotifierProvider.notifier)
              .state
              .savedBackgroundItems;

          if (locations.isNotEmpty) {
            final savedLocations = ref
                .read(backgroundNotifierProvider.notifier)
                .getSavedLocationsAsList(locations);

            log('savedLocations ${savedLocations?.length}');

            debugger(message: 'called');
            await ref
                .read(geofenceProvider.notifier)
                .initializeGeoFence(geofence, savedLocations);
          } else {
            await ref
                .read(geofenceProvider.notifier)
                .initializeGeoFenceOnly(geofence);
          }
        }),
      ),
    );

    return Container();
  }
}
