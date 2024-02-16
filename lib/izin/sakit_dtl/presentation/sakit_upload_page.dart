import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';
import '../application/sakit_dtl.dart';
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

    final sakitDtl = ref.watch(sakitDtlNotifierProvider);

    return VAsyncWidgetScaffold<List<SakitDtl>>(
      value: sakitDtl,
      data: (_) => VScaffoldWidget(
          scaffoldTitle: 'Form Upload Gambar',
          scaffoldBody: WillPopScope(
            onWillPop: () async {
              await ref
                  .read(sakitDtlNotifierProvider.notifier)
                  .loadSakitDetail(idSakit: id);
              return Future.value(true);
            },
            child: Stack(
              children: [
                InAppWebView(
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
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 16,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            color: Palette.primaryColor,
                            child: Text(
                              'Jika Sudah Upload, mohon Tekan Tombol Back (Kembali ke Halaman)',
                              style: TextStyle(color: Colors.white),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
