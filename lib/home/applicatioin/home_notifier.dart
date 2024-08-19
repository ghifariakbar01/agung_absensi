import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../cross_auth/application/cross_auth_notifier.dart';
import '../../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../../imei/application/imei_notifier.dart';
import '../../permission/application/shared/permission_introduction_providers.dart';
import '../../routes/application/route_names.dart';
import '../../tester/application/tester_state.dart';
import '../../widgets/v_dialogs.dart';
import '../../shared/providers.dart';

import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState.initial());

  Future<void> redirect({
    required String route,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    state = const HomeState.inProgress();

    await _processRedirect(
      ref: ref,
      route: route,
      context: context,
    );

    state = const HomeState.success();
  }

  Future<void> _processRedirect({
    required String route,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    bool isAbsenRoute = route == RouteNames.absenRoute;
    bool isRiwayatRoute = route == RouteNames.riwayatRoute;

    bool isSlipGajiRoute = route == RouteNames.slipGajiRoute;

    bool isGpsOff = await FlLocation.isLocationServicesEnabled == false;

    final tester = ref.read(testerNotifierProvider);
    bool isTester = tester != TesterState.forcedRegularUser();

    final permissionNotifier = ref.read(permissionNotifierProvider.notifier);
    bool isLocationDenied = await permissionNotifier.isLocationDenied();

    if (isAbsenRoute || isRiwayatRoute || isSlipGajiRoute) {
      await _uncross(ref);
    }

    /*
      Saat masuk ke Absen, atau Riwayat
    */
    if (isAbsenRoute) {
      _resetFoso(ref);

      if (!isTester) {
        if (isGpsOff) {
          return showDialog(
            context: context,
            builder: (context) => VSimpleDialog(
                label: 'GPS Tidak Berfungsi',
                labelDescription:
                    'Mohon nyalakan GPS pada device anda. Terimakasih 🙏',
                asset: Assets.iconLocationOff),
          );
        }

        if (isLocationDenied) {
          return showDialog(
            context: context,
            builder: (context) => VSimpleDialog(
                label: 'Izin Lokasi Tidak Aktif',
                labelDescription:
                    'Mohon nyalakan Izin Lokasi untuk E-FINGER. Terimakasih 🙏',
                asset: Assets.iconLocationOff),
          ).then((_) => context.pushNamed(RouteNames.permissionRoute));
        }
      }
    }

    await context.pushNamed(route);
    return;
  }

  Future<void> _uncross(WidgetRef ref) async {
    final user = ref.read(userNotifierProvider).user;
    final data = await ref.refresh(isUserCrossedProvider.future);

    final _isCrossed = data.when(
      crossed: () => true,
      notCrossed: () => false,
    );

    final _ptMap = await ref
        .read(firebaseRemoteConfigNotifierProvider.notifier)
        .getPtMap();

    if (_isCrossed) {
      await ref.read(crossAuthNotifierProvider.notifier).uncross(
            userId: user.nama!,
            password: user.password!,
            url: _ptMap,
          );
    }
  }

  _resetFoso(WidgetRef ref) {
    ref.read(imeiNotifierProvider.notifier).reset();
    ref.read(riwayatAbsenNotifierProvider.notifier).reset();
    ref.read(absenAuthNotifierProvidier.notifier).resetFoso();
    ref.read(geofenceProvider.notifier).resetFOSO();
  }
}
