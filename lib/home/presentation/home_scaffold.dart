import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../constants/constants.dart';
import '../../copyright/presentation/copyright_item.dart';
import '../../routes/application/route_names.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';

import '../../widgets/alert_helper.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/testing.dart';
import '../applicatioin/home_state.dart';
import 'home_appbar.dart';
import 'home_item.dart';
import 'home_tester_off.dart';
import 'home_tester_on.dart';

class Item {
  final String name;
  final String asset;
  final String routeNames;

  Item(this.name, this.asset, this.routeNames);
}

final List<Item> attendance = [
  Item('Absen', Assets.iconAbsen, RouteNames.absenNameRoute),
  Item('Riwayat', Assets.iconRiwayat, RouteNames.riwayatAbsenNameRoute),
  Item('Absen Manual', Assets.iconAbsenManual,
      RouteNames.absenManualListNameRoute),
];

final List<Item> leaveRequest = [
  Item('Cuti', Assets.iconCuti, RouteNames.cutiListNameRoute),
  Item('Sakit', Assets.iconSakit, RouteNames.sakitListNameRoute),
  Item('Izin', Assets.iconIzin, RouteNames.izinListNameRoute),
  Item('DT / PC', Assets.iconDtPc, RouteNames.dtPcListNameRoute),
];

final List<Item> admin = [
  Item('Approval', Assets.iconApproval, RouteNames.centralApproveNameRoute),
];

final List<Item> activity = [
  Item('Ganti Hari', Assets.iconGantiHari, RouteNames.gantiHariListNameRoute),
  Item('Lembur', Assets.iconLembur, RouteNames.lemburListNameRoute),
  Item(
      'Tugas Dinas', Assets.iconTugasDinas, RouteNames.tugasDinasListNameRoute),
  Item('Jadwal Shift', Assets.iconJadwalShift,
      RouteNames.jadwalShiftListNameRoute),
];

// final List<Item> others = [
//   Item('Slip Gaji', Assets.iconSlipGaji, RouteNames.slipGajiNameRoute),
// ];

class HomeScaffold extends ConsumerWidget {
  const HomeScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);

    final isTester = ref.watch(testerNotifierProvider);

    // REDIRECT FROM HOME
    ref.listen<HomeState>(
      homeNotifierProvider,
      (_, state) => state.maybeWhen(
        orElse: () => null,
        failure: () => AlertHelper.showSnackBar(
            //
            context,
            message: 'Error redirecting from Home'),
      ),
    );

    // ref.listen<AsyncValue<WaRegister>>(waRegisterNotifierProvider,
    //     (_, state) async {
    //   if (!state.isLoading && state.hasValue && state.value != null) {
    //     final val = state.value;
    //     if (val!.phone == null || val.isRegistered == null) {
    //       final nama = ref.read(userNotifierProvider).user.nama;
    //       if (nama != 'Ghifar')
    //         return ref
    //             .read(waRegisterNotifierProvider.notifier)
    //             .confirmRegisterWa(context: context);
    //     }

    //     //
    //   } else {
    //     return state.showAlertDialogOnError(context, ref);
    //   }
    // });

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: height,
            width: width,
            child: ListView(
              children: [
                const AppLogo(),
                const SizedBox(height: 24),
                Constants.isDev ? Testing() : Container(),

                ...isTester.maybeWhen(
                    tester: () {
                      return [
                        Text(
                          'Toggle Location',
                          style: Themes.customColor(10,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        HomeTesterOn(),
                      ];
                    },
                    orElse: user.user.nama == 'Ghifar'
                        ? () {
                            return [
                              const SizedBox(height: 24),
                              Text(
                                'Toggle Location',
                                style: Themes.customColor(10,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              HomeTesterOff(),
                            ];
                          }
                        : () {
                            return [Container()];
                          }

                    //
                    ),
                // isOffline ? Container() : HomeWa(onRefresh),
                // ...categories(title: 'Admin', width: width, item: admin),
                ...categories(
                  title: 'Attendance',
                  width: width,
                  item: attendance,
                ),

                ...categories(
                  title: 'Leave Request',
                  width: width,
                  item: leaveRequest,
                ),
                ...categories(
                  title: 'Activity',
                  width: width,
                  item: activity,
                ),
                // ...categories(
                //   title: 'Others',
                //   width: width,
                //   item: others,
                // ),

                const SizedBox(height: 48),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(child: CopyrightItem()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> categories({
    required String title,
    required double width,
    required List<Item> item,
  }) =>
      [
        SizedBox(
          height: 24,
        ),
        Text(
          title,
          style: Themes.customColor(10, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 68,
          width: width,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(
              width: 16,
            ),
            itemBuilder: (context, index) => HomeItem(item: item[index]),
            itemCount: item.length,
          ),
        ),
      ];
}
