import 'package:face_net_authentication/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../style/style.dart';

class WebViewWidget extends HookConsumerWidget {
  const WebViewWidget(this.imageUrl, {Key? key}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = useState(0);

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: InAppWebView(
            onWebViewCreated: (_) {},
            onProgressChanged: (controller, prog) {
              progress.value = prog;
              Log.info('progress.value ${progress.value} $prog');
            },
            initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(imageUrl))),
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
        if (progress.value < 100)
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${progress.value}%',
                  style: Themes.customColor(14),
                )
              ],
            ),
          )
      ],
    );
  }
}
