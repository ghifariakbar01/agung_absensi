import 'dart:developer';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:face_net_authentication/widgets/v_button.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/constants.dart';
import '../cross_auth/application/cross_auth_notifier.dart';
import '../style/style.dart';
import '../user/application/user_model.dart';

_determineBaseUrl(UserModelWithPassword user) {
  final pt = user.ptServer;
  if (pt == null) {
    throw AssertionError('pt null');
  }

  return Constants.ptMap.entries
      .firstWhere(
        (element) => element.key == pt,
        orElse: () => Constants.ptMap.entries.first,
      )
      .value
      .replaceAll('/services', '');
}

class SlipGajiPage extends HookConsumerWidget {
  const SlipGajiPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).user;
    final pinGaji = useState('');
    final _url = _determineBaseUrl(user);
    final url = useState(
        '$_url/page_print_mob.aspx?userid=${user.idUser}&userpass=${user.password}&mode=slip_gaji&noid=${pinGaji.value}');

    final pinGajiController = useTextEditingController();

    final crossAuth = ref.watch(crossAuthNotifierProvider);

    return KeyboardDismissOnTap(
        child: VScaffoldWidget(
      scaffoldTitle: 'Slip Gaji',
      scaffoldFAB: IconButton(
        icon: Icon(
          Icons.refresh,
          color: Colors.blue,
        ),
        onPressed: () {
          pinGaji.value = '';
          pinGajiController.text = '';
        },
      ),
      scaffoldBody: VAsyncWidgetScaffold(
        value: crossAuth,
        data: (_) => pinGaji.value.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: pinGajiController,
                    decoration:
                        Themes.formStyleBordered('Masukkan Pin Gaji Anda'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  VButton(
                      label: 'Submit',
                      onPressed: () {
                        pinGaji.value = pinGajiController.text;
                        url.value =
                            '$_url/page_print_mob.aspx?userid=${user.idUser}&userpass=${user.password}&mode=slip_gaji&noid=${pinGajiController.text}';
                      })
                ],
              )
            : InAppWebView(
                onLoadStart: (controller, url) {
                  log('url start $url');
                },
                initialUrlRequest:
                    URLRequest(url: WebUri.uri(Uri.parse(url.value))),
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
    ));
  }
}
