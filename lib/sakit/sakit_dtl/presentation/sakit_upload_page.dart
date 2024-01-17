import 'package:face_net_authentication/pages/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/sakit_dtl_notifier.dart';

class SakitUploadPage extends ConsumerWidget {
  const SakitUploadPage(
    this.id,
  );

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formUploadUrl = ref
        .watch(sakitDtlNotifierProvider.notifier)
        .formUploadImageFormSakit(id);

    return VScaffoldWidget(
        scaffoldTitle: 'Form Upload Gambar',
        scaffoldBody: InAppWebView(
          onWebViewCreated: (_) {},
          initialUrlRequest: URLRequest(url: Uri.parse(formUploadUrl)),
          onLoadStop: (controller, url) async {
            String html = await controller.evaluateJavascript(
                source:
                    "window.document.getElementsByTagName('html')[0].outerHTML;");

            if (html.contains('Runtime Error')) {}
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ));
  }
}
