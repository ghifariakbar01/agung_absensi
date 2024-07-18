import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../shared/providers.dart';
import '../../utils/string_utils.dart';
import '../../widgets/v_dialogs.dart';
import 'widget/background_item.dart';

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
                    (failure) => showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => VSimpleDialog(
                              asset: Assets.iconCrossed,
                              label: 'Error',
                              labelDescription: failure.when(
                                  server: (code, message) =>
                                      'Error $code $message',
                                  passwordExpired: () => 'Password Expired',
                                  passwordWrong: () => 'Password Wrong',
                                  noConnection: () => 'Tidak Ada Koneksi'),
                            )), (_) async {
                  await ref
                      .read(absenNotifierProvidier.notifier)
                      .getAbsenToday();
                  //
                  String jam = StringUtils.hoursDate(DateTime.now());
                  await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                            asset: Assets.iconChecked,
                            label: 'JAM $jam',
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
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          title: Text(
            'Absen Tersimpan',
            style: Themes.customColor(
              20,
              fontWeight: FontWeight.bold,
            ),
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
