import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/user_failure.dart';
import '../../shared/providers.dart';
import 'welcome_imei.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_dialogs.dart';
import 'welome_scaffold.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userNotifierProvider.notifier).getUser();
      await ref.read(geofenceProvider.notifier).getGeofenceList();
    });

    ref.listen<Option<Either<UserFailure, String?>>>(
      userNotifierProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
            (failure) => showDialog(
                  context: context,
                  builder: (_) => VSimpleDialog(
                    label: 'Error',
                    labelDescription: failure.maybeMap(
                        empty: (_) => 'No user found',
                        unknown: (unkn) => '${unkn.errorCode} ${unkn.message}',
                        orElse: () => ''),
                    asset: Assets.iconCrossed,
                  ),
                ), (userString) {
          final userParsed =
              ref.read(userNotifierProvider.notifier).parseUser(userString);

          userParsed.fold(
              (failure) => showDialog(
                    context: context,
                    builder: (_) => VSimpleDialog(
                      label: 'Error',
                      labelDescription: failure.maybeMap(
                          errorParsing: (error) =>
                              'Error while parsing user. ${error.message}',
                          orElse: () => ''),
                      asset: Assets.iconCrossed,
                    ),
                  ),
              (userParsed) => ref
                  .read(userNotifierProvider.notifier)
                  .onUserParsed(
                    user: userParsed,
                    dioRequestSet: () => ref.read(dioRequestProvider).addAll({
                      "username": "${userParsed.nama}",
                      "password": "${userParsed.password}",
                    }),
                    checkAndUpdateStatus: () => ref
                        .read(authNotifierProvider.notifier)
                        .checkAndUpdateAuthStatus(),
                    checkAndUpdateImei: () => ref
                        .read(imeiNotifierProvider.notifier)
                        .checkAndUpdateImei(user: userParsed),
                  ));
        }),
      ),
    );

    return Stack(
      children: [
        WelcomeScaffold(),
        WelcomeImei(),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
