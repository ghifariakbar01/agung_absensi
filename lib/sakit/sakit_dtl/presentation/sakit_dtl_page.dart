import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../shared/webview_widget.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
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
    ref.listen<AsyncValue>(sakitDtlNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final sakitDtl = ref.watch(sakitDtlNotifierProvider);

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold<List<SakitDtl>>(
          value: sakitDtl,
          data: (dtl) => RefreshIndicator(
                onRefresh: () {
                  ref
                      .read(sakitDtlNotifierProvider.notifier)
                      .loadSakitDetail(idSakit: dtl.first.idSakit);
                  return Future.value();
                },
                child: VScaffoldWidget(
                  scaffoldTitle: 'Upload Gambar',
                  scaffoldFAB: FloatingActionButton.small(
                      backgroundColor: Palette.primaryColor,
                      child: Icon(
                        Icons.upload,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pushNamed(
                          RouteNames.sakitUploadRoute,
                          extra: dtl.first.idSakit)),
                  scaffoldBody: ListView.separated(
                    itemCount: dtl.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (context, index) => InkWell(
                        onTap: () => context.pushNamed(
                            RouteNames.sakitPhotoDtlRoute,
                            extra: ref
                                .read(sakitDtlNotifierProvider.notifier)
                                .urlImageFormSakit(dtl[index].namaImg)),
                        child: Ink(child: SakitDtlWidget(dtl[index]))),
                  ),
                ),
              )),
    );
  }
}

class SakitDtlWidget extends HookConsumerWidget {
  const SakitDtlWidget(
    this.item,
  );

  final SakitDtl item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref
        .watch(sakitDtlNotifierProvider.notifier)
        .urlImageFormSakit(item.namaImg);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Palette.containerBackgroundColor.withOpacity(0.1),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID : ${item.namaImg}',
                style: Themes.customColor(
                  18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'By : ${item.cUser}',
                style: Themes.customColor(
                  14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${DateFormat('E, dd MMM yyyy HH:mm').format(DateTime.parse(item.cDate))}',
                maxLines: 3,
                style: Themes.customColor(
                  14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 8,
          ),

          // RIGHT
          Container(
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: IgnorePointer(
                ignoring: true,
                child: WebViewWidget(imageUrl),
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
