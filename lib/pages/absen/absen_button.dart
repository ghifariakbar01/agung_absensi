import 'dart:developer';

import 'package:face_net_authentication/application/tester/tester_state.dart';
import 'package:face_net_authentication/pages/absen/absen_reset.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dartz/dartz.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_state.dart';
import '../../application/background/saved_location.dart';
import '../../application/network_state/network_state_notifier.dart';
import '../../application/routes/route_names.dart';
import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../domain/background_failure.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';

import '../../utils/geofence_utils.dart';
import '../../utils/string_utils.dart';
import '../widgets/v_button.dart';
import '../widgets/v_dialogs.dart';

// final buttonInProvider = StateProvider<bool>((ref) {
//   return false;
// });

// final buttonOutProvider = StateProvider<bool>((ref) {
//   return false;
// });

final buttonResetVisibilityProvider = StateProvider<bool>((ref) {
  return false;
});

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

    final buttonResetVisibility = ref.watch(buttonResetVisibilityProvider);

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

                  // RESET RESET BUTTON
                  ref.read(buttonResetVisibilityProvider.notifier).state =
                      false;
                  // ref.read(buttonInProvider.notifier).state = false;
                  // ref.read(buttonOutProvider.notifier).state = false;

                  await ref
                      .read(absenNotifierProvidier.notifier)
                      .getAbsenToday();

                  final jamBerhasil =
                      await ref.refresh(networkTimeFutureProvider.future);
                  String jamBerhasilStr = StringUtils.hoursDate(jamBerhasil);

                  offlineNotifier.state = false;

                  await HapticFeedback.vibrate();

                  await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                            asset: Assets.iconChecked,
                            label: 'JAM $jamBerhasilStr',
                            labelDescription: 'BERHASIL',
                          )).then((_) =>
                      context.pushNamed(RouteNames.riwayatAbsenNameRoute));
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

                  await HapticFeedback.vibrate();

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

    // ABSEN STATE
    final absen = ref.watch(absenNotifierProvidier);

    // IS TESTER
    final isTester = ref.watch(testerNotifierProvider);

    // IS OFFLINE MODE
    final isOfflineMode = ref.watch(absenOfflineModeProvider);

    // KARYAWAN SHIFT
    final karyawanShift = ref.watch(karyawanShiftFutureProvider);

    // LAT, LONG
    final nearest = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.remainingDistance));

    // JARAK MAKSIMUM
    final minDistance = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.minDistance));

    // SAVED LOCATIONS
    final savedIsNotEmpty = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems.isNotEmpty));

    // NETWORK
    final network = ref.watch(networkStateNotifierProvider);

    // RESET ABSEN
    // final buttonIn = ref.watch(buttonInProvider);
    // final buttonOut = ref.watch(buttonOutProvider);

    return Column(
      children: [
        // Load Karyawan Shift
        karyawanShift.when(
            data: (isKaryawanShift) {
              final String karyawanShiftStr = isKaryawanShift ? 'SHIFT' : '';

              return Column(
                children: [
                  // Toggle Absen Ulang
                  AbsenReset(),

                  Visibility(
                    visible: true,
                    child: VButton(
                        label: 'ABSEN IN $karyawanShiftStr',
                        isEnabled: true,

                        //  network.when(
                        //     online: () => isTester.maybeWhen(
                        //         tester: () =>
                        //             buttonResetVisibility ||
                        //             isKaryawanShift ||
                        //             absen == AbsenState.empty() ||
                        //             absen == AbsenState.incomplete(),
                        //         orElse: () =>
                        //             buttonResetVisibility ||
                        //             isKaryawanShift &&
                        //                 nearest < minDistance &&
                        //                 nearest != 0 ||
                        //             absen == AbsenState.empty() &&
                        //                 nearest < minDistance &&
                        //                 nearest != 0 ||
                        //             absen == AbsenState.incomplete() &&
                        //                 nearest < 100 &&
                        //                 nearest != 0),
                        //     offline: () => false),

                        onPressed: () => _absenIn(
                            context: context,
                            isTester: isTester,
                            currentLocationLatitude: currentLocationLatitude,
                            currentLocationLongitude: currentLocationLongitude
                            //
                            )),
                  ),
                  Visibility(
                    visible: true,
                    child: VButton(
                        label: 'ABSEN OUT $karyawanShiftStr',
                        isEnabled: true,

                        // network.when(
                        //     online: () => isTester.maybeWhen(
                        //         tester: () =>
                        //             buttonResetVisibility ||
                        //             isKaryawanShift ||
                        //             absen == AbsenState.absenIn(),
                        //         orElse: () =>
                        //             buttonResetVisibility ||
                        //             isKaryawanShift &&
                        //                 nearest < minDistance &&
                        //                 nearest != 0 ||
                        //             absen == AbsenState.absenIn() &&
                        //                 nearest < minDistance &&
                        //                 nearest != 0),
                        //     offline: () => false),
                        onPressed: () => _absenOut(
                            context: context,
                            isTester: isTester,
                            currentLocationLatitude: currentLocationLatitude,
                            currentLocationLongitude: currentLocationLongitude
                            //
                            )),
                  ),
                ],
              );
            },
            error: ((error, stackTrace) =>
                Text('Error: $error \n StackTrace: $stackTrace')),
            loading: () => Container()),

        Visibility(
            visible: true,
            child: VButton(
                label: 'SIMPAN ABSEN',
                isEnabled: isTester.maybeWhen(
                    tester: () => true,
                    orElse: () => nearest < minDistance && nearest != 0),
                onPressed: () async {
                  await HapticFeedback.vibrate();

                  // ALAMAT GEOFENCE
                  final alamat = ref.watch(geofenceProvider
                      .select((value) => value.nearestCoordinates));

                  // SAVE ABSEN
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .addSavedLocation(
                          savedLocation: SavedLocation(
                        idGeof: alamat.id,
                        alamat: alamat.nama,
                        date: DateTime.now(),
                        dbDate: DateTime.now(),
                        latitude: currentLocationLatitude,
                        longitude: currentLocationLongitude,
                      ));

                  // debugger();
                })),

        Visibility(
            visible: true,
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

  // Functions
  Future<dynamic> _absenOut({
    required BuildContext context,
    required TesterState isTester,
    required double currentLocationLatitude,
    required double currentLocationLongitude,
  }) async {
    {
      await HapticFeedback.vibrate();

      DateTime refreshed = await ref.refresh(networkTimeFutureProvider.future);
      String idGeof = ref.read(
          geofenceProvider.select((value) => value.nearestCoordinates.id));
      String imei =
          ref.read(imeiNotifierProvider.select((value) => value.imei));
      String lokasi = await GeofenceUtil.getLokasiStr(
          lat: currentLocationLatitude, long: currentLocationLongitude);

      if (imei.isEmpty) {
        return;
      }

      return await showCupertinoDialog(
          context: context,
          builder: (_) => VAlertDialog(
              label: 'Ingin absen-out ?',
              labelDescription: 'JAM : ' + StringUtils.hoursDate(refreshed),
              onPressed: () async {
                debugger(message: 'called');

                await isTester.maybeWhen(
                    tester: () =>
                        ref.read(absenAuthNotifierProvidier.notifier).absen(
                              idGeof: '0',
                              imei: imei,
                              lokasi: 'NULL (APPLE REVIEW)',
                              latitude: '0',
                              longitude: '0',
                              date: refreshed,
                              dbDate: refreshed,
                              inOrOut: JenisAbsen.absenOut,
                            ),
                    orElse: () =>
                        ref.read(absenAuthNotifierProvidier.notifier).absen(
                              idGeof: idGeof,
                              imei: imei,
                              lokasi: lokasi,
                              latitude: '$currentLocationLatitude',
                              longitude: '$currentLocationLongitude',
                              date: refreshed,
                              dbDate: refreshed,
                              inOrOut: JenisAbsen.absenOut,
                            ));

                debugger(message: 'called');

                context.pop();
              }));
    }
  }

  Future<dynamic> _absenIn({
    required BuildContext context,
    required TesterState isTester,
    required double currentLocationLatitude,
    required double currentLocationLongitude,
  }) async {
    {
      await HapticFeedback.vibrate();

      DateTime refreshed = await ref.refresh(networkTimeFutureProvider.future);
      String idGeof = ref.read(
          geofenceProvider.select((value) => value.nearestCoordinates.id));
      String imei =
          ref.read(imeiNotifierProvider.select((value) => value.imei));
      String lokasi = await GeofenceUtil.getLokasiStr(
          lat: currentLocationLatitude, long: currentLocationLongitude);

      // if (imei.isEmpty) {
      //   return;
      // }

      return await showCupertinoDialog(
          context: context,
          builder: (_) => VAlertDialog(
              label: 'Ingin absen-in ?',
              labelDescription: 'JAM : ' + StringUtils.hoursDate(refreshed),
              onPressed: () async {
                debugger(message: 'called');

                await isTester.maybeWhen(
                    tester: () =>
                        ref.read(absenAuthNotifierProvidier.notifier).absen(
                              idGeof: '0',
                              imei: imei,
                              lokasi: 'NULL (APPLE REVIEW)',
                              latitude: '0',
                              longitude: '0',
                              date: refreshed,
                              dbDate: refreshed,
                              inOrOut: JenisAbsen.absenIn,
                            ),
                    orElse: () =>
                        ref.read(absenAuthNotifierProvidier.notifier).absen(
                              idGeof: idGeof,
                              imei: imei,
                              lokasi: lokasi,
                              latitude: '$currentLocationLatitude',
                              longitude: '$currentLocationLongitude',
                              date: refreshed,
                              dbDate: refreshed,
                              inOrOut: JenisAbsen.absenIn,
                            ));

                debugger(message: 'called');

                context.pop();
              }));
    }
  }
}
