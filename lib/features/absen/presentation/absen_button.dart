import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dartz/dartz.dart';

import '../../../constants/assets.dart';
import '../../domain/background_failure.dart';
import '../../domain/geofence_failure.dart';
import '../../domain/riwayat_absen_failure.dart';
import '../../geofence/application/geofence_response.dart';
import '../../geofence/geofence_helper.dart';
import '../../imei/application/imei_auth_state.dart';
import '../../imei/application/imei_notifier.dart';
import '../../riwayat_absen/application/riwayat_absen_model.dart';
import '../../../shared/providers.dart';
import '../../../widgets/v_dialogs.dart';

import '../application/absen_helper.dart';
import 'absen_button_column.dart';

final buttonResetVisibilityProvider = StateProvider<bool>((ref) {
  return false;
});

class AbsenButton extends StatefulHookConsumerWidget {
  const AbsenButton({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AbsenButton> createState() => _AbsenButtonState();
}

class _AbsenButtonState extends ConsumerState<AbsenButton> {
  @override
  void initState() {
    super.initState();

    ref.listenManual<
            Option<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>>>(
        riwayatAbsenNotifierProvider
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                  (e) => _onRiwayatError(e),
                  (list) async {
                    await ref
                        .read(absenNotifierProvidier.notifier)
                        .getAbsenTodayFromStorage();

                    ref
                        .read(riwayatAbsenNotifierProvider.notifier)
                        .replaceAbsenRiwayat(list);

                    ref.read(riwayatAbsenNotifierProvider.notifier).resetFoso();

                    return ref
                        .read(geofenceProvider.notifier)
                        .getGeofenceListAfterAbsen();
                  },
                )),
        fireImmediately: true);

    ref.listenManual<Option<Either<GeofenceFailure, List<GeofenceResponse>>>>(
        geofenceProvider.select(
          (state) => state.failureOrSuccessOptionAfterAbsen,
        ),
        (_, failureOrSuccessOptionAfterAbsen) =>
            failureOrSuccessOptionAfterAbsen.fold(
              () {},
              (either) async {
                final geofenceHelper = GeofenceHelper(ref, context);

                return either.fold(
                    (failure) => failure.maybeWhen(
                        noConnection: () => ref
                            .read(geofenceProvider.notifier)
                            .getGeofenceListFromStorage(),
                        empty: () => geofenceHelper.geofenceEmptyError(),
                        orElse: () => geofenceHelper.otherError(failure)),
                    (list) async {
                  await geofenceHelper.reinitializeGeofence(list);

                  final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
                  final user = await ref
                      .read(userNotifierProvider.notifier)
                      .getUserString();

                  final imei = await imeiNotifier.getImeiStringFromServer(
                    idKary: user.IdKary ?? '-',
                  );

                  final savedImei =
                      await imeiNotifier.getImeiStringFromStorage();

                  final imeiAuthState = imei.isEmpty
                      ? ImeiAuthState.empty()
                      : ImeiAuthState.registered();

                  return imeiNotifier.processImei(
                    imei: imei,
                    nama: user.nama ?? '-',
                    savedImei: savedImei,
                    imeiAuthState: imeiAuthState,
                  );
                });
              },
            ),
        fireImmediately: true);

    ref.listenManual<Option<Either<BackgroundFailure, Unit>>>(
        backgroundNotifierProvider.select(
          (state) => state.failureOrSuccessOptionSave,
        ),
        (_, failureOrSuccessOptionSave) => failureOrSuccessOptionSave.fold(
            () {},
            (either) => either.fold(
                    (failure) => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                            label: 'Error',
                            labelDescription: failure.when(
                              empty: () => 'No saved found',
                              formatException: (value) =>
                                  'FormatException: $value',
                              unknown: (errorCode, message) =>
                                  'Error: $errorCode $message',
                            ),
                            asset: Assets.iconCrossed,
                          ),
                        ), (_) async {
                  final isTester = ref.read(testerNotifierProvider);

                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .executeLocation(
                        context: context,
                        isTester: isTester,
                        absen: ({required location}) async {
                          final user = ref.read(userNotifierProvider).user;

                          final nama = user.nama ?? '-';
                          final idUser = user.idUser ?? 0;
                          final isTester = ref.read(testerNotifierProvider);

                          final imei = await ref
                              .read(imeiNotifierProvider.notifier)
                              .getImeiStringFromStorage();

                          return AbsenHelper(ref).absen(
                            idUser: idUser,
                            nama: nama,
                            imei: imei,
                            context: context,
                            absenList: location,
                            isTester: isTester,
                          );
                        },
                      );
                })),
        fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    return AbsenButtonColumn();
  }

  // on error
  Future<dynamic> _onRiwayatError(RiwayatAbsenFailure e) async {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) => VSimpleDialog(
              asset: Assets.iconCrossed,
              label: 'Error',
              labelDescription: e.when(
                noConnection: () => 'no connection',
                passwordExpired: () => 'Password Expired',
                passwordWrong: () => 'Password Wrong',
                wrongFormat: (message) => 'wrong format $message',
                storage: () => 'Storage / memori penuh',
                server: (errorCode, message) =>
                    'error server $errorCode $message',
              ),
            ));
  }
}
