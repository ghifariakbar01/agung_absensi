import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/constants/assets.dart';

import '../../domain/absen_failure.dart';
import '../../shared/providers.dart';
import '../widgets/v_dialogs.dart';

class WelcomeSaved extends ConsumerStatefulWidget {
  const WelcomeSaved();

  @override
  ConsumerState<WelcomeSaved> createState() => _WelcomeSavedState();
}

class _WelcomeSavedState extends ConsumerState<WelcomeSaved> {
  @override
  Widget build(BuildContext context) {
    ref.listen<Option<Either<AbsenFailure, Unit>>>(
        absenAuthNotifierProvidier
            .select((value) => value.failureOrSuccessOptionSaved),
        (_, failureOrSuccessOptionSaved) => failureOrSuccessOptionSaved.fold(
            () {},
            (either) => either.fold(
                (failure) => failure.when(
                      server: (code, message) => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                                asset: Assets.iconCrossed,
                                label: '$code',
                                labelDescription: '$message',
                              )),
                      noConnection: () => ref
                          .read(absenOfflineModeProvider.notifier)
                          .state = true,
                    ),
                (_) {})));

    return Container();
  }
}
