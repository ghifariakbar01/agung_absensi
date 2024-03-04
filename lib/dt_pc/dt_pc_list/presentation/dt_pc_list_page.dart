import 'package:face_net_authentication/dt_pc/dt_pc_list/application/dt_pc_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/sakit/sakit_approve/application/sakit_approve_notifier.dart';
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
import '../application/dt_pc_list.dart';
import 'dt_pc_list_item.dart';

class DtPcListPage extends HookConsumerWidget {
  const DtPcListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(dtPcListControllerProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final sendWa = ref.watch(sendWaNotifierProvider);
    final dtPcList = ref.watch(dtPcListControllerProvider);
    final sakitApprove = ref.watch(sakitApproveControllerProvider);

    ref.listen<AsyncValue>(sakitApproveControllerProvider, (_, state) {
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
            ref.invalidate(dtPcListControllerProvider);
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
        ref.read(dtPcListControllerProvider.notifier).load(
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
      await ref.read(dtPcListControllerProvider.notifier).refresh();
      return Future.value();
    };

    final infoMessage =
        "1. Input DT/PC harus di input maksimal pada hari H DT/PC (H-0)\n"
        "2. harus sudah Approve atasan maksimal (H+3) dari penginputan\n"
        "3. dari HR sudah harus di approve maksimal H+1 dari approve atasan.";

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold(
        value: sakitApprove,
        data: (_) => VAsyncWidgetScaffold(
          value: sendWa,
          data: (_) => VScaffoldTabLayout(
            scaffoldTitle: 'List Form DT / PC',
            additionalInfo: VAdditionalInfo(infoMessage: infoMessage),
            scaffoldFAB: FloatingActionButton.small(
                backgroundColor: Palette.primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => context.pushNamed(
                      RouteNames.createDtPcNameRoute,
                    )),
            onPageChanged: onRefresh,
            scaffoldBody: [
              VAsyncValueWidget<List<DtPcList>>(
                  value: dtPcList,
                  data: (list) {
                    final waiting = list
                        .where((e) =>
                            (e.spvSta == false || e.hrdSta == false) &&
                            e.btlSta == false)
                        .toList();
                    return _list(scrollController, waiting, onRefresh);
                  }),
              VAsyncValueWidget<List<DtPcList>>(
                  value: dtPcList,
                  data: (list) {
                    final approved = list
                        .where((e) =>
                            (e.spvSta == true || e.hrdSta == true) &&
                            e.btlSta == false)
                        .toList();
                    return _list(scrollController, approved, onRefresh);
                  }),
              VAsyncValueWidget<List<DtPcList>>(
                  value: dtPcList,
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

  Widget _list(ScrollController scrollController, List<DtPcList> list,
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
                        DtPcListItem(list[index])
                      ],
                    )
                  : DtPcListItem(list[index])),
    );
  }
}
