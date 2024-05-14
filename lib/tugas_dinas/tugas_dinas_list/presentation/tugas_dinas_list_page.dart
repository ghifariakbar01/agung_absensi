import 'package:collection/collection.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_approve/application/tugas_dinas_approve_notifier.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_list/application/is_hrd_or_spv_tugas_dinas_list_notifier.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
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
import '../../../routes/application/route_names.dart';
import '../../../shared/providers.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/is_hrd_or_spv_tugas_dinas_list.dart';
import '../application/tugas_dinas_list.dart';

import 'tugas_dinas_list_item.dart';

class TugasDinasListPage extends HookConsumerWidget {
  const TugasDinasListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendWa = ref.watch(sendWaNotifierProvider);
    final tugasdDinasList = ref.watch(tugasDinasListControllerProvider);
    final tugasDinasApprove = ref.watch(tugasDinasApproveControllerProvider);
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
      await ref.read(tugasDinasListControllerProvider.notifier).refresh(
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

    Future<void> onScrolled() async {
      onScrolledVisibility();

      if (_isAtBottom.value == false &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        _isAtBottom.value = true;

        await ref.read(tugasDinasListControllerProvider.notifier).load(
            page: page.value + 1,
            searchUser: _lastSearch.value,
            dateRange: _dateTimeRange.value);

        page.value++;
      }
    }

    final infoMessage = "Ketentuan Tugas Dinas Ketegori Luar Kota \n"
        "1. Input Pengajuan Tugas Dinas maksimal harus di input pada H-3 sebelum keberangkatan, \n"
        "2. Harus sudah Approve atasan maksimal H-3 dari keberangkatan \n"
        "3. dari HR sudah harus di approve maksimal H+1 dari approve atasan. (Perhitungan Hari Berdasarkan Hari Kerja)\n\n"
        "Ketentuan Tugas Dinas Ketegori Selain Luar Kota \n"
        "1. Input tugas dinas dalam kota harus diinput H-0. \n"
        "2. Diapprove atasan H+1 setelah karyawan input. \n"
        "3. Approve HR H+1 setelah atasan approve.\n"
        "4. Tugas dinas kategori Kunjungan diperlukan Approve dari GM";

    useEffect(() {
      scrollController.addListener(onScrolled);
      return () => scrollController.removeListener(onScrolled);
    }, [scrollController]);

    ref.listen<AsyncValue>(crossAuthNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        ref.invalidate(isUserCrossedProvider);
        ref.invalidate(tugasDinasListControllerProvider);
      }
    });

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

    ref.listen<AsyncValue>(tugasDinasApproveControllerProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        if (ModalRoute.of(context)?.isCurrent != true) {
          context.pop();
        }
        return AlertHelper.showSnackBar(
          context,
          onDone: () async {
            ref.invalidate(tugasDinasListControllerProvider);
          },
          color: Palette.primaryColor,
          message: '${state.value} ',
        );
      }
    });

    final errLog = ref.watch(errLogControllerProvider);
    final _isUserCrossed = ref.watch(isUserCrossedProvider);
    final _isHrdOrSpv = ref.watch(isHrdOrSPVTugasDinasListNotifierProvider);

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
                child: VAsyncWidgetScaffold(
                  value: tugasDinasApprove,
                  data: (_) => VAsyncWidgetScaffold(
                    value: sendWa,
                    data: (_) => VAsyncWidgetScaffold<IsHrdOrSPVTugasDinasList>(
                      value: _isHrdOrSpv,
                      data: (data) {
                        final _isActionsVisible = data.when(
                            isHrdOrSpv: () => true,
                            isRegularStaff: () => false);

                        return VScaffoldTabLayout(
                          scaffoldTitle: 'List Form Tugas Dinas',
                          additionalInfo:
                              VAdditionalInfo(infoMessage: infoMessage),
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
                          currPT:
                              _initialDropdown ?? _initialDropdownPlaceholder,
                          isActionsVisible: _isActionsVisible,
                          onPageChanged: onPageChanged,
                          onFieldSubmitted: onFieldSubmitted,
                          onFilterSelected: onFilterSelected,
                          onDropdownChanged: onDropdownChanged,
                          initialDateRange: _dateTimeRange.value,
                          scaffoldBody: [
                            Stack(
                              children: [
                                VAsyncValueWidget<List<TugasDinasList>>(
                                    value: tugasdDinasList,
                                    data: (list) {
                                      final waiting = list
                                          .where((e) =>
                                              (e.spvSta == false ||
                                                  e.hrdSta == false) &&
                                              e.btlSta == false)
                                          .toList();
                                      return _list(_isCrossed, waiting,
                                          onRefresh, scrollController);
                                    }),
                                Positioned(
                                    bottom: 20,
                                    left: 10,
                                    child: SearchFilterInfoWidget(
                                      d1: _d1,
                                      d2: _d2,
                                      lastSearch: _lastSearch.value,
                                      isScrolling: _isScrollStopped.value,
                                    ))
                              ],
                            ),
                            Stack(
                              children: [
                                VAsyncValueWidget<List<TugasDinasList>>(
                                    value: tugasdDinasList,
                                    data: (list) {
                                      final approved = list
                                          .where((e) =>
                                              (e.spvSta == true &&
                                                  e.hrdSta == true) &&
                                              e.btlSta == false)
                                          .toList();
                                      return _list(_isCrossed, approved,
                                          onRefresh, scrollController);
                                    }),
                                Positioned(
                                    bottom: 20,
                                    left: 10,
                                    child: SearchFilterInfoWidget(
                                      d1: _d1,
                                      d2: _d2,
                                      lastSearch: _lastSearch.value,
                                      isScrolling: _isScrollStopped.value,
                                    ))
                              ],
                            ),
                            Stack(
                              children: [
                                VAsyncValueWidget<List<TugasDinasList>>(
                                    value: tugasdDinasList,
                                    data: (list) {
                                      final cancelled = list
                                          .where((e) => e.btlSta == true)
                                          .toList();
                                      return _list(_isCrossed, cancelled,
                                          onRefresh, scrollController);
                                    }),
                                Positioned(
                                    bottom: 20,
                                    left: 10,
                                    child: SearchFilterInfoWidget(
                                      d1: _d1,
                                      d2: _d2,
                                      lastSearch: _lastSearch.value,
                                      isScrolling: _isScrollStopped.value,
                                    ))
                              ],
                            ),
                          ],
                        );
                      },
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
