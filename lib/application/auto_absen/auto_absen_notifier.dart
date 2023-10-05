import 'dart:developer';

import 'auto_absen_state.dart';
import '../absen/absen_enum.dart';
import '../absen/absen_state.dart';
import '../../constants/assets.dart';
import '../../shared/providers.dart';
import '../../utils/string_utils.dart';
import 'package:flutter/material.dart';
import '../background/saved_location.dart';
import 'package:go_router/go_router.dart';
import '../../pages/widgets/v_dialogs.dart';
import '../background/background_item_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:face_net_authentication/style/style.dart';

class AutoAbsenNotifier extends StateNotifier<AutoAbsenState> {
  AutoAbsenNotifier(this.ref) : super(AutoAbsenState.initial());

  StateNotifierProviderRef<AutoAbsenNotifier, AutoAbsenState> ref;

  Future<void> processAutoAbsen({
    required String imei,
    required BuildContext buildContext,
    required Map<String, List<BackgroundItemState>> autoAbsenMap,
    required List<Geofence> geofence,
    required List<BackgroundItemState> savedItems,
  }) async {
    //

    final list = autoAbsenMap.values;

    if (list.isNotEmpty) {
      int startIndex = 0;

      list.forEach((absensInDate) async {
        /// check if absen [AbsenState.empty()], [AbsenState.absenIn()] or [AbsenState.complete()]
        debugger(message: 'called');

        if (absensInDate.isNotEmpty) {
          debugger(message: 'called');

          void incrementIndex() => startIndex = startIndex + 1;

          while (startIndex + 1 <= absensInDate.length) {
            // ID GEOF, IMEI field
            final absenSaved = absensInDate[startIndex];
            final idGeofSaved = absenSaved.savedLocations.idGeof;
            final date = absenSaved.savedLocations.date;

            await getAbsenState(date: date);

            // GET RECENT ABSEN STATE
            final absenState = ref.read(absenNotifierProvidier.notifier).state;

            log('absenState $absenState');

            final belumAbsen = absenState == AbsenState.empty();
            final udahAbsenMasuk = absenState == AbsenState.absenIn();
            final udahAbsenMasukSamaKeluar =
                absenState == AbsenState.complete();

            JenisAbsen jenisAbsenShift = JenisAbsen.unknown;

            final karyawanShift =
                await ref.read(karyawanShiftFutureProvider.future);

            if (karyawanShift) {
              await showDialog(
                  context: buildContext,
                  barrierDismissible: false,
                  builder: (context) => VAlertDialog(
                        label: 'PILIH ABSEN',
                        labelDescription: 'PILIH ABSEN IN ATAU OUT',
                        pressedLabel: 'ABSEN IN',
                        backPressedLabel: 'ABSEN OUT',
                        onPressed: () {
                          jenisAbsenShift = JenisAbsen.absenIn;
                          buildContext.pop();
                        },
                        onBackPressed: () {
                          jenisAbsenShift = JenisAbsen.absenOut;
                          buildContext.pop();
                        },
                      ));
            }

            // debugger();

            log('CONDITION 1 : ${belumAbsen || jenisAbsenShift == JenisAbsen.absenIn}');
            log('CONDITION 2 : ${udahAbsenMasuk || jenisAbsenShift == JenisAbsen.absenOut}');

            if (belumAbsen || jenisAbsenShift == JenisAbsen.absenIn) {
              // debugger(message: 'called');
              final jenisAbsen = jenisAbsenShift == JenisAbsen.unknown
                  ? JenisAbsen.absenIn
                  : jenisAbsenShift;

              final date = absenSaved.savedLocations.date;

              await showDialog(
                  context: buildContext,
                  barrierDismissible: false,
                  builder: (context) => VAlertDialog(
                      label: 'ABSEN MASUK ?',
                      labelDescription:
                          'TANGGAL ${StringUtils.yyyyMMddWithStripe(date)}: JAM ${StringUtils.hoursDate(date)}',
                      backPressedLabel: 'TIDAK & HAPUS ABSEN',
                      onPressed: () async {
                        await ref
                            .read(absenAuthNotifierProvidier.notifier)
                            .absenOneLiner(
                                backgroundItemState: absenSaved,
                                jenisAbsen: jenisAbsen,
                                idGeof: idGeofSaved ?? '',
                                imei: imei,
                                onAbsen: () async {
                                  await getAbsenState(date: date);
                                  await getSavedLocations();
                                },
                                deleteSaved: () => deleteSavedLocation(
                                    savedLocation: absenSaved.savedLocations,
                                    context: buildContext),
                                getAbsenState: () => getAbsenState(
                                    date: absenSaved.savedLocations.date),
                                showSuccessDialog: () async {
                                  buildContext.pop();
                                  await showDialog(
                                      context: buildContext,
                                      barrierDismissible: true,
                                      builder: (_) => VSimpleDialog(
                                            asset: Assets.iconChecked,
                                            label:
                                                'JAM ${StringUtils.hoursDate(absenSaved.savedLocations.date)}',
                                            labelDescription:
                                                'TANGGAL ${StringUtils.yyyyMMddWithStripe(absenSaved.savedLocations.date)}',
                                          ));
                                },
                                showFailureDialog: (code, message) async {
                                  buildContext.pop();
                                  await showDialog(
                                      context: buildContext,
                                      barrierDismissible: true,
                                      builder: (_) => VSimpleDialog(
                                            color: Palette.red,
                                            asset: Assets.iconCrossed,
                                            label: code,
                                            labelDescription: message,
                                          ));
                                });
                      },
                      onBackPressed: () async {
                        buildContext.pop();
                        await deleteSavedLocation(
                            savedLocation: absenSaved.savedLocations,
                            context: context);
                      }));

              incrementIndex();
            } else if (udahAbsenMasuk ||
                jenisAbsenShift == JenisAbsen.absenOut) {
              // debugger(message: 'called');
              final jenisAbsen = jenisAbsenShift == JenisAbsen.unknown
                  ? JenisAbsen.absenOut
                  : jenisAbsenShift;

              final date = absenSaved.savedLocations.date;

              await showDialog(
                  context: buildContext,
                  barrierDismissible: false,
                  builder: (context) => VAlertDialog(
                      label: 'ABSEN KELUAR ? ',
                      labelDescription:
                          'TANGGAL ${StringUtils.yyyyMMddWithStripe(date)}: JAM ${StringUtils.hoursDate(date)}',
                      backPressedLabel: 'TIDAK & HAPUS ABSEN',
                      onPressed: () async {
                        await ref
                            .read(absenAuthNotifierProvidier.notifier)
                            .absenOneLiner(
                              backgroundItemState: absenSaved,
                              jenisAbsen: jenisAbsen,
                              idGeof: idGeofSaved ?? '',
                              imei: imei,
                              onAbsen: () async {
                                await getAbsenState(date: date);
                                await getSavedLocations();
                              },
                              deleteSaved: () => deleteSavedLocation(
                                  savedLocation: absenSaved.savedLocations,
                                  context: context),
                              getAbsenState: () => getAbsenState(
                                  date: absenSaved.savedLocations.date),
                              showSuccessDialog: () => showDialog(
                                context: buildContext,
                                barrierDismissible: true,
                                builder: (_) => VSimpleDialog(
                                  asset: Assets.iconChecked,
                                  label:
                                      'JAM ${StringUtils.hoursDate(absenSaved.savedLocations.date)}',
                                  labelDescription:
                                      'TANGGAL ${StringUtils.yyyyMMddWithStripe(absenSaved.savedLocations.date)}',
                                ),
                              ),
                              showFailureDialog: (code, message) => showDialog(
                                  context: buildContext,
                                  barrierDismissible: true,
                                  builder: (_) => VSimpleDialog(
                                        color: Palette.red,
                                        asset: Assets.iconCrossed,
                                        label: code,
                                        labelDescription: message,
                                      )),
                            );

                        // absen one liner
                        buildContext.pop();
                      },
                      onBackPressed: () async {
                        buildContext.pop();
                        await deleteSavedLocation(
                            savedLocation: absenSaved.savedLocations,
                            context: context);
                      }));

              incrementIndex();
            } else if (udahAbsenMasukSamaKeluar) {
              // debugger();

              // delete saved absen as we don't need them.
              await deleteSavedLocation(
                  savedLocation: absenSaved.savedLocations,
                  context: buildContext);

              // Trigger another build [FOR DELETION]
              await getSavedLocations();
              await ref.read(geofenceProvider.notifier).getGeofenceList();

              incrementIndex();
            }

            // debugger();
          }

          final Function(Location location) mockListener = ref
              .read(mockLocationNotifierProvider.notifier)
              .addMockLocationListener;

          // REINITIALIZE
          await reinitializeDependencies(
              geofence: geofence, mockListener: mockListener);
        }
      });
    }
  }

  List<BackgroundItemState> currentNetworkTimeForSavedAbsen({
    required DateTime dbDate,
    required List<BackgroundItemState> savedItems,
  }) {
    List<BackgroundItemState> locations = [];

    savedItems.forEach((element) {
      locations.add(BackgroundItemState(
          abenStates: element.abenStates,
          savedLocations: SavedLocation(
              idGeof: element.savedLocations.idGeof,
              latitude: element.savedLocations.latitude,
              longitude: element.savedLocations.longitude,
              alamat: element.savedLocations.alamat,
              date: element.savedLocations.date,
              dbDate: dbDate)));
    });

    return locations;
  }

  Map<String, List<BackgroundItemState>> sortAbsenMap(
      List<BackgroundItemState> backgroundItems) {
    final groupedMap = <String, List<BackgroundItemState>>{};

    for (final backgroundItem in backgroundItems) {
      final date = backgroundItem.savedLocations.date;
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (!groupedMap.containsKey(dateString)) {
        groupedMap[dateString] = [];
      }

      groupedMap[dateString]!.add(backgroundItem);
    }

    return groupedMap;
  }

  Future<void> getAbsenState({required DateTime date}) async {
    await this.ref.read(absenNotifierProvidier.notifier).getAbsen(date: date);
  }

  Future<void> getSavedLocations() async {
    await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
  }

  Future<void> deleteSavedLocation(
      {required BuildContext context,
      required SavedLocation savedLocation}) async {
    // debugger(message: 'called');
    await ref
        .read(backgroundNotifierProvider.notifier)
        .removeLocationFromSaved(savedLocation, onSaved: () async {
      // final savedLocations = await ref
      //     .read(backgroundNotifierProvider.notifier)
      //     .getSavedLocationsOneLiner();

      // final bgItems = ref
      //     .read(backgroundNotifierProvider.notifier)
      //     .getBackgroundItemsAsList(savedLocations);

      // log('bgItems savedLocations $bgItems $savedLocations');

      // ref
      //     .read(backgroundNotifierProvider.notifier)
      //     .changeBackgroundItems(bgItems ?? []);

      // // Trigger another build [FOR DELETION]
      // await getSavedLocations();
      // await ref.read(geofenceProvider.notifier).getGeofenceList();
    });
  }

  Future<void> reinitializeDependencies({
    required List<Geofence> geofence,
    required Function(Location location) mockListener,
  }) async {
    await getSavedLocations();
    await ref
        .read(geofenceProvider.notifier)
        .initializeGeoFence(geofence, onError: (e) {});
    await ref
        .read(geofenceProvider.notifier)
        .addGeofenceMockListener(mockListener: mockListener);
  }
}
