import 'package:face_net_authentication/tugas_dinas/tugas_dinas_approve/application/tugas_dinas_approve_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../shared/providers.dart';
import '../../../style/style.dart';

import '../../../widgets/tappable_widget.dart';
import '../../../widgets/v_dialogs.dart';

import '../application/tugas_dinas_list.dart';
import 'tugas_dinas_dtl_dialog.dart';

class TugasDinasListItem extends HookConsumerWidget {
  const TugasDinasListItem(
    this.item,
  );

  final TugasDinasList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // final _isSpvApprove = item.spvTgl != item.cDate && item.spvSta == true;
    // final spvAging = _isSpvApprove
    //     ? DateTime.parse(item.spvTgl!)
    //         .difference(DateTime.parse(item.cDate!))
    //         .inDays
    //     : DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    // final _isHrdApprove = item.hrdTgl != item.cDate && item.hrdSta == true;
    // final hrdAging = _isHrdApprove
    //     ? DateTime.parse(item.hrdTgl!)
    //         .difference(DateTime.parse(item.cDate!))
    //         .inDays
    //     : DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: item.btlSta == true ? Palette.red : theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: item.btlSta == true
                          ? Colors.white
                          : Colors.grey.withOpacity(0.5), // Shadow color
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
                        DateFormat(
                          'EEEE, dd MMMM yyyy',
                        ).format(DateTime.parse(item.cDate!)),
                        style: Themes.customColor(10,
                            fontWeight: FontWeight.w500,
                            color: item.btlSta == true ? Colors.white : null),
                      ),

                      Spacer(),

                      // tappable svg
                      TappableSvg(
                          assetPath: Assets.iconDetail,
                          color: item.btlSta == true ? Colors.white : null,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => TugasDinasDtlDialog(
                                item: item,
                              ),
                            );
                          }),
                      SizedBox(
                        width: 4,
                      ),
                      if (item.btlSta == false)
                        TappableSvg(
                            assetPath: Assets.iconBatal,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => VBatalDialog(
                                  onTap: () async {
                                    context.pop();
                                    await ref
                                        .read(
                                            tugasDinasApproveControllerProvider
                                                .notifier)
                                        .batal(
                                          item: item,
                                          nama: ref
                                              .read(userNotifierProvider)
                                              .user
                                              .nama!,
                                        );
                                  },
                                ),
                              );
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
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pemohon',
                            style: Themes.customColor(7,
                                color: item.btlSta == true
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: 90,
                            child: Text(
                              item.fullname!,
                              style: Themes.customColor(9,
                                  color: item.btlSta == true
                                      ? Colors.white
                                      : Palette.primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pemberi Tugas',
                                style: Themes.customColor(7,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                item.pemberiName!,
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
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
                                ).format(DateTime.parse(item.tglStart!)),
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.blue,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dept',
                                style: Themes.customColor(7,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                item.dept!,
                                style: Themes.customColor(8,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
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
                                'Tanggal Akhir',
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
                                ).format(DateTime.parse(item.tglEnd!)),
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
                        width: 4,
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kategori',
                        style: Themes.customColor(7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          '${item.kategori}',
                          style: Themes.customColor(9,
                              color: item.btlSta == true
                                  ? Colors.white
                                  : Palette.orange,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
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
                        'Perusahaan',
                        style: Themes.customColor(7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        item.perusahaan!,
                        style: Themes.customColor(9,
                            color: item.btlSta == true
                                ? Colors.white
                                : Palette.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
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
                        'Alamat',
                        style: Themes.customColor(7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        item.lokasi!,
                        style: Themes.customColor(9,
                            color: item.btlSta == true
                                ? Colors.white
                                : Palette.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
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
                        style: Themes.customColor(7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${item.ket}',
                        style: Themes.customColor(9,
                            color: item.btlSta == true
                                ? Colors.white
                                : Palette.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
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
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey
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
                                      if (!ref
                                          .read(userNotifierProvider)
                                          .user
                                          .isSpvOrHrd!) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VAksesDitolak(),
                                        );
                                      } else {
                                        await showDialog(
                                            context: context,
                                            builder: (context) => VAlertDialog2(
                                                label:
                                                    'Dibutuhkan Konfirmasi SPV ${item.spvSta ? '(Unapprove)' : '(Approve)'}',
                                                onPressed: () async {
                                                  context.pop();
                                                  await ref
                                                      .read(
                                                          tugasDinasApproveControllerProvider
                                                              .notifier)
                                                      .processSpv(
                                                        item: item,
                                                        nama: ref
                                                            .read(
                                                                userNotifierProvider)
                                                            .user
                                                            .nama!,
                                                      );
                                                }));
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
                                              color: item.btlSta == true
                                                  ? Colors.white
                                                  : Colors.grey.withOpacity(
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
                                            'Approve SPV   ',
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
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey
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
                                      if (!ref
                                          .read(userNotifierProvider)
                                          .user
                                          .isSpvOrHrd!) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VAksesDitolak(),
                                        );
                                      } else {
                                        return showDialog(
                                            context: context,
                                            builder: (context) => VAlertDialog2(
                                                label:
                                                    'Dibutuhkan Konfirmasi HRD ${item.hrdSta ? '(Unapprove)' : '(Approve)'}',
                                                onPressed: () async {
                                                  context.pop();
                                                  await ref
                                                      .read(
                                                          tugasDinasApproveControllerProvider
                                                              .notifier)
                                                      .processHrd(
                                                        item: item,
                                                        namaHrd: ref
                                                            .read(
                                                                userNotifierProvider)
                                                            .user
                                                            .nama!,
                                                      );
                                                }));
                                      }
                                    },
                                    child: Ink(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: item.hrdSta == true
                                            ? Palette.green
                                            : Palette.red2,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Approve HRD    ',
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
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbUp,
                                  ),
                                ),
                              if (item.hrdSta == false)
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

                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey
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
                                      if (!ref
                                          .read(userNotifierProvider)
                                          .user
                                          .isSpvOrHrd!) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VAksesDitolak(),
                                        );
                                      } else {
                                        return showDialog(
                                            context: context,
                                            builder: (context) => VAlertDialog2(
                                                label:
                                                    'Dibutuhkan Konfirmasi GM ${item.gmSta ? '(Unapprove)' : '(Approve)'}',
                                                onPressed: () async {
                                                  context.pop();
                                                  await ref
                                                      .read(
                                                          tugasDinasApproveControllerProvider
                                                              .notifier)
                                                      .processGm(
                                                        item: item,
                                                        namaGm: ref
                                                            .read(
                                                                userNotifierProvider)
                                                            .user
                                                            .nama!,
                                                        ptServer: ref
                                                            .read(
                                                                userNotifierProvider)
                                                            .user
                                                            .ptServer!,
                                                      );
                                                }));
                                      }
                                    },
                                    child: Ink(
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: item.gmSta == true
                                              ? Palette.green
                                              : Palette.red2,
                                          boxShadow: [
                                            BoxShadow(
                                              color: item.btlSta == true
                                                  ? Colors.white
                                                  : Colors.grey.withOpacity(
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
                                            'Approve GM   ',
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
                              if (item.gmSta == true)
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbUp,
                                  ),
                                ),
                              if (item.gmSta == false)
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
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey
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
                                      if (!ref
                                          .read(userNotifierProvider)
                                          .user
                                          .isSpvOrHrd!) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VAksesDitolak(),
                                        );
                                      } else {
                                        return showDialog(
                                            context: context,
                                            builder: (context) => VAlertDialog2(
                                                label:
                                                    'Dibutuhkan Konfirmasi COO ${item.cooSta ? '(Unapprove)' : '(Approve)'}',
                                                onPressed: () async {
                                                  context.pop();
                                                  await ref
                                                      .read(
                                                          tugasDinasApproveControllerProvider
                                                              .notifier)
                                                      .processCOO(
                                                        item: item,
                                                        namaCoo: ref
                                                            .read(
                                                                userNotifierProvider)
                                                            .user
                                                            .nama!,
                                                      );
                                                }));
                                      }
                                    },
                                    child: Ink(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(8),
                                        ),
                                        color: item.cooSta == true
                                            ? Palette.green
                                            : Palette.red2,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Approve COO    ',
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
                              if (item.cooSta == true)
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbUp,
                                  ),
                                ),
                              if (item.cooSta == false)
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
