import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_state.dart';
import '../../application/background/saved_location.dart';
import '../../application/routes/route_names.dart';
import '../../shared/providers.dart';
import '../../utils/string_utils.dart';
import '../widgets/v_button.dart';
import '../widgets/v_dialogs.dart';

class AbsenButton extends ConsumerStatefulWidget {
  const AbsenButton({Key? key}) : super(key: key);

  @override
  ConsumerState<AbsenButton> createState() => _AbsenButtonState();
}

class _AbsenButtonState extends ConsumerState<AbsenButton> {
  bool? karyawanShift;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      karyawanShift = await ref
          .read(isKarwayanShiftNotifierProvider.notifier)
          .isKaryawanShift();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOfflineMode = ref.watch(absenOfflineModeProvider);

    // ABSEN STATE
    final absen = ref.watch(absenNotifierProvidier);

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

    // SAVED LOCATIONS
    final savedIsNotEmpty = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems.isNotEmpty));

    // KARYAWAN SHIFT
    final karyawanShiftStr =
        karyawanShift != null && karyawanShift == true ? 'SHIFT' : '';

    final isKaryawanShift = karyawanShift != null && karyawanShift == true;

    // CURRENT NETWORK TIME
    final networkTime = ref.watch(networkTimeFutureProvider);

    return Column(
      children: [
        // Absen Masuk
        Visibility(
          visible: !isOfflineMode,
          child: VButton(
              label: 'ABSEN IN $karyawanShiftStr',
              isEnabled:
                  isKaryawanShift && nearest < minDistance && nearest != 0 ||
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
                            data: (data) => StringUtils.hoursDate(data),
                            loading: () => '...Loading...',
                            error: (error, stackTrace) => '$error $stackTrace',
                          ),
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
              label: 'ABSEN OUT $karyawanShiftStr',
              isEnabled:
                  isKaryawanShift && nearest < minDistance && nearest != 0 ||
                      absen == AbsenState.absenIn() &&
                          nearest < minDistance &&
                          nearest != 0,
              onPressed: () => showCupertinoDialog(
                  context: context,
                  builder: (_) => VAlertDialog(
                        label: 'Ingin absen-out ?',
                        labelDescription: 'JAM : ' +
                            networkTime.when(
                              data: (data) => StringUtils.hoursDate(data),
                              loading: () => '...Loading...',
                              error: (error, stackTrace) =>
                                  '$error $stackTrace',
                            ),
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
                              date: DateTime.now(),
                              dbDate: DateTime.now()));

                  debugger();
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
