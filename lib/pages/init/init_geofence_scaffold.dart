import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/background/saved_location.dart';
import '../../application/geofence/geofence_response.dart';
import '../../constants/assets.dart';
import '../../domain/background_failure.dart';
import '../../domain/geofence_failure.dart';
import '../../pages/home/saved/home_saved.dart';
import '../../pages/widgets/alert_helper.dart';
import '../../pages/widgets/loading_overlay.dart';
import '../../pages/widgets/v_dialogs.dart';
import '../../shared/providers.dart';

class InitGeofenceScaffold extends ConsumerStatefulWidget {
  const InitGeofenceScaffold();

  @override
  ConsumerState<InitGeofenceScaffold> createState() =>
      _InitGeofenceScaffoldState();
}

class _InitGeofenceScaffoldState extends ConsumerState<InitGeofenceScaffold> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
      await ref.read(geofenceProvider.notifier).getGeofenceList();
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    // SAVED ABSEN
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
                        ), (savedLocations) async {
                  if (savedLocations.isNotEmpty) {
                    //
                    log('savedLocations $savedLocations');
                    ref
                        .read(backgroundNotifierProvider.notifier)
                        .processSavedLocations(
                          locations: savedLocations,
                          onProcessed: ({required items}) => ref
                              .read(backgroundNotifierProvider.notifier)
                              .changeBackgroundItems(items),
                        );
                  } else {
                    ref
                        .read(backgroundNotifierProvider.notifier)
                        .changeBackgroundItems([]);
                  }
                })));

    // GEOFENCE
    ref.listen<Option<Either<GeofenceFailure, List<GeofenceResponse>>>>(
      geofenceProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
                  (failure) => failure.maybeWhen(
                      noConnection: () => ref
                          .read(geofenceProvider.notifier)
                          .getGeofenceListFromStorage(),
                      orElse: () => showCupertinoDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                              label: 'Error',
                              labelDescription: failure.maybeWhen(
                                  server: (error, stacktrace) =>
                                      'Error geofence: ($error) $stacktrace',
                                  wrongFormat: () => 'Error parsing geofence',
                                  orElse: () => ''),
                              asset: Assets.iconCrossed,
                              color: Colors.red))), (geofenceList) async {
                //
                if (geofenceList.isNotEmpty) {
                  final geofence = ref
                      .read(geofenceProvider.notifier)
                      .geofenceResponseToList(geofenceList);
                  final savedItems = ref
                      .read(backgroundNotifierProvider.notifier)
                      .state
                      .savedBackgroundItems;

                  final isOffline =
                      ref.read(absenOfflineModeProvider.notifier).state;
                  log('isOffline $isOffline');

                  if (!isOffline) {
                    await ref.read(geofenceProvider.notifier).startAutoAbsen(
                        geofenceResponseList: geofenceList,
                        savedBackgroundItems: savedItems,
                        saveGeofence: (geofenceList) => ref
                            .read(geofenceProvider.notifier)
                            .saveGeofence(geofenceList),
                        startAbsen: (savedItems) async {
                          // ABSEN TERSIMPAN
                          if (savedItems.isNotEmpty) {
                            final savedLocations = ref
                                .read(backgroundNotifierProvider.notifier)
                                .getSavedLocationsAsList(savedItems);

                            log('savedLocations ${savedLocations?.length}');
                            // debugger(message: 'called');

                            await ref
                                .read(geofenceProvider.notifier)
                                .initializeGeoFence(geofence,
                                    onError: (e) => log('error geofence $e'));

                            // debugger();
                            log('savedItems $savedItems');
                            // [AUTO ABSEN]

                            final imei = ref.read(imeiNotifierProvider
                                .select((value) => value.imei));

                            final dbDate = await ref
                                .refresh(networkTimeFutureProvider.future);

                            // GET CURRENT NETWORK TIME
                            await ref.read(networkTimeFutureProvider.future);

                            final savedItemsCurrent = ref
                                .read(autoAbsenNotifierProvider.notifier)
                                .currentNetworkTimeForSavedAbsen(
                                    dbDate: dbDate, savedItems: savedItems);

                            final autoAbsen = ref
                                .read(autoAbsenNotifierProvider.notifier)
                                .sortAbsenMap(savedItemsCurrent);

                            // debugger();

                            await ref
                                .read(autoAbsenNotifierProvider.notifier)
                                .processAutoAbsen(
                                  imei: imei,
                                  buildContext: buildContext,
                                  autoAbsenMap: autoAbsen,
                                  geofence: geofence,
                                  savedItems: savedItemsCurrent,
                                );

                            // debugger();
                          } else {
                            if (geofence.isNotEmpty) {
                              //
                              await ref
                                  .read(geofenceProvider.notifier)
                                  .initializeGeoFence(geofence,
                                      onError: (e) => log('error geofence $e'));
                            } else {
                              //
                              await ref
                                  .read(geofenceProvider.notifier)
                                  .getGeofenceListFromStorage();
                            }
                            //
                            await ref
                                .read(backgroundNotifierProvider.notifier)
                                .getSavedLocations();
                          }
                        });
                    // debugger();
                  } else {
                    //
                    await ref
                        .read(geofenceProvider.notifier)
                        .initializeGeoFence(geofence,
                            onError: (e) => log('error geofence $e'));

                    // debugger();
                  }
                } else {
                  await ref
                      .read(geofenceProvider.notifier)
                      .getGeofenceListFromStorage();

                  // debugger();
                  // }
                }
              })),
    );

    final isLoading =
        ref.watch(geofenceProvider.select((value) => value.isGetting)) ||
            ref.watch(
                backgroundNotifierProvider.select((value) => value.isGetting));

    return Scaffold(
      body: Stack(children: [
        HomeSaved(),
        LoadingOverlay(
            loadingMessage: 'Initializing Geofence & Saved Locations...',
            isLoading: isLoading),
      ]),
      backgroundColor: Colors.transparent,
    );
  }
}
