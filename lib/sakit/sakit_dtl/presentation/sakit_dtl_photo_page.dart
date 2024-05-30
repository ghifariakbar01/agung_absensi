import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SakitDtlPhotoPage extends StatelessWidget {
  const SakitDtlPhotoPage({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        onWebViewCreated: (_) {},
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
    );
  }
}
