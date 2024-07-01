import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:face_net_authentication/tugas_dinas/tugas_dinas_list/application/tugas_dinas_list_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../routes/application/route_names.dart';
import '../../../style/style.dart';

import '../../../utils/dialog_helper.dart';
import '../../../widgets/tappable_widget.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_dialogs.dart';

// import '../../create_tugas_dinas/application/create_tugas_dinas_notifier.dart';
import '../../create_tugas_dinas/application/create_tugas_dinas_notifier.dart';
import '../../create_tugas_dinas/application/jenis_tugas_dinas.dart';
import '../../tugas_dinas_approve/application/tugas_dinas_approve_notifier.dart';
import '../application/mst_user_list.dart';
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

    final jenisTugasDinas = ref.watch(jenisTugasDinasNotifierProvider);
    final masterUser = ref.watch(mstUserListNotifierProvider);

    final isCooGmVisible = item.isCooGmVisible!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 300,
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
                        "${item.idDinas} - ${DateFormat(
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
                              builder: (context) => TugasDinasDtlDialog(
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
                                        .read(
                                            tugasDinasApproveControllerProvider
                                                .notifier)
                                        .batal(idDinas: item.idDinas!);
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
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 90,
                        child: Column(
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
                            Text(
                              item.fullname == null ? '-' : item.fullname!,
                              style: Themes.customColor(9,
                                  color: item.btlSta == true
                                      ? Colors.white
                                      : Palette.primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VAsyncValueWidget<List<MstUserList>>(
                            value: masterUser,
                            data: (mst) => Column(
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
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    item.idPemberi == null
                                        ? ''
                                        : mst
                                                .firstWhereOrNull((element) =>
                                                    element.idUser ==
                                                    item.idPemberi!)
                                                ?.fullname ??
                                            '',
                                    style: Themes.customColor(9,
                                        color: item.btlSta == true
                                            ? Colors.white
                                            : Palette.primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
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
                            height: 4,
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
                                height: item.qtyfoto == 0 ? 8 : 2,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => item.qtyfoto == 0
                                      ? context.pushNamed(
                                          RouteNames.tugasDinasUploadRoute,
                                          extra: item.idDinas,
                                        )
                                      : context.pushNamed(
                                          RouteNames.tugasDinasDtlRoute,
                                          extra: item.idDinas,
                                        ),
                                  child: item.qtyfoto == 0
                                      ? Ink(
                                          child: Icon(
                                          Icons.upload,
                                          color: item.btlSta == true
                                              ? Colors.white
                                              : Palette.primaryColor,
                                        ))
                                      : Ink(
                                          child: Text(
                                              'Upload : ${item.qtyfoto} Documents',
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
                              SizedBox(
                                width: 90,
                                child: Text(
                                  item.dept == null ? '-' : item.dept!,
                                  style: Themes.customColor(8,
                                      color: item.btlSta == true
                                          ? Colors.white
                                          : Palette.primaryColor,
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
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 4,
                      ),
                    ],
                  ),

                  VAsyncValueWidget<List<JenisTugasDinas>>(
                    value: jenisTugasDinas,
                    data: (jenis) => Column(
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
                            jenis
                                    .firstWhereOrNull(
                                      (element) =>
                                          element.kode == item.kategori,
                                    )
                                    ?.kategori ??
                                '-',
                            style: Themes.customColor(9,
                                color: item.btlSta == true
                                    ? Colors.white
                                    : Palette.orange,
                                fontWeight: FontWeight.w500),
                          ),
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
                        item.perusahaan == null ? '-' : item.perusahaan!,
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
                        item.lokasi == null ? '-' : item.lokasi!,
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
                          ),
                        ),
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
                  child: Row(children: [
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
                                                            tugasDinasApproveControllerProvider
                                                                .notifier)
                                                        .approve(
                                                            idDinas:
                                                                item.idDinas!,
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
                                                            tugasDinasApproveControllerProvider
                                                                .notifier)
                                                        .approve(
                                                            idDinas:
                                                                item.idDinas!,
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

                      if (isCooGmVisible) ...[
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
                                      if (item.isGm == false) {
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
                                                        'Dibutuhkan Konfirmasi GM (Approve)',
                                                    onPressed: () async {
                                                      context.pop();
                                                      await ref
                                                          .read(
                                                              tugasDinasApproveControllerProvider
                                                                  .notifier)
                                                          .approve(
                                                              idDinas:
                                                                  item.idDinas!,
                                                              note: '',
                                                              jenisApp: 'gm',
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
                                                        'Dibutuhkan Konfirmasi GM (Unapprove)',
                                                    onPressed: () async {
                                                      context.pop();
                                                      await ref
                                                          .read(
                                                              tugasDinasApproveControllerProvider
                                                                  .notifier)
                                                          .approve(
                                                              idDinas:
                                                                  item.idDinas!,
                                                              note: '',
                                                              jenisApp: 'gm',
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
                      ],

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
                                              .showFormDialog(context: context);

                                      if (item.hrdSta == false) {
                                        await showDialog(
                                            context: context,
                                            builder: (context) => VAlertDialog2(
                                                label:
                                                    'Dibutuhkan Konfirmasi HRD (Approve)',
                                                onPressed: () async {
                                                  context.pop();
                                                  await ref
                                                      .read(
                                                          tugasDinasApproveControllerProvider
                                                              .notifier)
                                                      .approve(
                                                          idDinas:
                                                              item.idDinas!,
                                                          note: text ?? '',
                                                          jenisApp: 'hr',
                                                          tahun:
                                                              item.cDate!.year);
                                                }));
                                      } else {
                                        await showDialog(
                                            context: context,
                                            builder: (context) => VAlertDialog2(
                                                label:
                                                    'Dibutuhkan Konfirmasi HRD (Unapprove)',
                                                onPressed: () async {
                                                  context.pop();
                                                  await ref
                                                      .read(
                                                          tugasDinasApproveControllerProvider
                                                              .notifier)
                                                      .approve(
                                                          idDinas:
                                                              item.idDinas!,
                                                          note: text ?? '',
                                                          jenisApp: 'hr',
                                                          tahun:
                                                              item.cDate!.year);
                                                }));
                                      }
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
                            if (item.hrdSta == true) ...[
                              if (!isCooGmVisible) ...[
                                Positioned(
                                  left: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbUp,
                                  ),
                                )
                              ] else if (isCooGmVisible) ...[
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbUp,
                                  ),
                                )
                              ]
                            ],
                            if (item.hrdSta == false) ...[
                              if (!isCooGmVisible) ...[
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
                                )
                              ] else if (isCooGmVisible) ...[
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbDown,
                                  ),
                                )
                              ]
                            ]
                          ],
                        ),
                      ),

                      if (isCooGmVisible) ...[
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
                                      if (item.isCoo == false) {
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
                                                        'Dibutuhkan Konfirmasi COO (Approve)',
                                                    onPressed: () async {
                                                      context.pop();
                                                      await ref
                                                          .read(
                                                              tugasDinasApproveControllerProvider
                                                                  .notifier)
                                                          .approve(
                                                              idDinas:
                                                                  item.idDinas!,
                                                              note: '',
                                                              jenisApp: 'coo',
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
                                                        'Dibutuhkan Konfirmasi COO (Unapprove)',
                                                    onPressed: () async {
                                                      context.pop();
                                                      await ref
                                                          .read(
                                                              tugasDinasApproveControllerProvider
                                                                  .notifier)
                                                          .approve(
                                                              idDinas:
                                                                  item.idDinas!,
                                                              note: '',
                                                              jenisApp: 'coo',
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
                        )
                      ],
                    ],
                  ]),
                ))
          ],
        ),
      ),
    );
  }
}
