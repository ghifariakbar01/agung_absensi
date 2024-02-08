import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../permission/application/shared/permission_introduction_providers.dart';
import '../../routes/application/route_names.dart';
import '../../tester/application/tester_state.dart';
import '../../widgets/v_dialogs.dart';
import '../../shared/providers.dart';

import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState.initial());

  Future<void> redirect(
      {required String route,
      required WidgetRef ref,
      required BuildContext context}) async {
    state = const HomeState.inProgress();

    await _processRedirect(ref: ref, route: route, context: context);

    state = const HomeState.success();
  }

  Future<void> _processRedirect(
      {required String route,
      required WidgetRef ref,
      required BuildContext context}) async {
    bool isAbsenRoute = route == RouteNames.absenRoute;
    bool isLocationOn = await FlLocation.isLocationServicesEnabled;

    bool isTester =
        ref.read(testerNotifierProvider) != TesterState.forcedRegularUser();
    bool isLocationDenied =
        await ref.read(permissionNotifierProvider.notifier).isLocationDenied();

    if (isAbsenRoute && !isTester) {
      if (!isLocationOn) {
        await showDialog(
          context: context,
          builder: (context) => VSimpleDialog(
              label: 'GPS Tidak Berfungsi',
              labelDescription:
                  'Mohon nyalakan GPS pada device anda. Terimakasih',
              asset: 'assets/ic_location_off.svg'),
        );
      } else {
        if (isLocationDenied) {
          await showDialog(
            context: context,
            builder: (context) => VSimpleDialog(
                label: 'Izin Lokasi Tidak Aktif',
                labelDescription:
                    'Mohon nyalakan Izin Lokasi untuk E-FINGER. Terimakasih',
                asset: 'assets/ic_location_off.svg'),
          ).then((_) => context.pushNamed(RouteNames.permissionRoute));
        } else {
          await context.pushNamed(route);
        }
      }
    } else {
      await context.pushNamed(route);
    }
  }
}
