import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/user/user_model.dart';
import 'package:face_net_authentication/constants/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../application/geofence/geofence_response.dart';
import '../../application/routes/route_names.dart';
import '../../domain/geofence_failure.dart';
import '../../domain/user_failure.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_dialogs.dart';
import 'welome_scaffold.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userNotifierProvider.notifier).getUser();
//
      await ref.read(geofenceProvider.notifier).getGeofenceList();

      // await ref.read(geofenceProvider.notifier).initializeGeoFence();
    });

    ref.listen<Option<Either<UserFailure, String?>>>(
      userNotifierProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
            (failure) => VSimpleDialog(
                label: 'Error',
                labelDescription: failure.maybeMap(
                    empty: (_) => 'No user found',
                    unknown: (unkn) => '${unkn.errorCode} ${unkn.message}',
                    orElse: () => ''),
                asset: Assets.iconCrossed,
                color: Colors.red), (user) {
          final userParsed =
              ref.read(userNotifierProvider.notifier).parseUser(user);

          userParsed.fold(
              (failure) => VSimpleDialog(
                  label: 'Error',
                  labelDescription: failure.maybeMap(
                      errorParsing: (error) =>
                          'Error while parsing user. ${error.message}',
                      orElse: () => ''),
                  asset: Assets.iconCrossed,
                  color: Colors.red), (userParsed) {
            ref.read(userNotifierProvider.notifier).setUser(userParsed);

            ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
          });
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
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Center(
              child: TextButton(
            onPressed: () => showCupertinoDialog(
                context: context,
                builder: (_) => VAlertDialog(
                    color: Palette.secondaryColor,
                    label: 'Ingin loogout ?',
                    labelDescription: 'LOGOUT',
                    onPressed: () async {
                      context.pop();

                      debugger(message: 'called');

                      await ref
                          .read(userNotifierProvider.notifier)
                          .logout(UserModel.initial());

                      await ref
                          .read(authNotifierProvider.notifier)
                          .checkAndUpdateAuthStatus();

                      final isLoggedIn = ref.watch(authNotifierProvider);

                      isLoggedIn == AuthState.authenticated()
                          ? context.replaceNamed(RouteNames.welcomeNameRoute)
                          : context.replaceNamed(RouteNames.signInNameRoute);
                    })),
            child: Text(
              'logout',
              style: Themes.blackItalic(),
            ),
          )),
        ),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
