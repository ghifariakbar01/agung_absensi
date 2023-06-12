import 'package:face_net_authentication/pages/camera_signup.dart';
import 'package:face_net_authentication/pages/sign_in/sign_in_page.dart';
import 'package:face_net_authentication/pages/welcome_signed_in/welcome_page_signed.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../pages/absen/absen_daftar_page.dart';
import '../../../pages/absen/absen_keluar_page.dart';
import '../../../pages/absen/absen_masuk_page.dart';
import '../../../pages/absen/absen_page.dart';
import '../../../pages/change_pass/change_password_page.dart';
import '../../../pages/home.dart';
import '../../../pages/camera_page.dart';
import '../../../pages/welcome/presentation/welcome_page.dart';
import '../../presentation/widgets/splash_page.dart';
import '../../shared/providers.dart';
import 'auth/auth_notifier.dart';
import 'route_names.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authNotifierProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authNotifierProvider);

    final areWeSigningIn = state.location == RouteNames.signInRoute;

    return authState.maybeMap(
      authenticated: (_) => areWeSigningIn ? RouteNames.homeRoute : null,
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

            //
            GoRoute(
              name: RouteNames.signInNameRoute,
              path: RouteNames.signInRoute,
              builder: (context, state) => const SignInPage(),
            ),

            GoRoute(
              name: RouteNames.absenNameRoute,
              path: RouteNames.absenRoute,
              builder: (context, state) => const AbsenPage(),
            ),

            GoRoute(
              name: RouteNames.welcomeSignedNameRoute,
              path: RouteNames.welcomeSignedRoute,
              builder: (context, state) => const WelcomePageSigned(),
            ),

            GoRoute(
              name: RouteNames.absenDaftarNameRoute,
              path: RouteNames.absenDaftarRoute,
              builder: (context, state) => const AbsenDaftarPage(),
            ),

            GoRoute(
              name: RouteNames.absenMasukNameRoute,
              path: RouteNames.absenMasukRoute,
              builder: (context, state) => const AbsenMasukPage(),
            ),

            GoRoute(
              name: RouteNames.absenKeluarNameRoute,
              path: RouteNames.absenKeluarRoute,
              builder: (context, state) => const AbsenKeluarPage(),
            ),

            GoRoute(
              name: RouteNames.cameraNameRoute,
              path: RouteNames.cameraRoute,
              builder: (context, state) => const CameraPage(),
            ),

            GoRoute(
              name: RouteNames.homeNameRoute,
              path: RouteNames.homeRoute,
              builder: (context, state) => MyHomePage(),
            ),
          ]),
    ];
  }
}
