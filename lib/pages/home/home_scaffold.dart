import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../utils/string_utils.dart';
import '../widgets/v_dialogs.dart';
import 'home.dart';

class HomeScaffold extends HookConsumerWidget {
  const HomeScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Option<Either<AbsenFailure, Unit>>>(
        absenAuthNotifierProvidier
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (failure) => failure.when(
                          server: (code, message) => showDialog(
                              context: context,
                              builder: (_) => VSimpleDialog(
                                    asset: Assets.iconCrossed,
                                    label: '$code',
                                    labelDescription: '$message',
                                  )),
                          noConnection: () => showDialog(
                              context: context,
                              builder: (_) => VSimpleDialog(
                                    asset: Assets.iconCrossed,
                                    label: 'NoConnection',
                                    labelDescription: 'Tidak ada koneksi',
                                  )),
                        ), (_) async {
                  debugger(message: 'called');

                  await ref.read(absenNotifierProvidier.notifier).getAbsen(
                      date: DateTime.now(),
                      onAbsen: (absen) => ref
                          .read(absenNotifierProvidier.notifier)
                          .changeAbsen(absen));

                  await showDialog(
                      context: context,
                      builder: (_) => VSimpleDialog(
                            asset: Assets.iconChecked,
                            label:
                                'JAM ${StringUtils.hoursDate(DateTime.now())}',
                            labelDescription: 'BERHASIL',
                          ));
                })));

    return MyHomePage();
  }
}
