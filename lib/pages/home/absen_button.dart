import 'dart:developer';

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

    ref.listen<RemoteResponse<AbsenRequest>>(
        absenAuthNotifierProvidier.select((value) => value.absenId),
        (__, absenAuth) {
      absenAuth.map(withNewData: (data) {
        log('data $data');

        debugger(message: 'called');
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
              builder: (_) => VSimpleDialog(
                    color: Palette.red,
                    asset: Assets.iconCrossed,
                    label: 'NoConnection',
                    labelDescription: 'Tidak ada koneksi',
                  )).then((_) => showDialog(
              context: context,
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

    final absen = ref.watch(absenNotifierProvidier);
    final nearest = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.remainingDistance));

    final minDistance = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.minDistance));

    final savedIsNotEmpty = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems.isNotEmpty));

    final recentIsNotEmpty = ref.watch(autoAbsenNotifierProvider
        .select((value) => value.recentAbsens.isNotEmpty));

    final isOfflineMode = ref.watch(absenOfflineModeProvider);

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

                      await showDialog(
                          context: context,
                          builder: (_) => VSimpleDialog(
                                asset: Assets.iconChecked,
                                label: 'Saved',
                                labelDescription: 'Absen tersimpan',
                              ));
                    })),

            // Visibility(
            //     visible: recentIsNotEmpty,
            //     child: VButton(
            //         label: 'ABSEN LOG',
            //         onPressed: () =>
            //             context.pushNamed(RouteNames.absenLogNameRoute))),

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
