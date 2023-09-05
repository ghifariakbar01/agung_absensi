import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dartz/dartz.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_request.dart';
import '../../application/background/saved_location.dart';
import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../domain/background_failure.dart';
import '../../infrastructure/remote_response.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';

import '../../utils/geofence_utils.dart';
import '../../utils/string_utils.dart';
import '../widgets/v_dialogs.dart';
import 'absen_button.dart';

class AbsenButtonPage extends ConsumerWidget {
  const AbsenButtonPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // LAT, LONG
    final currentLocationLatitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.latitude));
    final currentLocationLongitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.longitude));

    // ID GEOF, IMEI field
    final idGeof =
        ref.read(geofenceProvider.select((value) => value.nearestCoordinates));
    final imei =
        ref.read(imeiAuthNotifierProvider.select((value) => value.imei));

    // GET ID
    ref.listen<RemoteResponse<AbsenRequest>>(
        absenAuthNotifierProvidier.select((value) => value.absenId),
        (_, id) async {
      id.when(withNewData: (response) async {
        final absenAuthNotifier = ref.read(absenAuthNotifierProvidier.notifier);

        final lokasi = await GeofenceUtil.getLokasi(
            latitude: currentLocationLatitude,
            longitude: currentLocationLongitude);

        final lokasiString =
            '${lokasi?.street}, ${lokasi?.locality}, ${lokasi?.administrativeArea}. ${lokasi?.postalCode}';

        ref.invalidate(networkTimeFutureProvider);

        final networkTime = ref.read(networkTimeFutureProvider);

        networkTime.whenData((time) => response.when(
            // ABSEN IN
            absenIn: (id) async => await absenAuthNotifier.absen(
                  idAbsenMnl: '${id + 1}',
                  lokasi: lokasiString,
                  latitude: currentLocationLatitude.toString(),
                  longitude: currentLocationLongitude.toString(),
                  idGeof: idGeof.id.toString(),
                  imei: imei,
                  date: time,
                  dbDate: time,
                  inOrOut: JenisAbsen.absenIn,
                ),
            // ABSEN OUT
            absenOut: (id) async => await absenAuthNotifier.absen(
                  idAbsenMnl: '${id + 1}',
                  lokasi: lokasiString,
                  latitude: currentLocationLatitude.toString(),
                  longitude: currentLocationLongitude.toString(),
                  idGeof: idGeof.id.toString(),
                  imei: imei,
                  date: time,
                  dbDate: time,
                  inOrOut: JenisAbsen.absenOut,
                ),
            absenUnknown: () {}));
      }, failure: (errorCode, message) async {
        if (errorCode == 500) {
          // NO CONNECTION

          // ALAMAT GEOFENCE
          final alamat = ref.watch(
              geofenceProvider.select((value) => value.nearestCoordinates));

          // SAVE ABSEN
          await ref.read(backgroundNotifierProvider.notifier).addSavedLocation(
              savedLocation: SavedLocation(
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
        } else {
          await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => VSimpleDialog(
                    asset: Assets.iconCrossed,
                    label: '$errorCode',
                    labelDescription: '$message',
                  ));
        }
      });
    });

    // GET ABSEN
    ref.listen<Option<Either<AbsenFailure, Unit>>>(
        absenAuthNotifierProvidier
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (failure) => failure.when(
                          server: (code, message) => showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) => VSimpleDialog(
                                    asset: Assets.iconCrossed,
                                    label: '$code',
                                    labelDescription: '$message',
                                  )),
                          passwordExpired: () => ref
                              .read(passwordExpiredNotifierProvider.notifier)
                              .savePasswordExpired(),
                          noConnection: () async {
                            // ALAMAT GEOFENCE
                            final alamat = ref.watch(geofenceProvider
                                .select((value) => value.nearestCoordinates));

                            // SAVE ABSEN
                            await ref
                                .read(backgroundNotifierProvider.notifier)
                                .addSavedLocation(
                                    savedLocation: SavedLocation(
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
                        ), (_) async {
                  // IF SUCCESS, GET RECENT ABSEN
                  final offlineNotifier =
                      ref.read(absenOfflineModeProvider.notifier);

                  await ref.read(absenNotifierProvidier.notifier).getAbsen(
                        date: DateTime.now(),
                      );

                  offlineNotifier.state = false;

                  await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                            asset: Assets.iconChecked,
                            label:
                                'JAM ${StringUtils.hoursDate(DateTime.now())}',
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
                })));

    return Stack(
      children: [
        AbsenButton(),
      ],
    );
  }
}
