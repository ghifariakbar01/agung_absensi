import 'dart:developer';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../style/style.dart';

class TugasDinasViewSuratPage extends HookConsumerWidget {
  const TugasDinasViewSuratPage(this.id);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).user;
    final url = useState(
        'http://agunglogisticsapp.co.id:1232/page_print_mob.aspx?userid=${user.idUser}&userpass=${user.password}&mode=dinas&noid=$id');

    return KeyboardDismissOnTap(
      child: VScaffoldWidget(
        scaffoldTitle: 'Surat Tugas',
        scaffoldFAB: FloatingActionButton.extended(
            onPressed: () => launchUrl(Uri.parse(url.value),
                mode: LaunchMode.externalApplication),
            label: Text(
              'Lihat di Browser',
              style: Themes.customColor(11),
            )),
        scaffoldBody: InAppWebView(
          onWebViewCreated: (_) {},
          initialUrlRequest: URLRequest(url: Uri.parse(url.value)),
          onZoomScaleChanged: (controller, oldScale, newScale) {
            log('oldScale $oldScale');
            log('newScale $newScale');
          },
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
