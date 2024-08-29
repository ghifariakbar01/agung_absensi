import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';

import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../constants/assets.dart';
import '../../../../widgets/v_dialogs.dart';

import '../../jadwal_shift_approve/application/jadwal_shift_approve_notifier.dart';
import '../application/jadwal_detail_notifier.dart';
import '../application/jadwal_shift_list.dart';
import 'jadwal_shift_dtl_dialog.dart';

class JadwalShiftListItem extends HookConsumerWidget {
  const JadwalShiftListItem(
    this.item,
  );

  final JadwalShiftList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 175,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.primaryColor,
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
                        "${item.idShift} - ${DateFormat(
                          'EEEE, dd MMMM yyyy',
                        ).format((item.cDate!))}",
                        style: Themes.customColor(10,
                            fontWeight: FontWeight.w500,
                            color: Palette.primaryColor),
                      ),

                      Spacer(),

                      TappableSvg(
                          assetPath: Assets.iconDetail,
                          color: Palette.primaryColor,
                          onTap: () {
                            ref
                                .read(jadwalDetailControllerProvider.notifier)
                                .loadDetail(idShift: item.idShift!);
                            return showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => JadwalShiftDtlDialog(
                                item.idShift!,
                                item.isDelete!,
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
                                  style:
                                      Themes.customColor(7, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  item.fullname ?? '-',
                                  style: Themes.customColor(9,
                                      color: Palette.primaryColor,
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
                                'Updated',
                                style: Themes.customColor(
                                  7,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                item.uUser == null || item.uDate == null
                                    ? '-'
                                    : "${item.uUser} / ${DateFormat('yyyy-MM-dd HH:mm').format(item.uDate!)}",
                                style: Themes.customColor(9,
                                    color: Colors.black,
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
                                'Created',
                                style: Themes.customColor(
                                  7,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                item.cUser == null || item.cDate == null
                                    ? '-'
                                    : "${item.cUser} / ${DateFormat('yyyy-MM-dd HH:mm').format(item.cDate!)}",
                                style: Themes.customColor(9,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Periode',
                                style:
                                    Themes.customColor(7, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                item.periode == null
                                    ? ""
                                    : DateFormat('yyyy-MMMM')
                                        .format(item.periode!),
                                style: Themes.customColor(9,
                                    color: Palette.blue,
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
                                'Week',
                                style: Themes.customColor(
                                  7,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                item.week == null
                                    ? '-'
                                    : item.week == 0
                                        ? '-'
                                        : item.week == 1
                                            ? "Week 1 & 2"
                                            : "Week 3 & 4",
                                style: Themes.customColor(9,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 4,
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
                  child: Row(children: [
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
                                  if (item.isStaf == false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => VFailedDialog(
                                        message: item.stafMsg,
                                      ),
                                    );
                                  } else {
                                    if (item.stafSta == false) {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return VAlertDialog2(
                                                label:
                                                    'Dibutuhkan Konfirmasi Staf (Approve)',
                                                onPressed: () async {
                                                  context.pop();
                                                  await ref
                                                      .read(
                                                          jadwalShiftApproveControllerProvider
                                                              .notifier)
                                                      .approve(
                                                          idShift:
                                                              item.idShift!,
                                                          jenisApp: 'staf');
                                                });
                                          });
                                    } else {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return VAlertDialog2(
                                                label:
                                                    'Dibutuhkan Konfirmasi Staf (Unapprove)',
                                                onPressed: () async {
                                                  context.pop();
                                                  await ref
                                                      .read(
                                                          jadwalShiftApproveControllerProvider
                                                              .notifier)
                                                      .approve(
                                                          idShift:
                                                              item.idShift!,
                                                          jenisApp: 'staf');
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
                                      color: item.stafSta == true
                                          ? Palette.green
                                          : Palette.red2,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Approve Staf',
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
                          if (item.stafSta == true)
                            Positioned(
                              right: 5,
                              bottom: 0,
                              top: 0,
                              child: SvgPicture.asset(
                                Assets.iconThumbUp,
                              ),
                            ),
                          if (item.stafSta == false)
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
                                  if (item.isSpv == false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => VFailedDialog(
                                        message: item.spvMsg,
                                      ),
                                    );
                                  } else {
                                    if (item.stafSta == false) {
                                      await showDialog(
                                          context: context,
                                          builder: (context) => VAlertDialog2(
                                              label:
                                                  'Dibutuhkan Konfirmasi SPV (Approve)',
                                              onPressed: () async {
                                                context.pop();
                                                await ref
                                                    .read(
                                                        jadwalShiftApproveControllerProvider
                                                            .notifier)
                                                    .approve(
                                                        idShift: item.idShift!,
                                                        jenisApp: 'spv');
                                              }));
                                    } else {
                                      await showDialog(
                                          context: context,
                                          builder: (context) => VAlertDialog2(
                                              label:
                                                  'Dibutuhkan Konfirmasi SPV (Unapprove)',
                                              onPressed: () async {
                                                context.pop();
                                                await ref
                                                    .read(
                                                        jadwalShiftApproveControllerProvider
                                                            .notifier)
                                                    .approve(
                                                        idShift: item.idShift!,
                                                        jenisApp: 'spv');
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
                                    color: item.spvSta == true
                                        ? Palette.green
                                        : Palette.red2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          if (item.spvSta == false)
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
                  ]),
                ))
          ],
        ),
      ),
    );
  }
}
