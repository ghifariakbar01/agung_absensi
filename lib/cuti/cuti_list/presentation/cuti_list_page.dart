import 'package:face_net_authentication/cuti/create_cuti/application/create_cuti_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cross_auth/application/cross_auth_notifier.dart';
import '../../../cross_auth_server/cross_auth_server_notifier.dart';
import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import '../../../style/style.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../cuti_approve/application/cuti_approve_notifier.dart';
import '../application/cuti_list_notifier.dart';
import 'cuti_list_scaffold.dart';

class CutiListPage extends ConsumerWidget {
  const CutiListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(crossAuthNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        ref.invalidate(isUserCrossedProvider);
        ref.invalidate(cutiListControllerProvider);
        ref.invalidate(mstKaryawanCutiNotifierProvider);
      }
    });

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

    ref.listen<AsyncValue>(createCutiNotifierProvider, (_, state) async {
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

    ref.listen<AsyncValue>(mstKaryawanCutiNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final crossAuthServer = ref.watch(crossAuthServerNotifierProvider);

    return Stack(
      children: [
        Container(),
        VAsyncWidgetScaffold<Map<String, List<String>>>(
            value: crossAuthServer,
            data: (_mapPT) {
              return CutiListScaffold(_mapPT);
            }),
      ],
    );
  }
}
