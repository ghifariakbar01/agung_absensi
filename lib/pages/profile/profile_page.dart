import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/profile/profile_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/user/user_model.dart';
import '../../constants/assets.dart';
import '../../domain/auth_failure.dart';
import '../../domain/edit_failure.dart';
import '../../domain/value_objects_copy.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import '../widgets/v_dialogs.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(userNotifierProvider.select((value) => value.user));

      // Get user
      await ref.read(userNotifierProvider.notifier).saveUserAfterUpdate(
          idKaryawan: IdKaryawan(user.idKary ?? ''),
          password: Password(user.password ?? ''),
          userId: UserId(user.nama ?? ''),
          server: PTName(user.ptServer));
    });

    ref.listen<Option<Either<AuthFailure, Unit?>>>(
      userNotifierProvider.select(
        (state) => state.failureOrSuccessOptionUpdate,
      ),
      (_, failureOrSuccessOptionUpdate) => failureOrSuccessOptionUpdate.fold(
        () {},
        (either) => either.fold(
            (failure) => failure.maybeMap(
                  noConnection: (_) =>
                      ref.read(absenOfflineModeProvider.notifier).state = true,
                  orElse: () => showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => VSimpleDialog(
                      label: 'Error',
                      labelDescription: failure.maybeMap(
                          server: (server) =>
                              '${server.errorCode} ${server.message}',
                          storage: (_) => 'storage penuh',
                          orElse: () => ''),
                      asset: Assets.iconCrossed,
                    ),
                  ),
                ),
            (_) => ref.read(userNotifierProvider.notifier).getUser()),
      ),
    );

    // FOR UNLINK DEVICE
    ref.listen<Option<Either<EditFailure, Unit>>>(
      editProfileNotifierProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
                  (failure) => AlertHelper.showSnackBar(
                        context,
                        message: failure.map(
                          server: (value) =>
                              '${value.message} ${value.errorCode}',
                          noConnection: (_) => 'tidak ada koneksi',
                        ),
                      ), (_) async {
                await ref
                    .read(userNotifierProvider.notifier)
                    .logout(UserModelWithPassword.initial());

                await ref
                    .read(authNotifierProvider.notifier)
                    .checkAndUpdateAuthStatus();
              })),
    );

    return Stack(
      children: [
        const ProfileScaffold(),
        const LoadingOverlay(isLoading: false)
      ],
    );
  }
}
