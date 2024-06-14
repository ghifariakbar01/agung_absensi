import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:face_net_authentication/lembur/create_lembur/application/create_lembur_notifier.dart';
import 'package:face_net_authentication/lembur/lembur_approve/application/lembur_approve_notifier.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';

import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_dialogs.dart';

import '../../create_lembur/application/jenis_lembur.dart';
import '../application/lembur_list.dart';
import 'lembur_dtl_dialog.dart';

class LemburListItem extends HookConsumerWidget {
  const LemburListItem(
    this.item,
  );

  final LemburList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final jenis = ref.watch(jenisLemburNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 195,
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
                        "${item.idLmbr} - ${DateFormat(
                          'EEEE, dd MMMM yyyy',
                        ).format((DateTime.parse(item.cDate!)))}",
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
                              builder: (context) => LemburDtlDialog(
                                item: item,
                              ),
                            );
                          }),
                      SizedBox(
                        width: 4,
                      ),
                      if (false)
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
                                          .read(lemburApproveControllerProvider
                                              .notifier)
                                          .batal(idLembur: item.idLmbr!);
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
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Column(
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
                                  item.fullname ?? '-',
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
                            height: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jenis Lembur',
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
                              VAsyncValueWidget<List<JenisLembur>>(
                                value: jenis,
                                data: (jns) => Builder(builder: (context) {
                                  final selected = jns.firstWhereOrNull(
                                    (element) => element.Kode == item.kategori,
                                  );

                                  return Text(
                                    selected == null ? '-' : selected.Nama!,
                                    style: Themes.customColor(9,
                                        color: item.btlSta == true
                                            ? Colors.white
                                            : Palette.orange,
                                        fontWeight: FontWeight.w500),
                                  );
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'In',
                                style: Themes.customColor(7,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                item.masuk == null
                                    ? '-'
                                    : DateFormat(
                                        'yyyy-MM-dd HH:mm',
                                      ).format(DateTime.parse(item.masuk!)),
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.primaryColor,
                                    fontWeight: FontWeight.w500),
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
                                'Out',
                                style: Themes.customColor(7,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                item.pulang == null
                                    ? '-'
                                    : DateFormat(
                                        'yyyy-MM-dd HH:mm',
                                      ).format(DateTime.parse(item.pulang!)),
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal Lembur Awal',
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
                                  'yyyy-MM-dd HH:mm',
                                ).format(DateTime.parse(item.jamAwal!)),
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.blue,
                                    fontWeight: FontWeight.w500),
                              )
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
                                'Tanggal Lembur Akhir',
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
                                  'yyyy-MM-dd HH:mm',
                                ).format(DateTime.parse(item.jamAkhir!)),
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.tertiaryColor,
                                    fontWeight: FontWeight.w500),
                              )
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
                                'Total Jam',
                                style: Themes.customColor(7,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Builder(builder: (_) {
                                final _total = DateTime.parse(item.jamAkhir!)
                                    .difference(DateTime.parse(item.jamAwal!))
                                    .inHours;

                                return Text(
                                  _total.toString(),
                                  style: Themes.customColor(9,
                                      color: item.btlSta == true
                                          ? Colors.white
                                          : Palette.primaryColor,
                                      fontWeight: FontWeight.w500),
                                );
                              }),
                            ],
                          )
                        ],
                      )
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
                                              item.ket ?? '-',
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

                  // LOWER
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
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0,
                                        1), // Controls the position of the shadow
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
                                                              lemburApproveControllerProvider
                                                                  .notifier)
                                                          .approve(
                                                              idLembur:
                                                                  item.idLmbr!,
                                                              note: '',
                                                              jenisApp: 'spv',
                                                              tahun: 2024);
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
                                                              lemburApproveControllerProvider
                                                                  .notifier)
                                                          .approve(
                                                              idLembur:
                                                                  item.idLmbr!,
                                                              note: '',
                                                              jenisApp: 'spv',
                                                              tahun: 2024);
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
                                          color: item.spvSta == true
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
                                                                lemburApproveControllerProvider
                                                                    .notifier)
                                                            .approve(
                                                                idLembur: item
                                                                    .idLmbr!,
                                                                note:
                                                                    text ?? '',
                                                                jenisApp: 'hr',
                                                                tahun: 2024);
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
                                                                lemburApproveControllerProvider
                                                                    .notifier)
                                                            .approve(
                                                                idLembur: item
                                                                    .idLmbr!,
                                                                note:
                                                                    text ?? '',
                                                                jenisApp: 'hr',
                                                                tahun: 2024);
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
                                        color: item.hrdSta == true
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
