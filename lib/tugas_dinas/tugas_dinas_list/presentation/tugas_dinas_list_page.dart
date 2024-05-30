import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cross_auth/application/cross_auth_notifier.dart';
import '../../../cross_auth_server/cross_auth_server_notifier.dart';
import '../../../style/style.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../create_tugas_dinas/application/create_tugas_dinas_notifier.dart';
import '../../tugas_dinas_approve/application/tugas_dinas_approve_notifier.dart';
import '../application/tugas_dinas_list_notifier.dart';
import 'tugas_dinas_list_scaffold.dart';

class TugasDinasListPage extends ConsumerWidget {
  const TugasDinasListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(crossAuthNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        ref.invalidate(isUserCrossedProvider);
        ref.invalidate(tugasDinasListControllerProvider);
      }
    });

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

    ref.listen<AsyncValue>(createTugasDinasNotifierProvider, (_, state) {
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

    final crossAuthServer = ref.watch(crossAuthServerNotifierProvider);

    return Stack(
      children: [
        Container(),
        VAsyncWidgetScaffold<Map<String, List<String>>>(
            value: crossAuthServer,
            data: (_mapPT) {
              return TugasDinasListScaffold(_mapPT);
            })
      ],
    );
  }
}
