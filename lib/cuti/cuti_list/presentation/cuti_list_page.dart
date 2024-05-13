import 'package:collection/collection.dart';
import 'package:face_net_authentication/cuti/cuti_approve/application/cuti_approve_notifier.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
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
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../routes/application/route_names.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../shared/providers.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';

import '../../../style/style.dart';
import '../application/cuti_list.dart';
import '../application/cuti_list_notifier.dart';

import 'cuti_list_item.dart';

class CutiListPage extends HookConsumerWidget {
  const CutiListPage();
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
          //
          searchUser: _lastSearch.value,
          dateRange: _dateTimeRange.value);
      return Future.value();
    };

    final onPageChanged = () async {
      page.value = 0;
      _resetScroll();
      await ref.read(cutiListControllerProvider.notifier).refresh(
          //
          searchUser: _lastSearch.value,
          dateRange: _dateTimeRange.value);
      return Future.value();
    };

    final onFieldSubmitted = (String value) async {
      page.value = 0;
      _resetScroll();

      _lastSearch.value = value;
      await ref.read(cutiListControllerProvider.notifier).refresh(
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

    ref.listen<AsyncValue>(crossAuthNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        ref.invalidate(isUserCrossedProvider);
        ref.invalidate(cutiListControllerProvider);
        ref.invalidate(mstKaryawanCutiNotifierProvider);
      }
    });

    ref.listen<AsyncValue>(cutiApproveControllerProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          onDone: () async {
            ref.invalidate(cutiListControllerProvider);
            ref.invalidate(mstKaryawanCutiNotifierProvider);
          },
          color: Palette.primaryColor,
          message: '${state.value} ',
        );
      } else {
        return state.showAlertDialogOnError(context, ref);
      }
    });

    ref.listen<AsyncValue>(mstKaryawanCutiNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    Future<void> onScrolled() async {
      onScrolledVisibility();

      if (_isAtBottom.value == false &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        _isAtBottom.value = true;

        await ref.read(cutiListControllerProvider.notifier).load(
            page: page.value + 1,
            searchUser: _lastSearch.value,
            dateRange: _dateTimeRange.value);

        page.value++;
      }
    }

    useEffect(() {
      scrollController.addListener(onScrolled);
      return () => scrollController.removeListener(onScrolled);
    }, [scrollController]);

    final errLog = ref.watch(errLogControllerProvider);
    final _isUserCrossed = ref.watch(isUserCrossedProvider);

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
                            data: (_) => VScaffoldTabLayout(
                              scaffoldTitle: 'List Form Cuti',
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
                              currPT: _initialDropdown,
                              onPageChanged: onPageChanged,
                              onFieldSubmitted: onFieldSubmitted,
                              onFilterSelected: onFilterSelected,
                              onDropdownChanged: onDropdownChanged,
                              initialDateRange: _dateTimeRange.value,
                              scaffoldBody: [
                                Stack(
                                  children: [
                                    VAsyncValueWidget<List<CutiList>>(
                                        value: cutiList,
                                        data: (list) {
                                          final waiting = list
                                              .where((e) =>
                                                  (e.spvSta == false ||
                                                      e.hrdSta == false) &&
                                                  e.btlSta == false)
                                              .toList();
                                          return _list(
                                            _isCrossed,
                                            mst,
                                            waiting,
                                            onRefresh,
                                            scrollController,
                                          );
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
                                    VAsyncValueWidget<List<CutiList>>(
                                        value: cutiList,
                                        data: (list) {
                                          final approved = list
                                              .where((e) =>
                                                  (e.spvSta == true &&
                                                      e.hrdSta == true) &&
                                                  e.btlSta == false)
                                              .toList();
                                          return _list(
                                            _isCrossed,
                                            mst,
                                            approved,
                                            onRefresh,
                                            scrollController,
                                          );
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
                                    VAsyncValueWidget<List<CutiList>>(
                                        value: cutiList,
                                        data: (list) {
                                          final cancelled = list
                                              .where((e) => e.btlSta == true)
                                              .toList();
                                          return _list(
                                            _isCrossed,
                                            mst,
                                            cancelled,
                                            onRefresh,
                                            scrollController,
                                          );
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
                            ),
                          ),
                        )),
              );
            }),
      ),
    );
  }
}

Widget _list(
  bool _isCrossed,
  MstKaryawanCuti mst,
  List<CutiList> list,
  Future<void> Function() onRefresh,
  ScrollController scrollController,
) {
  return RefreshIndicator(
      onRefresh: onRefresh,
      child: list.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 16.0, right: 16.0, bottom: 0),
              child: Container(
                height: 100,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Palette.greyDisabled.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isCrossed
                    ? Center(
                        child: Text(
                          'Sedang Melintas Server',
                          style: Themes.customColor(8,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              "1. Cuti Tahunan wajib diinput paling lambat H-5.\n"
                              "2. Persetujuan atasan paling lambat H+3 dari Tanggal penginputan Cuti.\n"
                              "3. Cuti Emergency dan Cuti Bersama dapat diinput pada hari H.\n"
                              "4. Total Hari dihitung berdasarkan Hari Kerja. (Tidak termasuk Tanggal Merah) '",
                              style: Themes.customColor(8,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Saldo Cuti \n(${mst.cutiBaru != 0 ? mst.tahunCutiBaru : mst.tahunCutiTidakBaru} )',
                                style: Themes.customColor(10,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${mst.cutiBaru != 0 ? mst.cutiBaru : mst.cutiTidakBaru}',
                                style: Themes.customColor(20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
              ),
            )
          : ListView.separated(
              controller: scrollController,
              separatorBuilder: (__, index) => SizedBox(
                    height: 8,
                  ),
              itemCount: list.length + 1,
              itemBuilder: (BuildContext context, int index) => index ==
                      list.length
                  ? SizedBox(
                      height: 50,
                    )
                  : index == 0
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Palette.greyDisabled.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _isCrossed
                                    ? Center(
                                        child: Text(
                                          'Sedang Melintas Server',
                                          style: Themes.customColor(8,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              "1. Cuti Tahunan wajib diinput paling lambat H-5.\n"
                                              "2. Persetujuan atasan paling lambat H+3 dari Tanggal penginputan Cuti.\n"
                                              "3. Cuti Emergency dan Cuti Bersama dapat diinput pada hari H.\n"
                                              "4. Total Hari dihitung berdasarkan Hari Kerja. (Tidak termasuk Tanggal Merah) '",
                                              style: Themes.customColor(8,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Saldo Cuti \n(${mst.cutiBaru != 0 ? mst.tahunCutiBaru : mst.tahunCutiTidakBaru} )',
                                                style: Themes.customColor(10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                '${mst.cutiBaru != 0 ? mst.cutiBaru : mst.cutiTidakBaru}',
                                                style: Themes.customColor(20,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CutiListItem(list[index])
                          ],
                        )
                      : CutiListItem(list[index])));
}
