import 'package:face_net_authentication/wa_register/application/wa_register_notifier.dart';
import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../permission/application/shared/permission_introduction_providers.dart';
import '../../routes/application/route_names.dart';
import '../../tester/application/tester_state.dart';
import '../../wa_register/application/wa_register.dart';
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
    bool isGpsOn = await FlLocation.isLocationServicesEnabled;

    final tester = ref.read(testerNotifierProvider);
    bool isTester = tester != TesterState.forcedRegularUser();

    final permissionNotifier = ref.read(permissionNotifierProvider.notifier);
    bool isLocationDenied = await permissionNotifier.isLocationDenied();

    final waRegister = await ref.read(waRegisterNotifierProvider.future);

    final nama = ref.read(userNotifierProvider).user.nama;
    final isMe = nama == 'Ghifar';

    if (!isAbsenRoute) {
      if (!isMe && waRegister == WaRegister.initial()) {
        return showDialog(
          context: context,
          builder: (context) => VSimpleDialog(
            asset: Assets.iconWa,
            label: 'Nomor Wa Belum Terdaftar',
            labelDescription:
                'Mohon lakukan registrasi nomor Wa terlebih dahulu, agar bisa menerima notifikasi pesan Wa. Terimakasih 🙏',
          ),
        );
      }
    }

    if (isAbsenRoute && !isTester) {
      if (!isGpsOn) {
        return showDialog(
          context: context,
          builder: (context) => VSimpleDialog(
              label: 'GPS Tidak Berfungsi',
              labelDescription:
                  'Mohon nyalakan GPS pada device anda. Terimakasih 🙏',
              asset: Assets.iconLocationOff),
        );
      } else {
        final redirectToPermission =
            context.pushNamed(RouteNames.permissionRoute);

        if (isLocationDenied) {
          return showDialog(
            context: context,
            builder: (context) => VSimpleDialog(
                label: 'Izin Lokasi Tidak Aktif',
                labelDescription:
                    'Mohon nyalakan Izin Lokasi untuk E-FINGER. Terimakasih 🙏',
                asset: Assets.iconLocationOff),
          ).then((_) => redirectToPermission);
        } else {
          await context.pushNamed(route);
          return;
        }
      }
    } else {
      await context.pushNamed(route);
      return;
    }
  }
}
