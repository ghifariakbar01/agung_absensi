import 'dart:async';

import 'package:face_net_authentication/network_time/network_time_notifier.dart';
import 'package:face_net_authentication/utils/os_vibrate.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import '../../background/application/saved_location.dart';
import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../domain/background_failure.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../routes/application/route_names.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../tester/application/tester_state.dart';
import '../../utils/enums.dart';
import '../../utils/geofence_utils.dart';
import '../../widgets/v_button.dart';
import '../../widgets/v_dialogs.dart';

import '../application/absen_state.dart';
import 'absen_reset.dart';
import 'absen_success.dart';

final buttonResetVisibilityProvider = StateProvider<bool>((ref) {
  return false;
});

class AbsenButton extends ConsumerStatefulWidget {
  const AbsenButton();

  @override
  ConsumerState<AbsenButton> createState() => _AbsenButtonState();
}

class _AbsenButtonState extends ConsumerState<AbsenButton> {
  // MODIFY WHEN TESTING
  bool isTesting = false;

  @override
  Widget build(BuildContext context) {
    // ABSEN MODE OFFLINE
    ref.listen<Option<Either<BackgroundFailure, Unit>>>(
        backgroundNotifierProvider.select(
          (state) => state.failureOrSuccessOptionSave,
        ),
        (_, failureOrSuccessOptionSave) => failureOrSuccessOptionSave.fold(
            () {},
            (either) => either.fold(
                (failure) => showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                        label: 'Error',
                        labelDescription: failure.maybeMap(
                          orElse: () => '',
                          empty: (_) => 'No saved found',
                          unknown: (unkn) =>
                              '${unkn.errorCode} ${unkn.message}',
                        ),
                        asset: Assets.iconCrossed,
                      ),
                    ),
                (_) => _onBerhasilSimpanAbsen(context))));

    // ABSEN STATE
    final absen = ref.watch(absenNotifierProvidier);

    // IS TESTER
    final isTester = ref.watch(testerNotifierProvider);

    // IS OFFLINE MODE
    final isOfflineMode = ref.watch(absenOfflineModeProvider);

    // KARYAWAN SHIFT
    final karyawanAsync = ref.watch(karyawanShiftFutureProvider);

    // SAVED LOCATIONS
    final savedIsNotEmpty = ref.watch(
      backgroundNotifierProvider
          .select((value) => value.savedBackgroundItems.isNotEmpty),
    );

    final networkTimeFutureProvider = ref.watch(networkTimeNotifierProvider);

    // LAT, LONG
    final nearest = ref.watch(
      geofenceProvider
          .select((value) => value.nearestCoordinates.remainingDistance),
    );

    // JARAK MAKSIMUM
    final minDistance = ref.watch(
      geofenceProvider.select((value) => value.nearestCoordinates.minDistance),
    );

    // LAT, LONG
    final currentLocationLatitude = ref.watch(
      geofenceProvider.select((value) => value.currentLocation.latitude),
    );
    final currentLocationLongitude = ref.watch(
      geofenceProvider.select((value) => value.currentLocation.longitude),
    );

    final buttonResetVisibility = ref.watch(buttonResetVisibilityProvider);

    // GET ABSEN
    ref.listen<Option<Either<AbsenFailure, Unit>>>(
        absenAuthNotifierProvidier
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                (failure) => failure.maybeWhen(
                    noConnection: () => _onNoConnection(
                          context,
                          currentLocationLatitude,
                          currentLocationLongitude,
                        ),
                    orElse: () => _onErrOther(failure, context)),
                (_) => _onBerhasilAbsen(context))));

    return Column(
      children: [
        // Load Karyawan Shift
        karyawanAsync.when(
          loading: () => Container(),
          error: ((error, stackTrace) =>
              Text('Error: $error \n StackTrace: $stackTrace')),
          data: (isShift) {
            final String karyawanShiftStr = isShift ? 'SHIFT' : '';

            return Column(
              children: [
                Visibility(
                    visible: !isOfflineMode,
                    child: AbsenReset(
                        isTester: isTester.maybeWhen(
                      tester: () => true,
                      orElse: () => false,
                    ))),
                SizedBox(height: 20),
                Visibility(
                  visible: !isOfflineMode,
                  child: VAsyncValueWidget<DateTime>(
                    value: networkTimeFutureProvider,
                    data: (time) => VButton(
                        label: 'ABSEN IN $karyawanShiftStr',
                        isEnabled: isTesting
                            ? true
                            : isTester.maybeWhen(
                                tester: () =>
                                    buttonResetVisibility ||
                                    isShift ||
                                    absen == AbsenState.empty() ||
                                    absen == AbsenState.incomplete(),
                                orElse: () =>
                                    buttonResetVisibility ||
                                    isShift &&
                                        nearest < minDistance &&
                                        nearest != 0 ||
                                    absen == AbsenState.empty() &&
                                        nearest < minDistance &&
                                        nearest != 0 ||
                                    absen == AbsenState.incomplete() &&
                                        nearest < 100 &&
                                        nearest != 0),
                        onPressed: () async {
                          await ref
                              .read(networkTimeNotifierProvider.notifier)
                              .refresh();
                          return _absenIn(
                              currTime: time,
                              context: context,
                              isTester: isTester,
                              currentLocationLatitude: currentLocationLatitude,
                              currentLocationLongitude:
                                  currentLocationLongitude);
                        }),
                  ),
                ),
                Visibility(
                  visible: !isOfflineMode,
                  child: VAsyncValueWidget<DateTime>(
                    value: networkTimeFutureProvider,
                    data: (time) => VButton(
                        label: 'ABSEN OUT $karyawanShiftStr',
                        isEnabled: isTesting
                            ? true
                            : isTester.maybeWhen(
                                tester: () =>
                                    buttonResetVisibility ||
                                    isShift ||
                                    absen == AbsenState.absenIn(),
                                orElse: () =>
                                    buttonResetVisibility ||
                                    isShift &&
                                        nearest < minDistance &&
                                        nearest != 0 ||
                                    absen == AbsenState.absenIn() &&
                                        nearest < minDistance &&
                                        nearest != 0),
                        onPressed: () async {
                          await ref
                              .read(networkTimeNotifierProvider.notifier)
                              .refresh();
                          return _absenOut(
                              currTime: time,
                              context: context,
                              isTester: isTester,
                              currentLocationLatitude: currentLocationLatitude,
                              currentLocationLongitude:
                                  currentLocationLongitude);
                        }),
                  ),
                )
              ],
            );
          },
        ),

        Visibility(
            visible: isTesting ? true : isOfflineMode,
            child: VButton(
                label: 'SIMPAN ABSEN IN',
                isEnabled: isTester.maybeWhen(
                    tester: () => true,
                    orElse: () => isTesting
                        ? isTesting
                        : nearest < minDistance && nearest != 0),
                onPressed: () async {
                  await HapticFeedback.selectionClick();

                  // ALAMAT GEOFENCE
                  final alamat = ref.read(geofenceProvider).nearestCoordinates;

                  // SAVE ABSEN
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .addSavedLocation(
                          savedLocation: SavedLocation.initial().copyWith(
                        idGeof: alamat.id,
                        alamat: alamat.nama,
                        absenState: AbsenState.empty(),
                        latitude: currentLocationLatitude,
                        longitude: currentLocationLongitude,
                      ));

                  //
                })),

        Visibility(
            visible: isTesting ? true : isOfflineMode,
            child: VButton(
                label: 'SIMPAN ABSEN OUT',
                isEnabled: isTester.maybeWhen(
                    tester: () => true,
                    orElse: () => isTesting
                        ? isTesting
                        : nearest < minDistance && nearest != 0),
                onPressed: () async {
                  await OSVibrate.vibrate();

                  // ALAMAT GEOFENCE
                  final alamat = ref.read(geofenceProvider).nearestCoordinates;

                  // SAVE ABSEN
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .addSavedLocation(
                          savedLocation: SavedLocation.initial().copyWith(
                        idGeof: alamat.id,
                        alamat: alamat.nama,
                        absenState: AbsenState.absenIn(),
                        latitude: currentLocationLatitude,
                        longitude: currentLocationLongitude,
                      ));

                  //
                })),

        Visibility(
            visible: isTesting ? true : savedIsNotEmpty,
            child: VButton(
                label: 'ABSEN TERSIMPAN',
                onPressed: () async {
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .getSavedLocations();

                  context.pushNamed(RouteNames.absenTersimpanNameRoute);
                }))
      ],
    );
  }

  Future<void> _onBerhasilSimpanAbsen(BuildContext context) async {
    await OSVibrate.vibrate();
    await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconChecked,
              label: 'Saved',
              labelDescription:
                  'Absen tersimpan. Saat ada koneksi, buka halaman absen untung melakukan absen dengan absen tersimpan.',
            ));
  }

  Future<void> _onBerhasilAbsen(BuildContext context) async {
    ref.read(buttonResetVisibilityProvider.notifier).state = false;
    ref.read(absenOfflineModeProvider.notifier).state = false;
    await OSVibrate.vibrate();

    await ref.read(absenNotifierProvidier.notifier).getAbsenToday();

    final _time = await ref.read(networkTimeNotifierProvider.future);

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        backgroundColor: Colors.white,
        builder: (context) => Success(
              DateFormat('HH:mm').format(_time),
            ));
  }

  _onErrOther(
    AbsenFailure failure,
    BuildContext context,
  ) async {
    final String errMessage = failure.maybeWhen(
        server: (code, message) => 'Error $code $message',
        passwordExpired: () => 'Password Expired',
        passwordWrong: () => 'Password Wrong',
        orElse: () => '');

    await ref.read(errLogControllerProvider.notifier).sendLog(
          isHoting: true,
          errMessage: errMessage,
        );

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconCrossed,
              label: 'Error',
              labelDescription: failure.maybeWhen(
                  server: (code, message) => 'Error $code $message',
                  passwordExpired: () => 'Password Expired',
                  passwordWrong: () => 'Password Wrong',
                  orElse: () => ''),
            ));
  }

  _onNoConnection(
    BuildContext context,
    double currentLocationLatitude,
    double currentLocationLongitude,
  ) async {
    final absenState = ref.read(absenNotifierProvidier);
    final alamat = ref.read(geofenceProvider).nearestCoordinates;

    await ref.read(backgroundNotifierProvider.notifier).addSavedLocation(
            savedLocation: SavedLocation(
          idGeof: alamat.id,
          alamat: alamat.nama,
          date: DateTime.now(),
          dbDate: DateTime.now(),
          absenState: absenState,
          latitude: currentLocationLatitude,
          longitude: currentLocationLongitude,
        ));

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              color: Palette.red,
              asset: Assets.iconCrossed,
              label: 'NoConnection',
              labelDescription: 'Tidak ada koneksi',
            )).then((_) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconChecked,
              label: 'Saved',
              labelDescription: 'Absen tersimpan',
            )));
  }

  Future<dynamic> _absenOut({
    required DateTime currTime,
    required BuildContext context,
    required TesterState isTester,
    required double currentLocationLatitude,
    required double currentLocationLongitude,
  }) async {
    await OSVibrate.vibrate();

    String idGeof = ref.read(geofenceProvider).nearestCoordinates.id;
    String imei = ref.read(userNotifierProvider).user.imeiHp ?? '';

    String lokasi = await GeofenceUtil.getLokasiStr(
      lat: currentLocationLatitude,
      long: currentLocationLongitude,
    );

    if (imei.isEmpty) {
      return;
    }

    if (ModalRoute.of(context)?.isCurrent != true) {
      context.pop();
    }

    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VAlertDialog3(
            label:
                '\nIngin Absen Pulang ?\n\n${DateFormat('dd MMM yyyy').format(currTime)}',
            labelDescription: DateFormat('HH:mm').format(currTime),
            onPressed: () async {
              context.pop();
              return isTester.maybeWhen(
                  tester: () =>
                      ref.read(absenAuthNotifierProvidier.notifier).absen(
                            idGeof: '0',
                            imei: imei,
                            lokasi: 'NULL (APPLE REVIEW)',
                            latitude: '0',
                            longitude: '0',
                            date: currTime,
                            dbDate: currTime,
                            inOrOut: JenisAbsen.absenOut,
                          ),
                  orElse: () =>
                      ref.read(absenAuthNotifierProvidier.notifier).absen(
                            idGeof: idGeof,
                            imei: imei,
                            lokasi: lokasi,
                            latitude: '$currentLocationLatitude',
                            longitude: '$currentLocationLongitude',
                            date: currTime,
                            dbDate: currTime,
                            inOrOut: JenisAbsen.absenOut,
                          ));
            }));
  }

  Future<dynamic> _absenIn({
    required DateTime currTime,
    required BuildContext context,
    required TesterState isTester,
    required double currentLocationLatitude,
    required double currentLocationLongitude,
  }) async {
    await OSVibrate.vibrate();

    String idGeof = ref.read(geofenceProvider).nearestCoordinates.id;
    String imei = ref.read(userNotifierProvider).user.imeiHp ?? '';

    String lokasi = await GeofenceUtil.getLokasiStr(
      lat: currentLocationLatitude,
      long: currentLocationLongitude,
    );

    if (imei.isEmpty) {
      return;
    }

    if (ModalRoute.of(context)?.isCurrent != true) {
      context.pop();
    }

    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VAlertDialog3(
            label:
                '\nIngin Absen Masuk ?\n\n${DateFormat('dd MMM yyyy').format(currTime)}',
            labelDescription: DateFormat('HH:mm').format(currTime),
            onPressed: () async {
              context.pop();
              return isTester.maybeWhen(
                  tester: () =>
                      ref.read(absenAuthNotifierProvidier.notifier).absen(
                            idGeof: '0',
                            imei: imei,
                            lokasi: 'NULL (APPLE REVIEW)',
                            latitude: '0',
                            longitude: '0',
                            date: currTime,
                            dbDate: currTime,
                            inOrOut: JenisAbsen.absenIn,
                          ),
                  orElse: () =>
                      ref.read(absenAuthNotifierProvidier.notifier).absen(
                            idGeof: idGeof,
                            imei: imei,
                            lokasi: lokasi,
                            latitude: '$currentLocationLatitude',
                            longitude: '$currentLocationLongitude',
                            date: currTime,
                            dbDate: currTime,
                            inOrOut: JenisAbsen.absenIn,
                          ));
            }));
  }
}
