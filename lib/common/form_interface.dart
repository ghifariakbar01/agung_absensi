import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../cross_auth/application/is_user_crossed.dart';

abstract class FormInterface<T> {
  final AsyncValue<void> sendWa = AsyncValue.data({});
  final AsyncValue<void> crossAuth = AsyncValue.data({});
  final AsyncValue<List<T>> listForm = AsyncValue.data([]);
  final AsyncValue<void> listApprove = AsyncValue.data({});

  final ScrollController scrollController = ScrollController();
  final ValueNotifier<int> page = ValueNotifier(0);
  final ValueNotifier<String> lastSearch = ValueNotifier('');
  final ValueNotifier<DateTimeRange> dateTimeRange =
      ValueNotifier(DateTimeRange(
    end: DateTime.now(),
    start: DateTime.now().subtract(Duration(days: 30)),
  ));
  /* 
  _d1, _d2
  */
  final ValueNotifier<bool> isScrollStopped = ValueNotifier(false);
  void resetScroll();
  Future<void> Function() onRefresh();
  Future<void> Function(String value) onFieldSubmitted();
  final Map<String, List<String>> mapPT = {
    'gs_12': ['ACT', 'Transina', 'ALR'],
    'gs_14': ['Tama Raya'],
    'gs_18': ['ARV'],
    'gs_21': ['AJL'],
  };
  final String currPT = '';
  final List<String> initialDropdown = [];
  final ValueNotifier<List<String>> dropdownValue = ValueNotifier([]);
  Future<void> Function(List<String> value) onDropdownChanged();
  Future<void> Function(DateTimeRange value) onFilterSelected();
  void onScrolledVisibility();
  final ValueNotifier<bool> isAtBottom = ValueNotifier(false);
  void onScrolled();
  final AsyncValue<void> errLog = AsyncValue.data({});
  final AsyncValue<IsUserCrossedState> isUserCrossed =
      AsyncValue.data(IsUserCrossedState.notCrossed());
}
