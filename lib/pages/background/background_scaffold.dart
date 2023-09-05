import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/background/widget/background_item.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../shared/providers.dart';
import '../../utils/string_utils.dart';
import '../widgets/v_dialogs.dart';

class BackgroundScaffold extends ConsumerWidget {
  const BackgroundScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          passwordExpired: () => ref
                              .read(passwordExpiredNotifierProvider.notifier)
                              .savePasswordExpired(),
                          noConnection: () => showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) => VSimpleDialog(
                                    asset: Assets.iconCrossed,
                                    label: 'NoConnection',
                                    labelDescription: 'Tidak ada koneksi',
                                  )),
                        ), (_) async {
                  debugger(message: 'called');

                  await ref.read(absenNotifierProvidier.notifier).getAbsen(
                        date: DateTime.now(),
                      );

                  await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                            asset: Assets.iconChecked,
                            label:
                                'JAM ${StringUtils.hoursDate(DateTime.now())}',
                            labelDescription: 'BERHASIL',
                          ));

                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .getSavedLocations();
                })));

    final backgroundItems = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.primaryColor,
          elevation: 0,
          title: Text(
            'Absen Tersimpan',
            style: Themes.customColor(FontWeight.bold, 20, Colors.white),
          ),
        ),
        body: SafeArea(
            child: ListView.builder(
                itemCount: backgroundItems.length,
                itemBuilder: ((context, index) => BackgroundItem(
                      item: backgroundItems[index],
                      index: index,
                    )))));
  }
}
