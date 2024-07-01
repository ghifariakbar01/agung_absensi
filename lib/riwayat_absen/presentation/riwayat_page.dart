import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/constants/assets.dart';
import 'package:face_net_authentication/domain/riwayat_absen_failure.dart';

import 'package:face_net_authentication/widgets/loading_overlay.dart';
import 'package:face_net_authentication/widgets/v_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/riwayat_absen_model.dart';
import '../application/riwayat_absen_notifier.dart';
import 'riwayat_scaffold.dart';

class RiwayatAbsenPage extends ConsumerWidget {
  const RiwayatAbsenPage({required this.isFromAbsen});

  final bool? isFromAbsen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Option<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>>>(
        riwayatAbsenNotifierProvider
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                (e) => e.maybeWhen(
                    orElse: () => showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (builder) => VSimpleDialog(
                              asset: Assets.iconCrossed,
                              label: 'Error',
                              labelDescription: e.maybeWhen(
                                orElse: () => '',
                                noConnection: () => 'no connection',
                                passwordExpired: () => 'Password Expired',
                                passwordWrong: () => 'Password Wrong',
                                wrongFormat: (message) =>
                                    'wrong format $message',
                                server: (errorCode, message) =>
                                    'error server $errorCode $message',
                              ),
                            ))),
                ref
                    .read(riwayatAbsenNotifierProvider.notifier)
                    .replaceAbsenRiwayat)));

    final isLoading = ref
        .watch(riwayatAbsenNotifierProvider.select((value) => value.isGetting));

    return Stack(
      children: [
        RiwayatAbsenScaffold(isFromAbsen: isFromAbsen),
        LoadingOverlay(isLoading: isLoading),
      ],
    );
  }
}
