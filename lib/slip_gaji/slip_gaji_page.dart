import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/widgets/v_button.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../style/style.dart';

class SlipGajiPage extends HookConsumerWidget {
  const SlipGajiPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).user;
    final pinGaji = useState(0);
    final url = useState(
        'http://agunglogisticsapp.co.id:1232/page_print_mob.aspx?userid=${user.idUser}&userpass=${user.password}&mode=slip_gaji&noid=$pinGaji');

    final pinGajiController = useTextEditingController();

    return KeyboardDismissOnTap(
      child: VScaffoldWidget(
        scaffoldTitle: 'Slip Gaji',
        scaffoldFAB: IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.blue,
          ),
          onPressed: () {
            pinGaji.value = 0;
            pinGajiController.text = '';
          },
        ),
        scaffoldBody: pinGaji.value == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: pinGajiController,
                    decoration:
                        Themes.formStyleBordered('Masukkan Pin Gaji Anda'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  VButton(
                      label: 'Submit',
                      onPressed: () {
                        pinGaji.value = int.parse(pinGajiController.text);
                      })
                ],
              )
            : InAppWebView(
                onWebViewCreated: (_) {},
                initialUrlRequest: URLRequest(url: Uri.parse(url.value)),
                onLoadStop: (controller, url) async {
                  String html = await controller.evaluateJavascript(
                      source:
                          "window.document.getElementsByTagName('html')[0].outerHTML;");

                  if (html.contains('Runtime Error')) {}
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
      ),
    );
  }
}
