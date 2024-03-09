import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/widgets/loading_overlay.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../domain/edit_failure.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../../widgets/v_dialogs.dart';
import 'profile_scaffold.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // FOR UNLINK DEVICE
    ref.listen<Option<Either<EditFailure, Unit?>>>(
      imeiNotifierProvider.select(
        (state) => state.failureOrSuccessOptionClearRegisterImei,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
              (failure) => failure.maybeMap(
                    noConnection: (_) => null,
                    orElse: () => showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                        label: 'Error',
                        labelDescription: failure.maybeMap(
                            server: (server) => 'error server $server',
                            passwordExpired: (password) => '$password',
                            passwordWrong: (password) => '$password',
                            orElse: () => ''),
                        asset: Assets.iconCrossed,
                      ),
                    ),
                  ),
              (_) => _onImeiCleared())),
    );

    final userUpdate = ref.watch(userInitFutureProvider(context));

    return VAsyncValueWidget(
        value: userUpdate,
        data: (_) => Stack(
              children: [
                const ProfileScaffold(),
                const LoadingOverlay(isLoading: false)
              ],
            ));
  }

  Future<void> _onImeiCleared() async {
    {
      bool isSuccess = await ref
          .read(imeiNotifierProvider.notifier)
          .clearImeiSuccess(
              idKary: ref.read(userNotifierProvider).user.IdKary ?? 'null');

      if (Platform.isIOS) {
        if (isSuccess) {
          await ref
              .read(imeiNotifierProvider.notifier)
              .clearImeiFromDBAndLogoutiOS(ref);
        }
      } else {
        if (isSuccess) {
          await ref
              .read(imeiNotifierProvider.notifier)
              .clearImeiFromDBAndLogout(ref);
        }
      }
    }
  }
}
