import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../widgets/app_logo.dart';

final packageInfoProvider = FutureProvider((ref) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String version = packageInfo.version;
  // String buildNumber = packageInfo.buildNumber;

  return 'V$version';
});

class CopyRightPage extends ConsumerWidget {
  const CopyRightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Palette.primaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText(
                'APP VERSION: ${packageInfo.when(data: (packageInfo) => packageInfo, error: (error, stackTrace) => 'Error: $error StackTrace: $stackTrace', loading: () => '')}',
                style: Themes.customColor(FontWeight.bold, 15, Colors.black),
              ),
              SizedBox(
                height: 16,
              ),
              Center(child: AppLogo()),
              SizedBox(
                height: 16,
              ),
              SelectableText(
                '© 2023 Agung Logistics. All Rights Reserved.',
                style: Themes.customColor(FontWeight.w500, 14, Colors.black),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Palette.primaryColor.withOpacity(0.1)),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'CONTACT US',
                      textAlign: TextAlign.center,
                      style:
                          Themes.customColor(FontWeight.bold, 14, Colors.black),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SelectableText(
                      'Agung Logistics, Jl. Cut Mutiah No.14 Lt.4, Menteng, 10340 Jakarta Pusat\ntel.: (62-21) 3190 5712, (62-21) 3190 5713\ne-mail: web@agunglogistics.co.id',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
