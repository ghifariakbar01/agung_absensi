import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/background/saved_location.dart';
import 'package:face_net_authentication/domain/auto_absen_failure.dart';
import 'package:flutter/material.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../pages/widgets/v_dialogs.dart';
import '../../shared/providers.dart';
import '../../utils/string_utils.dart';
import '../absen/absen_enum.dart';
import '../absen/absen_state.dart';
import '../background/background_item_state.dart';
import '../background/recent_absen_state.dart';
import '../geofence/geofence_coordinate_state.dart';
import 'auto_absen_repository.dart';
import 'auto_absen_state.dart';

class AutoAbsenNotifier extends StateNotifier<AutoAbsenState> {
  AutoAbsenNotifier(this.absenRepository) : super(AutoAbsenState.initial());

  final AutoAbsenRepository absenRepository;

  void changeRecentAbsen(List<RecentAbsenState> savedRecentAbsens) {
    state = state.copyWith(recentAbsens: [...savedRecentAbsens]);
  }

  Future<void> processAutoAbsen({
    required String imei,
    required WidgetRef ref,
    required BuildContext context,
    required Map<String, List<BackgroundItemState>> autoAbsenMap,
    required List<Geofence> geofence,
    required List<BackgroundItemState> savedItems,
    required List<GeofenceCoordinate> nearestCoordinatesSaved,
  }) async {
    //
    Future<void> getAbsenState({required DateTime date}) async {
      await ref.read(absenNotifierProvidier.notifier).getAbsen(
          date: date,
          onAbsen: (absen) {
            ref.read(absenNotifierProvidier.notifier).changeAbsen(absen);

            ref.read(absenOfflineModeProvider.notifier).state = false;
          },
          onNoConnection: () {
            ref.read(absenOfflineModeProvider.notifier).state = true;
            return;
          });
    }

    Future<void> getSavedLocations() async {
      await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
    }

    Future<void> deleteSavedLocation(
        {required SavedLocation savedLocation}) async {
      debugger(message: 'called');
      await ref
          .read(backgroundNotifierProvider.notifier)
          .removeLocationFromSaved(savedLocation, onSaved: () async {
        final savedLocations = await ref
            .read(backgroundNotifierProvider.notifier)
            .getSavedLocationsOneLiner();

        final bgItems = ref
            .read(backgroundNotifierProvider.notifier)
            .getBackgroundItemsAsList(savedLocations);

        log('bgItems savedLocations $bgItems $savedLocations');

        ref
            .read(backgroundNotifierProvider.notifier)
            .changeBackgroundItems(bgItems ?? []);

        // Trigger another build [FOR DELETION]
        await ref.read(userNotifierProvider.notifier).getUser();
        await getSavedLocations();

        await ref.read(geofenceProvider.notifier).getGeofenceList();
      });

      context.pop();
    }

    Future<void> reinitializeDependencies() async {
      // reinitialize dependecies
      final savedLocations = ref
          .read(backgroundNotifierProvider.notifier)
          .getSavedLocationsAsList(savedItems);
      log('savedLocations ${savedLocations?.length}');
      await getSavedLocations();
      debugger(message: 'called');

      await ref.read(geofenceProvider.notifier).initializeGeoFence(
          savedLocations, geofence,
          onError: () =>
              ref.read(geofenceProvider.notifier).getGeofenceListFromStorage());
    }

    final list = autoAbsenMap.values;

    if (list.isNotEmpty) {
      list.forEach((absensInDate) async {
        /// check if absen [AbsenState.empty()], [AbsenState.absenIn()] or [AbsenState.complete()]
        debugger(message: 'called');

        if (absensInDate.isNotEmpty) {
          debugger(message: 'called');

          // ID GEOF, IMEI field
          absensInDate.forEachIndexed((index, absenSaved) async {
            final idGeofSaved = nearestCoordinatesSaved[index].id;
            final date = absensInDate[index].savedLocations.date;

            await getAbsenState(date: date);

            // GET RECENT ABSEN STATE
            final absenState = ref.read(absenNotifierProvidier.notifier).state;

            log('absenState $absenState');

            final belumAbsen = absenState == AbsenState.empty();
            final udahAbsenMasuk = absenState == AbsenState.absenIn();
            final udahAbsenMasukSamaKeluar =
                absenState == AbsenState.complete();

            JenisAbsen jenisAbsenShift = JenisAbsen.unknown;

            final karyawanShift = await ref
                .read(isKarwayanShiftNotifierProvider.notifier)
                .isKaryawanShift();

            if (karyawanShift) {
              await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => VAlertDialog(
                        label: 'PILIH ABSEN',
                        labelDescription: 'PILIH ABSEN IN ATAU OUT',
                        pressedLabel: 'ABSEN IN',
                        backPressedLabel: 'ABSEN OUT',
                        onPressed: () {
                          jenisAbsenShift = JenisAbsen.absenIn;
                          context.pop();
                        },
                        onBackPressed: () {
                          jenisAbsenShift = JenisAbsen.absenOut;
                          context.pop();
                        },
                      ));
            }

            log('CONDITION 1 : ${belumAbsen || jenisAbsenShift == JenisAbsen.absenIn}');
            log('CONDITION 2 : ${udahAbsenMasuk || jenisAbsenShift == JenisAbsen.absenOut}');

            if (belumAbsen || jenisAbsenShift == JenisAbsen.absenIn) {
              debugger(message: 'called');
              final jenisAbsen = jenisAbsenShift == JenisAbsen.unknown
                  ? JenisAbsen.absenIn
                  : jenisAbsenShift;

              final date = absenSaved.savedLocations.date;

              await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => VAlertDialog(
                      label: 'ABSEN MASUK ?',
                      labelDescription:
                          'TANGGAL ${StringUtils.yyyyMMddWithStripe(date)}: JAM ${StringUtils.hoursDate(date)}',
                      backPressedLabel: 'TIDAK & HAPUS ABSEN',
                      onPressed: () async => // absen one liner
                          await ref
                              .read(absenAuthNotifierProvidier.notifier)
                              .absenOneLiner(
                                  backgroundItemState: absenSaved,
                                  jenisAbsen: jenisAbsen,
                                  idGeof: idGeofSaved,
                                  imei: imei,
                                  onAbsen: () async {
                                    await getAbsenState(date: date);
                                    await getSavedLocations();
                                  },
                                  deleteSaved: () => deleteSavedLocation(
                                      savedLocation: absenSaved.savedLocations),
                                  reinitializeDependencies: () =>
                                      reinitializeDependencies(),
                                  getAbsenState: () => getAbsenState(
                                      date: absenSaved.savedLocations.date),
                                  showSuccessDialog: () => showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (_) => VSimpleDialog(
                                            asset: Assets.iconChecked,
                                            label:
                                                'JAM ${StringUtils.hoursDate(absenSaved.savedLocations.date)}',
                                            labelDescription:
                                                'TANGGAL ${StringUtils.yyyyMMddWithStripe(absenSaved.savedLocations.date)}',
                                          ))),
                      onBackPressed: () => deleteSavedLocation(
                          savedLocation: absenSaved.savedLocations)));
            } else if (udahAbsenMasuk ||
                jenisAbsenShift == JenisAbsen.absenOut) {
              debugger(message: 'called');
              final jenisAbsen = jenisAbsenShift == JenisAbsen.unknown
                  ? JenisAbsen.absenOut
                  : jenisAbsenShift;

              final date = absenSaved.savedLocations.date;

              await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => VAlertDialog(
                      label: 'ABSEN KELUAR ? ',
                      labelDescription:
                          'TANGGAL ${StringUtils.yyyyMMddWithStripe(date)}: JAM ${StringUtils.hoursDate(date)}',
                      backPressedLabel: 'TIDAK & HAPUS ABSEN',
                      onPressed: () async => // absen one liner
                          await ref
                              .read(absenAuthNotifierProvidier.notifier)
                              .absenOneLiner(
                                backgroundItemState: absenSaved,
                                jenisAbsen: jenisAbsen,
                                idGeof: idGeofSaved,
                                imei: imei,
                                onAbsen: () async {
                                  await getAbsenState(date: date);

                                  await getSavedLocations();
                                },
                                deleteSaved: () => deleteSavedLocation(
                                    savedLocation: absenSaved.savedLocations),
                                reinitializeDependencies: () =>
                                    reinitializeDependencies(),
                                getAbsenState: () => getAbsenState(
                                    date: absenSaved.savedLocations.date),
                                showSuccessDialog: () => showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) => VSimpleDialog(
                                          asset: Assets.iconChecked,
                                          label:
                                              'JAM ${StringUtils.hoursDate(absenSaved.savedLocations.date)}',
                                          labelDescription:
                                              'TANGGAL ${StringUtils.yyyyMMddWithStripe(absenSaved.savedLocations.date)}',
                                        )),
                              ),
                      onBackPressed: () => deleteSavedLocation(
                          savedLocation: absenSaved.savedLocations)));
            } else if (udahAbsenMasukSamaKeluar &&
                jenisAbsenShift != JenisAbsen.unknown) {
              // delete saved absen as we don't need them.
              await deleteSavedLocation(
                  savedLocation: absenSaved.savedLocations);

              // Trigger another build [FOR DELETION]
              await ref.read(userNotifierProvider.notifier).getUser();
              await getSavedLocations();
              await ref.read(geofenceProvider.notifier).getGeofenceList();
            }
          });
        }
      });
    }
  }

  Future<void> saveRecentAbsen({required RecentAbsenState savedRecent}) async {
    final jsonAbsen = jsonEncode(savedRecent);

    log('jsonAbsen $jsonAbsen');

    await absenRepository.addRecentAbsen(jsonAbsen);
  }

  Future<void> getRecentAbsen() async {
    Either<AutoAbsenFailure, List<RecentAbsenState>> failureOrSuccess;

    state = state.copyWith(
        isProcessing: true, failureOrSuccessOptionRecentAbsen: none());

    failureOrSuccess = await absenRepository.getRecentAbsen();

    state = state.copyWith(
        isProcessing: true,
        failureOrSuccessOptionRecentAbsen: optionOf(failureOrSuccess));
  }

  Map<String, List<BackgroundItemState>> unsortAbsenMap(
      List<BackgroundItemState> backgroundItems) {
    final grouped = groupByDateMonthYear(backgroundItems);

    return grouped;
  }

  Map<String, List<BackgroundItemState>> sortAbsenMap(
      List<BackgroundItemState> backgroundItems) {
    final grouped = groupByDateMonthYear(backgroundItems);

    // grouped.forEach((key, value) {
    //   // get possible hours
    //   final possibleHours = getPossibleHours(value);

    //   final possibleHoursValid =
    //       possibleHours.isNotEmpty && possibleHours.length > 1;

    //   if (possibleHoursValid) {
    //     // mutation
    //     grouped[key] = possibleHours;
    //   } else {
    //     // mutation
    //     grouped[key] = reduceList(value);
    //   }
    // });

    log('group after $grouped');

    return grouped;
  }

  List<BackgroundItemState> reduceList(List<BackgroundItemState> items) {
    if (items.length > 2) {
      return [items.first, items.last];
    }

    return items;
  }

  List<BackgroundItemState> getPossibleHours(
      List<BackgroundItemState> backgroundItems) {
    final List<BackgroundItemState> list = [];

    final absenIn = absenHourIn(backgroundItems);
    final absenOut = absenHourOut(backgroundItems);

    if (absenIn != null) {
      list.add(absenIn);
    } else if (absenOut != null) {
      list.add(absenOut);
    }

    return list;
  }

  BackgroundItemState? absenHourIn(List<BackgroundItemState> backgroundItems) {
    for (final item in backgroundItems) {
      if (item.savedLocations.date.hour > 7 &&
          item.savedLocations.date.hour < 12) {
        return item;
      } else {
        return null;
      }
    }
    return null;
  }

  BackgroundItemState? absenHourOut(List<BackgroundItemState> backgroundItems) {
    for (final item in backgroundItems) {
      if (item.savedLocations.date.hour >= 17 &&
          item.savedLocations.date.hour < 22) {
        return item;
      } else {
        return null;
      }
    }
    return null;
  }

  Map<String, List<BackgroundItemState>> groupByDateMonthYear(
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
}
