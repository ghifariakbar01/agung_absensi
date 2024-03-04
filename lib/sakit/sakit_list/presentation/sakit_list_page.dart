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
import '../application/sakit_list.dart';
import '../application/sakit_list_notifier.dart';
import 'sakit_list_item.dart';

class SakitListPage extends HookConsumerWidget {
  const SakitListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(sakitListControllerProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final sendWa = ref.watch(sendWaNotifierProvider);
    final sakitList = ref.watch(sakitListControllerProvider);
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
            ref.invalidate(sakitListControllerProvider);
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
        ref.read(sakitListControllerProvider.notifier).load(
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
      await ref.read(sakitListControllerProvider.notifier).refresh();
      return Future.value();
    };

    final infoMessage =
        "1. Input sakit harus dimasukan pada hari pertama kerja s/d maksimal H+3 sejak masuk kerja.\n"
        "2. Approve Atasan maksimal H+3 dari penginputan.\n"
        "3. Approve HR maksimal H+1 dari approve Atasan.\n"
        "4. Perhitungan Hari berdasarkan hari kerja.";

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold(
        value: sakitApprove,
        data: (_) => VAsyncWidgetScaffold(
          value: sendWa,
          data: (_) => VScaffoldTabLayout(
            scaffoldTitle: 'List Form Sakit',
            additionalInfo: VAdditionalInfo(infoMessage: infoMessage),
            scaffoldFAB: FloatingActionButton.small(
                backgroundColor: Palette.primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => context.pushNamed(
                      RouteNames.createSakitNameRoute,
                    )),
            onPageChanged: onRefresh,
            scaffoldBody: [
              VAsyncValueWidget<List<SakitList>>(
                  value: sakitList,
                  data: (list) {
                    final waiting = list
                        .where((e) =>
                            (e.spvSta == false || e.hrdSta == false) &&
                            e.batalStatus == false)
                        .toList();
                    return _list(scrollController, waiting, onRefresh);
                  }),
              VAsyncValueWidget<List<SakitList>>(
                  value: sakitList,
                  data: (list) {
                    final approved = list
                        .where((e) =>
                            (e.spvSta == true || e.hrdSta == true) &&
                            e.batalStatus == false)
                        .toList();
                    return _list(scrollController, approved, onRefresh);
                  }),
              VAsyncValueWidget<List<SakitList>>(
                  value: sakitList,
                  data: (list) {
                    final cancelled =
                        list.where((e) => e.batalStatus == true).toList();
                    return _list(scrollController, cancelled, onRefresh);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list(ScrollController scrollController, List<SakitList> list,
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
                        SakitListItem(list[index])
                      ],
                    )
                  : SakitListItem(list[index])),
    );
  }
}
