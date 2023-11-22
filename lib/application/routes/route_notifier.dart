import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../../pages/change_pass/change_password_page.dart';

import '../../pages/absen/absen_page.dart';
import '../../pages/background/background_page.dart';
import '../../pages/copyright/copyright_page.dart';
import '../../pages/imei_introduction/imei_introduction_page.dart';
import '../../pages/init/init_user_scaffold.dart';
import '../../pages/permission/permission_page.dart';
import '../../pages/profile/edit_profile/edit_profile_page.dart';
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
import '../init_user/init_user_status.dart';
import '../tc/shared/tc_providers.dart';
import '../tc/tc_state.dart';
import 'route_names.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authNotifierProvider,
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
        initUserStatusNotifierProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final tcState = _ref.read(tcNotifierProvider);
    final authState = _ref.read(authNotifierProvider);
    final initUserState = _ref.read(initUserStatusNotifierProvider);
    final imeiIntroState = _ref.read(imeiIntroductionNotifierProvider);

    final areWeSigningIn = state.location == RouteNames.signInRoute;
    final areWeReadingTC = state.location == RouteNames.termsAndConditionRoute;
    final areWeReadingImei = state.location == RouteNames.imeiInstructionRoute;

    final areWeInitializingUser =
        state.location == RouteNames.initUserNameRoute;

    final weInitializedUser = initUserState == InitUserStatus.success();

    final weVisitedTC = tcState == TCState.visited();
    final weVisitedImei = imeiIntroState == ImeiIntroductionState.visited();

    final weAlreadyDidAllProcedures =
        weInitializedUser && weVisitedTC && weVisitedImei;

    return authState.maybeMap(
      authenticated: (_) {
        if (areWeSigningIn) {
          if (weVisitedTC && weVisitedImei) {
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

        if (areWeInitializingUser) {
          if (weAlreadyDidAllProcedures) {
            return RouteNames.homeNameRoute;
          } else {
            return RouteNames.initUserNameRoute;
          }
        }

        // if (weAlreadyDidAllProcedures) {
        //   return RouteNames.initUserNameRoute;
        // }

        // log('state.location ${state.location} weInitializedUser');
        // log('$initUserState $weInitializedUser weInitializedUser');
        // log('$imeiIntroState $weVisitedImei weVisitedImei $weVisitedTC');

        return null;
      },
      orElse: () => areWeSigningIn ? null : RouteNames.signInRoute,
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
        name: RouteNames.initUserNameRoute,
        path: RouteNames.initUserRoute,
        builder: (context, state) => InitUserScaffold(),
      ),

      GoRoute(
          name: RouteNames.homeNameRoute,
          path: RouteNames.homeRoute,
          builder: (context, state) => const HomePage(),
          routes: [
            // GoRoute(
            //   name: RouteNames.changePassNameRoute,
            //   path: RouteNames.changePassRoute,
            //   builder: (context, state) => const ChangePasswordPage(),
            // ),
            // GoRoute(
            //   name: RouteNames.signUpNameRoute,
            //   path: RouteNames.signUpRoute,
            //   builder: (context, state) => const SignUp(),
            // ),
            GoRoute(
                name: RouteNames.permissionNameRoute,
                path: RouteNames.permissionRoute,
                builder: (context, state) => const PermissionPage()),
            GoRoute(
              name: RouteNames.riwayatAbsenNameRoute,
              path: RouteNames.riwayatAbsenRoute,
              builder: (context, state) => const RiwayatAbsenPage(),
            ),
            // GoRoute(
            //   name: RouteNames.cameraNameRoute,
            //   path: RouteNames.cameraRoute,
            //   builder: (context, state) => const CameraPage(),
            // ),
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
