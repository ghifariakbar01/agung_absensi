import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/sakit/sakit_approve/application/sakit_approve_notifier.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routes/application/route_names.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/izin_list.dart';
import '../application/izin_list_notifier.dart';
import 'izin_list_item.dart';

class IzinListPage extends HookConsumerWidget {
  const IzinListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(izinListControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    final sendWa = ref.watch(sendWaNotifierProvider);
    final sakitList = ref.watch(izinListControllerProvider);
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
            ref.invalidate(izinListControllerProvider);
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
        ref.read(izinListControllerProvider.notifier).load(
              page: page.value + 1,
            );

        page.value++;
      }
    }

    useEffect(() {
      scrollController.addListener(onScrolled);
      return () => scrollController.removeListener(onScrolled);
    }, [scrollController]);

    return VAsyncWidgetScaffold(
      value: sakitApprove,
      data: (_) => VAsyncWidgetScaffold(
        value: sendWa,
        data: (_) => RefreshIndicator(
          onRefresh: () async {
            page.value = 0;
            await ref.read(izinListControllerProvider.notifier).refresh();
            return Future.value();
          },
          child: VScaffoldTabLayout(
            scaffoldTitle: 'List Form Izin',
            scaffoldFAB: FloatingActionButton.small(
                backgroundColor: Palette.primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => context.pushNamed(
                      RouteNames.createSakitNameRoute,
                    )),
            onPageChanged: () async {
              page.value = 0;
              await ref.read(izinListControllerProvider.notifier).refresh();
              return Future.value();
            },
            scaffoldBody: [
              VAsyncValueWidget<List<IzinList>>(
                  value: sakitList,
                  data: (list) {
                    final waiting = list
                        .where((e) =>
                            (e.spvSta == false || e.hrdSta == false) &&
                            e.btlSta == false)
                        .toList();
                    return _list(scrollController, waiting);
                  }),
              VAsyncValueWidget<List<IzinList>>(
                  value: sakitList,
                  data: (list) {
                    final approved = list
                        .where((e) =>
                            (e.spvSta == true || e.hrdSta == true) &&
                            e.btlSta == false)
                        .toList();
                    return _list(scrollController, approved);
                  }),
              VAsyncValueWidget<List<IzinList>>(
                  value: sakitList,
                  data: (list) {
                    final cancelled =
                        list.where((e) => e.btlSta == true).toList();
                    return _list(scrollController, cancelled);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  ListView _list(ScrollController scrollController, List<IzinList> list) {
    return ListView.separated(
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
                      IzinListItem(list[index])
                    ],
                  )
                : IzinListItem(list[index]));
  }
}
