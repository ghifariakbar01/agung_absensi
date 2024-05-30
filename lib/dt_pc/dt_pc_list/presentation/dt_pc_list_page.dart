import 'package:face_net_authentication/dt_pc/create_dt_pc/application/create_dt_pc_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cross_auth/application/cross_auth_notifier.dart';
import '../../../cross_auth_server/cross_auth_server_notifier.dart';
import '../../../style/style.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../dt_pc_approve/application/dt_pc_approve_notifier.dart';
import '../application/dt_pc_list_notifier.dart';
import 'dt_pc_list_scaffold.dart';

class DtPcListPage extends ConsumerWidget {
  const DtPcListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(crossAuthNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        ref.invalidate(isUserCrossedProvider);
        ref.invalidate(dtPcListControllerProvider);
      }
    });

    ref.listen<AsyncValue>(dtPcApproveControllerProvider, (_, state) {
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

    ref.listen<AsyncValue>(createDtPcNotifierProvider, (_, state) {
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

    final crossAuthServer = ref.watch(crossAuthServerNotifierProvider);

    return Stack(
      children: [
        Container(),
        VAsyncWidgetScaffold<Map<String, List<String>>>(
            value: crossAuthServer,
            data: (_mapPT) {
              return DtPcListScaffold(_mapPT);
            })
      ],
    );
  }
}
