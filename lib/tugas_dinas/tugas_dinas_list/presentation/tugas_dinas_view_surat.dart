import 'package:face_net_authentication/utils/logging.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/constants.dart';
import '../../../style/style.dart';
import '../../../user/application/user_model.dart';

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

class TugasDinasViewSuratPage extends HookConsumerWidget {
  const TugasDinasViewSuratPage(this.id);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).user;
    final _url = _determineBaseUrl(user);
    final url = useState(
        '$_url/page_print_mob.aspx?userid=${user.idUser}&userpass=${user.password}&mode=dinas&noid=$id');

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
          initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(url.value))),
          onZoomScaleChanged: (controller, oldScale, newScale) {
            Log.info('oldScale $oldScale');
            Log.info('newScale $newScale');
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
