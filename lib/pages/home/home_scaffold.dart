import 'dart:developer';

import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/wa_register/application/wa_register_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/home/home_state.dart';
import '../../application/imei_introduction/shared/imei_introduction_providers.dart';
import '../../application/routes/route_names.dart';
import '../../constants/assets.dart';
import '../../style/style.dart';
import '../../theme/application/theme_notifier.dart';
import '../../wa_register/application/wa_register.dart';
import '../copyright/copyright_page.dart';
import '../widgets/alert_helper.dart';
import '../widgets/app_logo.dart';
import '../widgets/copyright_text.dart';
import '../widgets/network_widget.dart';
import '../widgets/v_async_widget.dart';
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
];

final List<Item> leaveRequest = [
  Item('Form Sakit', Assets.iconSakit, RouteNames.sakitListNameRoute)
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
        success: () => null,
        failure: () => AlertHelper.showSnackBar(
            //
            context,
            message: 'Error redirecting from Home'),
      ),
    );

    ref.listen<AsyncValue>(themeControllerProvider, (_, state) {
      if (!state.isLoading && state.hasValue && state.value != null) {
        ref.refresh(themeNotifierProvider);
      } else {
        return state.showAlertDialogOnError(context);
      }
    });

    ref.listen<AsyncValue<WaRegister>>(waRegisterNotifierProvider, (_, state) {
      if (!state.isLoading && state.hasValue && state.value != null) {
        //
      } else {
        return state.showAlertDialogOnError(context);
      }
    });

    final themeAsync = ref.watch(themeNotifierProvider);
    final themeController = ref.watch(themeControllerProvider);

    final waRegisterAsync = ref.watch(waRegisterNotifierProvider);

    return VAsyncWidgetScaffold<void>(
      value: themeController,
      data: (_) => VAsyncWidgetScaffold<WaRegister>(
        value: waRegisterAsync,
        data: (waRegister) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 45,
              actions: [
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () => context.pushNamed(RouteNames.copyrightNameRoute),
                  child: Icon(
                    Icons.copyright,
                    color: Palette.tertiaryColor,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                VAsyncWidgetScaffold<String>(
                    value: themeAsync,
                    data: (theme) => InkWell(
                        onTap: () => ref
                            .read(themeControllerProvider.notifier)
                            .saveTheme(theme == 'dark' || theme == ''
                                ? 'light'
                                : 'dark'),
                        child: theme == 'dark'
                            ? Icon(
                                Icons.dark_mode,
                                color: Palette.tertiaryColor,
                              )
                            : Icon(Icons.dark_mode_outlined,
                                color: Palette.tertiaryColor))),
                Expanded(child: Container()),
                SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () async {
                    debugger(message: 'called');
                    await ref
                        .read(imeiIntroNotifierProvider.notifier)
                        .clearVisitedIMEIIntroduction();
                    await ref
                        .read(imeiIntroNotifierProvider.notifier)
                        .checkAndUpdateImeiIntro();
                    await context
                        .pushNamed(RouteNames.imeiInstructionNameRoute);
                  },
                  child: Ink(
                    child: Icon(
                      Icons.help_outline_outlined,
                      color: Palette.tertiaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () => context.pushNamed(RouteNames.profileNameRoute),
                  child: Ink(
                    child: Icon(
                      Icons.person,
                      color: Palette.tertiaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                NetworkWidget(),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 500,
                      width: width,
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

                          // REGISTER WA
                          if (waRegister.phone == null ||
                              waRegister.isRegistered == null) ...[
                            Text(
                              'Mohon Register Wa Anda',
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
                                  width: 8,
                                ),
                                itemBuilder: (__, _) => Ink(
                                    height: 68,
                                    width: 68,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5), // Shadow color
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: Offset(-1,
                                              1), // Controls the position of the shadow
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () => ref
                                          .read(waRegisterNotifierProvider
                                              .notifier)
                                          .confirmRegisterWa(context: context),
                                      child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Column(
                                          children: [
                                            Icon(Icons.message),
                                            Spacer(),
                                            Text(
                                              'Register Wa ',
                                              style: Themes.customColor(
                                                7,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                                itemCount: 1,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],

                          Text(
                            'Attendance',
                            style: Themes.customColor(10,
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(
                            height: 8,
                          ),
                          //
                          SizedBox(
                            height: 68,
                            width: width,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => SizedBox(
                                width: 8,
                              ),
                              itemBuilder: (context, index) =>
                                  HomeItem(item: attendance[index]),
                              itemCount: attendance.length,
                            ),
                          ),

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
                          //
                          SizedBox(
                            height: 68,
                            width: width,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => SizedBox(
                                width: 8,
                              ),
                              itemBuilder: (context, index) =>
                                  HomeItem(item: leaveRequest[index]),
                              itemCount: leaveRequest.length,
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
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
