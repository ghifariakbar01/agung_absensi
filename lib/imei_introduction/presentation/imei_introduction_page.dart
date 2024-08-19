import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../style/style.dart';
import '../../widgets/v_button.dart';
import '../../widgets/v_dialogs.dart';
import '../application/shared/imei_introduction_providers.dart';

class ImeiIntroductionPage extends ConsumerWidget {
  const ImeiIntroductionPage({
    Key? key,
    required this.isUnlink,
  }) : super(key: key);

  final bool? isUnlink;

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
              style: Themes.customColor(
                40,
                fontWeight: FontWeight.bold,
              ),
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
              ' E-FINGER menyimpan UID untuk memastikan user hanya menginstall aplikasi di satu device. ' +
                  ' User yang sudah memiliki UID di satu device tidak dapat melakukan instalasi aplikasi di device kedua.' +
                  ' Jika ingin melakukan instalasi E-FINGER di device kedua lakukan Unlink Device pada device pertama dan diikuti dengan melakukan uninstall aplikasi pada device pertama.' +
                  ' Pengguna iOS tidak bisa melakukan unlink tanpa menggati device. ',
              textAlign: TextAlign.justify,
              style: Themes.customColor(
                18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 18,
              ),
              Center(
                child: Text(
                    'Untuk petunjuk melakukan Unlink Device ikuti langkah di bawah ini.',
                    style: Themes.customColor(
                      18,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              SizedBox(
                height: 18,
              ),
              RichText(
                text: TextSpan(
                  text: 'Dari halaman Home, lalu tap Ujung Kanan  ',
                  style: Themes.customColor(
                    18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                        text: '(icon Profil)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' -> ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Scroll ke bawah Halaman ',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: ' -> ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Tap button ',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: ' Unlink ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' -> ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Tap Ya ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' -> ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Uninstall',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Aplikasi dari HP Anda ',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: ' -> ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Hubungi HR ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' untuk melakukan',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: ' request unlink Server ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' (Sertakan Nama & Payroll) ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' -> ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Tunggu HR melakukan unlink Server ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' -> ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Setelah HR melakukan unlink, ',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: ' Download & Install',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' kembali Aplikasi di HP yang baru. ',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              SizedBox(
                height: 36,
              ),
              RichText(
                text: TextSpan(
                  text: '',
                  style: Themes.customColor(
                    18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text:
                          'Bagaimana jika saya mendapatkan error Unlink Saat Absen ? \n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'Anda harus menghubungi HR dan melakukan request Unlink. Dan ',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: 'menginstall ulang aplikasi ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ' dari HP anda. Untuk user iOS, cukup menghubungi HR. \n\n',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text:
                            'Bagaimana jika saya mendapatkan error Unlink Saat Login ? \n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'Anda harus menghubungi HR dan melakukan request Unlink. Dan ',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: 'menginstall ulang aplikasi ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ' dari HP anda.  Untuk user iOS, cukup menghubungi HR.',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              SizedBox(
                height: 36,
              ),
              VButton(
                label: 'Ok, Saya Mengerti.',
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => VAlertDialog(
                        label: 'Apakah anda yakin?',
                        labelDescription:
                            'Jika anda sudah mengerti instruksi di atas, tap Ya',
                        onPressed: () async {
                          if (isUnlink != null) {
                            await ref
                                .read(imeiIntroNotifierProvider.notifier)
                                .saveVisitedIMEIIntroduction(
                                    '${DateTime.now()}');
                            await ref
                                .read(userNotifierProvider.notifier)
                                .logout();
                            await ref
                                .read(authNotifierProvider.notifier)
                                .checkAndUpdateAuthStatus();
                          } else {
                            await ref
                                .read(imeiIntroNotifierProvider.notifier)
                                .saveVisitedIMEIIntroduction(
                                    '${DateTime.now()}');

                            await ref
                                .read(imeiIntroNotifierProvider.notifier)
                                .checkAndUpdateImeiIntro();
                          }
                        })),
              )
            ],
          ),
        ],
      ),
    )));
  }
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
