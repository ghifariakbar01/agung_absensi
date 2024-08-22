import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../../shared/webview_widget.dart';
import '../../../../widgets/v_async_widget.dart';
import '../../../../widgets/v_scaffold_widget.dart';
import '../../../../style/style.dart';

import '../application/tugas_dinas_dtl.dart';
import '../application/tugas_dinas_dtl_notifier.dart';

class TugasDinasDtlPageBy extends StatefulHookConsumerWidget {
  const TugasDinasDtlPageBy(
    this.idTugasDinas,
  );
  final int idTugasDinas;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TugasDinasDtlPageByState();
}

class _TugasDinasDtlPageByState extends ConsumerState<TugasDinasDtlPageBy> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(tugasDinasDtlNotifierProvider.notifier)
          .loadTugasDinasDetail(idTugasDinas: widget.idTugasDinas);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(tugasDinasDtlNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final sakitDtl = ref.watch(tugasDinasDtlNotifierProvider);

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold<List<TugasDinasDtl>>(
          value: sakitDtl,
          data: (dtl) => RefreshIndicator(
                onRefresh: () {
                  ref
                      .read(tugasDinasDtlNotifierProvider.notifier)
                      .loadTugasDinasDetail(idTugasDinas: dtl.first.idDinas);
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
                          RouteNames.tugasDinasUploadRoute,
                          extra: dtl.first.idDinas)),
                  scaffoldBody: ListView.separated(
                    itemCount: dtl.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (context, index) => InkWell(
                        onTap: () => context.pushNamed(
                            RouteNames.tugasDinasPhotoDtlRoute,
                            extra: ref
                                .read(tugasDinasDtlNotifierProvider.notifier)
                                .urlImageFormTugasDinas(dtl[index].namaImg)),
                        child: Ink(child: TugasDinasDtlWidget(dtl[index]))),
                  ),
                ),
              )),
    );
  }
}

class TugasDinasDtlWidget extends HookConsumerWidget {
  const TugasDinasDtlWidget(
    this.item,
  );

  final TugasDinasDtl item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref
        .watch(tugasDinasDtlNotifierProvider.notifier)
        .urlImageFormTugasDinas(item.namaImg);

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
                child: WebViewCustom(imageUrl),
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
