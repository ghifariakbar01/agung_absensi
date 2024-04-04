import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../copyright/presentation/copyright_page.dart';
import '../../routes/application/route_names.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../wa_register/application/wa_register.dart';

import '../../wa_register/application/wa_register_notifier.dart';
import '../../widgets/alert_helper.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/copyright_text.dart';
import '../applicatioin/home_state.dart';
import 'home_appbar.dart';
import 'home_item.dart';
import 'home_register_wa.dart';
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
  Item(
      'Tugas Dinas', Assets.iconTugasDinas, RouteNames.tugasDinasListNameRoute),
];

final List<Item> others = [
  Item('Slip Gaji', Assets.iconSlipGaji, RouteNames.slipGajiNameRoute),
];

class HomeScaffold extends ConsumerWidget {
  const HomeScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);

    final isTester = ref.watch(testerNotifierProvider);
    final packageInfo = ref.watch(packageInfoProvider);

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

    // ref.listen<AsyncValue>(themeControllerProvider, (_, state) async {
    //   if (!state.isLoading && state.hasValue && state.value != null) {
    //     // ignore: unused_result
    //     ref.refresh(themeNotifierProvider);
    //   } else {
    //     return state.showAlertDialogOnError(context, ref);
    //   }
    // });

    // final themeController = ref.watch(themeControllerProvider);

    // VAsyncWidgetScaffold<void>(
    //   value: themeController,
    //   data: (_) =>

    ref.listen<AsyncValue<WaRegister>>(waRegisterNotifierProvider,
        (_, state) async {
      if (!state.isLoading && state.hasValue && state.value != null) {
        final val = state.value;
        if (val!.phone == null || val.isRegistered == null) {
          final nama = ref.read(userNotifierProvider).user.nama;
          if (nama != 'Ghifar')
            return ref
                .read(waRegisterNotifierProvider.notifier)
                .confirmRegisterWa(context: context);
        }

        //
      } else {
        return state.showAlertDialogOnError(context, ref);
      }
    });

    final onRefresh = () async {
      await ref.read(waRegisterNotifierProvider.notifier).refresh();
      await ref
          .read(currentlySavedPhoneNumberNotifierProvider.notifier)
          .refresh();
    };

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
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                children: [
                  const AppLogo(),
                  const SizedBox(height: 24),
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
                  HomeWa(onRefresh),
                  // ...categories(title: 'Admin', width: width, item: admin),
                  ...categories(
                      title: 'Attendance', width: width, item: attendance),
                  ...categories(
                      title: 'Leave Request', width: width, item: leaveRequest),
                  ...categories(
                      title: 'Activity', width: width, item: activity),
                  ...categories(title: 'Others', width: width, item: others),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(child: CopyrightAgung()),
                      Center(
                        child: SelectableText(
                          'APP VERSION: ${packageInfo.when(
                            loading: () => '',
                            data: (packageInfo) => packageInfo,
                            error: (error, stackTrace) =>
                                'Error: $error StackTrace: $stackTrace',
                          )}',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: Themes.customColor(
                            8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> categories(
          {required String title,
          required double width,
          required List<Item> item}) =>
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
