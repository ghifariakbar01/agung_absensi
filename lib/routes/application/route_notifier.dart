import 'package:face_net_authentication/absen_manual/create_absen_manual/presentation/edit_absen_manual_page.dart';
import 'package:face_net_authentication/dt_pc/create_dt_pc/presentation/edit_dt_pc_page.dart';
import 'package:face_net_authentication/sakit/create_sakit/presentation/edit_sakit_page.dart';
import 'package:face_net_authentication/sakit/sakit_dtl/presentation/sakit_dtl_page.dart';
import 'package:face_net_authentication/sakit/sakit_dtl/presentation/sakit_dtl_photo_page.dart';
import 'package:face_net_authentication/tugas_dinas/create_tugas_dinas/presentation/create_tugas_dinas_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../absen/presentation/absen_page.dart';

import '../../absen_manual/absen_manual_list/application/absen_manual_list.dart';
import '../../absen_manual/absen_manual_list/presentation/absen_manual_list_page.dart';
import '../../absen_manual/create_absen_manual/presentation/create_absen_manual_page.dart';
import '../../auth/application/auth_notifier.dart';
import '../../background/presentation/background_page.dart';

import '../../copyright/presentation/copyright_page.dart';
import '../../cuti/create_cuti/presentation/create_cuti_page.dart';
import '../../cuti/create_cuti/presentation/edit_cuti_page.dart';
import '../../cuti/cuti_list/application/cuti_list.dart';
import '../../cuti/cuti_list/presentation/cuti_list_page.dart';
import '../../dt_pc/create_dt_pc/presentation/create_dt_pc_page.dart';
import '../../dt_pc/dt_pc_list/application/dt_pc_list.dart';
import '../../dt_pc/dt_pc_list/presentation/dt_pc_list_page.dart';

import '../../ganti_hari/create_ganti_hari/presentation/create_ganti_hari_page.dart';
import '../../ganti_hari/create_ganti_hari/presentation/edit_ganti_hari_page.dart';
import '../../ganti_hari/ganti_hari_list/application/ganti_hari_list.dart';
import '../../ganti_hari/ganti_hari_list/presentation/ganti_hari_list_page.dart';
import '../../home/presentation/home_page.dart';
import '../../imei_introduction/application/imei_state.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../imei_introduction/presentation/imei_introduction_page.dart';
import '../../init_user/application/init_user_status.dart';
import '../../izin/create_izin/presentation/create_izin_page.dart';
import '../../izin/create_izin/presentation/edit_izin_page.dart';
import '../../izin/izin_list/application/izin_list.dart';
import '../../izin/izin_list/presentation/izin_list_page.dart';
import '../../lembur/create_lembur/presentation/create_lembur_page.dart';
import '../../lembur/create_lembur/presentation/edit_lembur_page.dart';
import '../../lembur/lembur_list/application/lembur_list.dart';
import '../../lembur/lembur_list/presentation/lembur_list_page.dart';
import '../../permission/presentation/permission_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../riwayat_absen/presentation/riwayat_page.dart';
import '../../sakit/create_sakit/presentation/create_sakit_page.dart';
import '../../sakit/sakit_dtl/presentation/sakit_upload_page.dart';

import '../../sakit/sakit_list/application/sakit_list.dart';
import '../../sakit/sakit_list/presentation/sakit_list_page.dart';
import '../../shared/providers.dart';
import '../../sign_in_form/presentation/sign_in_page.dart';
import '../../slip_gaji/slip_gaji_page.dart';
import '../../tc/application/shared/tc_providers.dart';
import '../../tc/application/tc_state.dart';
import '../../tc/presentation/tc_page.dart';
import '../../tugas_dinas/create_tugas_dinas/presentation/edit_tugas_dinas_page.dart';
import '../../tugas_dinas/create_tugas_dinas/presentation/search_pemberi_tugas.dart';
import '../../tugas_dinas/tugas_dinas_list/application/tugas_dinas_list.dart';
import '../../tugas_dinas/tugas_dinas_list/presentation/tugas_dinas_list_page.dart';
import '../../tugas_dinas/tugas_dinas_list/presentation/tugas_dinas_view_surat.dart';
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
      initUserStatusNotifierProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final tcState = _ref.read(tcNotifierProvider);
    final authState = _ref.read(authNotifierProvider);
    final initUserState = _ref.read(initUserStatusNotifierProvider);
    final imeiIntroState = _ref.read(imeiIntroNotifierProvider);

    final String current = state.matchedLocation;
    final areWeAtDefaultRoute = current == RouteNames.defaultRoute;

    final defaultRoute = current == RouteNames.defaultRoute;
    final areWeSigningIn = current == RouteNames.signInRoute;
    final areWeReadingTC = current == RouteNames.termsAndConditionRoute;
    final areWeReadingImei = current == RouteNames.imeiInstructionRoute;

    final weInitializedUser = initUserState == InitUserStatus.success();

    final weVisitedTC = tcState == TCState.visited();
    final weVisitedImei = imeiIntroState == ImeiIntroductionState.visited();

    final weAlreadyDidAllProcedures =
        weInitializedUser && weVisitedTC && weVisitedImei;

    return authState.maybeMap(
      authenticated: (_) {
        if (areWeSigningIn || defaultRoute) {
          if (weVisitedTC && weVisitedImei) {
            return RouteNames.homeRoute;
          } else {
            return RouteNames.termsAndConditionRoute;
          }
        }

        if (areWeReadingTC && weVisitedTC) {
          return RouteNames.imeiInstructionRoute;
        }

        if (areWeReadingImei && weVisitedImei) {
          return RouteNames.homeRoute;
        }

        if (!weVisitedImei) {
          return RouteNames.imeiInstructionRoute;
        }

        if (areWeAtDefaultRoute) {
          if (!weVisitedTC) {
            return RouteNames.termsAndConditionRoute;
          }

          if (weAlreadyDidAllProcedures) {
            return RouteNames.homeRoute;
          }
        }

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
                final cuti = state.extra as Map<String, dynamic>;
                final _data = SakitList.fromJson(cuti);
                return EditSakitPage(_data);
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
                final cuti = state.extra as Map<String, dynamic>;
                final _data = CutiList.fromJson(cuti);
                return EditCutiPage(_data);
              },
            ),
            GoRoute(
              name: RouteNames.izinListNameRoute,
              path: RouteNames.izinListRoute,
              builder: (context, state) => IzinListPage(),
            ),
            GoRoute(
              name: RouteNames.createIzinNameRoute,
              path: RouteNames.createIzinRoute,
              builder: (context, state) => CreateIzinPage(),
            ),
            GoRoute(
              name: RouteNames.editIzinNameRoute,
              path: RouteNames.editIzinRoute,
              builder: (context, state) {
                final absen = state.extra as Map<String, dynamic>;
                final _data = IzinList.fromJson(absen);
                return EditIzinPage(_data);
              },
            ),
            GoRoute(
              name: RouteNames.dtPcListNameRoute,
              path: RouteNames.dtPcListRoute,
              builder: (context, state) => DtPcListPage(),
            ),
            GoRoute(
              name: RouteNames.createDtPcNameRoute,
              path: RouteNames.createDtPcRoute,
              builder: (context, state) => CreateDtPcPage(),
            ),
            GoRoute(
              name: RouteNames.editDtPcNameRoute,
              path: RouteNames.editDtPcRoute,
              builder: (context, state) {
                final absen = state.extra as Map<String, dynamic>;
                final _data = DtPcList.fromJson(absen);
                return EditDtPcPage(_data);
              },
            ),
            GoRoute(
              name: RouteNames.absenManualListNameRoute,
              path: RouteNames.absenManualListRoute,
              builder: (context, state) => AbsenManualListPage(),
            ),
            GoRoute(
              name: RouteNames.createAbsenManualNameRoute,
              path: RouteNames.createAbsenManualRoute,
              builder: (context, state) => CreateAbsenManualPage(),
            ),
            GoRoute(
              name: RouteNames.editAbsenManualNameRoute,
              path: RouteNames.editAbsenManualRoute,
              builder: (context, state) {
                final absen = state.extra as Map<String, dynamic>;
                final _data = AbsenManualList.fromJson(absen);
                return EditAbsenManualPage(_data);
              },
            ),
            GoRoute(
              name: RouteNames.tugasDinasListNameRoute,
              path: RouteNames.tugasDinasListRoute,
              builder: (context, state) => TugasDinasListPage(),
            ),
            GoRoute(
              name: RouteNames.createTugasDinasNameRoute,
              path: RouteNames.createTugasDinasRoute,
              builder: (context, state) => CreateTugasDinasPage(),
            ),
            GoRoute(
              name: RouteNames.editTugasDinasNameRoute,
              path: RouteNames.editTugasDinasRoute,
              builder: (context, state) {
                final tugas = state.extra as Map<String, dynamic>;
                final _data = TugasDinasList.fromJson(tugas);
                return EditTugasDinasPage(_data);
              },
            ),
            GoRoute(
              name: RouteNames.searchPemberiTugasDinasNameRoute,
              path: RouteNames.searchPemberiTugasDinasRoute,
              builder: (context, state) => SearchPemberiTugas(),
            ),
            GoRoute(
              name: RouteNames.gantiHariListNameRoute,
              path: RouteNames.gantiHariListRoute,
              builder: (context, state) => GantiHariListPage(),
            ),
            GoRoute(
              name: RouteNames.createGantiHariNameRoute,
              path: RouteNames.createGantiHariRoute,
              builder: (context, state) => CreateGantiHariPage(),
            ),
            GoRoute(
              name: RouteNames.editGantiHariNameRoute,
              path: RouteNames.editGantiHariRoute,
              builder: (context, state) {
                final dayoff = state.extra as Map<String, dynamic>;
                final _data = GantiHariList.fromJson(dayoff);
                return EditGantiHariPage(_data);
              },
            ),
            GoRoute(
              name: RouteNames.lemburListNameRoute,
              path: RouteNames.lemburListRoute,
              builder: (context, state) => LemburListPage(),
            ),
            GoRoute(
              name: RouteNames.createLemburNameRoute,
              path: RouteNames.createLemburRoute,
              builder: (context, state) => CreateLemburPage(),
            ),
            GoRoute(
              name: RouteNames.editLemburNameRoute,
              path: RouteNames.editLemburRoute,
              builder: (context, state) {
                final dayoff = state.extra as Map<String, dynamic>;
                final _data = LemburList.fromJson(dayoff);
                return EditLemburPage(_data);
              },
            ),
            GoRoute(
              name: RouteNames.slipGajiNameRoute,
              path: RouteNames.slipGajiRoute,
              builder: (context, state) => SlipGajiPage(),
            ),
            GoRoute(
              name: RouteNames.viewSuratNameRoute,
              path: RouteNames.viewSuratRoute,
              builder: (context, state) {
                final id = state.extra as int;
                return TugasDinasViewSuratPage(id);
              },
            ),
          ]),
    ];
  }
}
