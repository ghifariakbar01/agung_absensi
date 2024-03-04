import 'package:face_net_authentication/absen_manual/absen_manual_approve/application/absen_manual_approve_notifier.dart';
import 'package:face_net_authentication/absen_manual/absen_manual_list/application/absen_manual_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:face_net_authentication/widgets/v_additional_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routes/application/route_names.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/absen_manual_list.dart';
import 'absen_manual_list_item.dart';

class AbsenManualListPage extends HookConsumerWidget {
  const AbsenManualListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(absenManualListControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
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

    void onScrolled() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        ref.read(absenManualListControllerProvider.notifier).load(
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
      await ref.read(absenManualListControllerProvider.notifier).refresh();
      return Future.value();
    };

    final infoMessage =
        "1. Absen Manual Di input Maks H=0 dan di approve oleh atasan dan HR maks H+1\n"
        "2. WFH : khusus untuk karyawan yang bekerja dari rumah (work from home)\n"
        "3. Absen Harian : untuk karyawan yang lokasi kerjanya tidak tersedia mesin finger print.\n"
        "4. Absen Lainnya / Kasus : untuk kasus-kasus tidak melakukan finger print karena listrik mati, mesin error / rusak, sidik jari tidak terbaca, lupa absen, jaringan trouble / internet mati saat akan input absen manual dll.";

    return VAsyncWidgetScaffold(
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
          scaffoldBody: [
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
            VAsyncValueWidget<List<AbsenManualList>>(
                value: absenManualList,
                data: (list) {
                  final cancelled =
                      list.where((e) => e.btlSta == true).toList();
                  return _list(scrollController, cancelled, onRefresh);
                }),
          ],
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
