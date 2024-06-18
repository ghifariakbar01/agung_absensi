import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../domain/edit_failure.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../../utils/dialog_helper.dart';
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
      (_, failureOrSuccessOption) => failureOrSuccessOption
          .fold(
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
                  (_) => DialogHelper.showCustomDialog(
                        'Unlink Sukses. Mohon Uninstall Aplikasi. Terimakasih 🙏',
                        context,
                        label: 'Uninstall',
                        isLarge: true,
                        assets: Assets.iconChecked,
                      )))!
          .then((_) => _onImeiCleared()),
    );

    final user = ref.watch(getUserFutureProvider);

    return VAsyncWidgetScaffold(
      value: user,
      data: (_) => ProfileScaffold(),
    );
  }

  Future<void> _onImeiCleared() async {
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
