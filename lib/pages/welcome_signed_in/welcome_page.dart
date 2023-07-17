import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/background_service/recent_absen_state.dart';
import 'package:face_net_authentication/constants/assets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_state.dart';
import '../../application/background_service/saved_location.dart';
import '../../application/geofence/geofence_response.dart';
import '../../domain/background_failure.dart';
import '../../domain/geofence_failure.dart';
import '../../domain/user_failure.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import 'welcome_imei.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_dialogs.dart';
import 'welcome_saved.dart';
import 'welome_scaffold.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage();

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userNotifierProvider.notifier).getUser();
      await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
      await ref.read(geofenceProvider.notifier).getGeofenceList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Option<Either<UserFailure, String?>>>(
      userNotifierProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
            (failure) => showDialog(
                  context: context,
                  builder: (_) => VSimpleDialog(
                    label: 'Error',
                    labelDescription: failure.maybeMap(
                        empty: (_) => 'No user found',
                        unknown: (unkn) => '${unkn.errorCode} ${unkn.message}',
                        orElse: () => ''),
                    asset: Assets.iconCrossed,
                  ),
                ), (userString) {
          final userParsed =
              ref.read(userNotifierProvider.notifier).parseUser(userString);

          userParsed.fold(
              (failure) => showDialog(
                    context: context,
                    builder: (_) => VSimpleDialog(
                      label: 'Error',
                      labelDescription: failure.maybeMap(
                          errorParsing: (error) =>
                              'Error while parsing user. ${error.message}',
                          orElse: () => ''),
                      asset: Assets.iconCrossed,
                    ),
                  ),
              (userParsed) => ref
                  .read(userNotifierProvider.notifier)
                  .onUserParsed(
                    user: userParsed,
                    dioRequestSet: () => ref.read(dioRequestProvider).addAll({
                      "username": "${userParsed.nama}",
                      "password": "${userParsed.password}",
                    }),
                    checkAndUpdateStatus: () => ref
                        .read(authNotifierProvider.notifier)
                        .checkAndUpdateAuthStatus(),
                    checkAndUpdateImei: () => ref
                        .read(imeiNotifierProvider.notifier)
                        .checkAndUpdateImei(user: userParsed),
                  ));
        }),
      ),
    );

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
                  if (savedLocations.isNotEmpty) {
                    debugger(message: 'called');

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

    ref.listen<Option<Either<GeofenceFailure, List<GeofenceResponse>>>>(
      geofenceProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
            (failure) => failure.maybeWhen(
                noConnection: () async {
                  await ref
                      .read(geofenceProvider.notifier)
                      .getGeofenceListFromStorage();

                  return Future.value(true);
                },
                orElse: () => showCupertinoDialog(
                    context: context,
                    builder: (_) => VSimpleDialog(
                        label: 'Error',
                        labelDescription: failure.when(
                            server: (_, __) => 'Error server geofence',
                            wrongFormat: () => 'Error parsing geofence',
                            noConnection: () => 'No connection'),
                        asset: Assets.iconCrossed,
                        color: Colors.red))), (geofenceList) async {
          log('geofenceList $geofenceList');

          // geofenceList exist
          if (geofenceList.isNotEmpty) {
            final geofence = ref
                .read(geofenceProvider.notifier)
                .geofenceResponseToList(geofenceList);

            final savedItems = ref
                .read(backgroundNotifierProvider.notifier)
                .state
                .savedBackgroundItems;

            await ref.read(geofenceProvider.notifier).startAutoAbsen(
                geofenceResponseList: geofenceList,
                savedBackgroundItems: savedItems,
                saveGeofence: (geofenceList) => ref
                    .read(geofenceProvider.notifier)
                    .saveGeofence(geofenceList),
                startAbsen: (savedItems) async {
                  if (savedItems.isNotEmpty) {
                    final savedLocations = ref
                        .read(backgroundNotifierProvider.notifier)
                        .getSavedLocationsAsList(savedItems);

                    log('savedLocations ${savedLocations?.length}');

                    debugger(message: 'called');

                    await ref
                        .read(geofenceProvider.notifier)
                        .initializeGeoFence(geofence, savedLocations);

                    log('savedItems $savedItems');

                    // [AUTO ABSEN]
                    final autoAbsen = ref
                        .read(autoAbsenNotifierProvider.notifier)
                        .sortAbsenMap(savedItems);

                    log('autoAbsen: map $autoAbsen');

                    autoAbsen.forEach((key, absensInDate) async {
                      /// check if absen [AbsenState.empty()], [AbsenState.absenIn()] or [AbsenState.complete()]

                      debugger(message: 'called');
                      log('autoAbsen: key $key');

                      if (absensInDate.isNotEmpty) {
                        debugger(message: 'called');

                        final absensInDateLen = absensInDate.length;

                        // used for Absen In
                        final firstAbsen = 0;

                        // used for Absen Out
                        final lastAbsen = absensInDateLen - 1;

                        for (int i = 0; i < absensInDateLen; i++) {
                          final absenSaved = absensInDate[i];

                          await ref
                              .read(absenNotifierProvidier.notifier)
                              .getAbsen(
                                  date: absenSaved.savedLocations.date,
                                  onAbsen: (absen) {
                                    ref
                                        .read(absenNotifierProvidier.notifier)
                                        .changeAbsen(absen);

                                    ref
                                        .read(absenOfflineModeProvider.notifier)
                                        .state = false;
                                  },
                                  onNoConnection: () {
                                    ref
                                        .read(absenOfflineModeProvider.notifier)
                                        .state = true;
                                    return;
                                  });

                          final absenState =
                              ref.read(absenNotifierProvidier.notifier).state;

                          log('absenState $absenState');

                          if (absenState == AbsenState.empty() &&
                              i == firstAbsen) {
                            debugger(message: 'called');
                            final jenisAbsen = JenisAbsen.absenIn;

                            // absen one liner
                            await ref
                                .read(absenAuthNotifierProvidier.notifier)
                                .absenOneLiner(
                                  backgroundItemState: absenSaved,
                                  jenisAbsen: jenisAbsen,
                                  onAbsen: () async {
                                    await ref
                                        .read(absenNotifierProvidier.notifier)
                                        .getAbsen(
                                            date:
                                                absenSaved.savedLocations.date,
                                            onAbsen: (absen) => ref
                                                .read(absenNotifierProvidier
                                                    .notifier)
                                                .changeAbsen(absen),
                                            onNoConnection: () => ref
                                                .read(absenOfflineModeProvider
                                                    .notifier)
                                                .state = true);

                                    await ref
                                        .read(
                                            backgroundNotifierProvider.notifier)
                                        .getSavedLocations();
                                  },
                                  deleteSaved: () async {
                                    // delete saved absen
                                    debugger(message: 'called');

                                    await ref
                                        .read(
                                            backgroundNotifierProvider.notifier)
                                        .removeLocationFromSaved(
                                            absenSaved.savedLocations,
                                            onSaved: () async {
                                      final savedLocations = await ref
                                          .read(backgroundNotifierProvider
                                              .notifier)
                                          .getSavedLocationsOneLiner();

                                      debugger(message: 'called');

                                      final bgItems = ref
                                          .read(backgroundNotifierProvider
                                              .notifier)
                                          .getBackgroundItemsAsList(
                                              savedLocations);

                                      log('bgItems savedLocations $bgItems $savedLocations');

                                      ref
                                          .read(backgroundNotifierProvider
                                              .notifier)
                                          .changeBackgroundItems(bgItems ?? []);
                                    });
                                  },
                                  reinitializeDependencies: () async {
                                    // reinitialize dependecies
                                    final savedLocations = ref
                                        .read(
                                            backgroundNotifierProvider.notifier)
                                        .getSavedLocationsAsList(savedItems);

                                    log('savedLocations ${savedLocations?.length}');

                                    await ref
                                        .read(
                                            backgroundNotifierProvider.notifier)
                                        .getSavedLocations();

                                    debugger(message: 'called');
                                    await ref
                                        .read(geofenceProvider.notifier)
                                        .initializeGeoFence(
                                            geofence, savedLocations);
                                  },
                                  getAbsenState: () async {
                                    // get absen state
                                    await ref
                                        .read(absenNotifierProvidier.notifier)
                                        .getAbsen(
                                            date:
                                                absenSaved.savedLocations.date,
                                            onAbsen: (absen) => ref
                                                .read(absenNotifierProvidier
                                                    .notifier)
                                                .changeAbsen(absen),
                                            onNoConnection: () => ref
                                                .read(absenOfflineModeProvider
                                                    .notifier)
                                                .state = true);
                                  },
                                );
                          } else if (absenState == AbsenState.absenIn() &&
                              lastAbsen == i) {
                            debugger(message: 'called');
                            final jenisAbsen = JenisAbsen.absenOut;

                            // absen one liner
                            await ref
                                .read(absenAuthNotifierProvidier.notifier)
                                .absenOneLiner(
                                  backgroundItemState: absenSaved,
                                  jenisAbsen: jenisAbsen,
                                  onAbsen: () async {
                                    await ref
                                        .read(absenNotifierProvidier.notifier)
                                        .getAbsen(
                                            date:
                                                absenSaved.savedLocations.date,
                                            onAbsen: (absen) => ref
                                                .read(absenNotifierProvidier
                                                    .notifier)
                                                .changeAbsen(absen),
                                            onNoConnection: () => ref
                                                .read(absenOfflineModeProvider
                                                    .notifier)
                                                .state = true);

                                    await ref
                                        .read(
                                            backgroundNotifierProvider.notifier)
                                        .getSavedLocations();
                                  },
                                  deleteSaved: () async {
                                    // delete saved absen
                                    await ref
                                        .read(
                                            backgroundNotifierProvider.notifier)
                                        .removeLocationFromSaved(
                                            absenSaved.savedLocations,
                                            onSaved: () async {
                                      final savedLocations = await ref
                                          .read(backgroundNotifierProvider
                                              .notifier)
                                          .getSavedLocationsOneLiner();

                                      final bgItems = ref
                                          .read(backgroundNotifierProvider
                                              .notifier)
                                          .getBackgroundItemsAsList(
                                              savedLocations);

                                      ref
                                          .read(backgroundNotifierProvider
                                              .notifier)
                                          .changeBackgroundItems(bgItems ?? []);
                                    });
                                  },
                                  reinitializeDependencies: () async {
                                    // reinitialize dependecies
                                    final savedLocations = ref
                                        .read(
                                            backgroundNotifierProvider.notifier)
                                        .getSavedLocationsAsList(savedItems);

                                    log('savedLocations ${savedLocations?.length}');

                                    await ref
                                        .read(
                                            backgroundNotifierProvider.notifier)
                                        .getSavedLocations();

                                    debugger(message: 'called');
                                    await ref
                                        .read(geofenceProvider.notifier)
                                        .initializeGeoFence(
                                            geofence, savedLocations);
                                  },
                                  getAbsenState: () async {
                                    // get absen state
                                    await ref
                                        .read(absenNotifierProvidier.notifier)
                                        .getAbsen(
                                            date:
                                                absenSaved.savedLocations.date,
                                            onAbsen: (absen) => ref
                                                .read(absenNotifierProvidier
                                                    .notifier)
                                                .changeAbsen(absen),
                                            onNoConnection: () => ref
                                                .read(absenOfflineModeProvider
                                                    .notifier)
                                                .state = true);
                                  },
                                );
                          } else if (absenState == AbsenState.complete()) {
                            // delete saved absen as we don't need them.
                            await ref
                                .read(backgroundNotifierProvider.notifier)
                                .removeLocationFromSaved(
                                    absenSaved.savedLocations,
                                    onSaved: () async {
                              final savedLocations = await ref
                                  .read(backgroundNotifierProvider.notifier)
                                  .getSavedLocationsOneLiner();

                              final bgItems = ref
                                  .read(backgroundNotifierProvider.notifier)
                                  .getBackgroundItemsAsList(savedLocations);

                              log('bgItems savedLocations $bgItems $savedLocations');

                              ref
                                  .read(backgroundNotifierProvider.notifier)
                                  .changeBackgroundItems(bgItems ?? []);

                              // Trigger another build [FOR DELETION]
                              await ref
                                  .read(userNotifierProvider.notifier)
                                  .getUser();
                              await ref
                                  .read(backgroundNotifierProvider.notifier)
                                  .getSavedLocations();
                              await ref
                                  .read(geofenceProvider.notifier)
                                  .getGeofenceList();
                            });
                          }
                        }
                      }
                    });
                  } else {
                    await ref
                        .read(geofenceProvider.notifier)
                        .initializeGeoFenceOnly(geofence);

                    await ref
                        .read(backgroundNotifierProvider.notifier)
                        .getSavedLocations();

                    final savedItems = ref
                        .read(backgroundNotifierProvider.notifier)
                        .state
                        .savedBackgroundItems;

                    log('savedItems: isEmpty $savedItems');
                  }
                });
          } else {
            await ref
                .read(geofenceProvider.notifier)
                .getGeofenceListFromStorage();
          }
        }),
      ),
    );

    return Stack(
      children: [
        WelcomeSaved(),
        WelcomeScaffold(),
        WelcomeImei(),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
