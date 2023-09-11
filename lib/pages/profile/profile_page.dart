import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/profile/profile_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/init_geofence/init_geofence_status.dart';
import '../../application/init_imei/init_imei_status.dart';
import '../../application/init_password_expired/init_password_expired_status.dart';
import '../../application/init_user/init_user_status.dart';
import '../../constants/assets.dart';
import '../../domain/auth_failure.dart';
import '../../domain/edit_failure.dart';
import '../../domain/value_objects_copy.dart';
import '../../shared/providers.dart';
import '../widgets/v_dialogs.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                ref.read(userNotifierProvider.notifier).setUserInitial();
                ref.read(initUserStatusProvider.notifier).state =
                    InitUserStatus.init();
                await ref.read(userNotifierProvider.notifier).logout();
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
