
import 'package:face_net_authentication/application/init_user/init_user_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../pages/change_pass/change_password_page.dart';

import '../../pages/absen/absen_page.dart';
import '../../pages/background/background_page.dart';
import '../../pages/camera/camera_page.dart';
import '../../pages/camera/camera_signup.dart';
import '../../pages/copyright/copyright_page.dart';
import '../../pages/imei_introduction/imei_introduction_page.dart';
import '../../pages/permission/permission_page.dart';
import '../../pages/profile/edit_profile.dart/edit_profile_page.dart';
import '../../pages/profile/profile_page.dart';
import '../../pages/riwayat/riwayat_page.dart';
import '../../pages/sign_in/sign_in_page.dart';
import '../../pages/tc/tc_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/widgets/splash_page.dart';
import '../../shared/providers.dart';
import '../auth/auth_notifier.dart';

import '../imei_introduction/imei_state.dart';
import '../imei_introduction/shared/imei_introduction_providers.dart';
import '../init_geofence/init_geofence_scaffold.dart';
import '../init_geofence/init_geofence_status.dart';
import '../init_imei/init_imei_scaffold.dart';
import '../init_imei/init_imei_status.dart';
import '../init_password_expired/init_password_expired.dart';
import '../init_password_expired/init_password_expired_status.dart';
import '../init_user/init_user_scaffold.dart';
import '../permission/permission_state.dart';
import '../permission/shared/permission_introduction_providers.dart';
import '../tc/shared/tc_providers.dart';
import '../tc/tc_state.dart';
import 'route_names.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authNotifierProvider,
      (_, __) => notifyListeners(),
    );

    _ref.listen<PermissionState>(
      permissionNotifierProvider,
      (_, __) => notifyListeners(),
    );

    _ref.listen<TCState>(
      tcNotifierProvider,
      (_, __) => notifyListeners(),
    );

    _ref.listen<ImeiIntroductionState>(
      imeiIntroductionNotifierProvider,
      (_, __) => notifyListeners(),
    );

    _ref.listen<InitUserStatus>(
        initUserStatusProvider, (__, _) => notifyListeners());

    _ref.listen<InitGeofenceStatus>(
        initGeofenceStatusProvider, (__, _) => notifyListeners());

    _ref.listen<InitImeiStatus>(
        initImeiStatusProvider, (__, _) => notifyListeners());

    _ref.listen<InitPasswordExpiredStatus>(
        initPasswordExpiredStatusProvider, (__, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authNotifierProvider);
    final tcState = _ref.read(tcNotifierProvider);
    final imeiIntroState = _ref.read(imeiIntroductionNotifierProvider);
    final permissionState = _ref.read(permissionNotifierProvider);

    final initializationUserState = _ref.read(initUserStatusProvider);
    final initializationGeofenceState = _ref.read(initGeofenceStatusProvider);
    final initializationImeiState = _ref.read(initImeiStatusProvider);
    final initializationPasswordExpiredState =
        _ref.read(initPasswordExpiredStatusProvider);

    final areWeInitializingUser =
        state.location == RouteNames.initUserNameRoute;
    final areWeInitializingGeofence =
        state.location == RouteNames.initGeofenceNameRoute;
    final areWeInitializingImei =
        state.location == RouteNames.initImeiNameRoute;
    final areWeInitializingPasswordExpired =
        state.location == RouteNames.initPasswordExpiredNameRoute;

    final areWeSigningIn = state.location == RouteNames.signInRoute;
    final areWeReadingTC = state.location == RouteNames.termsAndConditionRoute;
    final areWeReadingImei = state.location == RouteNames.imeiInstructionRoute;
    final areWeGranting = state.location == RouteNames.permissionRoute;

    final weInitializedUser =
        initializationUserState == InitUserStatus.success();
    final weInitializedGeofence =
        initializationGeofenceState == InitGeofenceStatus.success();
    final weInitializedImei =
        initializationImeiState == InitImeiStatus.success();
    final weInitializedPasswordExpired = initializationPasswordExpiredState ==
        InitPasswordExpiredStatus.success();

    final weGranted = permissionState == PermissionState.completed();
    final weVisitedTC = tcState == TCState.visited();
    final weVisitedImei = imeiIntroState == ImeiIntroductionState.visited();

    final weAlreadyDidAllProcedures = weGranted &&
        weVisitedTC &&
        weVisitedImei &&
        weInitializedUser &&
        weInitializedGeofence &&
        weInitializedImei &&
        weInitializedPasswordExpired;

    return authState.maybeMap(
      authenticated: (_) {
        if (!weGranted) {
          return RouteNames.permissionNameRoute;
        }

        if (areWeSigningIn) {
          if (weGranted && weVisitedTC && weVisitedImei) {
            return RouteNames.initUserNameRoute;
          }

          return RouteNames.termsAndConditionNameRoute;
        }

        if (areWeReadingTC && weVisitedTC) {
          return RouteNames.imeiInstructionNameRoute;
        }

        if (areWeReadingImei && weVisitedImei) {
          return RouteNames.initUserNameRoute;
        }

        if (areWeGranting && weAlreadyDidAllProcedures) {
          return RouteNames.initUserNameRoute;
        }

        if (areWeGranting && weGranted) {
          return RouteNames.signInRoute;
        }

        if (areWeInitializingUser) {
          if (weInitializedUser) {
            return RouteNames.initGeofenceNameRoute;
          }
        }

        if (areWeInitializingGeofence) {
          if (weInitializedGeofence) {
            return RouteNames.initImeiNameRoute;
          }
        }

        if (areWeInitializingImei) {
          if (weInitializedImei) {
            return RouteNames.initPasswordExpiredNameRoute;
          }
        }

        if (areWeInitializingPasswordExpired) {
          if (weInitializedPasswordExpired) {
            return RouteNames.homeNameRoute;
          }
        }

        return null;
      },
      orElse: () => areWeSigningIn
          ? null
          : () {
              if (weGranted) {
                return RouteNames.signInRoute;
              } else {
                return RouteNames.permissionRoute;
              }
            }(),
    );
  }

  List<GoRoute> get routes {
    return [
      GoRoute(
        name: RouteNames.defaultNameRoute,
        path: RouteNames.defaultRoute,
        builder: (context, state) => const SplashPage(),
      ),
      //
      GoRoute(
        name: RouteNames.signInNameRoute,
        path: RouteNames.signInRoute,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        name: RouteNames.termsAndConditionNameRoute,
        path: RouteNames.termsAndConditionRoute,
        builder: (context, state) => TCPage(),
      ),
      GoRoute(
          name: RouteNames.imeiInstructionNameRoute,
          path: RouteNames.imeiInstructionRoute,
          builder: (context, state) => ImeiIntroductionPage()),

      GoRoute(
          name: RouteNames.permissionNameRoute,
          path: RouteNames.permissionRoute,
          builder: (context, state) => const PermissionPage()),
      //
      GoRoute(
          name: RouteNames.initUserNameRoute,
          path: RouteNames.initUserRoute,
          builder: (context, state) => const InitUserScaffold()),
      //
      GoRoute(
          name: RouteNames.initGeofenceNameRoute,
          path: RouteNames.initGeofenceRoute,
          builder: (context, state) => const InitGeofenceScaffold()),
      //
      GoRoute(
          name: RouteNames.initImeiNameRoute,
          path: RouteNames.initImeiRoute,
          builder: (context, state) => const InitImeiScaffold()),
      //
      GoRoute(
          name: RouteNames.initPasswordExpiredNameRoute,
          path: RouteNames.initPasswordExpiredRoute,
          builder: (context, state) => const InitPasswordExpiredScaffold()),
      //
      GoRoute(
          name: RouteNames.homeNameRoute,
          path: RouteNames.homeRoute,
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              name: RouteNames.changePassNameRoute,
              path: RouteNames.changePassRoute,
              builder: (context, state) => const ChangePasswordPage(),
            ),
            GoRoute(
              name: RouteNames.signUpNameRoute,
              path: RouteNames.signUpRoute,
              builder: (context, state) => const SignUp(),
            ),
            GoRoute(
              name: RouteNames.riwayatAbsenNameRoute,
              path: RouteNames.riwayatAbsenRoute,
              builder: (context, state) => const RiwayatAbsenPage(),
            ),
            GoRoute(
              name: RouteNames.cameraNameRoute,
              path: RouteNames.cameraRoute,
              builder: (context, state) => const CameraPage(),
            ),
            GoRoute(
              name: RouteNames.editProfileNameRoute,
              path: RouteNames.editProfileRoute,
              builder: (context, state) => const EditProfilePage(),
            ),
            GoRoute(
              name: RouteNames.profileNameRoute,
              path: RouteNames.profileRoute,
              builder: (context, state) => const ProfilePage(),
            ),
            GoRoute(
              name: RouteNames.absenTersimpanNameRoute,
              path: RouteNames.absenTersimpanRoute,
              builder: (context, state) => BackgroundPage(),
            ),
            GoRoute(
              name: RouteNames.absenNameRoute,
              path: RouteNames.absenRoute,
              builder: (context, state) => AbsenPage(),
            ),
            GoRoute(
              name: RouteNames.copyrightNameRoute,
              path: RouteNames.copyrightRoute,
              builder: (context, state) => CopyRightPage(),
            ),
          ]),
    ];
  }
}
