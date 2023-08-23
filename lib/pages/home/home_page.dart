import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../../application/background/saved_location.dart';
import '../../application/geofence/geofence_response.dart';
import '../../constants/assets.dart';
import '../../domain/background_failure.dart';
import '../../domain/geofence_failure.dart';
import '../../domain/user_failure.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_dialogs.dart';
import 'imei/home_imei.dart';
import 'saved/home_saved.dart';
import 'home_scaffold.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
                  barrierDismissible: true,
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
                    barrierDismissible: true,
                    builder: (_) => VSimpleDialog(
                      label: 'Error',
                      labelDescription: failure.maybeMap(
                          errorParsing: (error) =>
                              'Error while parsing user. ${error.message}',
                          orElse: () => ''),
                      asset: Assets.iconCrossed,
                    ),
                  ),
              (userParsed) =>
                  ref.read(userNotifierProvider.notifier).onUserParsed(
                        user: userParsed,
                        initializeDioRequest: () {
                          ref.read(dioRequestProvider).addAll({
                            "username": "${userParsed.nama}",
                            "password": "${userParsed.password}",
                            "server": "${userParsed.ptServer}"
                          });
                          log('dioRequestProvider ${ref.read(dioRequestProvider)}');
                        },
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
                    // debugger(message: 'called');

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

                  ref.read(absenOfflineModeProvider.notifier).state = true;

                  return await Future.value(true);
                },
                orElse: () => showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => VSimpleDialog(
                        label: 'Error',
                        labelDescription: failure.maybeWhen(
                            server: (_, __) => 'Error server geofence',
                            wrongFormat: () => 'Error parsing geofence',
                            orElse: () => ''),
                        asset: Assets.iconCrossed,
                        color: Colors.red))), (geofenceList) async {
          if (geofenceList.isNotEmpty) {
            final geofence = ref
                .read(geofenceProvider.notifier)
                .geofenceResponseToList(geofenceList);
            final savedItems = ref
                .read(backgroundNotifierProvider.notifier)
                .state
                .savedBackgroundItems;

            final isOffline = ref.read(absenOfflineModeProvider.notifier).state;
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
                      debugger(message: 'called');

                      await ref
                          .read(geofenceProvider.notifier)
                          .initializeGeoFence(savedLocations, geofence,
                              onError: () => ref
                                  .read(geofenceProvider.notifier)
                                  .getGeofenceListFromStorage());
                      debugger(message: 'called');

                      log('savedItems $savedItems');
                      // [AUTO ABSEN]
                      final autoAbsen = ref
                          .read(autoAbsenNotifierProvider.notifier)
                          .sortAbsenMap(savedItems);
                      log('autoAbsen: map $autoAbsen');
                      debugger(message: 'called');

                      final nearestCoordinatesSaved = ref.read(geofenceProvider
                          .select((value) => value.nearestCoordinatesSaved));
                      final imei = ref.read(imeiAuthNotifierProvider
                          .select((value) => value.imei));

                      debugger(message: 'called');

                      await ref
                          .read(autoAbsenNotifierProvider.notifier)
                          .processAutoAbsen(
                              imei: imei,
                              ref: ref,
                              context: context,
                              autoAbsenMap: autoAbsen,
                              geofence: geofence,
                              savedItems: savedItems,
                              nearestCoordinatesSaved: nearestCoordinatesSaved);
                    } else {
                      if (geofence.isNotEmpty) {
                        await ref
                            .read(geofenceProvider.notifier)
                            .initializeGeoFence(null, geofence,
                                onError: () => ref
                                    .read(geofenceProvider.notifier)
                                    .getGeofenceListFromStorage());
                      } else {
                        await ref
                            .read(geofenceProvider.notifier)
                            .getGeofenceListFromStorage();
                      }

                      await ref
                          .read(backgroundNotifierProvider.notifier)
                          .getSavedLocations();
                    }
                  });
            } else {
              await ref.read(geofenceProvider.notifier).initializeGeoFence(
                  null, geofence,
                  onError: () => ref
                      .read(geofenceProvider.notifier)
                      .getGeofenceListFromStorage());
            }
          } else {
            await ref
                .read(geofenceProvider.notifier)
                .getGeofenceListFromStorage();
          }
        }),
      ),
    );

    return UpgradeAlert(
      upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
      child: Stack(
        children: [
          HomeSaved(),
          HomeScaffold(),
          HomeImei(),
          LoadingOverlay(isLoading: false),
        ],
      ),
    );
  }
}
