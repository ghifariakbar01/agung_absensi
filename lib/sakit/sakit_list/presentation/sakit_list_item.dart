import 'dart:developer';

import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit_notifier.dart';
import 'package:face_net_authentication/sakit/sakit_approve/application/sakit_approve_notifier.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/routes/route_names.dart';
import '../../../style/style.dart';
import '../application/sakit_list.dart';
import 'sakit_dialog.dart';

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

    final sakitApprove = ref.watch(sakitApproveControllerProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.primaryColor,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: Themes.customColor(FontWeight.normal, 11,
                          color: Theme.of(context).unselectedWidgetColor),
                    ),
                    Text(
                      'Nama : ${item.cUser}',
                      style: Themes.customColor(FontWeight.normal, 11,
                          color: Theme.of(context).unselectedWidgetColor),
                    ),
                    Text(
                      'PT : ${item.payroll}',
                      style: Themes.customColor(FontWeight.normal, 10,
                          color: Theme.of(context).unselectedWidgetColor),
                    ),
                    Text(
                      'Dept : ${item.dept}',
                      style: Themes.customColor(FontWeight.normal, 10,
                          color: Theme.of(context).unselectedWidgetColor),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Diagnosa : ${item.ket}',
                      style: Themes.customColor(FontWeight.normal, 8,
                          color: Theme.of(context).unselectedWidgetColor),
                      overflow: TextOverflow.visible,
                    ),
                    if (item.spvNote != null) ...[
                      Text(
                        'SPV Note : ${item.spvNote}',
                        style: Themes.customColor(FontWeight.normal, 8,
                            color: Theme.of(context).unselectedWidgetColor),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                    if (item.hrdNote != null) ...[
                      Text(
                        'HRD Note : ${item.hrdNote}',
                        style: Themes.customColor(FontWeight.normal, 8,
                            color: Theme.of(context).unselectedWidgetColor),
                        overflow: TextOverflow.visible,
                      ),
                    ]
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
                        style: Themes.customColor(FontWeight.normal, 10,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                    ],
                    if (item.tglStart != null) ...[
                      Text(
                        'Tanggal Awal : ${DateFormat('yyyy-MM-dd').format(DateTime.parse(item.tglStart!))}',
                        style: Themes.customColor(FontWeight.normal, 10,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                    ],
                    Text(
                      'Tanggal Akhir : ${DateFormat('yyyy-MM-dd').format(DateTime.parse(item.tglEnd!))}',
                      style: Themes.customColor(FontWeight.normal, 10,
                          color: Theme.of(context).unselectedWidgetColor),
                    ),
                    Text(
                      'Total Hari : ${item.totHari}',
                      style: Themes.customColor(FontWeight.normal, 10,
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
                onTap: () async {
                  //  if (ref
                  //     .read(sakitApproveControllerProvider.notifier)
                  //     .canSpvApprove(item)) {
                  //   log('message');
                  // }

                  // jika belum diapprove maka approve
                  // kl udah di unapprove
                  if (item.spvSta == false) {
                    final String? text =
                        await DialogHelper<void>().showFormDialog(
                      value: sakitApprove,
                      label: 'Isi Form Approve SPV',
                      context: context,
                    );

                    if (text != null) {
                      log('message $text');
                      ref
                          .read(sakitApproveControllerProvider.notifier)
                          .approveSpv(
                              idSakit: item.idSakit!,
                              nama: ref.read(userNotifierProvider).user.nama!,
                              note: text);
                    }
                  } else {
                    ref
                        .read(sakitApproveControllerProvider.notifier)
                        .unapproveSpv(
                          itemSakit: item,
                          nama: ref.read(userNotifierProvider).user.nama!,
                        );
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
                        style: Themes.customColor(FontWeight.normal, 10,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                      if (item.spvTgl != null) ...[
                        Text(
                          'SPV Aging : $spvAging',
                          style: Themes.customColor(FontWeight.normal, 10,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // LOWER RIGHT
              InkWell(
                onTap: () async {
                  // if (ref
                  //     .read(sakitApproveControllerProvider.notifier)
                  //     .canHrdApprove(item)) {
                  //   log('message');
                  // }

                  // jika belum diapprove maka approve
                  // kl udah di unapprove
                  if (item.hrdSta == false) {
                    final String? text =
                        await DialogHelper<void>().showFormDialog(
                      value: sakitApprove,
                      label: 'Isi Form Approve HRD',
                      context: context,
                    );

                    if (text != null) {
                      final createSakit = await ref
                          .read(createSakitNotifierProvider.notifier)
                          .getCreateSakit(ref.read(userNotifierProvider).user,
                              item.tglStart!, item.tglEnd!);

                      log('message $text');
                      ref
                          .read(sakitApproveControllerProvider.notifier)
                          .approveHrd(
                            note: text,
                            itemSakit: item,
                            createSakit: createSakit,
                            nama: ref.read(userNotifierProvider).user.nama!,
                          );
                    }
                  } else {
                    ref
                        .read(sakitApproveControllerProvider.notifier)
                        .unapproveHrd(
                          itemSakit: item,
                          nama: ref.read(userNotifierProvider).user.nama!,
                        );
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
                        style: Themes.customColor(FontWeight.normal, 10,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                      if (item.hrdTgl != null) ...[
                        Text(
                          'HRD Aging : $hrdAging',
                          style: Themes.customColor(FontWeight.normal, 10,
                              color: Theme.of(context).unselectedWidgetColor),
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
            // if (item.qtyFoto != null)
            // if (item.qtyFoto! > 0)
            InkWell(
              onTap: () => item.qtyFoto! == 0
                  ? context.pushNamed(RouteNames.sakitUploadRoute,
                      extra: item.idSakit)
                  : context.pushNamed(RouteNames.sakitDtlRoute,
                      extra: item.idSakit),
              child: Ink(
                child: Text('Upload : ${item.qtyFoto} Images',
                    style: Themes.customColor(FontWeight.normal, 10,
                        color: Colors.green,
                        decoration: TextDecoration.underline)),
              ),
            ),
            Spacer(),
            // if (item.cUser != currUser)
            InkWell(
              onTap: () =>
                  context.pushNamed(RouteNames.editSakitRoute, extra: item),
              child: Ink(
                child: Text('Edit',
                    style: Themes.customColor(FontWeight.normal, 10,
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            // if (item.cUser != currUser)
            InkWell(
              onTap: () => {},
              child: Ink(
                child: Text('Delete',
                    style: Themes.customColor(FontWeight.normal, 10,
                        color: Colors.red,
                        decoration: TextDecoration.underline)),
              ),
            )
          ]),

          SizedBox(
            height: 8,
          ),

          Row(
            children: [
              Text(
                'Last Update : ${item.uDate}',
                style: Themes.customColor(
                  FontWeight.normal,
                  10,
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text(
                    'Batal',
                    style: Themes.customColor(
                      FontWeight.normal,
                      10,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
