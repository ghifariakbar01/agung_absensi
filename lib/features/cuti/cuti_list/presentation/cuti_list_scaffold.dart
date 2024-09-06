import 'package:collection/collection.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/search_filter_info_widget.dart';
import '../../../cross_auth/application/cross_auth_notifier.dart';
import '../../../cross_auth/application/is_user_crossed.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../../../../helper.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../../shared/providers.dart';
import '../../../../style/style.dart';
import '../../../user/application/user_notifier.dart';
import '../../../../widgets/v_async_widget.dart';
import '../../../../widgets/v_scaffold_widget.dart';
import '../../cuti_approve/application/cuti_approve_notifier.dart';
import '../application/cuti_list.dart';
import '../application/cuti_list_notifier.dart';
import 'cuti_list_widget.dart';

class CutiListScaffold extends HookConsumerWidget {
  CutiListScaffold(this.mapPT);

  final Map<String, List<String>> mapPT;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mstCuti = ref.watch(mstKaryawanCutiNotifierProvider);
    final cutiApprove = ref.watch(cutiApproveControllerProvider);
    final cutiList = ref.watch(cutiListControllerProvider);
    final crossAuth = ref.watch(crossAuthNotifierProvider);

    /* 
      Search and Filter Date
      values
    */
    final _lastSearch = useState('');
    final _dateTimeRange = useState(CalendarHelper.initialDateRange());

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

    final _initialDropdownPlaceholder = ['ACT', 'Transina', 'ALR'];
    final _currPT = ref.watch(userNotifierProvider).user.ptServer;
    final _initialDropdown = mapPT.entries
        .firstWhereOrNull((element) => element.key == _currPT)
        ?.value;

    final _dropdownValue = useState(_initialDropdown);

    final onDropdownChanged = (List<String> value) async {
      page.value = 0;
      _resetScroll();

      _dropdownValue.value = value;
      final user = ref.read(userNotifierProvider).user;

      final _ptMap = await ref
          .read(firebaseRemoteConfigNotifierProvider.notifier)
          .getPtMap();

      await ref.read(crossAuthNotifierProvider.notifier).cross(
            userId: user.nama!,
            password: user.password!,
            pt: _dropdownValue.value ?? ['ACT', 'Transina', 'ALR'],
            url: _ptMap,
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

    final _isAtBottom = useState(false);

    void onScrolledVisibility() {
      scrollController.position.isScrollingNotifier.addListener(() {
        if (scrollController.position.pixels > 0.0) {
          _isScrollStopped.value = true;
        } else {
          _isScrollStopped.value = false;
        }

        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          _isAtBottom.value = true;
        } else {
          _isAtBottom.value = false;
        }
      });
    }

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
    final _userHasStaff = ref.watch(userHasStaffProvider);
    final _isUserCrossed = ref.watch(isUserCrossedProvider);

    final _isSearching = useState(false);
    final _searchFocus = useFocusNode();

    final _isDonePopping = useState(false);

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

              return PopScope(
                  canPop: _isDonePopping.value,
                  onPopInvoked: (_) async {
                    _isDonePopping.value = false;

                    final user = ref.read(userNotifierProvider).user;
                    final _rmt = await ref
                        .read(firebaseRemoteConfigNotifierProvider.future);

                    if (_isCrossed) {
                      await ref
                          .read(crossAuthNotifierProvider.notifier)
                          .uncross(
                            userId: user.nama!,
                            password: user.password!,
                            url: _rmt.ptMap,
                          );
                    }

                    _isDonePopping.value = true;
                  },
                  child: VAsyncWidgetScaffold<MstKaryawanCuti>(
                    value: mstCuti,
                    data: (mst) => VAsyncValueWidget(
                        value: cutiApprove,
                        data: (_) => VAsyncValueWidget<bool>(
                              value: _userHasStaff,
                              data: (s) => VScaffoldTabLayout(
                                scaffoldTitle: 'Cuti',
                                mapPT: mapPT,
                                currPT: _initialDropdown ??
                                    _initialDropdownPlaceholder,
                                isSearchVisible: s,
                                searchFocus: _searchFocus,
                                isSearching: _isSearching,
                                onPageChanged: onPageChanged,
                                onFieldSubmitted: onFieldSubmitted,
                                onFilterSelected: onFilterSelected,
                                onDropdownChanged: onDropdownChanged,
                                initialDateRange: _dateTimeRange.value,
                                scaffoldFAB: _isCrossed
                                    ? Container()
                                    : FloatingActionButton.small(
                                        backgroundColor: Palette.primaryColor,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => context.pushNamed(
                                              RouteNames.createCutiNameRoute,
                                            )),
                                bottomLeftWidget: SearchFilterInfoWidget(
                                  d1: _d1,
                                  d2: _d2,
                                  isSearchVisible: s,
                                  lastSearch: _lastSearch.value,
                                  isScrolling: _isScrollStopped.value,
                                  isBottom: _isAtBottom.value,
                                  onTapName: () {
                                    _isSearching.value = true;
                                    _searchFocus.requestFocus();
                                  },
                                  onTapDate: () => CalendarHelper.callCalendar(
                                      context, onFilterSelected),
                                ),
                                scaffoldBody: [
                                  VAsyncValueWidget<List<CutiList>>(
                                      value: cutiList,
                                      data: (list) {
                                        final waiting = list
                                            .where((e) =>
                                                (e.spvSta == false ||
                                                    e.hrdSta == false) &&
                                                e.btlSta == false)
                                            .toList();

                                        return CutiListWidget(
                                          _isCrossed,
                                          mst,
                                          waiting,
                                          onRefresh,
                                          scrollController,
                                        );
                                      }),
                                  VAsyncValueWidget<List<CutiList>>(
                                      value: cutiList,
                                      data: (list) {
                                        final approved = list
                                            .where((e) =>
                                                (e.spvSta == true &&
                                                    e.hrdSta == true) &&
                                                e.btlSta == false)
                                            .toList();
                                        return CutiListWidget(
                                          _isCrossed,
                                          mst,
                                          approved,
                                          onRefresh,
                                          scrollController,
                                        );
                                      }),
                                  VAsyncValueWidget<List<CutiList>>(
                                      value: cutiList,
                                      data: (list) {
                                        final cancelled = list
                                            .where((e) => e.btlSta == true)
                                            .toList();
                                        return CutiListWidget(
                                          _isCrossed,
                                          mst,
                                          cancelled,
                                          onRefresh,
                                          scrollController,
                                        );
                                      }),
                                ],
                              ),
                            )),
                  ));
            }),
      ),
    );
  }
}
