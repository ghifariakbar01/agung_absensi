import 'dart:developer';

import 'package:face_net_authentication/application/imei_introduction/shared/imei_introduction_providers.dart';
import 'package:face_net_authentication/constants/assets.dart';
import 'package:face_net_authentication/pages/widgets/copyright_text.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/routes/route_names.dart';
import '../widgets/app_logo.dart';
import 'welcome_drawer.dart';
import 'welcome_item.dart';

class HomeData {
  final String absen;
  final String icon;
  final String routeNames;

  HomeData(this.absen, this.icon, this.routeNames);
}

final List<HomeData> items = [
  HomeData('absen', Assets.iconClock, RouteNames.absenNameRoute),
  HomeData('riwayat', Assets.iconList, RouteNames.riwayatAbsenNameRoute),
];

class WelcomeScaffold extends ConsumerWidget {
  const WelcomeScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: WelcomeDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 0,
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
          )
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
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 16 / 19,
                              crossAxisCount: 4,
                            ),
                            padding: EdgeInsets.all(8),
                            itemCount: items.length,
                            itemBuilder: (_, index) =>
                                WelcomeItem(homeData: items[index])),
                      )),
                  const SizedBox(height: 30),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CopyrightAgung(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
