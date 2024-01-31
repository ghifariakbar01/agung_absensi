import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:face_net_authentication/sakit/sakit_approve/application/sakit_approve_notifier.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/routes/route_names.dart';
import '../../../pages/widgets/alert_helper.dart';
import '../../../pages/widgets/v_async_widget.dart';
import '../../../pages/widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/sakit_list.dart';
import '../application/sakit_list_notifier.dart';
import 'sakit_list_item.dart';

class SakitListPage extends HookConsumerWidget {
  const SakitListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(sakitListControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
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
        page.value++;

        ref.read(sakitListControllerProvider.notifier).load(
              page: page.value + 1,
            );
      }
    }

    useEffect(() {
      scrollController.addListener(onScrolled);
      return () => scrollController.removeListener(onScrolled);
    }, [scrollController]);

    return VAsyncWidgetScaffold<List<SakitList>>(
        value: sakitList,
        data: (list) {
          return VAsyncWidgetScaffold(
            value: sakitApprove,
            data: (_) => VAsyncWidgetScaffold(
              value: sendWa,
              data: (_) => RefreshIndicator(
                onRefresh: () {
                  page.value = 0;
                  ref.read(sakitListControllerProvider.notifier).refresh();
                  return Future.value();
                },
                child: VScaffoldWidget(
                  scaffoldTitle: 'List Form Sakit',
                  scaffoldFAB: FloatingActionButton.small(
                      backgroundColor: Palette.primaryColor,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pushNamed(
                            RouteNames.createSakitNameRoute,
                          )),
                  scaffoldBody: ListView.separated(
                      controller: scrollController,
                      separatorBuilder: (__, index) => SizedBox(
                            height: 8,
                          ),
                      itemCount: list.length + 1,
                      itemBuilder: (BuildContext context, int index) =>
                          index == list.length
                              ? SizedBox(
                                  height: 50,
                                )
                              : SakitListItem(list[index])),
                ),
              ),
            ),
          );
        });
  }
}
