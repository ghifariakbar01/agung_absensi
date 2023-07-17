import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/background/widget/background_item.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_request.dart';
import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../infrastructure/remote_response.dart';
import '../../shared/providers.dart';
import '../../utils/string_utils.dart';
import '../widgets/v_dialogs.dart';

class BackgroundScaffold extends ConsumerWidget {
  const BackgroundScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<RemoteResponse<AbsenRequest?>>(
        absenAuthNotifierProvidier.select((value) => value.backgroundIdSaved),
        (_, id) async {
      debugger(message: 'called');

      try {
        final itemBackgroundState = ref
            .read(absenAuthNotifierProvidier.notifier)
            .state
            .backgroundItemState;

        final location = itemBackgroundState.savedLocations;

        debugger(message: 'called');

        log('location ${location.alamat}');

        id.when(
          withNewData: (absenRequest) => absenRequest?.when(
              absenIn: (id) => ref
                  .read(absenAuthNotifierProvidier.notifier)
                  .absenSaved(
                      idAbsenMnl: '${id + 1}',
                      lokasi: '${location.alamat}',
                      date: location.date,
                      latitude: '${location.latitude ?? 0}',
                      longitude: '${location.longitude ?? 0}',
                      inOrOut: JenisAbsen.absenIn),
              absenOut: (id) => ref
                  .read(absenAuthNotifierProvidier.notifier)
                  .absenSaved(
                      idAbsenMnl: '${id + 1}',
                      lokasi: '${location.alamat}',
                      date: location.date,
                      latitude: '${location.latitude ?? 0}',
                      longitude: '${location.longitude ?? 0}',
                      inOrOut: JenisAbsen.absenOut),
              absenUnknown: () {}),
          failure: (code, message) => showDialog(
              context: context,
              builder: (_) => VSimpleDialog(
                    asset: Assets.iconCrossed,
                    label: '$code',
                    labelDescription: '$message',
                  )),
        );
      } on Exception catch (e) {
        log('error $e');
        // TODO
      }
    });

    ref.listen<Option<Either<AbsenFailure, Unit>>>(
        absenAuthNotifierProvidier
            .select((value) => value.failureOrSuccessOptionSaved),
        (_, failureOrSuccessOptionSaved) => failureOrSuccessOptionSaved.fold(
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
                          .changeAbsen(absen),
                      onNoConnection: () => ref
                          .read(absenOfflineModeProvider.notifier)
                          .state = true);

                  await showDialog(
                      context: context,
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
