import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:face_net_authentication/widgets/v_dialogs.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/webview_widget.dart';
import '../../../../style/style.dart';
import '../../izin_list/application/izin_list_notifier.dart';
import '../application/izin_dtl.dart';
import '../application/izin_dtl_notifier.dart';

class IzinUploadPage extends ConsumerWidget {
  const IzinUploadPage(
    this.id,
  );

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formUploadUrl =
        ref.watch(izinDtlNotifierProvider.notifier).formUploadImageFormIzin(id);

    final izinDtl = ref.watch(izinDtlNotifierProvider);

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
                  ref.invalidate(izinListControllerProvider);
                }));

        return Future.value(_isFinised);
      },
      child: VAsyncWidgetScaffold<List<IzinDtl>>(
        value: izinDtl,
        data: (_) => VScaffoldWidget(
            scaffoldTitle: 'Form Upload',
            scaffoldBody: PopScope(
              onPopInvoked: (_) async {
                await ref
                    .read(izinDtlNotifierProvider.notifier)
                    .loadIzinDetail(idIzin: id);
                return Future.value(true);
              },
              child: Stack(
                children: [
                  WebViewCustom(formUploadUrl),
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
