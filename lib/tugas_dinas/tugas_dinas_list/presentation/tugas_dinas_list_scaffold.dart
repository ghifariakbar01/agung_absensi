import 'package:collection/collection.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_approve/application/tugas_dinas_approve_notifier.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_additional_info.dart';
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
import '../../../helper.dart';
import '../../../routes/application/route_names.dart';
import '../../../shared/providers.dart';
import '../../../user/application/user_notifier.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/tugas_dinas_list.dart';

import 'tugas_dinas_list_item.dart';

class TugasDinasListScaffold extends HookConsumerWidget
    with DialogHelper, CalendarHelper {
  const TugasDinasListScaffold(this.mapPT);

  final Map<String, List<String>> mapPT;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tugasdDinasList = ref.watch(tugasDinasListControllerProvider);
    final tugasDinasApprove = ref.watch(tugasDinasApproveControllerProvider);
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

      await ref.read(tugasDinasListControllerProvider.notifier).refresh(
          //
          searchUser: _lastSearch.value,
          dateRange: _dateTimeRange.value);
      return Future.value();
    };

    final onPageChanged = () async {
      page.value = 0;
      _resetScroll();

      await ref.read(tugasDinasListControllerProvider.notifier).refresh(
          //
          searchUser: _lastSearch.value,
          dateRange: _dateTimeRange.value);
      return Future.value();
    };

    final onFieldSubmitted = (String value) async {
      page.value = 0;
      _resetScroll();

      _lastSearch.value = value;
      await ref.read(tugasDinasListControllerProvider.notifier).refresh(
          //
          searchUser: value,
          dateRange: _dateTimeRange.value);
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
      await ref.read(tugasDinasListControllerProvider.notifier).refresh(
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

    final infoMessage = [
      "<SUB>Ketentuan Tugas Dinas Ketegori Luar Kota<SUB>",
      "Input Pengajuan Tugas Dinas maksimal harus di input pada H-3 sebelum keberangkatan, ",
      "Harus sudah Approve atasan maksimal H-3 dari keberangkatan ",
      "Dari HR sudah harus di approve maksimal H+1 dari approve atasan. (Perhitungan Hari Berdasarkan Hari Kerja)",
    ];

    final infoMessage2 = [
      "<SUB>Ketentuan Tugas Dinas Ketegori Selain Luar Kota<SUB>",
      "Input tugas dinas dalam kota harus diinput H-0. ",
      "Diapprove atasan H+1 setelah karyawan input. ",
      "Approve HR H+1 setelah atasan approve.",
      "Tugas dinas kategori Kunjungan diperlukan Approve dari GM",
    ];

    useEffect(() {
      scrollController.addListener(onScrolledVisibility);
      return () => scrollController.removeListener(onScrolledVisibility);
    }, [scrollController]);

    ref.listen<AsyncValue>(tugasDinasListControllerProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        _isAtBottom.value = false;
      }

      return state.showAlertDialogOnError(context, ref);
    });

    final errLog = ref.watch(errLogControllerProvider);
    final _userHasStaff = ref.watch(userHasStaffProvider);
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

                  final _ptMap = await ref
                      .read(firebaseRemoteConfigNotifierProvider.notifier)
                      .getPtMap();

                  if (_isCrossed) {
                    await ref.read(crossAuthNotifierProvider.notifier).uncross(
                          userId: user.nama!,
                          password: user.password!,
                          url: _ptMap,
                        );
                  }

                  return true;
                },
                child: VAsyncWidgetScaffold(
                  value: tugasDinasApprove,
                  data: (_) => VAsyncWidgetScaffold<bool>(
                    value: _userHasStaff,
                    data: (s) => VScaffoldTabLayout(
                      scaffoldTitle: 'Tugas Dinas',
                      mapPT: mapPT,
                      additionalInfo: VAdditionalInfo(
                          infoMessage: [infoMessage, infoMessage2]),
                      isSearchVisible: s,
                      currPT: _initialDropdown ?? _initialDropdownPlaceholder,
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
                                    RouteNames.createTugasDinasNameRoute,
                                  )),
                      bottomLeftWidget: SearchFilterInfoWidget(
                        d1: _d1,
                        d2: _d2,
                        isSearchVisible: s,
                        isBottom: _isAtBottom.value,
                        lastSearch: _lastSearch.value,
                        isScrolling: _isScrollStopped.value,
                        onTapName: () {
                          _isSearching.value = true;
                          _searchFocus.requestFocus();
                        },
                        onTapDate: () => CalendarHelper.callCalendar(
                          context,
                          onFilterSelected,
                        ),
                      ),
                      scaffoldBody: [
                        VAsyncValueWidget<List<TugasDinasList>>(
                            value: tugasdDinasList,
                            data: (list) {
                              final waiting = list
                                  .where((e) =>
                                      (e.spvSta == false ||
                                          e.hrdSta == false ||
                                          e.gmSta == false ||
                                          e.cooSta == false) &&
                                      e.btlSta == false)
                                  .toList();
                              return _list(_isCrossed, waiting, onRefresh,
                                  scrollController);
                            }),
                        VAsyncValueWidget<List<TugasDinasList>>(
                            value: tugasdDinasList,
                            data: (list) {
                              final approved = list
                                  .where((e) =>
                                      (e.spvSta == true &&
                                          e.hrdSta == true &&
                                          e.gmSta == true &&
                                          e.cooSta == true) &&
                                      e.btlSta == false)
                                  .toList();
                              return _list(_isCrossed, approved, onRefresh,
                                  scrollController);
                            }),
                        VAsyncValueWidget<List<TugasDinasList>>(
                            value: tugasdDinasList,
                            data: (list) {
                              final cancelled =
                                  list.where((e) => e.btlSta == true).toList();
                              return _list(_isCrossed, cancelled, onRefresh,
                                  scrollController);
                            }),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _list(
    bool _isCrossed,
    List<TugasDinasList> list,
    Future<void> Function() onRefresh,
    ScrollController scrollController,
  ) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
          controller: scrollController,
          separatorBuilder: (__, index) => SizedBox(
                height: 8,
              ),
          itemCount: list.length + 1,
          itemBuilder: (BuildContext context, int index) => index == list.length
              ? SizedBox(
                  height: 50,
                )
              : index == 0
                  ? Column(
                      children: [
                        if (_isCrossed) ...[
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 0),
                              child: Container(
                                  height: 35,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        Palette.greyDisabled.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sedang Melintas Server',
                                      style: Themes.customColor(8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))),
                        ],
                        SizedBox(
                          height: 10,
                        ),
                        TugasDinasListItem(list[index])
                      ],
                    )
                  : TugasDinasListItem(list[index])),
    );
  }
}
