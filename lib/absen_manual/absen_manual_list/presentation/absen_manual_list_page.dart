import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/search_filter_info_widget.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../send_wa/application/send_wa_notifier.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_additional_info.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../../absen_manual_approve/application/absen_manual_approve_notifier.dart';
import '../application/absen_manual_list.dart';
import '../application/absen_manual_list_notifier.dart';
import 'absen_manual_list_item.dart';

class AbsenManualListPage extends HookConsumerWidget {
  const AbsenManualListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(absenManualListControllerProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final sendWa = ref.watch(sendWaNotifierProvider);
    final absenManualList = ref.watch(absenManualListControllerProvider);
    final absenApprove = ref.watch(absenManualApproveControllerProvider);

    ref.listen<AsyncValue>(absenManualApproveControllerProvider, (_, state) {
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
            ref.invalidate(absenManualListControllerProvider);
          },
          color: Palette.primaryColor,
          message: '${state.value} ',
        );
      }
    });

    final scrollController = useScrollController();
    final page = useState(0);

    final _oneMonth = Duration(days: 30);
    final _initialDateRange = DateTimeRange(
      end: DateTime.now(),
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

    final onRefresh = () async {
      page.value = 0;
      await ref.read(absenManualListControllerProvider.notifier).search(
          //
          searchUser: _lastSearch.value,
          dateRange: _dateTimeRange.value);
      return Future.value();
    };

    final onFieldSubmitted = (String value) async {
      page.value = 0;
      _lastSearch.value = value;
      await ref.read(absenManualListControllerProvider.notifier).search(
          //
          searchUser: value,
          dateRange: _dateTimeRange.value);
      return Future.value();
    };

    final onFilterSelected = (DateTimeRange value) async {
      _dateTimeRange.value = value;
      page.value = 0;
      await ref.read(absenManualListControllerProvider.notifier).search(
            dateRange: value,
            searchUser: _lastSearch.value,
          );
      return Future.value();
    };

    void onScrolled() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        ref.read(absenManualListControllerProvider.notifier).load(
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

    final infoMessage =
        "1. Absen Manual Di input Maks H=0 dan di approve oleh atasan dan HR maks H+1\n"
        "2. WFH : khusus untuk karyawan yang bekerja dari rumah (work from home)\n"
        "3. Absen Harian : untuk karyawan yang lokasi kerjanya tidak tersedia mesin finger print.\n"
        "4. Absen Lainnya / Kasus : untuk kasus-kasus tidak melakukan finger print karena listrik mati, mesin error / rusak, sidik jari tidak terbaca, lupa absen, jaringan trouble / internet mati saat akan input absen manual dll.";

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold(
        value: absenApprove,
        data: (_) => VAsyncWidgetScaffold(
          value: sendWa,
          data: (_) => VScaffoldTabLayout(
            scaffoldTitle: 'Absen Manual',
            additionalInfo: VAdditionalInfo(infoMessage: infoMessage),
            scaffoldFAB: FloatingActionButton.small(
                backgroundColor: Palette.primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => context.pushNamed(
                      RouteNames.createAbsenManualNameRoute,
                    )),
            onPageChanged: onRefresh,
            onFieldSubmitted: onFieldSubmitted,
            onFilterSelected: onFilterSelected,
            initialDateRange: _dateTimeRange.value,
            scaffoldBody: [
              Stack(
                children: [
                  VAsyncValueWidget<List<AbsenManualList>>(
                      value: absenManualList,
                      data: (list) {
                        final waiting = list
                            .where((e) =>
                                (e.spvSta == false || e.hrdSta == false) &&
                                e.btlSta == false)
                            .toList();
                        return _list(scrollController, waiting, onRefresh);
                      }),
                  Positioned(
                      bottom: 20,
                      left: 10,
                      child: SearchFilterInfoWidget(
                        d1: _d1,
                        d2: _d2,
                        lastSearch: _lastSearch.value,
                      ))
                ],
              ),
              Stack(
                children: [
                  VAsyncValueWidget<List<AbsenManualList>>(
                      value: absenManualList,
                      data: (list) {
                        final approved = list
                            .where((e) =>
                                (e.spvSta == true && e.hrdSta == true) &&
                                e.btlSta == false)
                            .toList();
                        return _list(scrollController, approved, onRefresh);
                      }),
                  Positioned(
                      bottom: 20,
                      left: 10,
                      child: SearchFilterInfoWidget(
                        d1: _d1,
                        d2: _d2,
                        lastSearch: _lastSearch.value,
                      ))
                ],
              ),
              Stack(
                children: [
                  VAsyncValueWidget<List<AbsenManualList>>(
                      value: absenManualList,
                      data: (list) {
                        final cancelled =
                            list.where((e) => e.btlSta == true).toList();
                        return _list(scrollController, cancelled, onRefresh);
                      }),
                  Positioned(
                      bottom: 20,
                      left: 10,
                      child: SearchFilterInfoWidget(
                        d1: _d1,
                        d2: _d2,
                        lastSearch: _lastSearch.value,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list(ScrollController scrollController, List<AbsenManualList> list,
      Future<void> Function() onRefresh) {
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
