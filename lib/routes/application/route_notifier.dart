import 'package:face_net_authentication/sakit/create_sakit/presentation/edit_sakit_page.dart';
import 'package:face_net_authentication/sakit/sakit_dtl/presentation/sakit_dtl_page.dart';
import 'package:face_net_authentication/sakit/sakit_dtl/presentation/sakit_dtl_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../../pages/change_pass/change_password_page.dart';

import '../../absen/presentation/absen_page.dart';

import '../../auth/application/auth_notifier.dart';
import '../../background/presentation/background_page.dart';
import '../../copyright/presentation/copyright_page.dart';
import '../../cuti/create_cuti/presentation/create_cuti_page.dart';
import '../../cuti/create_cuti/presentation/edit_cuti_page.dart';
import '../../cuti/cuti_list/application/cuti_list.dart';
import '../../cuti/cuti_list/presentation/cuti_list_page.dart';
import '../../edit_profile/presentation/edit_profile_page.dart';
import '../../home/presentation/home_page.dart';
import '../../imei_introduction/application/imei_state.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../imei_introduction/presentation/imei_introduction_page.dart';
import '../../init_user/application/init_user_status.dart';
import '../../init_user/presentation/init_user_scaffold.dart';
import '../../permission/presentation/permission_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../riwayat_absen/presentation/riwayat_page.dart';
import '../../sakit/create_sakit/presentation/create_sakit_page.dart';
import '../../sakit/sakit_dtl/presentation/sakit_upload_page.dart';

import '../../sakit/sakit_list/application/sakit_list.dart';
import '../../sakit/sakit_list/presentation/sakit_list_page.dart';
import '../../shared/providers.dart';
import '../../sign_in_form/presentation/sign_in_page.dart';
import '../../tc/application/shared/tc_providers.dart';
import '../../tc/application/tc_state.dart';
import '../../tc/presentation/tc_page.dart';
import '../../widgets/splash_page.dart';
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
      imeiIntroNotifierProvider,
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
    final imeiIntroState = _ref.read(imeiIntroNotifierProvider);

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
            GoRoute(
                name: RouteNames.permissionNameRoute,
                path: RouteNames.permissionRoute,
                builder: (context, state) => const PermissionPage()),
            GoRoute(
              name: RouteNames.riwayatAbsenNameRoute,
              path: RouteNames.riwayatAbsenRoute,
              builder: (context, state) => const RiwayatAbsenPage(),
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

            GoRoute(
              name: RouteNames.sakitListNameRoute,
              path: RouteNames.sakitListRoute,
              builder: (context, state) => SakitListPage(),
            ),
            GoRoute(
              name: RouteNames.createSakitNameRoute,
              path: RouteNames.createSakitRoute,
              builder: (context, state) => CreateSakitPage(),
            ),
            GoRoute(
              name: RouteNames.editSakitNameRoute,
              path: RouteNames.editSakitRoute,
              builder: (context, state) {
                final sakit = state.extra as SakitList;
                return EditSakitPage(sakit);
              },
            ),
            GoRoute(
                name: RouteNames.sakitDtlNameRoute,
                path: RouteNames.sakitDtlRoute,
                builder: (context, state) {
                  final id = state.extra as int;
                  return SakitDtlPageBy(id);
                }),
            GoRoute(
                name: RouteNames.sakitUploadNameRoute,
                path: RouteNames.sakitUploadRoute,
                builder: (context, state) {
                  final id = state.extra as int;
                  return SakitUploadPage(id);
                }),
            GoRoute(
                name: RouteNames.sakitPhotoDtlNameRoute,
                path: RouteNames.sakitPhotoDtlRoute,
                builder: (context, state) {
                  final imageUrl = state.extra as String;
                  return SakitDtlPhotoPage(imageUrl: imageUrl);
                }),

            GoRoute(
              name: RouteNames.cutiListNameRoute,
              path: RouteNames.cutiListRoute,
              builder: (context, state) => CutiListPage(),
            ),
            GoRoute(
              name: RouteNames.createCutiNameRoute,
              path: RouteNames.createCutiRoute,
              builder: (context, state) => CreateCutiPage(),
            ),
            GoRoute(
              name: RouteNames.editCutiNameRoute,
              path: RouteNames.editCutiRoute,
              builder: (context, state) {
                final cuti = state.extra as CutiList;
                return EditCutiPage(cuti);
              },
            ),

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
            // GoRoute(
            //   name: RouteNames.cameraNameRoute,
            //   path: RouteNames.cameraRoute,
            //   builder: (context, state) => const CameraPage(),
            // ),
          ]),
    ];
  }
}
