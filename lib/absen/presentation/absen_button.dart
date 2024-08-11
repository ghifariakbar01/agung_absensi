import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import '../../constants/assets.dart';
import '../../domain/absen_failure.dart';
import '../../domain/background_failure.dart';
import '../../domain/riwayat_absen_failure.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../network_time/network_time_notifier.dart';
import '../../riwayat_absen/application/riwayat_absen_model.dart';
import '../../riwayat_absen/application/riwayat_absen_notifier.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../utils/os_vibrate.dart';
import '../../widgets/v_dialogs.dart';

import '../application/absen_helper.dart';
import 'absen_button_column.dart';
import 'absen_success.dart';

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
                        .getAbsenToday();

                    final _time =
                        await ref.read(networkTimeNotifierProvider.future);

                    ref
                        .read(riwayatAbsenNotifierProvider.notifier)
                        .replaceAbsenRiwayat(list);

                    await ref.read(backgroundNotifierProvider.notifier).clear();
                    await ref
                        .read(backgroundNotifierProvider.notifier)
                        .getSavedLocations();

                    return showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Palette.green,
                      builder: (context) => Success(
                        DateFormat('HH:mm').format(_time),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                        ),
                      ),
                    );
                  },
                )),
        fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Option<Either<BackgroundFailure, Unit>>>(
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
                            labelDescription: failure.map(
                              empty: (_) => 'No saved found',
                              formatException: (value) =>
                                  'FormatException: $value',
                              unknown: (l) => '${l.errorCode} ${l.message}',
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
                        absen: ({required location}) {
                          final user = ref.read(userNotifierProvider).user;

                          final nama = user.nama ?? '-';
                          final imei = user.imeiHp ?? '-';
                          final idUser = user.idUser ?? 0;
                          final isTester = ref.read(testerNotifierProvider);

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
                })));

    // GET ABSEN
    ref.listen<Option<Either<AbsenFailure, Unit>>>(
        absenAuthNotifierProvidier
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                (failure) => failure.maybeWhen(
                    noConnection: () => _onNoConnection(context),
                    orElse: () => _onErrOther(failure, context)),
                (_) => _onBerhasilAbsen(context))));

    return AbsenButtonColumn();
  }

  Future<void> _onBerhasilAbsen(BuildContext context) async {
    ref.read(buttonResetVisibilityProvider.notifier).state = false;
    ref.read(absenOfflineModeProvider.notifier).state = false;
    await OSVibrate.vibrate();

    final _riwayat = ref.read(riwayatAbsenNotifierProvider);
    await ref.read(riwayatAbsenNotifierProvider.notifier).getAbsenRiwayat(
          dateFirst: _riwayat.dateFirst,
          dateSecond: _riwayat.dateSecond,
        );
  }

  // on error
  Future<dynamic> _onRiwayatError(RiwayatAbsenFailure e) {
    return showCupertinoDialog(
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
                wrongFormat: (message) => 'wrong format $message',
                server: (errorCode, message) =>
                    'error server $errorCode $message',
              ),
            ));
  }

  Future<void> _onErrOther(
    AbsenFailure failure,
    BuildContext context,
  ) async {
    final String errMessage = failure.maybeWhen(
        server: (code, message) => 'Error $code $message',
        passwordExpired: () => 'Password Expired',
        passwordWrong: () => 'Password Wrong',
        orElse: () => '');

    await ref.read(errLogControllerProvider.notifier).sendLog(
          isHoting: true,
          errMessage: errMessage,
        );

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconCrossed,
              label: 'Error',
              labelDescription: failure.maybeWhen(
                  server: (code, message) => 'Error $code $message',
                  passwordExpired: () => 'Password Expired',
                  passwordWrong: () => 'Password Wrong',
                  orElse: () => ''),
            ));
  }

  Future<void> _onNoConnection(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              color: Palette.red,
              asset: Assets.iconCrossed,
              label: 'NoConnection',
              labelDescription: 'Tidak ada koneksi',
            )).then((_) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconChecked,
              label: 'Saved',
              labelDescription:
                  'Absen masih tersimpan di HP. Mohon lakukan absen saat ada jaringan internet.',
            )));
  }
}
