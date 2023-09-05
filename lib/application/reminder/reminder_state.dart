import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_state.freezed.dart';

@freezed
class ReminderState with _$ReminderState {
  const factory ReminderState({required int daysLeft}) = _ReminderState;

  factory ReminderState.initial() => ReminderState(daysLeft: 9);
}
