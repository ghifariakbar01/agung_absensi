import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/profile/profile_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/init_user/init_user_status.dart';
import '../../constants/assets.dart';
import '../../domain/edit_failure.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../widgets/v_dialogs.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userInitFutureProvider(context).future);
      // await ref.read(getUserFutureProvider.future);
    });
  }

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
                      ), (_) async {
                bool isSuccess = await ref
                    .read(imeiNotifierProvider.notifier)
                    .clearImeiSuccess();

                if (Platform.isIOS) {
                  bool isImeiClearedFromSaved = await ref
                      .read(imeiNotifierProvider.notifier)
                      .clearImeiSaved();

                  if (isSuccess && isImeiClearedFromSaved) {
                    await ref
                        .read(imeiNotifierProvider.notifier)
                        .clearImeiFromDBAndLogout(ref);
                  }
                } else {
                  if (isSuccess) {
                    await ref
                        .read(imeiNotifierProvider.notifier)
                        .clearImeiFromDBAndLogout(ref);
                  }
                }
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
