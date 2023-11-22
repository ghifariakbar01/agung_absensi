import 'dart:developer';

import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/home/home_state.dart';
import '../../application/imei_introduction/shared/imei_introduction_providers.dart';
import '../../application/routes/route_names.dart';
import '../../constants/assets.dart';
import '../../style/style.dart';
import '../../theme/application/theme_notifier.dart';
import '../copyright/copyright_page.dart';
import '../widgets/alert_helper.dart';
import '../widgets/app_logo.dart';
import '../widgets/copyright_text.dart';
import '../widgets/network_widget.dart';
import '../widgets/v_async_widget.dart';
import 'home_drawer.dart';
import 'home_item.dart';
import 'home_tester_off.dart';
import 'home_tester_on.dart';

class Item {
  final String absen;
  final String icon;
  final String routeNames;

  Item(this.absen, this.icon, this.routeNames);
}

final List<Item> items = [
  Item('ABSEN', Assets.iconClock, RouteNames.absenNameRoute),
  Item('RIWAYAT', Assets.iconList, RouteNames.riwayatAbsenNameRoute),
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

    final themeAsync = ref.watch(themeNotifierProvider);
    final themeController = ref.watch(themeControllerProvider);

    return AsyncValueWidget<void>(
      value: themeController,
      data: (_) => Scaffold(
        drawer: WelcomeDrawer(),
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
            AsyncValueWidget<String>(
                value: themeAsync,
                data: (theme) => InkWell(
                    onTap: () => ref
                        .read(themeControllerProvider.notifier)
                        .saveTheme(
                            theme == 'dark' || theme == '' ? 'light' : 'dark'),
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
                    .read(imeiIntroductionNotifierProvider.notifier)
                    .clearVisitedIMEIIntroduction();
                await ref
                    .read(imeiIntroductionNotifierProvider.notifier)
                    .checkAndUpdateStatusIMEIIntroduction();
                await context.pushNamed(RouteNames.imeiInstructionNameRoute);
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: 24),
                    SizedBox(
                        height: 300,
                        width: width,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: GridView(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 16 / 19,
                              crossAxisCount: 4,
                            ),
                            padding: EdgeInsets.all(8),
                            children: [
                              ...isTester.maybeWhen(
                                  tester: testerModeOn,
                                  orElse: user.user.nama == 'Ghifar'
                                      ? testerModeOff
                                      : regularMode)
                            ],
                          ),
                        )),
                    const SizedBox(height: 30),
                  ],
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
                            FontWeight.bold,
                            8,
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
      ),
    );
  }
}

List<Widget> testerModeOn() => [HomeTesterOn(), ...regularMode()];

List<Widget> testerModeOff() => [HomeTesterOff(), ...regularMode()];

List<Widget> regularMode() =>
    [HomeItem(item: items[0]), HomeItem(item: items[1])];
