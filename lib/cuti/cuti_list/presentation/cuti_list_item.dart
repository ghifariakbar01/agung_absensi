import 'dart:developer';

import 'package:face_net_authentication/cuti/create_cuti/application/create_cuti_notifier.dart';
import 'package:face_net_authentication/cuti/cuti_approve/application/cuti_approve_notifier.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routes/application/route_names.dart';
import '../../../sakit/sakit_list/presentation/sakit_dialog.dart';
import '../../../shared/providers.dart';
import '../../../style/style.dart';

import '../../../utils/string_utils.dart';
import '../../../widgets/v_dialogs.dart';
import '../../create_cuti/application/alasan_cuti.dart';
import '../../create_cuti/application/jenis_cuti.dart';
import '../application/cuti_list.dart';

class CutiListItem extends HookConsumerWidget {
  const CutiListItem(
    this.item,
  );

  final CutiList item;

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

    final jenisCuti = ref.watch(jenisCutiNotifierProvider);
    final alasanCuti = ref.watch(alasanCutiNotifierProvider);

    log('item.btlSta ${item.btlSta == true}');

    return IgnorePointer(
      ignoring: item.btlSta == true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: item.btlSta == true
              ? Palette.red.withOpacity(0.3)
              : theme.primaryColor,
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
                        'ID Form: ${item.idCuti}',
                        style: Themes.customColor(11,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                      Text(
                        'Nama : ${item.fullname}',
                        style: Themes.customColor(11,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                      Text(
                        'PT : ${item.pt}',
                        style: Themes.customColor(10,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                      Text(
                        'Departemen : ${item.dept}',
                        style: Themes.customColor(10,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      VAsyncValueWidget<List<JenisCuti>>(
                        value: jenisCuti,
                        data: (list) => Text(
                          'Jenis Cuti : ${list.firstWhere((element) => element.inisial == item.jenisCuti, orElse: () => list.first).nama}',
                          style: Themes.customColor(10,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                      ),
                      VAsyncValueWidget<List<AlasanCuti>>(
                        value: alasanCuti,
                        data: (list) => Text(
                          'Alasan Cuti : ${list.firstWhere((element) => element.kode == item.alasan, orElse: () => list.first).alasan}',
                          style: Themes.customColor(10,
                              color: Theme.of(context).unselectedWidgetColor),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Keterangan Cuti : ${item.ket}',
                        style: Themes.customColor(8,
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
                      Text(
                        'Tanggal Awal : ${StringUtils.formatTanggal(item.tglStart!)}',
                        style: Themes.customColor(8,
                            color: Theme.of(context).unselectedWidgetColor),
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        'Tanggal Akhir : ${StringUtils.formatTanggal(item.tglEnd!)}',
                        style: Themes.customColor(8,
                            color: Theme.of(context).unselectedWidgetColor),
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        'Periode Bulan : ${item.bulanCuti}',
                        style: Themes.customColor(8,
                            color: Theme.of(context).unselectedWidgetColor),
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        'Periode Tahun : ${item.tahunCuti}',
                        style: Themes.customColor(8,
                            color: Theme.of(context).unselectedWidgetColor),
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        'Total Cuti : ${item.totalHari}',
                        style: Themes.customColor(8,
                            color: Theme.of(context).unselectedWidgetColor),
                        overflow: TextOverflow.visible,
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
                Material(
                  color: Colors.transparent,
                  child: InkWell(
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
                          label: 'Isi Form Approve SPV',
                          context: context,
                        );

                        final namaSpv =
                            ref.read(userNotifierProvider).user.nama!;

                        if (text != null) {
                          log('message $text');
                          await ref
                              .read(cutiApproveControllerProvider.notifier)
                              .approveSpv(
                                note: text,
                                itemCuti: item,
                                nama: namaSpv,
                              );
                        }
                      } else {
                        final namaSpv =
                            ref.read(userNotifierProvider).user.nama!;

                        await ref
                            .read(cutiApproveControllerProvider.notifier)
                            .unapproveSpv(
                              itemCuti: item,
                              nama: namaSpv,
                            );
                      }
                    },
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
                          style: Themes.customColor(10,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        if (item.spvTgl != null) ...[
                          Text(
                            'SPV Aging : $spvAging',
                            style: Themes.customColor(10,
                                color: Theme.of(context).unselectedWidgetColor),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // LOWER RIGHT
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      // if (ref
                      //     .read(sakitApproveControllerProvider.notifier)
                      //     .canHrdApprove(item)) {
                      //   log('message');
                      // }

                      if (item.hrdSta == false) {
                        final String? text =
                            await DialogHelper<void>().showFormDialog(
                          label: 'Isi Form Approve HRD',
                          context: context,
                        );

                        if (text != null) {
                          final namaHrd =
                              ref.read(userNotifierProvider).user.nama!;

                          await ref
                              .read(cutiApproveControllerProvider.notifier)
                              .approveHrd(
                                note: text,
                                itemCuti: item,
                                nama: namaHrd,
                              );
                        }
                      } else {
                        final namaHrd =
                            ref.read(userNotifierProvider).user.nama!;

                        await ref
                            .read(cutiApproveControllerProvider.notifier)
                            .unapproveHrd(
                              itemCuti: item,
                              nama: namaHrd,
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
                            style: Themes.customColor(10,
                                color: Theme.of(context).unselectedWidgetColor),
                          ),
                          if (item.hrdTgl != null) ...[
                            Text(
                              'HRD Aging : $hrdAging',
                              style: Themes.customColor(10,
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                            ),
                          ],
                        ],
                      ),
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
              // if (item.cUser != currUser)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      context.pushNamed(RouteNames.editCutiRoute, extra: item),
                  child: Ink(
                    child: Text('Edit',
                        style: Themes.customColor(10,
                            color: Colors.blue,
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              // if (item.cUser != currUser)
              // Material(
              //   color: Colors.transparent,
              //   child: InkWell(
              //     onTap: () => {},
              //     child: Ink(
              //       child: Text('Delete',
              //           style: Themes.customColor(10,
              //               color: Colors.red,
              //               decoration: TextDecoration.underline)),
              //     ),
              //   ),
              // )
            ]),

            SizedBox(
              height: 8,
            ),

            Row(
              children: [
                if (item.btlSta == true) ...[
                  Text(
                    'Form Dibatalkan',
                    style: Themes.customColor(
                      10,
                    ),
                  ),
                ],
                if (item.btlSta == false) ...[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => VAlertDialog(
                                label: 'Batalkan form cuti ?',
                                labelDescription:
                                    'Jika Ya, form cuti tidak dapat digunakan.',
                                onPressed: () async {
                                  context.pop();
                                  await ref
                                      .read(cutiApproveControllerProvider
                                          .notifier)
                                      .batal(
                                        itemCuti: item,
                                        nama: ref
                                            .read(userNotifierProvider)
                                            .user
                                            .nama!,
                                      );
                                }));
                      },
                      child: Ink(
                        child: Column(
                          children: [
                            Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            Text(
                              'Batal',
                              style: Themes.customColor(
                                10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
