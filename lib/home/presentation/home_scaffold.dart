import 'package:face_net_authentication/send_wa/application/phone_num.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/wa_register/application/wa_register_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../copyright/presentation/copyright_page.dart';
import '../../routes/application/route_names.dart';
import '../../style/style.dart';
import '../../theme/application/theme_notifier.dart';
import '../../wa_register/application/wa_register.dart';

import '../../widgets/alert_helper.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/copyright_text.dart';
import '../../widgets/v_async_widget.dart';
import '../../widgets/v_dialogs.dart';
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
  Item('Approval', Assets.iconApproval, RouteNames.tugasDinasListNameRoute),
];

final List<Item> activity = [
  Item(
      'Tugas Dinas', Assets.iconTugasDinas, RouteNames.tugasDinasListNameRoute),
];

class HomeScaffold extends ConsumerWidget {
  const HomeScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);
    final width = MediaQuery.of(context).size.width;
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

    ref.listen<AsyncValue>(themeControllerProvider, (_, state) async {
      if (!state.isLoading && state.hasValue && state.value != null) {
        // ignore: unused_result
        ref.refresh(themeNotifierProvider);
      } else {
        return state.showAlertDialogOnError(context, ref);
      }
    });

    ref.listen<AsyncValue<WaRegister>>(waRegisterNotifierProvider,
        (_, state) async {
      if (!state.isLoading && state.hasValue && state.value != null) {
        final val = state.value;
        if (val!.phone == null || val.isRegistered == null) {
          return ref
              .read(waRegisterNotifierProvider.notifier)
              .confirmRegisterWa(context: context);
        }

        //
      } else {
        return state.showAlertDialogOnError(context, ref);
      }
    });

    final themeController = ref.watch(themeControllerProvider);

    final waRegisterAsync = ref.watch(waRegisterNotifierProvider);
    final currentlySavedPhoneAsync =
        ref.watch(currentlySavedPhoneNumberNotifierProvider);

    final onRefresh = () async {
      await ref.read(waRegisterNotifierProvider.notifier).refresh();
      await ref
          .read(currentlySavedPhoneNumberNotifierProvider.notifier)
          .refresh();
    };

    return VAsyncWidgetScaffold<void>(
      value: themeController,
      data: (_) => VAsyncWidgetScaffold<WaRegister>(
        value: waRegisterAsync,
        data: (waRegister) {
          return Scaffold(
            appBar: HomeAppBar(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
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

                            SizedBox(
                              height: 24,
                            ),

                            // REGISTER WA
                            if (waRegister.phone == null ||
                                waRegister.isRegistered == null) ...[
                              Text(
                                'Register Notifikasi Whatsapp',
                                style: Themes.customColor(10,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              HomeRegisterWa(),
                              SizedBox(
                                height: 8,
                              )
                            ],

                            if (waRegister.phone != null &&
                                waRegister.isRegistered != null) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Register Notifikasi Whatsapp',
                                    style: Themes.customColor(10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (user.user.noTelp1 != null &&
                                      user.user.noTelp2 != null)
                                    VAsyncValueWidget<PhoneNum>(
                                      value: currentlySavedPhoneAsync,
                                      data: (phone) => Ink(
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.vibrate().then((_) =>
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (_) =>
                                                        VSimpleDialog(
                                                          asset: Assets
                                                              .iconChecked,
                                                          label:
                                                              'Tidak Sesuai ?',
                                                          labelDescription:
                                                              'Jika nomor tidak sesuai, silahkan hubungi HRD untuk mengubah data',
                                                        )).then(
                                                    (_) => onRefresh()));
                                          },
                                          child: Text(
                                            '${phone.noTelp1!.isEmpty ? "-" : "${phone.noTelp1}"}'
                                            '${phone.noTelp2!.isEmpty ? "-" : "/${phone.noTelp2}"}',
                                            style: Themes.customColor(7,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              HomeRetryRegisterWa(),
                              SizedBox(
                                height: 8,
                              )
                            ],
                            // // Admin
                            // SizedBox(
                            //   height: 24,
                            // ),
                            // Text(
                            //   'Admin Menu',
                            //   style: Themes.customColor(10,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            // SizedBox(
                            //   height: 68,
                            //   width: width,
                            //   child: ListView.separated(
                            //     scrollDirection: Axis.horizontal,
                            //     separatorBuilder: (context, index) => SizedBox(
                            //       width: 16,
                            //     ),
                            //     itemBuilder: (context, index) =>
                            //         HomeItem(item: admin[index]),
                            //     itemCount: admin.length,
                            //   ),
                            // ),
                            SizedBox(
                              height: 24,
                            ),
                            // Attendance
                            Text(
                              'Attendance',
                              style: Themes.customColor(10,
                                  fontWeight: FontWeight.bold),
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
                                itemBuilder: (context, index) =>
                                    HomeItem(item: attendance[index]),
                                itemCount: attendance.length,
                              ),
                            ),
                            // Leave Request
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              'Leave Request',
                              style: Themes.customColor(10,
                                  fontWeight: FontWeight.bold),
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
                                itemBuilder: (context, index) =>
                                    HomeItem(item: leaveRequest[index]),
                                itemCount: leaveRequest.length,
                              ),
                            ),
                            // Action
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              'Activity',
                              style: Themes.customColor(10,
                                  fontWeight: FontWeight.bold),
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
                                itemBuilder: (context, index) =>
                                    HomeItem(item: activity[index]),
                                itemCount: activity.length,
                              ),
                            ),

                            const SizedBox(height: 65),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
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
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
