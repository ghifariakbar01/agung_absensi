import 'package:face_net_authentication/cuti/cuti_approve/application/cuti_approve_notifier.dart';
import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../routes/application/route_names.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';

import '../../../style/style.dart';
import '../../create_cuti/application/create_cuti_notifier.dart';
import '../application/cuti_list.dart';
import '../application/cuti_list_notifier.dart';

import 'cuti_list_item.dart';

class CutiListPage extends HookConsumerWidget {
  const CutiListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen<AsyncValue>(mstKaryawanCutiNotifierProvider, (_, state) {
    //   state.showAlertDialogOnError(context);
    // });

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

    ref.listen<AsyncValue>(cutiApproveControllerProvider, (_, state) {
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
        return state.showAlertDialogOnError(context);
      }
    });

    return VAsyncWidgetScaffold<MstKaryawanCuti>(
        value: mstCuti,
        data: (saldo) {
          return VAsyncWidgetScaffold<List<CutiList>>(
              value: cutiList,
              data: (list) {
                return RefreshIndicator(
                  onRefresh: () {
                    page.value = 0;
                    ref
                        .read(mstKaryawanCutiNotifierProvider.notifier)
                        .refresh();
                    ref.read(cutiListControllerProvider.notifier).refresh();
                    return Future.value();
                  },
                  child: VScaffoldWidget(
                    scaffoldTitle: 'List Form Cuti',
                    scaffoldFAB: FloatingActionButton.small(
                      backgroundColor: Palette.primaryColor,
                      onPressed: () => context.pushNamed(
                        RouteNames.createCutiNameRoute,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    scaffoldBody: ListView.separated(
                        controller: scrollController,
                        separatorBuilder: (__, index) => SizedBox(
                              height: 8,
                            ),
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) =>
                            index == 0
                                ? Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Palette.greyDisabled
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Saldo Cuti \n(${saldo.cutiBaru != 0 ? saldo.tahunCutiBaru : saldo.tahunCutiTidakBaru} )',
                                                  style: Themes.customColor(10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  '${saldo.cutiBaru != 0 ? saldo.cutiBaru : saldo.cutiTidakBaru}',
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
                                      SizedBox(
                                        height: 8,
                                      ),
                                      CutiListItem(list[index])
                                    ],
                                  )
                                : CutiListItem(list[index])),
                  ),
                );
              });
        });
  }
}
