import 'package:face_net_authentication/application/reminder/reminder_notifier.dart';
import 'package:face_net_authentication/application/reminder/reminder_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final reminderNotifierProvider =
    StateNotifierProvider<ReminderNotifier, ReminderState>(
        (ref) => ReminderNotifier());
