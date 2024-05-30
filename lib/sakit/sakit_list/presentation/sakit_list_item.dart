import 'package:auto_size_text/auto_size_text.dart';
import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../routes/application/route_names.dart';
import '../../../style/style.dart';

import '../../../utils/dialog_helper.dart';
import '../../../widgets/v_dialogs.dart';
import '../../sakit_approve/application/sakit_approve_notifier.dart';
import '../application/sakit_list.dart';

import 'sakit_dtl_dialog.dart';

class SakitListItem extends HookConsumerWidget {
  const SakitListItem(
    this.item,
  );

  final SakitList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
                      color: item.btlSta == true
                          ? Colors.white
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT
                      if (item.cDate != null)
                        Text(
                          DateFormat(
                            'EEEE, dd MMMM yyyy',
                          ).format(item.cDate!),
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
                              builder: (context) => SakitDtlDialog(
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => VBatalDialog(
                                  onTap: () async {
                                    if (!false) {
                                      return showDialog(
                                        context: context,
                                        builder: (context) => VFailedDialog(
                                          message: '',
                                        ),
                                      );
                                    }
                                    context.pop();
                                    await ref
                                        .read(sakitApproveControllerProvider
                                            .notifier)
                                        .batal(
                                          idSakit: item.idSakit!,
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
                      SizedBox(
                        width: 90,
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
                        width: 25,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (item.tglStart != null)
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
                              if (item.tglEnd != null)
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
                                      ).format(item.tglEnd!),
                                      style: Themes.customColor(9,
                                          color: item.btlSta == true
                                              ? Colors.white
                                              : Palette.tertiaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jumlah Sakit',
                                    style: Themes.customColor(7,
                                        color: item.btlSta == true
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  // Text(
                                  //   item.totHari.toString() + " Hari",
                                  //   style: Themes.customColor(9,
                                  //       color: item.btlSta == true
                                  //           ? Colors.white
                                  //           : Palette.primaryColor,
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       'Surat',
                              //       style: Themes.customColor(7,
                              //           color: item.btlSta == true
                              //               ? Colors.white
                              //               : Colors.grey),
                              //     ),
                              //     SizedBox(
                              //       height: 2,
                              //     ),
                              //     if (item.surat != null)
                              //       Text(
                              //         '${item.surat!.toLowerCase() == 'ds' ? 'Dengan Surat' : 'Tanpa Surat'}',
                              //         style: Themes.customColor(9,
                              //             color: item.btlSta == true
                              //                 ? Colors.white
                              //                 : Palette.tertiaryColor,
                              //             fontWeight: FontWeight.w500),
                              //       ),
                              //   ],
                              // )
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
                        'Diagnosa',
                        style: Themes.customColor(7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey),
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
                                          'Diagnosa',
                                          style: Themes.customColor(10),
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              item.ket ?? '',
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

                  SizedBox(
                    height: 8,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Document',
                        style: Themes.customColor(7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => item.qtyfoto == 0
                              ? context.pushNamed(
                                  RouteNames.sakitUploadRoute,
                                  extra: item.idSakit,
                                )
                              : context.pushNamed(
                                  RouteNames.sakitDtlRoute,
                                  extra: item.idSakit,
                                ),
                          child: Ink(
                            child: Text(
                                item.qtyfoto == 0
                                    ? '-'
                                    : 'Upload : ${item.qtyfoto} Images',
                                style: Themes.customColor(
                                  9,
                                  color: item.btlSta == true
                                      ? Colors.white
                                      : Palette.blueLink,
                                )),
                          ),
                        ),
                      ),
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
                                'Canceled by ${item.btlNm ?? '-'}',
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
                                      if (!item.isSpv!) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VFailedDialog(
                                            message: item.spvMsg,
                                          ),
                                        );
                                      } else {
                                        // jika belum diapprove maka approve
                                        // kl udah di unapprove
                                        if (item.spvSta == false) {
                                          await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  VAlertDialog2(
                                                      label:
                                                          'Dibutuhkan Konfirmasi SPV (Approve)',
                                                      onPressed: () async {
                                                        context.pop();

                                                        await ref
                                                            .read(
                                                                sakitApproveControllerProvider
                                                                    .notifier)
                                                            .approve(
                                                              idSakit:
                                                                  item.idSakit!,
                                                              jenisApp: 'spv',
                                                              note: '',
                                                              tahun: item
                                                                  .cDate!.year,
                                                            );
                                                      }));
                                        } else {
                                          await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  VAlertDialog2(
                                                      label:
                                                          'Dibutuhkan Konfirmasi SPV (Unapprove)',
                                                      onPressed: () async {
                                                        context.pop();

                                                        await ref
                                                            .read(
                                                                sakitApproveControllerProvider
                                                                    .notifier)
                                                            .approve(
                                                              idSakit:
                                                                  item.idSakit!,
                                                              jenisApp: 'spv',
                                                              note: '',
                                                              tahun: item
                                                                  .cDate!.year,
                                                            );
                                                      }));
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
                                      if (!item.isHr!) {
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
                                          label: 'Note HRD',
                                          context: context,
                                        );

                                        if (item.hrdSta == false) {
                                          await ref
                                              .read(
                                                  sakitApproveControllerProvider
                                                      .notifier)
                                              .approve(
                                                idSakit: item.idSakit!,
                                                jenisApp: 'hr',
                                                note: text ?? '',
                                                tahun: item.cDate!.year,
                                              );
                                        } else {
                                          await ref
                                              .read(
                                                  sakitApproveControllerProvider
                                                      .notifier)
                                              .approve(
                                                idSakit: item.idSakit!,
                                                jenisApp: 'hr',
                                                note: text ?? '',
                                                tahun: item.cDate!.year,
                                              );
                                        }

                                        context.pop();
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
