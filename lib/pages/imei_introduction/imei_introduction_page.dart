import 'package:face_net_authentication/application/routes/route_names.dart';
import 'package:face_net_authentication/constants/assets.dart';
import 'package:face_net_authentication/pages/widgets/v_button.dart';
import 'package:face_net_authentication/pages/widgets/v_dialogs.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final imeiIntroductionPreference =
    FutureProvider.family<void, BuildContext>((ref, context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final bool? hasUnderstood = prefs.getBool('imei_introduction');

  if (hasUnderstood == null || hasUnderstood == false) {
    return;
  } else {
    context.replaceNamed(RouteNames.welcomeNameRoute);
  }
});

class ImeiIntroductionPage extends ConsumerWidget {
  const ImeiIntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(imeiIntroductionPreference(context), (_, __) {});

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
              'Agung Logistics HRMS Online menyimpan UID untuk validasi data absen. Jika ingin melakukan uninstall, lakukan UNLINK DEVICE di Setting aplikasi ini.',
              textAlign: TextAlign.justify,
              style: Themes.customColor(FontWeight.normal, 15, Colors.black),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text('Untuk petunjuk, ikuti instruksi dibawah.',
              style: Themes.customColor(FontWeight.normal, 15, Colors.black)),
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
          VButton(
              label: 'OK, SAYA MENGERTI.',
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => VAlertDialog(
                      label: 'Apakah anda yakin?',
                      labelDescription:
                          'Jika anda sudah mengerti instruksi di atas, tap YA',
                      onPressed: () async {
                        context.pop();

                        await understood(
                            true,
                            () => ref
                                .refresh(imeiIntroductionPreference(context)));
                      })))
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
