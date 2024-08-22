import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../domain/background_failure.dart';
import '../domain/geofence_failure.dart';
import '../err_log/application/err_log_notifier.dart';
import '../../shared/providers.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/logging.dart';
import '../../widgets/alert_helper.dart';
import '../../widgets/v_dialogs.dart';
import 'application/geofence_error_notifier.dart';
import 'application/geofence_response.dart';

class GeofenceHelper {
  final WidgetRef ref;
  final BuildContext context;

  GeofenceHelper(
    this.ref,
    this.context,
  );

  Future<void> reinitializeGeofence(
    List<GeofenceResponse> geofenceList,
  ) async {
    final Function(Location location) mockListener =
        ref.read(mockLocationNotifierProvider.notifier).checkMockLocationState;

    if (geofenceList.isNotEmpty) {
      final List<Geofence> geofence = ref
          .read(geofenceProvider.notifier)
          .geofenceResponseToList(geofenceList);

      await _onGeonfeceReinitialize(
        context,
        geofence,
        mockListener,
      );
    } else {
      await ref
          .read(geofenceProvider.notifier)
          .getGeofenceListFromStorageAfterAbsen();
    }
  }

  Future<void> _onGeonfeceReinitialize(
    BuildContext buildContext,
    List<Geofence> geofence,
    Function(Location location) mockListener,
  ) async {
    return geofence.isNotEmpty
        ? ref.read(geofenceProvider.notifier).initializeGeoFence(
              geofence,
              isRestart: true,
              mockListener: mockListener,
              onError: _onGeofenceError,
            )
        : DialogHelper.showCustomDialog(
            'Error _onGeonfeceNotOfflineReinitialize . Geofence empty',
            buildContext,
          );
  }

  Future<void> getAndInitializeGeofence(
    List<GeofenceResponse> geofenceList,
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
          context,
          geofence,
          geofenceList,
          mockListener,
        );
      } else {
        Log.warning('onGeofenceOffline');
        await _onGeofenceOffline(geofence, mockListener);
      }
    } else {
      await ref.read(geofenceProvider.notifier).getGeofenceListFromStorage();
    }
  }

  Future<void> _onGeofenceOffline(
    List<Geofence> geofence,
    mockListener(Location location),
  ) async {
    return ref.read(geofenceProvider.notifier).initializeGeoFence(
          geofence,
          mockListener: mockListener,
          onError: (e) => _onGeofenceError(e, false),
        );
  }

  Future<void> _onGeonfeceNotOffline(
    BuildContext buildContext,
    List<Geofence> geofence,
    List<GeofenceResponse> geofenceList,
    Function(Location location) mockListener,
  ) async {
    final geofenceNotifier = ref.read(geofenceProvider.notifier);
    final save = await geofenceNotifier.saveGeofence(geofenceList);
    return save.fold(
        (l) => DialogHelper.showCustomDialog(
              l.maybeWhen(
                storage: (value) => value ?? 'Storage Penuh Geofence',
                orElse: () => '',
              ),
              buildContext,
            ), (_) {
      return geofence.isNotEmpty
          ? geofenceNotifier.initializeGeoFence(
              geofence,
              mockListener: mockListener,
              onError: _onGeofenceError,
            )
          : DialogHelper.showCustomDialog(
              'Error initialize geofence. Geofence empty',
              buildContext,
            );
    });
  }

  Future<void> _onGeofenceError(Object e, [bool isOnline = true]) async {
    String msg = '';

    if (e is ErrorCodes) {
      final notifier = ref.read(geofenceErrorNotifierProvider.notifier);

      msg = notifier.geofenceErrMessage(e);
      notifier.checkAndUpdateError(e);

      if (isOnline) {
        await ref
            .read(errLogControllerProvider.notifier)
            .sendLog(errMessage: msg);
      }
    } else {
      msg = e.toString();
    }

    Log.shout(msg);

    await DialogHelper.showCustomDialog(
      msg,
      context,
    );
  }

  otherError(GeofenceFailure failure) async {
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

  savedBackgroundItemsError(BackgroundFailure failure) async {
    final errMessage = failure.map(
      empty: (_) => '',
      unknown: (value) => 'Unkown: ${value.errorCode} ${value.message}',
      formatException: (value) => 'Formatexception: $value',
    );

    await ref
        .read(errLogControllerProvider.notifier)
        .sendLog(errMessage: errMessage);

    return AlertHelper.showSnackBar(context, message: errMessage);
  }

  geofenceEmptyError() async {
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
            )).then((_) => _logout());
  }

  _logout() async {
    await ref.read(userNotifierProvider.notifier).logout();
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  }
}
