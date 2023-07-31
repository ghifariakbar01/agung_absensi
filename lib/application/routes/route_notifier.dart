import 'dart:developer';

import 'package:face_net_authentication/application/imei_introduction/imei_introduction_notifier.dart';
import 'package:face_net_authentication/application/imei_introduction/imei_state.dart';
import 'package:face_net_authentication/application/permission/permission_state.dart';
import 'package:face_net_authentication/application/permission/shared/permission_introduction_providers.dart';
import 'package:face_net_authentication/application/tc/shared/tc_providers.dart';
import 'package:face_net_authentication/application/tc/tc_state.dart';
import 'package:face_net_authentication/pages/background/background_page.dart';
import 'package:face_net_authentication/pages/imei_introduction/imei_introduction_page.dart';
import 'package:face_net_authentication/pages/profile/edit_profile.dart/edit_profile_page.dart';
import 'package:face_net_authentication/pages/profile/profile_page.dart';
import 'package:face_net_authentication/pages/sign_in/sign_in_page.dart';
import 'package:face_net_authentication/pages/welcome_signed_in/welcome_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../pages/change_pass/change_password_page.dart';

import '../../pages/camera/camera_page.dart';
import '../../pages/camera/camera_signup.dart';
import '../../pages/copyright/copyright_page.dart';
import '../../pages/home/home.dart';
import '../../pages/permission/permission_page.dart';
import '../../pages/riwayat/riwayat_page.dart';
import '../../pages/tc/tc_page.dart';
import '../../pages/widgets/splash_page.dart';
import '../../shared/providers.dart';
import '../auth/auth_notifier.dart';

import '../imei_introduction/shared/imei_introduction_providers.dart';
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
  }

  final Ref _ref;

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authNotifierProvider);
    final tcState = _ref.read(tcNotifierProvider);
    final imeiIntroState = _ref.read(imeiIntroductionNotifierProvider);
    final permissionState = _ref.read(permissionNotifierProvider);

    final areWeSigningIn = state.location == RouteNames.signInRoute;
    final areWeReadingTC = state.location == RouteNames.termsAndConditionRoute;
    final areWeReadingImei = state.location == RouteNames.imeiInstructionRoute;
    final areWeGranting = state.location == RouteNames.permissionRoute;

    final weGranted = permissionState == PermissionState.completed();
    final weVisitedTC = tcState == TCState.visited();
    final weVisitedImei = imeiIntroState == ImeiIntroductionState.visited();

    final weAlreadyDidAllProcedures = weGranted && weVisitedTC && weVisitedImei;

    return authState.maybeMap(
      authenticated: (_) {
        if (areWeSigningIn) {
          if (weGranted && weVisitedTC && weVisitedImei) {
            return RouteNames.welcomeNameRoute;
          }

          return RouteNames.termsAndConditionNameRoute;
        }

        if (areWeReadingTC && weVisitedTC) {
          return RouteNames.imeiInstructionNameRoute;
        }

        if (areWeReadingImei && weVisitedImei) {
          return RouteNames.welcomeNameRoute;
        }

        if (areWeGranting && weAlreadyDidAllProcedures) {
          return RouteNames.welcomeNameRoute;
        }

        if (areWeGranting && weGranted) {
          return RouteNames.signInRoute;
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

      GoRoute(
          name: RouteNames.welcomeNameRoute,
          path: RouteNames.welcomeRoute,
          builder: (context, state) => const WelcomePage(),
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
              builder: (context, state) => MyAbsenPage(),
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
