// ignore_for_file: sdk_version_since

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/dialog_helper.dart';

abstract class Helper {
  Future<void> storageDebugMode(Ref<Object?> ref,
      {required bool isDebug}) async {}
  Future<void> fixStorage(Ref ref) async {}
}

class HelperImpl implements Helper {
  @override
  Future<void> fixStorage(Ref<Object?> ref) async {
    Future<Unit> _saveCurrentImei(String? imei) async {
      if (imei == null) {
        return unit;
      } else {
        await ref.read(imeiCredentialsStorageProvider).save(imei);
        return unit;
      }
    }

    Future<String?> _getCurrentImei() async {
      return ref.read(imeiCredentialsStorageProvider).read();
    }

    Future<Unit> _deleteAll() async {
      await ref.read(flutterSecureStorageProvider).deleteAll();
      return unit;
    }

    final prefs = await SharedPreferences.getInstance();
    const String name = 'first_run';

    if (prefs.getBool(name) ?? true) {
      final String? _imei = await _getCurrentImei();
      await _deleteAll();
      await _saveCurrentImei(_imei);

      await prefs.setBool(name, false);
    }
  }

  @override
  Future<void> storageDebugMode(Ref<Object?> ref,
      {required bool isDebug}) async {
    Future<Unit> _deleteAll() async {
      await ref.read(flutterSecureStorageProvider).deleteAll();
      return unit;
    }

    Future<Unit> _deleteAllSharedPrefs() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return unit;
    }

    if (isDebug) {
      await _deleteAll();
      await _deleteAllSharedPrefs();
    }
  }
}

class CalendarHelper {
  static DateTimeRange initialDateRange() {
    final _end = DateTime.now().copyWith(day: 15);

    final _monthBefore = DateTime.now().month - 1;
    final _start = DateTime.now().copyWith(month: _monthBefore, day: 15);

    return DateTimeRange(
      start: _start,
      end: _end,
    );
  }

  static Future<void> callCalendar(
    BuildContext context,
    Future<dynamic> onFilterSelected(DateTimeRange value),
  ) async {
    final _oneYear = Duration(days: 365);

    final picked = await showDateRangePicker(
        context: context,
        initialDateRange: initialDateRange(),
        firstDate: DateTime.now().subtract(_oneYear),
        lastDate: DateTime.now().add(_oneYear));

    if (picked != null) {
      if (picked.duration.inDays < 32) {
        onFilterSelected(picked);
      } else {
        DialogHelper.showCustomDialog(
          'Filter melebihi 30 hari',
          context,
        ).then((_) => callCalendar(
              context,
              onFilterSelected,
            ));
      }
    }
  }
}
