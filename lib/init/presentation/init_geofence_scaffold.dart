import 'package:face_net_authentication/utils/logging.dart';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/device_detector/device_detector_notifier.dart';
import 'package:face_net_authentication/network_time/network_time_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geofence_service/geofence_service.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../background/application/saved_location.dart';
import '../../config/configuration.dart';
import '../../constants/assets.dart';
import '../../domain/background_failure.dart';
import '../../domain/geofence_failure.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../geofence/application/geofence_response.dart';

import '../../home/presentation/home_saved.dart';
import '../../network_state/application/network_state_notifier.dart';
import '../../shared/common_widgets.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../widgets/alert_helper.dart';
import '../../widgets/v_async_widget.dart';
import '../../widgets/v_dialogs.dart';

class InitGeofenceScaffold extends StatefulHookConsumerWidget {
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

      final isOffline = ref.read(absenOfflineModeProvider);
      if (isOffline) {
        await ref.read(geofenceProvider.notifier).getGeofenceListFromStorage();
      } else {
        await ref.read(geofenceProvider.notifier).getGeofenceList();
      }
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    ref.listen(networkCallbackProvider, (_, __) {});

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
          (either) => either.fold((failure) {
                failure.maybeWhen(
                    noConnection: () => ref
                        .read(geofenceProvider.notifier)
                        .getGeofenceListFromStorage(),
                    empty: () => _geofenceEmptyError(),
                    orElse: () => _otherError(failure));
              },
                  (geofenceList) =>
                      _getAndInitializeGeofence(geofenceList, buildContext))),
    );

    final isLoading =
        ref.watch(geofenceProvider.select((value) => value.isGetting)) ||
            ref.watch(
                backgroundNotifierProvider.select((value) => value.isGetting));

    ref.listen<AsyncValue>(errLogControllerProvider, (_, state) {
      state.showAlertDialogOnError(context, ref);
    });

    final errLog = ref.watch(errLogControllerProvider);

    final _controller = useAnimationController();

    final _device = ref.watch(deviceDetectorNotifierProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          if (!isLoading) ...[
            VAsyncValueWidget<bool>(
                value: _device,
                data: (dev) {
                  bool cond = false;

                  if (BuildConfig.isProduction) {
                    cond = dev == false;
                  } else {
                    cond = dev;
                  }

                  return cond
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Anda dideteksi menggunakan emulator. Harap gunakan aplikasi E-FINGER pada device fisik anda.',
                              textAlign: TextAlign.center,
                              style: Themes.customColor(
                                20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : HomeSaved();
                }),
          ],
          if (isLoading) ...[
            Align(
              alignment: Alignment.center,
              child: CommonWidget().lottie(
                'assets/location.json',
                'Initializing Geofence...',
                _controller,
              ),
            )
          ]
        ]),
      ),
    );
  }

  Future<void> _getAndInitializeGeofence(
    List<GeofenceResponse> geofenceList,
    BuildContext buildContext,
  ) async {
    final Function(Location location) mockListener =
        ref.read(mockLocationNotifierProvider.notifier).checkMockLocationState;

    if (geofenceList.isNotEmpty) {
      final List<Geofence> geofence = ref
          .read(geofenceProvider.notifier)
          .geofenceResponseToList(geofenceList);

      final isOffline = ref.read(absenOfflineModeProvider);

      if (!isOffline) {
        await _onGeonfeceNotOffline(
          buildContext,
          geofence,
          geofenceList,
          mockListener,
        );
      } else {
        Log.info('onGeofenceOffline');
        await _onGeofenceOffline(geofence, mockListener);
      }
    } else {
      await ref.read(geofenceProvider.notifier).getGeofenceListFromStorage();
    }
  }

  Future<void> _onGeofenceOffline(
      List<Geofence> geofence, mockListener(Location location)) async {
    await ref.read(geofenceProvider.notifier).initializeGeoFence(geofence,
        onError: (e) => Log.info('error geofence $e'));

    await ref
        .read(geofenceProvider.notifier)
        .addGeofenceMockListener(mockListener: mockListener);
  }

  Future<void> _onGeonfeceNotOffline(
    BuildContext buildContext,
    List<Geofence> geofence,
    List<GeofenceResponse> geofenceList,
    Function(Location location) mockListener,
  ) async {
    final List<SavedLocation> savedItems =
        ref.read(backgroundNotifierProvider).savedBackgroundItems;

    final geofenceNotifier = ref.read(geofenceProvider.notifier);
    await geofenceNotifier.startAutoAbsen(
        geofenceResponseList: geofenceList,
        savedBackgroundItems: savedItems,
        saveGeofence: geofenceNotifier.saveGeofence,
        showDialogAndLogout: () => showDialog(
                context: context,
                builder: (context) => VSimpleDialog(
                      asset: Assets.iconCrossed,
                      label: 'Error',
                      labelDescription:
                          'Mohon Maaf Storage Anda penuh. Mohon luangkan storage Anda agar bisa menyimpan data Geofence.',
                    ))
            .then((_) => ref.read(userNotifierProvider.notifier).logout()),
        startAbsenSaved: (savedItems) async {
          // ABSEN TERSIMPAN
          if (savedItems.isNotEmpty) {
            await geofenceNotifier.initializeGeoFence(
              geofence,
              onError: (e) => Log.info('error geofence $e'),
            );
            await ref
                .read(geofenceProvider.notifier)
                .addGeofenceMockListener(mockListener: mockListener);

            // debugger();
            Log.info('savedItems $savedItems');

            // [AUTO ABSEN]
            final imei = ref.read(imeiNotifierProvider).imei;

            // REFRESH CURRENT NETWORK TIME
            final dbDate =
                await ref.refresh(networkTimeNotifierProvider.future);
            // GET CURRENT NETWORK TIME
            await ref.read(networkTimeNotifierProvider.future);
            //
            final List<SavedLocation> savedItemsCurrent = ref
                .read(autoAbsenNotifierProvider.notifier)
                .currentNetworkTimeForSavedAbsen(
                    dbDate: dbDate, savedItems: savedItems);

            final Map<DateTime, List<SavedLocation>> autoAbsen = ref
                .read(autoAbsenNotifierProvider.notifier)
                .sortAbsenMap(savedItemsCurrent);

            // debugger();

            await ref.read(autoAbsenNotifierProvider.notifier).processAutoAbsen(
                  imei: imei,
                  geofence: geofence,
                  autoAbsenMap: autoAbsen,
                  buildContext: buildContext,
                  savedItems: savedItemsCurrent,
                );

            // debugger();
          } else {
            final thereAreGeofences = geofence.isNotEmpty;
            if (thereAreGeofences) {
              await geofenceNotifier.initializeGeoFence(
                geofence,
                onError: (e) => Log.info('error geofence $e'),
              );
              await ref
                  .read(geofenceProvider.notifier)
                  .addGeofenceMockListener(mockListener: mockListener);
            } else {
              await ref
                  .read(geofenceProvider.notifier)
                  .getGeofenceListFromStorage();
            }

            // might be redundant
            await ref
                .read(backgroundNotifierProvider.notifier)
                .getSavedLocations();
          }
        });
    // debugger();
  }

  _otherError(GeofenceFailure failure) async {
    final errMessage = failure.maybeMap(
      orElse: () => '',
      passwordExpired: (_) => 'Pass Expire',
      passwordWrong: (value) => 'Pass Wrong',
      server: (error) => 'Error geofence: ($error)',
      wrongFormat: (val) => 'Error parsing geofence : $val',
    );

    await ref
        .read(errLogControllerProvider.notifier)
        .sendLog(errMessage: errMessage);

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

  _savedBackgroundItemsError(BackgroundFailure failure) async {
    final errMessage = failure.map(
      empty: (_) => '',
      unknown: (value) => 'Error ${value.errorCode} ${value.message} ',
    );

    await ref
        .read(errLogControllerProvider.notifier)
        .sendLog(errMessage: errMessage);

    return AlertHelper.showSnackBar(context, message: errMessage);
  }

  _geofenceEmptyError() async {
    final String errMessage =
        'Geofence Belum Disimpan sehingga tidak ada Geofence Offline.';

    await ref
        .read(errLogControllerProvider.notifier)
        .sendLog(errMessage: errMessage);

    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              label: 'Error',
              labelDescription: errMessage,
              asset: Assets.iconCrossed,
              color: Colors.red,
            )).then((_) async {
      await ref.read(userNotifierProvider.notifier).logout();
      await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
    });
  }
}
