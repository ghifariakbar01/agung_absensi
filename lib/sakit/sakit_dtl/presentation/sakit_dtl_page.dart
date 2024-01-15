import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../pages/widgets/v_async_widget.dart';
import '../../../pages/widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/sakit_dtl.dart';
import '../application/sakit_dtl_notifier.dart';

class SakitDtlPageBy extends StatefulHookConsumerWidget {
  const SakitDtlPageBy(
    this.idSakit,
  );
  final int idSakit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SakitDtlPageByState();
}

class _SakitDtlPageByState extends ConsumerState<SakitDtlPageBy> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(sakitDtlNotifierProvider.notifier)
          .loadSakitDetail(idSakit: widget.idSakit);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(sakitDtlNotifierProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    useEffect(() {
      return () {};
    }, []);

    final sakitDtl = ref.watch(sakitDtlNotifierProvider);

    return AsyncValueWidget<SakitDtl>(
        value: sakitDtl,
        data: (dtl) => RefreshIndicator(
              onRefresh: () {
                ref
                    .read(sakitDtlNotifierProvider.notifier)
                    .loadSakitDetail(idSakit: dtl.idSakit);
                return Future.value();
              },
              child: VScaffoldWidget(
                scaffoldTitle: 'Upload Gambar',
                scaffoldFAB: FloatingActionButton.small(
                    backgroundColor: Palette.primaryColor,
                    child: Icon(
                      Icons.upload,
                    ),
                    onPressed: () {}),
                scaffoldBody: SakitDtlWidget(dtl),
              ),
            ));
  }
}

class SakitDtlWidget extends HookConsumerWidget {
  const SakitDtlWidget(
    this.item,
  );

  final SakitDtl item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final imageUrl = ref
        .read(sakitDtlNotifierProvider.notifier)
        .urlImageFormSakit(item.namaImg);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // UPPER
                  Text(
                    'ID : ${item.idSakit}',
                    style: Themes.customColor(FontWeight.bold, 11,
                        color: Theme.of(context).unselectedWidgetColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Nama : ${item.namaImg}',
                    style: Themes.customColor(FontWeight.bold, 11,
                        color: Theme.of(context).unselectedWidgetColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Created By : ${item.cUser}',
                    style: Themes.customColor(FontWeight.bold, 10,
                        color: Theme.of(context).unselectedWidgetColor),
                  ),
                ],
              ),
              Text(
                'Tgl Upload : ${item.cDate}',
                style: Themes.customColor(FontWeight.bold, 8,
                    color: Theme.of(context).unselectedWidgetColor),
              ),
            ],
          ),

          SizedBox(
            height: 8,
          ),

          // RIGHT
          Container(
              height: 350,
              // width: 300,
              decoration: BoxDecoration(
                color: Palette.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: InAppWebView(
                onWebViewCreated: (_) {},
                initialUrlRequest: URLRequest(url: Uri.parse(imageUrl)),
                onLoadStop: (controller, url) async {
                  String html = await controller.evaluateJavascript(
                      source:
                          "window.document.getElementsByTagName('html')[0].outerHTML;");

                  if (html.contains('Runtime Error')) {}
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              )),

          SizedBox(
            height: 8,
          ),

          // LOWER
        ],
      ),
    );
  }
}
