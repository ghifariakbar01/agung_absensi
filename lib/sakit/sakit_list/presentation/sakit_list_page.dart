import 'dart:developer';

import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:face_net_authentication/sakit/sakit_approve/application/sakit_approve_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/routes/route_names.dart';
import '../../../pages/widgets/v_async_widget.dart';
import '../../../pages/widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/sakit_list.dart';
import '../application/sakit_list_notifier.dart';

class SakitListPage extends HookConsumerWidget {
  const SakitListPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(sakitListControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    final sakitList = ref.watch(sakitListControllerProvider);

    final scrollController = useScrollController();
    final page = useState(0);

    void onScrolled() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        page.value++;

        ref.read(sakitListControllerProvider.notifier).load(
              page: page.value + 1,
            );
      }
    }

    useEffect(() {
      scrollController.addListener(onScrolled);
      return () => scrollController.removeListener(onScrolled);
    }, [scrollController]);

    return VAsyncWidgetScaffold<List<SakitList>>(
        value: sakitList,
        data: (list) => RefreshIndicator(
              onRefresh: () {
                page.value = 0;
                ref.read(sakitListControllerProvider.notifier).refresh();

                return Future.value();
              },
              child: VScaffoldWidget(
                scaffoldTitle: 'List Form Sakit',
                scaffoldFAB: FloatingActionButton.small(
                    backgroundColor: Palette.primaryColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () => context.pushNamed(
                          RouteNames.createSakitNameRoute,
                        )),
                scaffoldBody: ListView.separated(
                    controller: scrollController,
                    separatorBuilder: (__, index) => SizedBox(
                          height: 8,
                        ),
                    itemCount: list.length + 1,
                    itemBuilder: (BuildContext context, int index) =>
                        index == list.length
                            ? SizedBox(
                                height: 50,
                              )
                            : SakitListItem(list[index])),
              ),
            ));
  }
}

class SakitListItem extends HookConsumerWidget {
  const SakitListItem(
    this.item,
  );

  final SakitList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final _isSpvApprove = item.spvTgl != item.cDate && item.spvSta == true;
    final spvAging = _isSpvApprove
        ? DateTime.parse(item.spvTgl!)
            .difference(DateTime.parse(item.cDate!))
            .inDays
        : DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    final _isHrdApprove = item.hrdTgl != item.cDate && item.hrdSta == true;
    final hrdAging = _isHrdApprove
        ? DateTime.parse(item.hrdTgl!)
            .difference(DateTime.parse(item.cDate!))
            .inDays
        : DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    return InkWell(
      onTap: () => item.qtyFoto! == 0
          // ||
          //         item.idUser != ref.read(userNotifierProvider).user.idUser
          ? () {}
          : context.pushNamed(RouteNames.sakitDtlRoute, extra: item.idSakit),
      child: Ink(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.primaryColor,
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              // UPPER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID Form: ${item.idSakit}',
                          style: Themes.customColor(FontWeight.bold, 11,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        Text(
                          'Nama : ${item.cUser}',
                          style: Themes.customColor(FontWeight.bold, 11,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        Text(
                          'PT : ${item.payroll}',
                          style: Themes.customColor(FontWeight.bold, 10,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        Text(
                          'Dept : ${item.dept}',
                          style: Themes.customColor(FontWeight.bold, 8,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Diagnosa : ${item.ket}',
                          style: Themes.customColor(FontWeight.bold, 8,
                              color: Theme.of(context).unselectedWidgetColor),
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),

                  // RIGHT
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.surat != null) ...[
                          Text(
                            'Surat: ${item.surat!.toLowerCase() == 'ds' ? 'Dengan Surat Dokter' : 'Tanpa Surat Dokter'}',
                            style: Themes.customColor(FontWeight.bold, 10,
                                color: Theme.of(context).unselectedWidgetColor),
                          ),
                        ],
                        if (item.tglStart != null) ...[
                          Text(
                            'Tanggal Awal : ${DateFormat('yyyy-MM-dd').format(DateTime.parse(item.tglStart!))}',
                            style: Themes.customColor(FontWeight.bold, 10,
                                color: Theme.of(context).unselectedWidgetColor),
                          ),
                        ],
                        Text(
                          'Tanggal Akhir : ${DateFormat('yyyy-MM-dd').format(DateTime.parse(item.tglEnd!))}',
                          style: Themes.customColor(FontWeight.bold, 10,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        Text(
                          'Total Hari : ${item.totHari}',
                          style: Themes.customColor(FontWeight.bold, 10,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 8,
              ),

              // MIDDLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // LOWER LEFT
                  InkWell(
                    onTap: () {
                      if (ref
                          .read(sakitApproveControllerProvider.notifier)
                          .canSpvApprove(item)) {
                        log('message');
                      }
                    },
                    child: Ink(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (item.spvSta != null)
                            item.spvSta == true
                                ? Icon(Icons.thumb_up,
                                    size: 20, color: Colors.green)
                                : Icon(
                                    Icons.thumb_down,
                                    size: 20,
                                    color: Palette.greyDisabled,
                                  ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Approve SPV',
                            style: Themes.customColor(FontWeight.bold, 10,
                                color: Theme.of(context).unselectedWidgetColor),
                          ),
                          if (item.spvTgl != null) ...[
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'SPV Aging : $spvAging',
                              style: Themes.customColor(FontWeight.bold, 10,
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // LOWER RIGHT
                  InkWell(
                    onTap: () {
                      if (ref
                          .read(sakitApproveControllerProvider.notifier)
                          .canHrdApprove(item)) {
                        log('message');
                      }
                    },
                    child: Ink(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (item.hrdSta != null)
                            item.hrdSta == true
                                ? Icon(Icons.thumb_up,
                                    size: 20, color: Colors.green)
                                : Icon(
                                    Icons.thumb_down,
                                    size: 20,
                                    color: Palette.greyDisabled,
                                  ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Approve HRD',
                            style: Themes.customColor(FontWeight.bold, 10,
                                color: Theme.of(context).unselectedWidgetColor),
                          ),
                          if (item.hrdTgl != null) ...[
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'HRD Aging : $hrdAging',
                              style: Themes.customColor(FontWeight.bold, 10,
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 8,
              ),

              // LOWER
              Row(children: [
                if (item.qtyFoto != null)
                  if (item.qtyFoto! > 0)
                    Text('Upload : ${item.qtyFoto} Images',
                        style: Themes.customColor(FontWeight.bold, 10,
                            color: Colors.green,
                            decoration: TextDecoration.underline)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
