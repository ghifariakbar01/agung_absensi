import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/absen/absen_request.dart';
import 'package:face_net_authentication/application/absen/absen_state.dart';
import 'package:face_net_authentication/application/routes/route_names.dart';
import 'package:face_net_authentication/infrastructure/remote_response.dart';
import 'package:face_net_authentication/pages/widgets/copyright_text.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/background/saved_location.dart';
import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../style/style.dart';
import '../../utils/geofence_utils.dart';
import '../../utils/string_utils.dart';
import '../tc/tc_page.dart';
import '../widgets/v_button.dart';
import '../widgets/v_dialogs.dart';

class AbsenButton extends ConsumerWidget {
  const AbsenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // LAT, LONG
    final currentLocationLatitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.latitude));
    final currentLocationLongitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.longitude));

    final nearest = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.remainingDistance));

    // JARAK MAKSIMUM
    final minDistance = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.minDistance));

    final savedIsNotEmpty = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems.isNotEmpty));

    final isOfflineMode = ref.watch(absenOfflineModeProvider);

    // ID GEOF, IMEI field
    final idGeof =
        ref.read(geofenceProvider.select((value) => value.nearestCoordinates));
    final imei =
        ref.read(imeiAuthNotifierProvider.select((value) => value.imei));

    // GET ID
    ref.listen<RemoteResponse<AbsenRequest>>(
        absenAuthNotifierProvidier.select((value) => value.absenId),
        (_, ID) async {
      ID.when(withNewData: (IDResponse) async {
        final absenAuthNotifier = ref.read(absenAuthNotifierProvidier.notifier);

        final lokasi = await getLokasi(
            latitude: currentLocationLatitude,
            longitude: currentLocationLongitude);

        final lokasiString =
            '${lokasi?.street}, ${lokasi?.locality}, ${lokasi?.administrativeArea}. ${lokasi?.postalCode}';

        IDResponse.maybeWhen(
            // ABSEN IN
            absenIn: (IDWhen) async => await absenAuthNotifier.absen(
                  idAbsenMnl: '${IDWhen + 1}',
                  lokasi: lokasiString,
                  latitude: currentLocationLatitude.toString(),
                  longitude: currentLocationLongitude.toString(),
                  idGeof: idGeof.id.toString(),
                  imei: imei,
                  date: DateTime.now(),
                  inOrOut: JenisAbsen.absenIn,
                ),
            // ABSEN OUT
            absenOut: (IDWhen) async => await absenAuthNotifier.absen(
                  idAbsenMnl: '${IDWhen + 1}',
                  lokasi: lokasiString,
                  latitude: currentLocationLatitude.toString(),
                  longitude: currentLocationLongitude.toString(),
                  idGeof: idGeof.id.toString(),
                  imei: imei,
                  date: DateTime.now(),
                  inOrOut: JenisAbsen.absenOut,
                ),
            orElse: () {});
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
                  // IF SUCCESS, GET RECENT ABSEN
                  final offlineNotifier =
                      ref.read(absenOfflineModeProvider.notifier);

                  await ref.read(absenNotifierProvidier.notifier).getAbsen(
                        date: DateTime.now(),
                        onAbsen: (absenSTATE) {
                          ref
                              .read(absenNotifierProvidier.notifier)
                              .changeAbsen(absenSTATE);

                          offlineNotifier.state = false;
                        },
                        onNoConnection: () => offlineNotifier.state = true,
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

    final absen = ref.watch(absenNotifierProvidier);
    log('absen $absen');

    final karyawanShift = ref.watch(karyawanShiftProvider);

    return Column(
      children: [
        // Karyawan Shift
        Visibility(
          visible: !isOfflineMode,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 38.0,
                  width: 38.0,
                  child: Checkbox(
                      key: UniqueKey(),
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: karyawanShift,
                      onChanged: (_) => karyawanShift
                          ? ref.read(karyawanShiftProvider.notifier).state =
                              false
                          : ref.read(karyawanShiftProvider.notifier).state =
                              true),
                ),
                SizedBox(
                  width: 4,
                ),
                Text('Karyawan Shift',
                    style: Themes.customColor(
                        FontWeight.bold, 13, Palette.primaryColor))
              ],
            ),
          ),
        ),

        // Absen Masuk
        Visibility(
          visible: !isOfflineMode,
          child: VButton(
              label: 'ABSEN IN',
              isEnabled:
                  karyawanShift && nearest < minDistance && nearest != 0 ||
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
                      labelDescription:
                          'JAM: ${StringUtils.hoursDate(DateTime.now())}',
                      onPressed: () async {
                        context.pop();

                        debugger(message: 'called');

                        await ref
                            .read(absenAuthNotifierProvidier.notifier)
                            .absenAndUpdate(jenisAbsen: JenisAbsen.absenIn);
                      }))),
        ),

        // Absen Keluar
        Visibility(
          visible: !isOfflineMode,
          child: VButton(
              label: 'ABSEN OUT',
              isEnabled:
                  karyawanShift && nearest < minDistance && nearest != 0 ||
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
                              .absenAndUpdate(jenisAbsen: JenisAbsen.absenOut);
                        },
                      ))),
        ),

        Visibility(
            visible: isOfflineMode && nearest < minDistance && nearest != 0,
            child: VButton(
                label: 'SIMPAN ABSEN',
                onPressed: () async {
                  // ALAMAT GEOFENCE
                  final alamat = ref.watch(geofenceProvider
                      .select((value) => value.nearestCoordinates));

                  // save absen
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .addSavedLocation(
                          savedLocation: SavedLocation(
                              latitude: currentLocationLatitude,
                              longitude: currentLocationLongitude,
                              alamat: alamat.nama,
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
