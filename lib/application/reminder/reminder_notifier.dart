import 'dart:developer';

import 'package:face_net_authentication/application/reminder/reminder_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReminderNotifier extends StateNotifier<ReminderState> {
  ReminderNotifier() : super(ReminderState.initial());

  String get stateToString => state.daysLeft.toString();

  String get daysLeftString =>
      'Waktu tersisa ${state.daysLeft} hari. Segera update password E-HRMS, unlink dan uninstall.';

  String get daysLeftStringDue =>
      'Anda memasuki waktu tenggang. Update password E-HRMS, unlink dan uninstall hari ini.';

  String get daysLeftStringPass =>
      'Anda melewati ${stateToString.substring(1, stateToString.length)} hari. Update password E-HRMS, unlink dan uninstall. ';

  int getDaysLeft({required DateTime passUpdate}) {
    DateTime now = DateTime.now();

    Duration difference = passUpdate.difference(now);
    return difference.inDays;
  }

  void changeDaysLeft(int daysLeft) {
    state = state.copyWith(daysLeft: daysLeft);
  }

  DateTime convertToDateTime({required String passUpdate}) {
    List<String> parts = passUpdate.split(' ');
    List<String> dateParts = parts[0].split('-');
    List<String> timeParts = parts[1].split(':');

    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    return DateTime(year, month, day, hour, minute, second);
  }
}
