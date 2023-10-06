import 'dart:developer';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/imei_introduction/shared/imei_introduction_providers.dart';
import '../../application/routes/route_names.dart';
import '../../constants/assets.dart';
import '../../style/style.dart';
import '../copyright/copyright_page.dart';
import '../widgets/app_logo.dart';
import '../widgets/copyright_text.dart';
import '../widgets/network_widget.dart';
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

    return Scaffold(
      drawer: WelcomeDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 45,
        actions: [
          Builder(
            builder: (context) => TextButton(
              style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              onPressed: () => context.pushNamed(RouteNames.copyrightNameRoute),
              child: Icon(
                Icons.copyright,
                color: Palette.tertiaryColor,
              ),
            ),
          ),
          Expanded(child: Container()),
          Builder(
            builder: (context) => TextButton(
              style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              onPressed: () async {
                debugger(message: 'called');
                await ref
                    .read(imeiIntroductionNotifierProvider.notifier)
                    .clearVisitedIMEIIntroduction();
                await ref
                    .read(imeiIntroductionNotifierProvider.notifier)
                    .checkAndUpdateStatusIMEIIntroduction();
                await context.pushNamed(RouteNames.imeiInstructionNameRoute);
              },
              child: Icon(
                Icons.help_outline_outlined,
                color: Palette.tertiaryColor,
              ),
            ),
          ),
          Builder(
            builder: (context) => TextButton(
              style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: Icon(
                Icons.more_horiz,
                color: Palette.tertiaryColor,
              ),
            ),
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
                            color: Palette.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 16 / 19,
                            crossAxisCount: 4,
                          ),
                          padding: EdgeInsets.all(8),
                          children: [
                            ...isTester.maybeWhen(
                                tester: testerMode,
                                orElse: user.user.nama == 'Ghifar'
                                    ? testerMode2
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
                        'APP VERSION: ${packageInfo.when(data: (packageInfo) => packageInfo, error: (error, stackTrace) => 'Error: $error StackTrace: $stackTrace', loading: () => '')}',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: Themes.customColor(
                            FontWeight.bold, 8, Palette.greyThree),
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
  }
}

List<Widget> testerMode() =>
    [HomeTesterOn(), WelcomeItem(item: items[0]), WelcomeItem(item: items[1])];

List<Widget> testerMode2() =>
    [HomeTesterOff(), WelcomeItem(item: items[0]), WelcomeItem(item: items[1])];

List<Widget> regularMode() =>
    [WelcomeItem(item: items[0]), WelcomeItem(item: items[1])];
