import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/constants/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/geofence/geofence_response.dart';
import '../../domain/geofence_failure.dart';
import '../../domain/user_failure.dart';
import '../../shared/providers.dart';
import 'welcome_imei.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_dialogs.dart';
import 'welome_scaffold.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage();

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(geofenceProvider.notifier).getGeofenceList();
      await ref.read(userNotifierProvider.notifier).getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
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

    ref.listen<Option<Either<GeofenceFailure, List<GeofenceResponse>>>>(
      geofenceProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
            (failure) => showCupertinoDialog(
                context: context,
                builder: (_) => VSimpleDialog(
                    label: 'Error',
                    labelDescription: failure.when(
                        server: (_, __) => 'Error server geofence',
                        wrongFormat: () => 'Error parsing geofence',
                        noConnection: () => 'No connection'),
                    asset: Assets.iconCrossed,
                    color: Colors.red)), (geofenceList) async {
          final geofence = ref
              .read(geofenceProvider.notifier)
              .geofenceResponseToList(geofenceList);

          await ref
              .read(geofenceProvider.notifier)
              .initializeGeoFence(geofence);
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
