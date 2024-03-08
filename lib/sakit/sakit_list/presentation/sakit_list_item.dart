import 'package:auto_size_text/auto_size_text.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../routes/application/route_names.dart';
import '../../../style/style.dart';

import '../../../widgets/v_dialogs.dart';
import '../../sakit_approve/application/sakit_approve_notifier.dart';
import '../application/sakit_list.dart';
import 'sakit_dialog.dart';
import 'sakit_dtl_dialog.dart';

class SakitListItem extends HookConsumerWidget {
  const SakitListItem(
    this.item,
  );

  final SakitList item;

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
        height: 210,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: item.batalStatus == true
                      ? Palette.red
                      : theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: item.batalStatus == true
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
                            color:
                                item.batalStatus == true ? Colors.white : null),
                      ),

                      Spacer(),

                      // tappable svg
                      TappableSvg(
                          assetPath: Assets.iconDetail,
                          color: item.batalStatus == true ? Colors.white : null,
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
                      if (item.batalStatus == false)
                        TappableSvg(
                            assetPath: Assets.iconBatal,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => VBatalDialog(
                                  onTap: () async {
                                    context.pop();
                                    await ref
                                        .read(sakitApproveControllerProvider
                                            .notifier)
                                        .batal(
                                          itemSakit: item,
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
                            'Nama',
                            style: Themes.customColor(7,
                                color: item.batalStatus == true
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            item.fullname!,
                            style: Themes.customColor(9,
                                color: item.batalStatus == true
                                    ? Colors.white
                                    : Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Awal',
                                    style: Themes.customColor(7,
                                        color: item.batalStatus == true
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
                                        color: item.batalStatus == true
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
                                    style: Themes.customColor(7,
                                        color: item.batalStatus == true
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
                                        color: item.batalStatus == true
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
                                        color: item.batalStatus == true
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    item.totHari!.toString() + " Hari",
                                    style: Themes.customColor(9,
                                        color: item.batalStatus == true
                                            ? Colors.white
                                            : Palette.primaryColor,
                                        fontWeight: FontWeight.w500),
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
                                    'Surat',
                                    style: Themes.customColor(7,
                                        color: item.batalStatus == true
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    '${item.surat!.toLowerCase() == 'ds' ? 'Dengan Surat' : 'Tanpa Surat'}',
                                    style: Themes.customColor(9,
                                        color: item.batalStatus == true
                                            ? Colors.white
                                            : Palette.tertiaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
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
                            color: item.batalStatus == true
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
                                    color: item.batalStatus == true
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
                            color: item.batalStatus == true
                                ? Colors.white
                                : Colors.grey),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => item.qtyFoto! == 0
                              ? context.pushNamed(RouteNames.sakitUploadRoute,
                                  extra: item.idSakit)
                              : context.pushNamed(RouteNames.sakitDtlRoute,
                                  extra: item.idSakit),
                          child: Ink(
                            child: Text(
                                item.qtyFoto == 0
                                    ? '-'
                                    : 'Upload : ${item.qtyFoto} Images',
                                style: Themes.customColor(
                                  9,
                                  color: item.batalStatus == true
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
                      if (item.batalStatus == true) ...[
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
                                'Canceled by ${item.batalNama}',
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
                                    color: item.batalStatus == true
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
                                          .read(sakitApproveControllerProvider
                                              .notifier)
                                          .canSpvApprove(item)) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VAksesDitolak(),
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
                                                            .approveSpv(
                                                                itemSakit: item,
                                                                note: '',
                                                                nama: ref
                                                                    .read(
                                                                        userNotifierProvider)
                                                                    .user
                                                                    .nama!);
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
                                                            .unapproveSpv(
                                                                itemSakit: item,
                                                                nama: ref
                                                                    .read(
                                                                        userNotifierProvider)
                                                                    .user
                                                                    .nama!);
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
                                          color: item.spvSta! == true
                                              ? Palette.green
                                              : Palette.red2,
                                          boxShadow: [
                                            BoxShadow(
                                              color: item.batalStatus == true
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
                              if (item.spvSta! == true)
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbUp,
                                  ),
                                ),
                              if (item.spvSta! == false)
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
                                    color: item.batalStatus == true
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
                                          .read(sakitApproveControllerProvider
                                              .notifier)
                                          .canHrdApprove(item)) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VAksesDitolak(),
                                        );
                                      } else {
                                        if (item.hrdSta == false) {
                                          final String? text =
                                              await DialogHelper<void>()
                                                  .showFormDialog(
                                            label: 'Note HRD',
                                            context: context,
                                          );

                                          if (text != null) {
                                            if (item.surat!.toLowerCase() ==
                                                'ds') {
                                              await ref
                                                  .read(
                                                      sakitApproveControllerProvider
                                                          .notifier)
                                                  .approveHrdDenganSurat(
                                                    note: text,
                                                    itemSakit: item,
                                                    namaHrd: ref
                                                        .read(
                                                            userNotifierProvider)
                                                        .user
                                                        .nama!,
                                                  );
                                              //
                                            } else {
                                              await ref
                                                  .read(
                                                      sakitApproveControllerProvider
                                                          .notifier)
                                                  .approveHrdTanpaSurat(
                                                    note: text,
                                                    itemSakit: item,
                                                    namaHrd: ref
                                                        .read(
                                                            userNotifierProvider)
                                                        .user
                                                        .nama!,
                                                  );
                                              //
                                            }
                                          }
                                        } else {
                                          if (item.surat!.toLowerCase() ==
                                              'ds') {
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
                                                                  sakitApproveControllerProvider
                                                                      .notifier)
                                                              .unApproveHrdDenganSurat(
                                                                  itemSakit:
                                                                      item,
                                                                  nama: ref
                                                                      .read(
                                                                          userNotifierProvider)
                                                                      .user
                                                                      .nama!);
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
                                                                  sakitApproveControllerProvider
                                                                      .notifier)
                                                              .unApproveHrdTanpaSurat(
                                                                  itemSakit:
                                                                      item,
                                                                  nama: ref
                                                                      .read(
                                                                          userNotifierProvider)
                                                                      .user
                                                                      .nama!);
                                                        }));
                                          }
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
                              if (item.hrdSta! == true)
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
                              if (item.hrdSta! == false)
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
