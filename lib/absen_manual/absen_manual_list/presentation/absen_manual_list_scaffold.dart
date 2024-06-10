import 'package:collection/collection.dart';
import 'package:face_net_authentication/cross_auth/application/cross_auth_notifier.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/search_filter_info_widget.dart';
import '../../../cross_auth/application/is_user_crossed.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../helper.dart';
import '../../../routes/application/route_names.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/v_additional_info.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../../absen_manual_approve/application/absen_manual_approve_notifier.dart';
import '../application/absen_manual_list.dart';
import '../application/absen_manual_list_notifier.dart';
import 'absen_manual_list_item.dart';

class AbsenManualListScaffold extends HookConsumerWidget
    with DialogHelper, CalendarHelper {
  const AbsenManualListScaffold(this.mapPT);

  final Map<String, List<String>> mapPT;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendWa = ref.watch(sendWaNotifierProvider);
    final crossAuth = ref.watch(crossAuthNotifierProvider);
    final absenManualList = ref.watch(absenManualListControllerProvider);
    final absenApprove = ref.watch(absenManualApproveControllerProvider);

    final scrollController = useScrollController();
    final page = useState(0);

    /* 
      Search and Filter Date
      values
    */
    final _lastSearch = useState('');
    final _dateTimeRange = useState(CalendarHelper.initialDateRange());

    /* 
      _
    */
    final _d1 = DateFormat('dd MMMM y').format(_dateTimeRange.value.start);
    final _d2 = DateFormat('dd MMMM y').format(_dateTimeRange.value.end);

    final _isScrollStopped = useState(false);

    void _resetScroll() {
      if (scrollController.hasClients) {
        _isScrollStopped.value = false;
        scrollController.jumpTo(0.0);
      }
    }

    final onRefresh = () async {
      page.value = 0;
      _resetScroll();

      await ref.read(absenManualListControllerProvider.notifier).search(
          //
          searchUser: _lastSearch.value,
          dateRange: _dateTimeRange.value);
      return Future.value();
    };

    final onFieldSubmitted = (String value) async {
      page.value = 0;
      _resetScroll();

      _lastSearch.value = value;
      await ref.read(absenManualListControllerProvider.notifier).search(
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
      await ref.read(absenManualListControllerProvider.notifier).search(
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

    ref.listen<AsyncValue>(absenManualListControllerProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        _isAtBottom.value = false;
      }

      return state.showAlertDialogOnError(context, ref);
    });

    useEffect(
      () {
        scrollController.addListener(onScrolledVisibility);
        return () => scrollController.removeListener(onScrolledVisibility);
      },
    );

    final infoMessage =
        "1. Absen Manual Di input Maks H=0 dan di approve oleh atasan dan HR maks H+1\n"
        "2. WFH : khusus untuk karyawan yang bekerja dari rumah (work from home)\n"
        "3. Absen Harian : untuk karyawan yang lokasi kerjanya tidak tersedia mesin finger print.\n"
        "4. Absen Lainnya / Kasus : untuk kasus-kasus tidak melakukan finger print karena listrik mati, mesin error / rusak, sidik jari tidak terbaca, lupa absen, jaringan trouble / internet mati saat akan input absen manual dll.";

    final errLog = ref.watch(errLogControllerProvider);
    final _isUserCrossed = ref.watch(isUserCrossedProvider);

    final _isSearching = useState(false);
    final _searchFocus = useFocusNode();

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold(
        value: crossAuth,
        data: (_) => VAsyncWidgetScaffold(
          value: sendWa,
          data: (_) => VAsyncWidgetScaffold(
            value: absenApprove,
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
                        await ref
                            .read(crossAuthNotifierProvider.notifier)
                            .uncross(
                              userId: user.nama!,
                              password: user.password!,
                            );
                      }

                      return true;
                    },
                    child: VScaffoldTabLayout(
                      scaffoldTitle: 'Absen Manual',
                      mapPT: mapPT,
                      additionalInfo: VAdditionalInfo(infoMessage: infoMessage),
                      currPT: _initialDropdown ?? _initialDropdownPlaceholder,
                      searchFocus: _searchFocus,
                      isSearching: _isSearching,
                      onPageChanged: onRefresh,
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
                                    RouteNames.createAbsenManualNameRoute,
                                  )),
                      bottomLeftWidget: SearchFilterInfoWidget(
                        d1: _d1,
                        d2: _d2,
                        lastSearch: _lastSearch.value,
                        isScrolling: _isScrollStopped.value,
                        onTapName: () {
                          _isSearching.value = true;
                          _searchFocus.requestFocus();
                        },
                        onTapDate: () => CalendarHelper.callCalendar(
                            context, onFilterSelected),
                      ),
                      scaffoldBody: [
                        VAsyncValueWidget<List<AbsenManualList>>(
                            value: absenManualList,
                            data: (list) {
                              final waiting = list
                                  .where((e) =>
                                      (e.spvSta == false ||
                                          e.hrdSta == false) &&
                                      e.btlSta == false)
                                  .toList();
                              return _list(
                                _isCrossed,
                                waiting,
                                onRefresh,
                                scrollController,
                              );
                            }),
                        VAsyncValueWidget<List<AbsenManualList>>(
                            value: absenManualList,
                            data: (list) {
                              final approved = list
                                  .where((e) =>
                                      (e.spvSta == true && e.hrdSta == true) &&
                                      e.btlSta == false)
                                  .toList();
                              return _list(
                                _isCrossed,
                                approved,
                                onRefresh,
                                scrollController,
                              );
                            }),
                        VAsyncValueWidget<List<AbsenManualList>>(
                            value: absenManualList,
                            data: (list) {
                              final cancelled =
                                  list.where((e) => e.btlSta == true).toList();
                              return _list(
                                _isCrossed,
                                cancelled,
                                onRefresh,
                                scrollController,
                              );
                            }),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _list(
    bool _isCrossed,
    List<AbsenManualList> list,
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
                                top: 10.0, left: 16.0, right: 16.0, bottom: 0),
                            child: Container(
                                height: 35,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Palette.greyDisabled.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Sedang Melintas Server',
                                    style: Themes.customColor(8,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          )
                        ],
                        SizedBox(
                          height: 10,
                        ),
                        AbsenManualListItem(list[index])
                      ],
                    )
                  : AbsenManualListItem(list[index])),
    );
  }
}
