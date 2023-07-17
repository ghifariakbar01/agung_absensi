import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/auto_absen_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../background_service/background_item_state.dart';
import '../background_service/recent_absen_state.dart';
import 'auto_absen_repository.dart';
import 'auto_absen_state.dart';

class AutoAbsenNotifier extends StateNotifier<AutoAbsenState> {
  AutoAbsenNotifier(this.absenRepository) : super(AutoAbsenState.initial());

  final AutoAbsenRepository absenRepository;

  void changeRecentAbsen(List<RecentAbsenState> savedRecentAbsens) {
    state = state.copyWith(recentAbsens: [...savedRecentAbsens]);
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
