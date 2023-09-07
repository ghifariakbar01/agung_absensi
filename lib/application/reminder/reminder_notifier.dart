import 'package:face_net_authentication/application/reminder/reminder_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReminderNotifier extends StateNotifier<ReminderState> {
  ReminderNotifier() : super(ReminderState.initial());

  String get stateToString => state.daysLeft.toString();

  String get daysLeftString =>
      'Waktu tersisa ${state.daysLeft} hari. Segera Ubah Password ERP Anda.';

  String get daysLeftStringDue =>
      'Anda memasuki waktu tenggang Expired Password, Ubah Password ERP Anda.';

  String get daysLeftStringPass =>
      'Anda melewati ${stateToString.substring(1, stateToString.length)} hari. Segera Ubah Password ERP Anda. ';

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

    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    return DateTime(year, month, day);
  }
}
