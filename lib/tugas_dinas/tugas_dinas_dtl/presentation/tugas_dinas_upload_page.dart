import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:face_net_authentication/widgets/v_dialogs.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';
import '../../tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import '../application/tugas_dinas_dtl.dart';
import '../application/tugas_dinas_dtl_notifier.dart';

class TugasDinasUploadPage extends ConsumerWidget {
  const TugasDinasUploadPage(
    this.id,
  );

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formUploadUrl = ref
        .watch(tugasDinasDtlNotifierProvider.notifier)
        .formUploadImageFormTugasDinas(id);

    final tugasDinasDtl = ref.watch(tugasDinasDtlNotifierProvider);

    return WillPopScope(
      onWillPop: () async {
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
                  ref.invalidate(tugasDinasListControllerProvider);
                }));

        return Future.value(_isFinised);
      },
      child: VAsyncWidgetScaffold<List<TugasDinasDtl>>(
        value: tugasDinasDtl,
        data: (_) => VScaffoldWidget(
            scaffoldTitle: 'Form Upload',
            scaffoldBody: WillPopScope(
              onWillPop: () async {
                await ref
                    .read(tugasDinasDtlNotifierProvider.notifier)
                    .loadTugasDinasDetail(idTugasDinas: id);
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
