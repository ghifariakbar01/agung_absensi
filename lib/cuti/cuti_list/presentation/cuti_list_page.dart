import 'package:face_net_authentication/cuti/cuti_approve/application/cuti_approve_notifier.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../routes/application/route_names.dart';
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
    ref.listen<AsyncValue>(mstKaryawanCutiNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final mstCuti = ref.watch(mstKaryawanCutiNotifierProvider);
    final cutiList = ref.watch(cutiListControllerProvider);

    final scrollController = useScrollController();

    final page = useState(0);

    void onScrolled() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        page.value++;

        ref.read(cutiListControllerProvider.notifier).load(
              page: page.value + 1,
            );
      }
    }

    useEffect(() {
      scrollController.addListener(onScrolled);
      return () => scrollController.removeListener(onScrolled);
    }, [scrollController]);

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

    final onRefresh = () async {
      page.value = 0;
      await ref.read(mstKaryawanCutiNotifierProvider.notifier).refresh();
      await ref.read(cutiListControllerProvider.notifier).refresh();
      return Future.value();
    };

    final onPageChanged = () async {
      page.value = 0;
      await ref.read(cutiListControllerProvider.notifier).refresh();
      return Future.value();
    };

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold<MstKaryawanCuti>(
          value: mstCuti,
          data: (mst) {
            return VScaffoldTabLayout(
              scaffoldTitle: 'List Form Cuti',
              scaffoldFAB: FloatingActionButton.small(
                  backgroundColor: Palette.primaryColor,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => context.pushNamed(
                        RouteNames.createCutiNameRoute,
                      )),
              onPageChanged: onPageChanged,
              scaffoldBody: [
                VAsyncValueWidget<List<CutiList>>(
                    value: cutiList,
                    data: (list) {
                      final waiting = list
                          .where((e) =>
                              (e.spvSta == false || e.hrdSta == false) &&
                              e.btlSta == false)
                          .toList();
                      return _list(mst, waiting, scrollController, onRefresh);
                    }),
                VAsyncValueWidget<List<CutiList>>(
                    value: cutiList,
                    data: (list) {
                      final approved = list
                          .where((e) =>
                              (e.spvSta == true || e.hrdSta == true) &&
                              e.btlSta != true)
                          .toList();
                      return _list(mst, approved, scrollController, onRefresh);
                    }),
                VAsyncValueWidget<List<CutiList>>(
                    value: cutiList,
                    data: (list) {
                      final cancelled =
                          list.where((e) => e.btlSta == true).toList();
                      return _list(mst, cancelled, scrollController, onRefresh);
                    }),
              ],
            );
          }),
    );
  }
}

Widget _list(MstKaryawanCuti mst, List<CutiList> list,
    ScrollController scrollController, Future<void> Function() onRefresh) {
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
                child: Row(
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
                        style:
                            Themes.customColor(8, fontWeight: FontWeight.bold),
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
                              color: Colors.red, fontWeight: FontWeight.bold),
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CutiListItem(list[index])
                          ],
                        )
                      : CutiListItem(list[index])));
}
