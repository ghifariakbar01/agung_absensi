import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/absen/absen_state.dart';
import 'package:face_net_authentication/application/routes/route_names.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/absen/absen_request.dart';
import '../../application/background_service/saved_location.dart';
import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../infrastructure/remote_response.dart';
import '../../style/style.dart';
import '../../utils/geofence_utils.dart';
import '../../utils/string_utils.dart';
import '../widgets/v_button.dart';
import '../widgets/v_dialogs.dart';
import 'absen_background.dart';

class AbsenButton extends ConsumerWidget {
  const AbsenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocationLatitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.latitude));
    final currentLocationLongitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.longitude));

    final absen = ref.watch(absenNotifierProvidier);
    final nearest = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.remainingDistance));

    final minDistance = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.minDistance));

    final savedIsNotEmpty = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems.isNotEmpty));

    final isOfflineMode = ref.watch(absenOfflineModeProvider);

    ref.listen<RemoteResponse<AbsenRequest>>(
        absenAuthNotifierProvidier.select((value) => value.absenId),
        (__, absenAuth) {
      absenAuth.map(withNewData: (id) async {
        log('data $id');

        final lokasi = await getLokasi(
            latitude: currentLocationLatitude,
            longitude: currentLocationLongitude);

        id.when(
          withNewData: (absenRequest) => absenRequest.when(
              absenIn: (id) async => await ref
                  .read(absenAuthNotifierProvidier.notifier)
                  .absen(
                      idAbsenMnl: '${id + 1}',
                      lokasi:
                          '${lokasi?.street}, ${lokasi?.subAdministrativeArea}, ${lokasi?.postalCode}.',
                      date: DateTime.now(),
                      latitude: '$currentLocationLatitude',
                      longitude: '$currentLocationLongitude',
                      inOrOut: JenisAbsen.absenIn),
              absenOut: (id) async => await ref
                  .read(absenAuthNotifierProvidier.notifier)
                  .absen(
                      idAbsenMnl: '${id + 1}',
                      lokasi:
                          '${lokasi?.street}, ${lokasi?.subAdministrativeArea}, ${lokasi?.postalCode}.',
                      date: DateTime.now(),
                      latitude: '$currentLocationLatitude',
                      longitude: '$currentLocationLongitude',
                      inOrOut: JenisAbsen.absenOut),
              absenUnknown: () {}),
          failure: (_, __) => {},
        );

        debugger(message: 'called');

        await ref.read(absenNotifierProvidier.notifier).getAbsen(
            date: DateTime.now(),
            onAbsen: (absen) async {
              ref.read(absenNotifierProvidier.notifier).changeAbsen(absen);

              ref.read(absenOfflineModeProvider.notifier).state = false;
            },
            onNoConnection: () =>
                ref.read(absenOfflineModeProvider.notifier).state = true);
      }, failure: (failure) async {
        // no connection
        if (failure.errorCode == 500) {
          debugger(message: 'called');

          final absen = SavedLocation(
              latitude: currentLocationLatitude,
              longitude: currentLocationLongitude,
              alamat: 'N/A',
              date: DateTime.now());

          // save absen
          await ref
              .read(backgroundNotifierProvider.notifier)
              .addSavedLocation(savedLocation: absen);

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

          await ref
              .read(backgroundNotifierProvider.notifier)
              .getSavedLocations();
          await ref
              .read(geofenceProvider.notifier)
              .getGeofenceListFromStorage();
        }
      });
    });

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
                          noConnection: () async {
                            debugger(message: 'called');

                            final alamat = 'N/A';

                            // save absen
                            await ref
                                .read(backgroundNotifierProvider.notifier)
                                .addSavedLocation(
                                    savedLocation: SavedLocation(
                                        latitude: currentLocationLatitude,
                                        longitude: currentLocationLongitude,
                                        alamat: alamat,
                                        date: DateTime.now()));

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
                  await ref.read(absenNotifierProvidier.notifier).getAbsen(
                        date: DateTime.now(),
                        onAbsen: (absen) {
                          debugger(message: 'called');

                          ref
                              .read(absenNotifierProvidier.notifier)
                              .changeAbsen(absen);

                          ref.read(absenOfflineModeProvider.notifier).state =
                              false;
                        },
                        onNoConnection: () => ref
                            .read(absenOfflineModeProvider.notifier)
                            .state = true,
                      );

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

    log('absen $absen');

    return Stack(
      children: [
        AbsenBackground(),
        Column(
          children: [
            // Absen Masuk
            Visibility(
              visible: !isOfflineMode,
              child: VButton(
                  label: 'ABSEN IN',
                  isEnabled: absen == AbsenState.empty() &&
                          nearest < minDistance &&
                          nearest != 0 ||
                      absen == AbsenState.incomplete() &&
                          nearest < 100 &&
                          nearest != 0,
                  onPressed: () => showCupertinoDialog(
                      context: context,
                      builder: (_) => VAlertDialog(
                          label: 'Ingin absen-in ?',
                          labelDescription:
                              'JAM: ${StringUtils.hoursDate(DateTime.now())}',
                          onPressed: () async {
                            context.pop();

                            debugger(message: 'called');

                            await ref
                                .read(absenAuthNotifierProvidier.notifier)
                                .absenAndUpdate(JenisAbsen.absenIn);
                          }))),
            ),

            // Absen Keluar
            Visibility(
              visible: !isOfflineMode,
              child: VButton(
                  label: 'ABSEN OUT',
                  isEnabled: absen == AbsenState.empty() &&
                          nearest < minDistance &&
                          nearest != 0 ||
                      absen == AbsenState.incomplete() &&
                          nearest < minDistance &&
                          nearest != 0 ||
                      absen == AbsenState.absenIn() &&
                          nearest < minDistance &&
                          nearest != 0,
                  onPressed: () => showCupertinoDialog(
                      context: context,
                      builder: (_) => VAlertDialog(
                            label: 'Ingin absen-out ?',
                            labelDescription:
                                'JAM: ${StringUtils.hoursDate(DateTime.now())}',
                            onPressed: () async {
                              context.pop();

                              await ref
                                  .read(absenAuthNotifierProvidier.notifier)
                                  .absenAndUpdate(JenisAbsen.absenOut);
                            },
                          ))),
            ),

            Visibility(
                visible: isOfflineMode && nearest < minDistance && nearest != 0,
                child: VButton(
                    label: 'SIMPAN ABSEN',
                    onPressed: () async {
                      // save absen
                      await ref
                          .read(backgroundNotifierProvider.notifier)
                          .addSavedLocation(
                              savedLocation: SavedLocation(
                                  latitude: currentLocationLatitude,
                                  longitude: currentLocationLongitude,
                                  alamat: 'N/A',
                                  date: DateTime.now()));

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
        ),
      ],
    );
  }

  Future<Placemark?> getLokasi({
    required double? latitude,
    required double? longitude,
  }) async {
    Placemark? lokasi =
        await getAddressFromCoordinates(latitude ?? 0, longitude ?? 0);

    if (lokasi == null) {
      lokasi = Placemark(
          street: 'LOCATION UKNOWN', subAdministrativeArea: '', postalCode: '');
    }

    return lokasi;
  }
}
