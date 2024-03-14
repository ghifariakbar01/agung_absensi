import 'package:face_net_authentication/tugas_dinas/tugas_dinas_approve/application/tugas_dinas_approve_notifier.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:face_net_authentication/widgets/v_additional_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/tugas_dinas_list.dart';

import 'tugas_dinas_list_item.dart';

class TugasDinasListPage extends HookConsumerWidget {
  const TugasDinasListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(tugasDinasListControllerProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final sendWa = ref.watch(sendWaNotifierProvider);
    final absenManualList = ref.watch(tugasDinasListControllerProvider);
    final absenApprove = ref.watch(tugasDinasApproveControllerProvider);

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

    final scrollController = useScrollController();
    final page = useState(0);

    void onScrolled() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        ref.read(tugasDinasListControllerProvider.notifier).load(
              page: page.value + 1,
            );

        page.value++;
      }
    }

    useEffect(() {
      scrollController.addListener(onScrolled);
      return () => scrollController.removeListener(onScrolled);
    }, [scrollController]);

    final onRefresh = () async {
      page.value = 0;
      await ref.read(tugasDinasListControllerProvider.notifier).refresh();
      return Future.value();
    };

    final infoMessage = "Ketentuan Tugas Dinas Ketegori Luar Kota \n"
        "1. Input Pengajuan Tugas Dinas maksimal harus di input pada H-3 sebelum keberangkatan, \n"
        "2. Harus sudah Approve atasan maksimal H-3 dari keberangkatan \n"
        "3. dari HR sudah harus di approve maksimal H+1 dari approve atasan. (Perhitungan Hari Berdasarkan Hari Kerja)\n\n"
        "Ketentuan Tugas Dinas Ketegori Selain Luar Kota \n"
        "1. Input tugas dinas dalam kota harus diinput H-0. \n"
        "2. Diapprove atasan H+1 setelah karyawan input. \n"
        "3. Approve HR H+1 setelah atasan approve.\n"
        "4. Tugas dinas kategori Kunjungan diperlukan Approve dari GM";

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold(
        value: absenApprove,
        data: (_) => VAsyncWidgetScaffold(
          value: sendWa,
          data: (_) => VScaffoldTabLayout(
            scaffoldTitle: 'List Form Tugas Dinas',
            additionalInfo: VAdditionalInfo(infoMessage: infoMessage),
            scaffoldFAB: FloatingActionButton.small(
                backgroundColor: Palette.primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => context.pushNamed(
                      RouteNames.createTugasDinasNameRoute,
                    )),
            onPageChanged: onRefresh,
            scaffoldBody: [
              VAsyncValueWidget<List<TugasDinasList>>(
                  value: absenManualList,
                  data: (list) {
                    final waiting = list
                        .where((e) =>
                            (e.spvSta == false || e.hrdSta == false) &&
                            e.btlSta == false)
                        .toList();
                    return _list(scrollController, waiting, onRefresh);
                  }),
              VAsyncValueWidget<List<TugasDinasList>>(
                  value: absenManualList,
                  data: (list) {
                    final approved = list
                        .where((e) =>
                            (e.spvSta == true && e.hrdSta == true) &&
                            e.btlSta == false)
                        .toList();
                    return _list(scrollController, approved, onRefresh);
                  }),
              VAsyncValueWidget<List<TugasDinasList>>(
                  value: absenManualList,
                  data: (list) {
                    final cancelled =
                        list.where((e) => e.btlSta == true).toList();
                    return _list(scrollController, cancelled, onRefresh);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list(ScrollController scrollController, List<TugasDinasList> list,
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
                        TugasDinasListItem(list[index])
                      ],
                    )
                  : TugasDinasListItem(list[index])),
    );
  }
}
