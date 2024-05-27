import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:face_net_authentication/cuti/cuti_approve/application/cuti_approve_notifier.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';

import '../../../cross_auth/application/cross_auth_notifier.dart';
import '../../../cross_auth/application/is_user_crossed.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../widgets/v_async_widget.dart';
import '../application/cuti_list_notifier.dart';
import 'cuti_scaffold_tablayout.dart';

class CutiListScaffold extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendWa = ref.watch(sendWaNotifierProvider);
    final mstCuti = ref.watch(mstKaryawanCutiNotifierProvider);
    final cutiApprove = ref.watch(cutiApproveControllerProvider);
    final cutiList = ref.watch(cutiListControllerProvider);
    final crossAuth = ref.watch(crossAuthNotifierProvider);

    final _oneMonth = Duration(days: 30);
    final _oneDay = Duration(days: 1);
    final _initialDateRange = DateTimeRange(
      end: DateTime.now().add(_oneDay),
      start: DateTime.now().subtract(_oneMonth),
    );

    /* 
      Search and Filter Date
      values
    */
    final _lastSearch = useState('');
    final _dateTimeRange = useState(_initialDateRange);

    final _d1 = DateFormat('dd MMMM y').format(_dateTimeRange.value.start);
    final _d2 = DateFormat('dd MMMM y').format(_dateTimeRange.value.end);

    final _isScrollStopped = useState(false);

    final scrollController = useScrollController();
    final page = useState(0);

    _resetScroll() {
      if (scrollController.hasClients) {
        _isScrollStopped.value = false;
        scrollController.jumpTo(0.0);
      }
    }

    final onRefresh = () async {
      page.value = 0;
      _resetScroll();

      await ref.read(mstKaryawanCutiNotifierProvider.notifier).refresh();
      await ref.read(cutiListControllerProvider.notifier).refresh(
            searchUser: _lastSearch.value,
            dateRange: _dateTimeRange.value,
          );
      return Future.value();
    };

    final onPageChanged = () async {
      page.value = 0;
      _resetScroll();

      await ref.read(cutiListControllerProvider.notifier).refresh(
            searchUser: _lastSearch.value,
            dateRange: _dateTimeRange.value,
          );
      return Future.value();
    };

    final onFieldSubmitted = (String value) async {
      page.value = 0;
      _resetScroll();

      _lastSearch.value = value;
      await ref.read(cutiListControllerProvider.notifier).refresh(
            searchUser: value,
            dateRange: _dateTimeRange.value,
          );
      return Future.value();
    };

    final Map<String, List<String>> _mapPT = {
      'gs_12': ['ACT', 'Transina', 'ALR'],
      'gs_14': ['Tama Raya'],
      'gs_18': ['ARV'],
      'gs_21': ['AJL'],
    };

    final _initialDropdownPlaceholder = ['ACT', 'Transina', 'ALR'];
    final _currPT = ref.watch(userNotifierProvider).user.ptServer;
    final _initialDropdown = _mapPT.entries
        .firstWhereOrNull((element) => element.key == _currPT)
        ?.value;

    final _dropdownValue = useState(_initialDropdown);

    final onDropdownChanged = (List<String> value) async {
      page.value = 0;
      _resetScroll();

      _dropdownValue.value = value;
      final user = ref.read(userNotifierProvider).user;

      await ref.read(crossAuthNotifierProvider.notifier).cross(
            userId: user.nama!,
            password: user.password!,
            pt: _dropdownValue.value ?? ['ACT', 'Transina', 'ALR'],
          );
      return Future.value();
    };

    final onFilterSelected = (DateTimeRange value) async {
      page.value = 0;
      _resetScroll();

      _dateTimeRange.value = value;
      await ref.read(cutiListControllerProvider.notifier).refresh(
            dateRange: value,
            searchUser: _lastSearch.value,
          );
      return Future.value();
    };

    void onScrolledVisibility() {
      scrollController.position.isScrollingNotifier.addListener(() {
        if (scrollController.position.pixels > 0.0) {
          _isScrollStopped.value = true;
        } else {
          _isScrollStopped.value = false;
        }
      });
    }

    final _isAtBottom = useState(false);

    ref.listen<AsyncValue>(cutiListControllerProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        _isAtBottom.value = false;
      }

      return state.showAlertDialogOnError(context, ref);
    });

    useEffect(() {
      scrollController.addListener(onScrolledVisibility);
      return () => scrollController.removeListener(onScrolledVisibility);
    }, [scrollController]);

    final errLog = ref.watch(errLogControllerProvider);
    final _isUserCrossed = ref.watch(isUserCrossedProvider);

    final _isSearching = useState(false);
    final _searchFocus = useFocusNode();

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold(
        value: crossAuth,
        data: (_) => VAsyncWidgetScaffold<IsUserCrossedState>(
            value: _isUserCrossed,
            data: (data) {
              final _isCrossed = data.when(
                crossed: () => true,
                notCrossed: () => false,
              );

              return WillPopScope(
                onWillPop: () async {
                  final user = ref.read(userNotifierProvider).user;

                  if (_isCrossed) {
                    await ref.read(crossAuthNotifierProvider.notifier).uncross(
                          userId: user.nama!,
                          password: user.password!,
                        );
                  }

                  return true;
                },
                child: VAsyncWidgetScaffold<MstKaryawanCuti>(
                    value: mstCuti,
                    data: (mst) => VAsyncValueWidget(
                          value: cutiApprove,
                          data: (_) => VAsyncWidgetScaffold(
                            value: sendWa,
                            data: (_) => CutiScaffoldTabLayout(
                              /* 
                                Async Values
                              */
                              mst: mst,
                              cutiList: cutiList,
                              isCrossed: _isCrossed,
                              /*
                                Search &  Date Filter
                              */
                              d1: _d1,
                              d2: _d2,
                              searchFocus: _searchFocus,
                              isSearching: _isSearching,
                              lastSearch: _lastSearch,
                              scrollController: scrollController,
                              isScrollStopped: _isScrollStopped,
                              initialDropdown: _initialDropdown ??
                                  _initialDropdownPlaceholder,
                              /*
                                Functions 
                              */
                              onRefresh: onRefresh,
                              onPageChanged: onPageChanged,
                              dateTimeRange: _dateTimeRange,
                              onFieldSubmitted: onFieldSubmitted,
                              onFilterSelected: onFilterSelected,
                              onDropdownChanged: onDropdownChanged,
                            ),
                          ),
                        )),
              );
            }),
      ),
    );
  }
}
