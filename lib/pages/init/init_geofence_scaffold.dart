import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../shared/providers.dart';
import '../../domain/geofence_failure.dart';
import '../../pages/widgets/v_dialogs.dart';
import '../../domain/background_failure.dart';
import '../../pages/widgets/alert_helper.dart';
import '../../pages/home/saved/home_saved.dart';
import '../../pages/widgets/loading_overlay.dart';
import '../../application/background/saved_location.dart';
import '../../application/geofence/geofence_response.dart';
import '../../application/background/background_item_state.dart';

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
                                orElse: () => '',
                                wrongFormat: () => 'Error parsing geofence',
                                server: (error, stacktrace) =>
                                    'Error geofence: ($error) $stacktrace',
                              ),
                              asset: Assets.iconCrossed,
                              color: Colors.red))), (geofenceList) async {
                final Function(Location location) mockListener = ref
                    .read(mockLocationNotifierProvider.notifier)
                    .addMockLocationListener;
                //
                if (geofenceList.isNotEmpty) {
                  final bool isOffline =
                      ref.read(absenOfflineModeProvider.notifier).state;
                  //
                  final List<Geofence> geofence = ref
                      .read(geofenceProvider.notifier)
                      .geofenceResponseToList(geofenceList);
                  //
                  final List<BackgroundItemState> savedItems =
                      ref.read(backgroundNotifierProvider).savedBackgroundItems;

                  log('isOffline $isOffline');

                  // Is currently offline
                  if (!isOffline) {
                    //
                    await ref.read(geofenceProvider.notifier).startAutoAbsen(
                        geofenceResponseList: geofenceList,
                        savedBackgroundItems: savedItems,
                        saveGeofence: (geofenceList) => ref
                            .read(geofenceProvider.notifier)
                            .saveGeofence(geofenceList),
                        showDialogAndLogout: () => showDialog(
                            context: context,
                            builder: (context) => VSimpleDialog(
                                  asset: Assets.iconCrossed,
                                  label: 'Error',
                                  labelDescription:
                                      'Mohon Maaf Storage Anda penuh. Mohon luangkan storage Anda agar bisa menyimpan data Geofence.',
                                )).then((_) =>
                            ref.read(userNotifierProvider.notifier).logout()),
                        startAbsen: (savedItems) async {
                          // ABSEN TERSIMPAN
                          if (savedItems.isNotEmpty) {
                            final List<SavedLocation>? savedLocations = ref
                                .read(backgroundNotifierProvider.notifier)
                                .getSavedLocationsAsList(savedItems);

                            log('savedLocations ${savedLocations?.length}');
                            // debugger(message: 'called');

                            await ref
                                .read(geofenceProvider.notifier)
                                .initializeGeoFence(geofence,
                                    onError: (e) => log('error geofence $e'));
                            await ref
                                .read(geofenceProvider.notifier)
                                .addGeofenceMockListener(
                                    mockListener: mockListener);

                            // debugger();
                            log('savedItems $savedItems');
                            // [AUTO ABSEN]

                            final imei = ref.read(imeiNotifierProvider
                                .select((value) => value.imei));

                            final dbDate = await ref
                                .refresh(networkTimeFutureProvider.future);

                            // GET CURRENT NETWORK TIME
                            await ref.read(networkTimeFutureProvider.future);

                            final List<BackgroundItemState> savedItemsCurrent =
                                ref
                                    .read(autoAbsenNotifierProvider.notifier)
                                    .currentNetworkTimeForSavedAbsen(
                                        dbDate: dbDate, savedItems: savedItems);

                            final Map<String, List<BackgroundItemState>>
                                autoAbsen = ref
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

                              await ref
                                  .read(geofenceProvider.notifier)
                                  .addGeofenceMockListener(
                                      mockListener: mockListener);
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

                    await ref
                        .read(geofenceProvider.notifier)
                        .addGeofenceMockListener(mockListener: mockListener);

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
