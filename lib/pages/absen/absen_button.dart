import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dartz/dartz.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_state.dart';
import '../../application/background/saved_location.dart';
import '../../application/routes/route_names.dart';
import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../domain/background_failure.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';

import '../../utils/string_utils.dart';
import '../widgets/v_button.dart';
import '../widgets/v_dialogs.dart';

class AbsenButton extends ConsumerStatefulWidget {
  const AbsenButton();

  @override
  ConsumerState<AbsenButton> createState() => _AbsenButtonState();
}

class _AbsenButtonState extends ConsumerState<AbsenButton> {
  @override
  Widget build(BuildContext context) {
    // LAT, LONG
    final currentLocationLatitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.latitude));
    final currentLocationLongitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.longitude));

    // GET ABSEN
    ref.listen<Option<Either<AbsenFailure, Unit>>>(
        absenAuthNotifierProvidier
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (failure) => failure.maybeWhen(
                          noConnection: () async {
                            // ALAMAT GEOFENCE
                            final alamat = ref.watch(geofenceProvider
                                .select((value) => value.nearestCoordinates));

                            // SAVE ABSEN
                            await ref
                                .read(backgroundNotifierProvider.notifier)
                                .addSavedLocation(
                                    savedLocation: SavedLocation(
                                        idGeof: alamat.id,
                                        latitude: currentLocationLatitude,
                                        longitude: currentLocationLongitude,
                                        alamat: alamat.nama,
                                        date: DateTime.now(),
                                        dbDate: DateTime.now()));

                            await showDialog(
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

                            return Future.value(true);
                          },
                          orElse: () => showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) => VSimpleDialog(
                                    asset: Assets.iconCrossed,
                                    label: 'Error',
                                    labelDescription: failure.maybeWhen(
                                        server: (code, message) =>
                                            'Error $code $message',
                                        passwordExpired: () =>
                                            'Password Expired',
                                        passwordWrong: () => 'Password Wrong',
                                        orElse: () => ''),
                                  )),
                        ), (_) async {
                  // IF SUCCESS, GET RECENT ABSEN
                  final offlineNotifier =
                      ref.read(absenOfflineModeProvider.notifier);

                  await ref
                      .read(absenNotifierProvidier.notifier)
                      .getAbsenToday();

                  final jamBerhasil = ref.read(absenPrepNotifierProvider
                      .select((value) => value.networkTime));
                  String jamBerhasilStr = StringUtils.hoursDate(jamBerhasil);

                  offlineNotifier.state = false;

                  await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                            asset: Assets.iconChecked,
                            label: 'JAM $jamBerhasilStr',
                            labelDescription: 'BERHASIL',
                          ));
                })));

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
                                empty: (_) => 'No saved found',
                                unknown: (unkn) =>
                                    '${unkn.errorCode} ${unkn.message}',
                                orElse: () => ''),
                            asset: Assets.iconCrossed,
                          ),
                        ), (_) async {
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .getSavedLocations();

                  await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                            asset: Assets.iconChecked,
                            label: 'Saved',
                            labelDescription: 'Absen tersimpan',
                          ));

                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .getSavedLocations();
                })));

    // IS OFFLINE MODE
    final isOfflineMode = ref.watch(absenOfflineModeProvider);

    // ABSEN STATE
    final absen = ref.watch(absenNotifierProvidier);

    // LAT, LONG
    final nearest = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.remainingDistance));

    // JARAK MAKSIMUM
    final minDistance = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.minDistance));

    // SAVED LOCATIONS
    final savedIsNotEmpty = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems.isNotEmpty));

    // KARYAWAN SHIFT
    final karyawanShift = ref.watch(karyawanShiftFutureProvider);

    // CURRENT NETWORK TIME
    final networkTime = ref.watch(networkTimeFutureProvider);

    return Column(
      children: [
        // Karyawan Shift
        karyawanShift.when(
            data: (isKaryawanShift) {
              final karyawanShiftStr = isKaryawanShift ? 'SHIFT' : '';

              return Column(
                children: [
                  // Absen Masuk
                  Visibility(
                    visible: !isOfflineMode,
                    child: VButton(
                        label: 'ABSEN IN $karyawanShiftStr',
                        isEnabled: isKaryawanShift &&
                                nearest < minDistance &&
                                nearest != 0 ||
                            absen == AbsenState.empty() &&
                                nearest < minDistance &&
                                nearest != 0 ||
                            absen == AbsenState.incomplete() &&
                                nearest < 100 &&
                                nearest != 0,
                        onPressed: () => showCupertinoDialog(
                            context: context,
                            builder: (_) => VAlertDialog(
                                label: 'Ingin absen-in ?',
                                labelDescription: 'JAM : ' +
                                    networkTime.when(
                                      data: (data) =>
                                          StringUtils.hoursDate(data),
                                      loading: () => '...Loading...',
                                      error: (error, stackTrace) =>
                                          '$error $stackTrace',
                                    ),
                                onPressed: () async {
                                  debugger(message: 'called');
                                  await ref
                                      .read(absenPrepNotifierProvider.notifier)
                                      .setup(
                                          lat: currentLocationLatitude,
                                          long: currentLocationLongitude);

                                  final absenPrep =
                                      ref.read(absenPrepNotifierProvider);

                                  debugger(message: 'called');

                                  await ref
                                      .read(absenAuthNotifierProvidier.notifier)
                                      .absen(
                                        idGeof: absenPrep.idGeofence,
                                        imei: absenPrep.imei,
                                        lokasi: absenPrep.lokasi,
                                        latitude: '$currentLocationLatitude',
                                        longitude: '$currentLocationLongitude',
                                        date: absenPrep.networkTime,
                                        dbDate: absenPrep.networkTime,
                                        inOrOut: JenisAbsen.absenIn,
                                      );

                                  debugger(message: 'called');

                                  context.pop();
                                }))),
                  ),

                  // Absen Keluar
                  Visibility(
                    visible: !isOfflineMode,
                    child: VButton(
                        label: 'ABSEN OUT $karyawanShiftStr',
                        isEnabled: isKaryawanShift &&
                                nearest < minDistance &&
                                nearest != 0 ||
                            absen == AbsenState.absenIn() &&
                                nearest < minDistance &&
                                nearest != 0,
                        onPressed: () => showCupertinoDialog(
                            context: context,
                            builder: (_) => VAlertDialog(
                                  label: 'Ingin absen-out ?',
                                  labelDescription: 'JAM : ' +
                                      networkTime.when(
                                        data: (data) =>
                                            StringUtils.hoursDate(data),
                                        loading: () => '...Loading...',
                                        error: (error, stackTrace) =>
                                            '$error $stackTrace',
                                      ),
                                  onPressed: () async {
                                    debugger(message: 'called');
                                    await ref
                                        .read(
                                            absenPrepNotifierProvider.notifier)
                                        .setup(
                                            lat: currentLocationLatitude,
                                            long: currentLocationLongitude);

                                    final absenPrep =
                                        ref.read(absenPrepNotifierProvider);

                                    debugger(message: 'called');

                                    await ref
                                        .read(
                                            absenAuthNotifierProvidier.notifier)
                                        .absen(
                                          idGeof: absenPrep.idGeofence,
                                          imei: absenPrep.imei,
                                          lokasi: absenPrep.lokasi,
                                          latitude: '$currentLocationLatitude',
                                          longitude:
                                              '$currentLocationLongitude',
                                          date: absenPrep.networkTime,
                                          dbDate: absenPrep.networkTime,
                                          inOrOut: JenisAbsen.absenOut,
                                        );

                                    debugger(message: 'called');

                                    context.pop();
                                  },
                                ))),
                  ),
                ],
              );
            },
            error: ((error, stackTrace) => Text('ERROR: $error $stackTrace')),
            loading: () => Container()),

        Visibility(
            visible: isOfflineMode,
            child: VButton(
                label: 'SIMPAN ABSEN',
                isEnabled: nearest < minDistance && nearest != 0,
                onPressed: () async {
                  // ALAMAT GEOFENCE
                  final alamat = ref.watch(geofenceProvider
                      .select((value) => value.nearestCoordinates));

                  // save absen
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .addSavedLocation(
                          savedLocation: SavedLocation(
                              idGeof: alamat.id,
                              latitude: currentLocationLatitude,
                              longitude: currentLocationLongitude,
                              alamat: alamat.nama,
                              date: DateTime.now(),
                              dbDate: DateTime.now()));

                  // debugger();
                })),

        Visibility(
            visible: savedIsNotEmpty,
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
}
