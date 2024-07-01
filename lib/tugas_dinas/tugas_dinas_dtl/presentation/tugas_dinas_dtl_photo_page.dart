import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TugasDinasDtlPhotoPage extends HookWidget {
  const TugasDinasDtlPhotoPage({Key? key, required this.imageUrl})
      : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final rotate = useState(0);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: Icon(Icons.rotate_90_degrees_ccw),
                onPressed: () =>
                    rotate.value == 4 ? rotate.value = 0 : rotate.value++,
              ),
            )
          ],
        ),
        body: RotatedBox(
          quarterTurns: rotate.value,
          child: InAppWebView(
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
        ),
      ),
    );
  }
}
