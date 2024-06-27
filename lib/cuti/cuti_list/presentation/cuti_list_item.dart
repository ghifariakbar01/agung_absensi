import 'package:auto_size_text/auto_size_text.dart';
import 'package:face_net_authentication/cuti/create_cuti/application/create_cuti_notifier.dart';
import 'package:face_net_authentication/cuti/cuti_approve/application/cuti_approve_notifier.dart';
import 'package:face_net_authentication/cuti/cuti_list/presentation/cuti_dtl_dialog.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';

import '../../../utils/dialog_helper.dart';
import '../../../widgets/v_dialogs.dart';
import '../../create_cuti/application/alasan_cuti.dart';
import '../../create_cuti/application/jenis_cuti.dart';
import '../application/cuti_list.dart';

import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';

class CutiListItem extends HookConsumerWidget {
  const CutiListItem(
    this.item,
  );

  final CutiList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final jenisCuti = ref.watch(jenisCutiNotifierProvider);
    final alasanCuti = ref.watch(alasanCutiNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 210,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: item.btlSta == true ? Palette.red : theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset:
                          Offset(0, 1), // Controls the position of the shadow
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upper Part
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT
                      Text(
                        "${item.idCuti} - ${DateFormat(
                          'EEEE, dd MMMM yyyy',
                        ).format((item.cDate!))}",
                        style: Themes.customColor(10,
                            fontWeight: FontWeight.w500,
                            color: item.btlSta == true
                                ? Colors.white
                                : Palette.primaryColor),
                      ),

                      Spacer(),

                      // tappable svg
                      TappableSvg(
                          assetPath: Assets.iconDetail,
                          color: item.btlSta == true
                              ? Colors.white
                              : Palette.primaryColor,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => CutiDtlDialog(
                                item: item,
                              ),
                            );
                          }),
                      SizedBox(
                        width: 4,
                      ),
                      TappableSvg(
                          assetPath: Assets.iconBatal,
                          onTap: () async {
                            if (item.btlSta!) {
                              return showDialog(
                                context: context,
                                builder: (context) => VFailedDialog(
                                  message: item.btlMsg,
                                ),
                              );
                            } else {
                              return showDialog(
                                context: context,
                                builder: (context) => VBatalDialog(
                                  onTap: () async {
                                    context.pop();
                                    await ref
                                        .read(cutiApproveControllerProvider
                                            .notifier)
                                        .batal(idCuti: item.idCuti!);
                                  },
                                ),
                              );
                            }
                          }),
                    ],
                  ),

                  SizedBox(
                    height: 2,
                  ),

                  Divider(
                    height: 2,
                    color: Palette.dividerColor,
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // MIDDLE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama',
                              style: Themes.customColor(7,
                                  color: item.btlSta == true
                                      ? Colors.white
                                      : Colors.grey),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              item.cUser!,
                              style: Themes.customColor(9,
                                  color: item.btlSta == true
                                      ? Colors.white
                                      : Palette.primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 65,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Saldo Awal',
                                      style: Themes.customColor(7,
                                          color: item.btlSta == true
                                              ? Colors.white
                                              : Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      item.saldoAwal == null
                                          ? '-'
                                          : item.saldoAwal.toString(),
                                      style: Themes.customColor(9,
                                          color: item.btlSta == true
                                              ? Colors.white
                                              : Palette.primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Awal',
                                    style: Themes.customColor(7,
                                        color: item.btlSta == true
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy',
                                    ).format(item.tglStart!),
                                    style: Themes.customColor(9,
                                        color: item.btlSta == true
                                            ? Colors.white
                                            : Palette.blue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Akhir',
                                    style: Themes.customColor(
                                      7,
                                      color: item.btlSta == true
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy',
                                    ).format(item.tglEnd!),
                                    style: Themes.customColor(9,
                                        color: item.btlSta == true
                                            ? Colors.white
                                            : Palette.tertiaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 65,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Saldo Akhir',
                                      style: Themes.customColor(7,
                                          color: item.btlSta == true
                                              ? Colors.white
                                              : Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      item.saldoAkhir == null
                                          ? '-'
                                          : item.saldoAkhir.toString(),
                                      style: Themes.customColor(9,
                                          color: item.btlSta == true
                                              ? Colors.white
                                              : Palette.primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jumlah Cuti',
                                    style: Themes.customColor(
                                      7,
                                      color: item.btlSta == true
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    item.totalHari!.toString() + " Hari",
                                    style: Themes.customColor(
                                      9,
                                      fontWeight: FontWeight.w500,
                                      color: item.btlSta == true
                                          ? Colors.white
                                          : Palette.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jenis Cuti',
                                    style: Themes.customColor(
                                      7,
                                      color: item.btlSta == true
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  VAsyncValueWidget<List<JenisCuti>>(
                                    value: jenisCuti,
                                    data: (list) => Text(
                                      '${list.firstWhere((element) => element.inisial == item.jenisCuti, orElse: () => list.first).nama}',
                                      style: Themes.customColor(9,
                                          color: item.btlSta == true
                                              ? Colors.white
                                              : Palette.tertiaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )

                      // tgl, jumlah sakit, surat info
                    ],
                  ),

                  SizedBox(
                    height: 4,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alasan Cuti',
                        style: Themes.customColor(
                          7,
                          color:
                              item.btlSta == true ? Colors.white : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      VAsyncValueWidget<List<AlasanCuti>>(
                        value: alasanCuti,
                        data: (list) => Text(
                          item.alasan == null
                              ? '-'
                              : '${item.alasan!.isEmpty ? '-' : list.firstWhere((element) => element.kode == item.alasan, orElse: () => list.first).alasan}',
                          style: Themes.customColor(9,
                              color: item.btlSta == true
                                  ? Colors.white
                                  : Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keterangan',
                        style: Themes.customColor(
                          7,
                          color:
                              item.btlSta == true ? Colors.white : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Ink(
                          height: 15,
                          child: InkWell(
                              onTap: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: Text(
                                          'Keterangan',
                                          style: Themes.customColor(10),
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              item.ket!,
                                              style: Themes.customColor(10),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                              child: AutoSizeText(
                                '${item.ket}',
                                maxFontSize: 9,
                                minFontSize: 5,
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ))),
                    ],
                  ),
                ],
              ),
            ),

            // approval
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      if (item.btlSta == true) ...[
                        Expanded(
                          child: Container(
                            height: 25,
                            decoration: BoxDecoration(
                                color: Palette.primaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0,
                                        1), // Controls the position of the shadow
                                  ),
                                ]),
                            child: Center(
                              child: Text(
                                'Canceled by ${item.btlNm}',
                                style: Themes.customColor(7,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // ok
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Palette.primaryColor,
                                    onTap: () async {
                                      if (item.isSpv == false) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VFailedDialog(
                                            message: item.spvMsg,
                                          ),
                                        );
                                      } else {
                                        if (item.spvSta == false) {
                                          await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return VAlertDialog2(
                                                    label:
                                                        'Dibutuhkan Konfirmasi SPV (Approve)',
                                                    onPressed: () async {
                                                      context.pop();
                                                      await ref
                                                          .read(
                                                              cutiApproveControllerProvider
                                                                  .notifier)
                                                          .approve(
                                                              idCuti:
                                                                  item.idCuti!,
                                                              note: '',
                                                              jenisApp: 'spv',
                                                              tahun: item
                                                                  .cDate!.year);
                                                    });
                                              });
                                        } else {
                                          await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return VAlertDialog2(
                                                    label:
                                                        'Dibutuhkan Konfirmasi SPV (Unapprove)',
                                                    onPressed: () async {
                                                      context.pop();
                                                      await ref
                                                          .read(
                                                              cutiApproveControllerProvider
                                                                  .notifier)
                                                          .approve(
                                                              idCuti:
                                                                  item.idCuti!,
                                                              note: '',
                                                              jenisApp: 'spv',
                                                              tahun: item
                                                                  .cDate!.year);
                                                    });
                                              });
                                        }
                                      }
                                    },
                                    child: Ink(
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                          ),
                                          color: item.spvSta! == true
                                              ? Palette.green
                                              : Palette.red2,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5), // Shadow color
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(0,
                                                  1), // Controls the position of the shadow
                                            ),
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Approve SPV',
                                            style: Themes.customColor(7,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (item.spvSta == true)
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbUp,
                                  ),
                                ),
                              if (item.spvSta == false)
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbDown,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // not ok
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(1,
                                        0), // Controls the position of the shadow
                                  ),
                                ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Palette.primaryColor,
                                    onTap: () async {
                                      if (item.isHr == false) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VFailedDialog(
                                            message: item.hrMsg,
                                          ),
                                        );
                                      } else {
                                        final String? text =
                                            await DialogHelper<void>()
                                                .showFormDialog(
                                                    context: context);

                                        if (item.hrdSta == false) {
                                          await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  VAlertDialog2(
                                                      label:
                                                          'Dibutuhkan Konfirmasi HRD (Approve)',
                                                      onPressed: () async {
                                                        context.pop();
                                                        await ref
                                                            .read(
                                                                cutiApproveControllerProvider
                                                                    .notifier)
                                                            .approve(
                                                                idCuti: item
                                                                    .idCuti!,
                                                                note:
                                                                    text ?? '',
                                                                jenisApp: 'hr',
                                                                tahun: item
                                                                    .cDate!
                                                                    .year);
                                                      }));
                                        } else {
                                          await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  VAlertDialog2(
                                                      label:
                                                          'Dibutuhkan Konfirmasi HRD (Unapprove)',
                                                      onPressed: () async {
                                                        context.pop();
                                                        await ref
                                                            .read(
                                                                cutiApproveControllerProvider
                                                                    .notifier)
                                                            .approve(
                                                                idCuti: item
                                                                    .idCuti!,
                                                                note:
                                                                    text ?? '',
                                                                jenisApp: 'hr',
                                                                tahun: item
                                                                    .cDate!
                                                                    .year);
                                                      }));
                                        }
                                      }
                                    },
                                    child: Ink(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(8),
                                        ),
                                        color: item.hrdSta! == true
                                            ? Palette.green
                                            : Palette.red2,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Approve HRD',
                                            style: Themes.customColor(7,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (item.hrdSta == true)
                                Positioned(
                                  left: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: Transform.scale(
                                    scaleX: -1,
                                    child: SvgPicture.asset(
                                      Assets.iconThumbUp,
                                    ),
                                  ),
                                ),
                              if (item.hrdSta == false)
                                Positioned(
                                  left: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: Transform.scale(
                                    scaleX: -1,
                                    child: SvgPicture.asset(
                                      Assets.iconThumbDown,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ]
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
