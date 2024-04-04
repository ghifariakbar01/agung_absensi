import 'dart:developer';

import '../../absen/application/absen_enum.dart';
import '../../absen/application/absen_state.dart';
import '../../background/application/saved_location.dart';
import '../../utils/os_vibrate.dart';
import 'auto_absen_state.dart';

import '../../constants/assets.dart';
import '../../shared/providers.dart';
import '../../utils/string_utils.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../widgets/v_dialogs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:face_net_authentication/style/style.dart';

class AutoAbsenNotifier extends StateNotifier<AutoAbsenState> {
  AutoAbsenNotifier(this.ref) : super(AutoAbsenState.initial());

  StateNotifierProviderRef<AutoAbsenNotifier, AutoAbsenState> ref;

  Future<void> processAutoAbsen({
    required String imei,
    required List<Geofence> geofence,
    required BuildContext buildContext,
    required List<SavedLocation> savedItems,
    required Map<String, List<SavedLocation>> autoAbsenMap,
  }) async {
    //

    final list = autoAbsenMap.values;

    if (list.isNotEmpty) {
      int startIndex = 0;

      list.forEach((absensInDate) async {
        /// check if absen [AbsenState.empty()], [AbsenState.absenIn()] or [AbsenState.complete()]
        ///

        if (absensInDate.isNotEmpty) {
          void incrementIndex() => startIndex = startIndex + 1;

          while (startIndex + 1 <= absensInDate.length) {
            // ID GEOF, IMEI field
            final absenSaved = absensInDate[startIndex];
            final idGeofSaved = absenSaved.idGeof;

            // GET RECENT ABSEN STATE
            final absenState = absenSaved.absenState;

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
                        onPressed: () async {
                          await OSVibrate.vibrate();
                          jenisAbsenShift = JenisAbsen.absenIn;
                          buildContext.pop();
                        },
                        onBackPressed: () async {
                          await OSVibrate.vibrate();
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

              final date = absenSaved.date;

              await OSVibrate.vibrate().then((_) => showDialog(
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
                              jenisAbsen: jenisAbsen,
                              backgroundItemState: absenSaved,
                              idGeof: idGeofSaved ?? '',
                              imei: imei,
                              onAbsen: getSavedLocations,
                              deleteSaved: () => deleteSavedLocation(
                                context: buildContext,
                                savedLocation: absenSaved,
                              ),
                              showSuccessDialog: () =>
                                  _showSuccessDialog(buildContext, absenSaved),
                              showFailureDialog: (code, message) =>
                                  _showFailureDialog(
                                      buildContext, code, message),
                            );

                        // absen one liner
                        buildContext.pop();
                      },
                      onBackPressed: () async {
                        buildContext.pop();
                        await deleteSavedLocation(
                          context: buildContext,
                          savedLocation: absenSaved,
                        );
                      })));

              incrementIndex();
            } else if (udahAbsenMasuk ||
                jenisAbsenShift == JenisAbsen.absenOut) {
              // debugger(message: 'called');
              final jenisAbsen = jenisAbsenShift == JenisAbsen.unknown
                  ? JenisAbsen.absenOut
                  : jenisAbsenShift;

              final date = absenSaved.date;

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
                              jenisAbsen: jenisAbsen,
                              backgroundItemState: absenSaved,
                              idGeof: idGeofSaved ?? '',
                              imei: imei,
                              onAbsen: getSavedLocations,
                              deleteSaved: () => deleteSavedLocation(
                                context: buildContext,
                                savedLocation: absenSaved,
                              ),
                              showSuccessDialog: () =>
                                  _showSuccessDialog(buildContext, absenSaved),
                              showFailureDialog: (code, message) =>
                                  _showFailureDialog(
                                      buildContext, code, message),
                            );

                        // absen one liner
                        buildContext.pop();
                      },
                      onBackPressed: () async {
                        buildContext.pop();
                        await OSVibrate.vibrate();
                        await deleteSavedLocation(
                          context: buildContext,
                          savedLocation: absenSaved,
                        );
                      }));

              incrementIndex();
            } else if (udahAbsenMasukSamaKeluar) {
              // debugger();
              await OSVibrate.vibrate();

              // delete saved absen as we don't need them.
              await deleteSavedLocation(
                context: buildContext,
                savedLocation: absenSaved,
              );

              // Trigger another build [FOR DELETION]
              await getSavedLocations();
              await ref.read(geofenceProvider.notifier).getGeofenceList();

              incrementIndex();
            }

            // debugger();
          }

          final Function(Location location) mockListener = ref
              .read(mockLocationNotifierProvider.notifier)
              .checkMockLocationState;

          // REINITIALIZE
          await reinitializeDependencies(
              geofence: geofence, mockListener: mockListener);
        }
      });
    }
  }

  Future<void> _showSuccessDialog(
      BuildContext buildContext, SavedLocation absenSaved) async {
    {
      buildContext.pop();
      await OSVibrate.vibrate();
      await showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
          asset: Assets.iconChecked,
          label: 'JAM ${StringUtils.hoursDate(absenSaved.date)}',
          labelDescription:
              'TANGGAL ${StringUtils.yyyyMMddWithStripe(absenSaved.date)}',
        ),
      );
    }
  }

  Future<void> _showFailureDialog(
      BuildContext buildContext, String code, String message) async {
    {
      buildContext.pop();
      await OSVibrate.vibrate();
      await showDialog(
          context: buildContext,
          barrierDismissible: true,
          builder: (_) => VSimpleDialog(
                color: Palette.red,
                asset: Assets.iconCrossed,
                label: code,
                labelDescription: message,
              ));
    }
  }

  List<SavedLocation> currentNetworkTimeForSavedAbsen({
    required DateTime dbDate,
    required List<SavedLocation> savedItems,
  }) {
    List<SavedLocation> locations = [];

    savedItems.forEach((element) {
      locations.add(SavedLocation(
          dbDate: dbDate,
          //
          date: element.date,
          alamat: element.alamat,
          idGeof: element.idGeof,
          latitude: element.latitude,
          longitude: element.longitude,
          absenState: element.absenState));
    });

    return locations;
  }

  Map<String, List<SavedLocation>> sortAbsenMap(
      List<SavedLocation> backgroundItems) {
    final groupedMap = <String, List<SavedLocation>>{};

    for (final backgroundItem in backgroundItems) {
      final date = backgroundItem.date;
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (!groupedMap.containsKey(dateString)) {
        groupedMap[dateString] = [];
      }

      groupedMap[dateString]!.add(backgroundItem);
    }

    return groupedMap;
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
      // change background item, for popup trigger
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
