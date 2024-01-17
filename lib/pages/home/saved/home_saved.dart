import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/constants/assets.dart';

import '../../../domain/absen_failure.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../shared/providers.dart';
import '../../widgets/v_async_widget.dart';
import '../../widgets/v_dialogs.dart';
import '../home_scaffold.dart';

class HomeSaved extends ConsumerStatefulWidget {
  const HomeSaved();

  @override
  ConsumerState<HomeSaved> createState() => _HomeSavedState();
}

class _HomeSavedState extends ConsumerState<HomeSaved> {
  @override
  Widget build(BuildContext context) {
    ref.listen<Option<Either<AbsenFailure, Unit>>>(
        absenAuthNotifierProvidier
            .select((value) => value.failureOrSuccessOptionSaved),
        (_, failureOrSuccessOptionSaved) => failureOrSuccessOptionSaved.fold(
            () {},
            (either) => either.fold(
                (failure) => failure.maybeWhen(
                      noConnection: () => ref
                          .read(absenOfflineModeProvider.notifier)
                          .state = true,
                      orElse: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                                asset: Assets.iconCrossed,
                                label: 'Error',
                                labelDescription: failure.maybeMap(
                                  server: (server) => 'Error $server',
                                  passwordExpired: (password) => '$password',
                                  passwordWrong: (password) => '$password',
                                  orElse: () => '',
                                ),
                              )),
                    ),
                (_) {})));

    ref.listen<AsyncValue>(errLogControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
        value: errLog, data: (_) => HomeScaffold());
  }
}
