
import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/imei/imei_state.dart';
import 'package:face_net_authentication/application/init_imei/init_imei_status.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/user/user_model.dart';
import '../../../constants/assets.dart';
import '../../../domain/edit_failure.dart';
import '../../../domain/value_objects_copy.dart';
import '../../../shared/providers.dart';
import '../../widgets/v_dialogs.dart';

class HomeImeiScaffold extends ConsumerWidget {
  const HomeImeiScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // GET IMEI INTERNET
    ref.listen<Option<Either<EditFailure, String?>>>(
        editProfileNotifierProvider.select(
          (state) => state.failureOrSuccessOptionGettingImei,
        ),
        (_, failureOrSuccessOptionGettingImei) =>
            failureOrSuccessOptionGettingImei.fold(
              () {},
              (either) => either.fold(
                  (failure) => failure.maybeMap(
                        noConnection: (_) => ref
                            .read(absenOfflineModeProvider.notifier)
                            .state = true,
                        passwordExpired: (_) => ref
                            .read(passwordExpiredNotifierProvider.notifier)
                            .savePasswordExpired(),
                        orElse: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                            label: 'Error',
                            labelDescription: failure.maybeMap(
                                server: (server) => 'error server $server',
                                orElse: () => ''),
                            asset: Assets.iconCrossed,
                          ),
                        ),
                      ), (imeiResponse) async {
                ImeiState imeiDBState = ref.read(imeiNotifierProvider);
                String savedImei = ref.read(
                    imeiAuthNotifierProvider.select((value) => value.imei));
                UserModelWithPassword user = ref
                    .read(userNotifierProvider.select((value) => value.user));

                await ref.read(editProfileNotifierProvider.notifier).onImei(
                    savedImei: savedImei,
                    imeiDBState: imeiDBState,
                    imeiDBString: imeiResponse,
                    onImeiNotRegistered: () async {
                      String generatedImei = ref
                          .read(imeiNotifierProvider.notifier)
                          .generateImei();

                      await ref
                          .read(editProfileNotifierProvider.notifier)
                          .registerAndShowDialog(
                              register: () => ref
                                  .read(editProfileNotifierProvider.notifier)
                                  .registerImei(imei: generatedImei),
                              getImeiCredentials: () => ref
                                  .read(imeiAuthNotifierProvider.notifier)
                                  .getImeiCredentials(),
                              onImeiComplete: () => ref
                                  .read(editProfileNotifierProvider.notifier)
                                  .onEditProfile(
                                      saveUser: () => ref
                                          .read(userNotifierProvider.notifier)
                                          .saveUserAfterUpdate(
                                              idKaryawan:
                                                  IdKaryawan(user.idKary ?? ''),
                                              password:
                                                  Password(user.password ?? ''),
                                              userId: UserId(user.nama ?? ''),
                                              server: PTName(user.ptServer)),
                                      onUser: () => ref
                                          .read(userNotifierProvider.notifier)
                                          .getUser()),
                              showDialog: () => showSuccessDialog(context));

                      ref.read(initImeiStatusProvider.notifier).state =
                          InitImeiStatus.success();
                    },
                    onImeiAlreadyRegistered: () async {
                      await ref
                          .read(editProfileNotifierProvider.notifier)
                          .onImeiAlreadyRegistered(
                            showDialog: () => showFailedDialog(context),
                            logout: () => ref
                                .read(userNotifierProvider.notifier)
                                .logout(),
                          );
                      //
                      ref.invalidate(resetInitProvider);
                    });
              }),
            ));

    return Container();
  }

  Future<void> showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => VSimpleDialog(
        label: 'Berhasil',
        labelDescription: 'Sukses daftar INSTALLATION ID',
        asset: Assets.iconChecked,
      ),
    ).then((_) => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => VSimpleDialog(
            color: Palette.red,
            label: 'Warning',
            labelDescription: 'Jika uninstall, unlink hp di setting profil',
            asset: Assets.iconChecked,
          ),
        ));
  }

  Future<void> showFailedDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => VSimpleDialog(
        label: 'Gagal',
        labelDescription: 'Sudah punya INSTALLATION ID',
        asset: Assets.iconCrossed,
      ),
    );
  }
}
