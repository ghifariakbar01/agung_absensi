import 'package:face_net_authentication/sakit/sakit_list/application/sakit_list_notifier.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:face_net_authentication/widgets/v_dialogs.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
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

    return PopScope(
      onPopInvoked: (_) async {
        bool _isFinised = false;

        await showDialog(
            context: context,
            builder: (context) => VAlertDialog(
                label: 'Sudah selesai upload ? ',
                labelDescription:
                    'Jika sudah, silahkan kembali ke halaman sebelumnya.',
                onPressed: () {
                  _isFinised = true;
                  context.pop();
                  ref.invalidate(sakitListControllerProvider);
                }));

        return Future.value(_isFinised);
      },
      child: VAsyncWidgetScaffold<List<SakitDtl>>(
        value: sakitDtl,
        data: (_) => VScaffoldWidget(
            scaffoldTitle: 'Form Upload',
            scaffoldBody: PopScope(
              onPopInvoked: (_) async {
                await ref
                    .read(sakitDtlNotifierProvider.notifier)
                    .loadSakitDetail(idSakit: id);
                return Future.value(true);
              },
              child: Stack(
                children: [
                  InAppWebView(
                    onWebViewCreated: (_) {},
                    initialUrlRequest:
                        URLRequest(url: WebUri.uri(Uri.parse(formUploadUrl))),
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
                      width: MediaQuery.of(context).size.width - 24,
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: Palette.primaryColor,
                              child: Text(
                                'Jika Sudah Upload, mohon Tekan Tombol Back (Kembali ke Halaman)',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
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
      ),
    );
  }
}
