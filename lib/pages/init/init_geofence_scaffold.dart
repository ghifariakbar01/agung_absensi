import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../shared/providers.dart';
import '../../domain/geofence_failure.dart';
import '../../pages/widgets/v_dialogs.dart';
import '../../domain/background_failure.dart';
import '../../pages/widgets/alert_helper.dart';
import '../../pages/home/saved/home_saved.dart';
import '../../pages/widgets/loading_overlay.dart';
import '../../application/background/saved_location.dart';
import '../../application/geofence/geofence_response.dart';

import '../widgets/v_async_widget.dart';

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
                _savedBackgroundItemsError,
                ref
                    .read(backgroundNotifierProvider.notifier)
                    .changeBackgroundItems)));

    // GEOFENCE
    ref.listen<Option<Either<GeofenceFailure, List<GeofenceResponse>>>>(
      geofenceProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold((failure) async {
                failure.maybeWhen(
                    noConnection: () => ref
                        .read(geofenceProvider.notifier)
                        .getGeofenceListFromStorage(),
                    empty: () => _geofenceEmptyError(),
                    orElse: () => _otherError(failure));
              }, (geofenceList) async {
                final Function(Location location) mockListener = ref
                    .read(mockLocationNotifierProvider.notifier)
                    .addMockLocationListener;
                //
                if (geofenceList.isNotEmpty) {
                  //
                  final List<Geofence> geofence = ref
                      .read(geofenceProvider.notifier)
                      .geofenceResponseToList(geofenceList);

                  final isOffline = ref.read(absenOfflineModeProvider);
                  log('isOffline Geofeonce $isOffline');

                  // Is currently offline
                  if (!isOffline) {
                    _onGeonfeceNotOffline(
                        //
                        geofenceList,
                        geofence,
                        mockListener,
                        buildContext);
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

    ref.listen<AsyncValue>(errLogControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => Scaffold(
        body: Stack(children: [
          HomeSaved(),
          LoadingOverlay(
              loadingMessage: 'Initializing Geofence & Saved Locations...',
              isLoading: isLoading),
        ]),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Future<void> _onGeonfeceNotOffline(
      List<GeofenceResponse> geofenceList,
      List<Geofence> geofence,
      Function(Location location) mockListener,
      BuildContext buildContext) async {
    {
      //
      final List<SavedLocation> savedItems =
          ref.read(backgroundNotifierProvider).savedBackgroundItems;

      //
      await ref.read(geofenceProvider.notifier).startAutoAbsen(
          geofenceResponseList: geofenceList,
          savedBackgroundItems: savedItems,
          saveGeofence: (geofenceList) =>
              ref.read(geofenceProvider.notifier).saveGeofence(geofenceList),
          showDialogAndLogout: () => showDialog(
                  context: context,
                  builder: (context) => VSimpleDialog(
                        asset: Assets.iconCrossed,
                        label: 'Error',
                        labelDescription:
                            'Mohon Maaf Storage Anda penuh. Mohon luangkan storage Anda agar bisa menyimpan data Geofence.',
                      ))
              .then((_) => ref.read(userNotifierProvider.notifier).logout()),
          startAbsen: (savedItems) async {
            // ABSEN TERSIMPAN
            if (savedItems.isNotEmpty) {
              await ref.read(geofenceProvider.notifier).initializeGeoFence(
                  geofence,
                  onError: (e) => log('error geofence $e'));
              await ref
                  .read(geofenceProvider.notifier)
                  .addGeofenceMockListener(mockListener: mockListener);

              // debugger();
              log('savedItems $savedItems');
              // [AUTO ABSEN]

              final imei =
                  ref.read(imeiNotifierProvider.select((value) => value.imei));

              final dbDate =
                  await ref.refresh(networkTimeFutureProvider.future);

              // GET CURRENT NETWORK TIME
              await ref.read(networkTimeFutureProvider.future);

              final List<SavedLocation> savedItemsCurrent = ref
                  .read(autoAbsenNotifierProvider.notifier)
                  .currentNetworkTimeForSavedAbsen(
                      dbDate: dbDate, savedItems: savedItems);

              final Map<String, List<SavedLocation>> autoAbsen = ref
                  .read(autoAbsenNotifierProvider.notifier)
                  .sortAbsenMap(savedItemsCurrent);

              // debugger();

              await ref
                  .read(autoAbsenNotifierProvider.notifier)
                  .processAutoAbsen(
                    imei: imei,
                    geofence: geofence,
                    autoAbsenMap: autoAbsen,
                    buildContext: buildContext,
                    savedItems: savedItemsCurrent,
                  );

              // debugger();
            } else {
              if (geofence.isNotEmpty) {
                //
                await ref.read(geofenceProvider.notifier).initializeGeoFence(
                    geofence,
                    onError: (e) => log('error geofence $e'));

                await ref
                    .read(geofenceProvider.notifier)
                    .addGeofenceMockListener(mockListener: mockListener);
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
    }
  }

  _otherError(GeofenceFailure failure) async {
    {
      final String errMessage = failure.maybeMap(
        orElse: () => '',
        passwordExpired: (_) => 'Pass Expire',
        passwordWrong: (value) => 'Pass Wrong',
        server: (error) => 'Error geofence: ($error)',
        wrongFormat: (val) => 'Error parsing geofence : $val',
      );

      final String imeiSaved =
          await ref.read(imeiNotifierProvider.notifier).getImeiString();

      final String imeiDb =
          await ref.read(imeiNotifierProvider.notifier).getImeiString();

      await ref.read(errLogControllerProvider.notifier).sendLog(
          imeiDb: imeiDb, imeiSaved: imeiSaved, errMessage: errMessage);

      return showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => VSimpleDialog(
              label: 'Error',
              labelDescription: errMessage,
              asset: Assets.iconCrossed,
              color: Colors.red)).then((_) =>
          ref.read(geofenceProvider.notifier).getGeofenceListFromStorage());
    }
  }

  _savedBackgroundItemsError(BackgroundFailure failure) async {
    {
      final String errMessage = failure.map(
        empty: (_) => '',
        unknown: (value) => 'Error ${value.errorCode} ${value.message} ',
      );

      final String imeiSaved =
          await ref.read(imeiNotifierProvider.notifier).getImeiString();

      final String imeiDb =
          await ref.read(imeiNotifierProvider.notifier).getImeiString();

      await ref.read(errLogControllerProvider.notifier).sendLog(
          imeiDb: imeiDb, imeiSaved: imeiSaved, errMessage: errMessage);

      return AlertHelper.showSnackBar(context, message: errMessage);
    }
  }

  _geofenceEmptyError() async {
    {
      final String errMessage =
          'Geofence Belum Disimpan sehingga tidak ada Geofence Offline.';

      final String imeiSaved =
          await ref.read(imeiNotifierProvider.notifier).getImeiString();

      final String imeiDb =
          await ref.read(imeiNotifierProvider.notifier).getImeiString();

      await ref.read(errLogControllerProvider.notifier).sendLog(
          imeiDb: imeiDb, imeiSaved: imeiSaved, errMessage: errMessage);

      return showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => VSimpleDialog(
                  label: 'Error',
                  labelDescription: "",
                  asset: Assets.iconCrossed,
                  color: Colors.red))
          .then((_) => ref.read(userNotifierProvider.notifier).logout());
    }
  }
}
