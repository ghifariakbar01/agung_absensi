import 'package:face_net_authentication/constants/assets.dart';
import 'package:face_net_authentication/pages/widgets/v_button.dart';
import 'package:face_net_authentication/pages/widgets/v_dialogs.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/imei_introduction/shared/imei_introduction_providers.dart';

class ImeiIntroductionPage extends ConsumerWidget {
  const ImeiIntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Center(
            child: Text(
              'Device Unlink',
              style:
                  Themes.customColor(FontWeight.bold, 40, Palette.primaryColor),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 200,
            child: Image.asset(
              Assets.iconChain,
              color: Palette.red,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Text(
              'E-FINGER menyimpan UID untuk memastikan user hanya menginstall aplikasi di satu device. User yang sudah memiliki UID di satu device tidak dapat melakukan instalasi aplikasi di device kedua. Jika ingin melakukan instalasi E-FINGER di device kedua lakukan Unlink Deivce diikuti dengan melakukan uninstall aplikasi.',
              textAlign: TextAlign.justify,
              style: Themes.customColor(FontWeight.normal, 15, Colors.black),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 4,
              ),
              Center(
                child: Text(
                    'Untuk petunjuk melakukan Unlink Device ikuti langkah di bawah ini.',
                    style: Themes.customColor(
                        FontWeight.normal, 15, Colors.black)),
              ),
              SizedBox(
                height: 4,
              ),
              instructionImage(1),
              SizedBox(
                height: 8,
              ),
              instructionImage(2),
              SizedBox(
                height: 4,
              ),
              instructionImage(3),
              SizedBox(
                height: 4,
              ),
              instructionImage(4),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text('Langkah terakhir, UNINSTALL aplikasi E-FINGER.',
                      textAlign: TextAlign.center,
                      style:
                          Themes.customColor(FontWeight.bold, 15, Palette.red)),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              VButton(
                label: 'OK, SAYA MENGERTI.',
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => VAlertDialog(
                        label: 'Apakah anda yakin?',
                        labelDescription:
                            'Jika anda sudah mengerti instruksi di atas, tap Ya',
                        onPressed: () async {
                          await ref
                              .read(imeiIntroductionNotifierProvider.notifier)
                              .saveVisitedIMEIIntroduction('${DateTime.now()}');

                          await ref
                              .read(imeiIntroductionNotifierProvider.notifier)
                              .checkAndUpdateStatusIMEIIntroduction();
                        })),
              )
            ],
          ),
        ],
      ),
    )));
  }
}

Future<void> understood(bool understood, Function onUnderstood) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('imei_introduction', true);

  await onUnderstood();
}

Widget instructionImage(int number) => Padding(
      padding: const EdgeInsets.all(32.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Palette.primaryColor.withOpacity(0.9)),
          padding: EdgeInsets.all(8),
          child: Image.asset(
            Assets.imgInstructionPrefix + '$number.jpg',
            fit: BoxFit.fill,
          )),
    );
