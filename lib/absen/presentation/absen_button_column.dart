import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../background/application/saved_location.dart';
import '../../routes/application/route_names.dart';
import '../../shared/providers.dart';
import '../../widgets/v_button.dart';
import '../application/absen_helper.dart';

import '../application/absen_state.dart';
import 'absen_button.dart';
import 'absen_reset.dart';

const bool isTesting = false;

class AbsenButtonColumn extends ConsumerWidget {
  const AbsenButtonColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ABSEN STATE
    final absen = ref.watch(absenNotifierProvidier);

    // IS TESTER
    final isTester = ref.watch(testerNotifierProvider);

    // KARYAWAN SHIFT
    final karyawanAsync = ref.watch(karyawanShiftFutureProvider);

    // SAVED LOCATIONS
    final savedIsNotEmpty = ref.watch(
      backgroundNotifierProvider
          .select((value) => value.savedBackgroundItems.isNotEmpty),
    );

    // LAT, LONG
    final nearest = ref.watch(
      geofenceProvider
          .select((value) => value.nearestCoordinates.remainingDistance),
    );

    // JARAK MAKSIMUM
    final minDistance = ref.watch(
      geofenceProvider.select((value) => value.nearestCoordinates.minDistance),
    );

    final buttonResetVisibility = ref.watch(buttonResetVisibilityProvider);

    return Column(
      children: [
        karyawanAsync.when(
          loading: () => Container(),
          error: (error, stackTrace) {
            return Text('Error: $error \n StackTrace: $stackTrace');
          },
          data: (isShift) {
            final String karyawanShiftStr = isShift ? 'SHIFT' : '';

            return Column(
              children: [
                AbsenReset(
                    isTester: isTester.maybeWhen(
                  tester: () => true,
                  orElse: () => false,
                )),
                SizedBox(height: 20),
                VButton(
                  label: 'ABSEN IN $karyawanShiftStr',
                  height: 50,
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
                                  nearest < minDistance &&
                                  nearest != 0),
                  onPressed: () async {
                    final geof = ref.read(geofenceProvider).currentLocation;
                    final lat = geof.latitude;
                    final long = geof.longitude;
                    final nearest =
                        ref.read(geofenceProvider).nearestCoordinates;

                    String idGeof = nearest.id;
                    String lokasi = nearest.nama;

                    return ref
                        .read(backgroundNotifierProvider.notifier)
                        .addSavedLocation(
                            savedLocation: SavedLocation.initial().copyWith(
                          idGeof: idGeof,
                          alamat: lokasi,
                          latitude: lat,
                          longitude: long,
                          absenState: AbsenState.empty(),
                        ));
                  },
                ),
                VButton(
                    label: 'ABSEN OUT $karyawanShiftStr',
                    height: 50,
                    isEnabled: isTesting
                        ? true
                        : isTester.maybeWhen(
                            tester: () =>
                                buttonResetVisibility ||
                                isShift ||
                                absen == AbsenState.absenIn() ||
                                absen == AbsenState.incomplete(),
                            orElse: () =>
                                buttonResetVisibility ||
                                isShift &&
                                    nearest < minDistance &&
                                    nearest != 0 ||
                                absen == AbsenState.absenIn() &&
                                    nearest < minDistance &&
                                    nearest != 0 ||
                                absen == AbsenState.incomplete() &&
                                    nearest < minDistance &&
                                    nearest != 0),
                    onPressed: () async {
                      final geof = ref.read(geofenceProvider).currentLocation;
                      final lat = geof.latitude;
                      final long = geof.longitude;
                      final nearest =
                          ref.read(geofenceProvider).nearestCoordinates;

                      String idGeof = nearest.id;
                      String lokasi = nearest.nama;

                      return ref
                          .read(backgroundNotifierProvider.notifier)
                          .addSavedLocation(
                              savedLocation: SavedLocation.initial().copyWith(
                            idGeof: idGeof,
                            alamat: lokasi,
                            latitude: lat,
                            longitude: long,
                            absenState: AbsenState.absenIn(),
                          ));
                    }),
              ],
            );
          },
        ),
        Visibility(
            visible: false,
            child: VButton(
                label: 'ABSEN SAVE (DEBUG)',
                height: 50,
                onPressed: () async {
                  final geof = ref.read(geofenceProvider).currentLocation;
                  final lat = geof.latitude;
                  final long = geof.longitude;
                  final nearest = ref.read(geofenceProvider).nearestCoordinates;

                  String idGeof = nearest.id;
                  String lokasi = nearest.nama;

                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .addSavedLocationDev(
                          savedLocation: SavedLocation.initial().copyWith(
                        idGeof: idGeof,
                        alamat: lokasi,
                        latitude: lat,
                        longitude: long,
                        date: DateTime.now().add(Duration(days: 1)),
                        dbDate: DateTime.now().add(Duration(days: 1)),
                        absenState: AbsenState.empty(),
                      ));

                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .addSavedLocationDev(
                          savedLocation: SavedLocation.initial().copyWith(
                        idGeof: idGeof,
                        alamat: lokasi,
                        latitude: lat,
                        longitude: long,
                        date: DateTime.now().add(Duration(days: 1)),
                        dbDate: DateTime.now().add(Duration(days: 1)),
                        absenState: AbsenState.absenIn(),
                      ));

                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .addSavedLocationDev(
                          savedLocation: SavedLocation.initial().copyWith(
                        idGeof: idGeof,
                        alamat: lokasi,
                        latitude: lat,
                        longitude: long,
                        date: DateTime.now().add(Duration(days: 2)),
                        dbDate: DateTime.now().add(Duration(days: 2)),
                        absenState: AbsenState.empty(),
                      ));

                  await ref.read(backgroundNotifierProvider.notifier)
                    ..getSavedLocations();
                })),
        Visibility(
            visible: isTesting ? true : savedIsNotEmpty,
            child: VButton(
                label: 'ABSEN TERSIMPAN',
                height: 50,
                onPressed: () async {
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .getSavedLocations();

                  context.pushNamed(RouteNames.absenTersimpanNameRoute);
                })),
        Visibility(
            visible: isTesting ? true : savedIsNotEmpty,
            child: VButton(
                label: 'JALANKAN ABSEN YANG TERSIMPAN',
                height: 50,
                onPressed: () async {
                  final isTester = ref.read(testerNotifierProvider);

                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .executeLocation(
                        context: context,
                        isTester: isTester,
                        absen: ({required location}) {
                          final user = ref.read(userNotifierProvider).user;

                          final nama = user.nama ?? '-';
                          final imei = user.imeiHp ?? '-';
                          final idUser = user.idUser ?? 0;
                          final isTester = ref.read(testerNotifierProvider);

                          return AbsenHelper(ref).absen(
                            idUser: idUser,
                            nama: nama,
                            imei: imei,
                            context: context,
                            absenList: location,
                            isTester: isTester,
                          );
                        },
                      );
                }))
      ],
    );
  }
}
