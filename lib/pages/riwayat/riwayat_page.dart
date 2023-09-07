import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_model.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_notifier.dart';
import 'package:face_net_authentication/constants/assets.dart';
import 'package:face_net_authentication/domain/riwayat_absen_failure.dart';
import 'package:face_net_authentication/pages/riwayat/riwayat_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:face_net_authentication/pages/widgets/v_dialogs.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RiwayatAbsenPage extends ConsumerWidget {
  const RiwayatAbsenPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Either<PasswordExpiredFailure, Unit>?
    ref.listen<Option<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>>>(
        riwayatAbsenNotifierProvider
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (error) => error.maybeWhen(
                        passwordExpired: () => ref
                            .read(passwordExpiredNotifierProvider.notifier)
                            .savePasswordExpired(),
                        passwordWrong: () => ref
                            .read(passwordExpiredNotifierProvider.notifier)
                            .savePasswordExpired(),
                        orElse: () => showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (builder) => VSimpleDialog(
                                  label: 'Error',
                                  labelDescription: error.maybeWhen(
                                      noConnection: () => 'no connection',
                                      wrongFormat: (message) =>
                                          'wrong format $message',
                                      server: (errorCode, message) =>
                                          'error server $errorCode $message',
                                      orElse: () => ''),
                                  asset: Assets.iconCrossed,
                                ))), (list) {
                  log('list.length ${list.length}');

                  final oldList = ref
                      .read(riwayatAbsenNotifierProvider.notifier)
                      .state
                      .riwayatAbsen;

                  final page = ref
                      .read(riwayatAbsenNotifierProvider.notifier)
                      .state
                      .page;

                  if (list.length < 1 && page != 1) {
                    // debugger(message: 'called');

                    ref
                        .read(riwayatAbsenNotifierProvider.notifier)
                        .changeIsMore(false);
                  } else if (list.length > 1 && page == 1) {
                    // debugger(message: 'called');

                    ref
                        .read(riwayatAbsenNotifierProvider.notifier)
                        .replaceAbsenRiwayat(list);
                  } else {
                    // debugger(message: 'called');

                    ref
                        .read(riwayatAbsenNotifierProvider.notifier)
                        .changeAbsenRiwayat(oldList, list);
                  }
                })));

    final isLoading = ref
        .watch(riwayatAbsenNotifierProvider.select((value) => value.isGetting));

    return Stack(
      children: [RiwayatAbsenScaffold(), LoadingOverlay(isLoading: isLoading)],
    );
  }
}
