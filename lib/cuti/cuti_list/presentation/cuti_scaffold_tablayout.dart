import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/search_filter_info_widget.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../routes/application/route_names.dart';
import '../../../style/style.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../application/cuti_list.dart';
import 'cuti_list_widget.dart';

class CutiScaffoldTabLayout extends ConsumerWidget {
  const CutiScaffoldTabLayout({
    required this.initialDropdown,
    required this.searchFocus,
    required this.isSearching,
    required this.onPageChanged,
    required this.dateTimeRange,
    required this.onFieldSubmitted,
    required this.onFilterSelected,
    required this.onDropdownChanged,
    required this.scrollController,
    required this.isCrossed,
    required this.onRefresh,
    required this.d1,
    required this.d2,
    required this.lastSearch,
    required this.mst,
    required this.isScrollStopped,
    required this.cutiList,
  });

  /*
  
  */
  final AsyncValue<List<CutiList>> cutiList;
  final MstKaryawanCuti mst;

  /*
  
  */
  final List<String> initialDropdown;
  final FocusNode searchFocus;
  final String d1;
  final String d2;
  final ScrollController scrollController;
  final ValueNotifier<String> lastSearch;
  final ValueNotifier<bool> isScrollStopped;
  final ValueNotifier<bool> isSearching;
  final bool isCrossed;
  final ValueNotifier<DateTimeRange> dateTimeRange;

  /*

  */
  final Future<void> Function() onRefresh;
  final Future<void> Function() onPageChanged;
  final Future<void> Function(String value) onFieldSubmitted;
  final Future<void> Function(List<String> value) onDropdownChanged;
  final Future<void> Function(DateTimeRange value) onFilterSelected;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _oneMonth = Duration(days: 30);
    final _oneDay = Duration(days: 1);
    final _initialDateRange = DateTimeRange(
      end: DateTime.now().add(_oneDay),
      start: DateTime.now().subtract(_oneMonth),
    );

    return VScaffoldTabLayout(
      isActionsVisible: true,
      scaffoldTitle: 'List Form Cuti',
      currPT: initialDropdown,
      searchFocus: searchFocus,
      isSearching: isSearching,
      onPageChanged: onPageChanged,
      onFieldSubmitted: onFieldSubmitted,
      onFilterSelected: onFilterSelected,
      onDropdownChanged: onDropdownChanged,
      initialDateRange: dateTimeRange.value,
      scaffoldFAB: isCrossed
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
        d1: d1,
        d2: d2,
        lastSearch: lastSearch.value,
        isScrolling: isScrollStopped.value,
        onTapName: () {
          isSearching.value = true;
          searchFocus.requestFocus();
        },
        onTapDate: () async {
          final _oneMonth = Duration(days: 30);

          final picked = await showDateRangePicker(
              context: context,
              initialDateRange: _initialDateRange,
              firstDate: DateTime.now().subtract(_oneMonth),
              lastDate: DateTime.now().add(Duration(days: 1)));

          if (picked != null) {
            print(picked);

            onFilterSelected(picked);
          }
        },
      ),
      scaffoldBody: [
        VAsyncValueWidget<List<CutiList>>(
            value: cutiList,
            data: (list) {
              final waiting = list
                  .where((e) =>
                      (e.spvSta == false || e.hrdSta == false) &&
                      e.btlSta == false)
                  .toList();

              return CutiListWidget(
                isCrossed,
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
                      (e.spvSta == true && e.hrdSta == true) &&
                      e.btlSta == false)
                  .toList();
              return CutiListWidget(
                isCrossed,
                mst,
                approved,
                onRefresh,
                scrollController,
              );
            }),
        VAsyncValueWidget<List<CutiList>>(
            value: cutiList,
            data: (list) {
              final cancelled = list.where((e) => e.btlSta == true).toList();
              return CutiListWidget(
                isCrossed,
                mst,
                cancelled,
                onRefresh,
                scrollController,
              );
            }),
      ],
    );
  }
}
