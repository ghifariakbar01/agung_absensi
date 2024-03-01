import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../routes/application/route_names.dart';
import '../../../shared/providers.dart';
import '../../../style/style.dart';
import '../../../utils/enums.dart';
import '../application/absen_manual_list.dart';
import '../application/absen_manual_list_notifier.dart';

class AbsenManualDtlDialog extends ConsumerWidget {
  const AbsenManualDtlDialog({Key? key, required this.item}) : super(key: key);

  final AbsenManualList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isHrdApproved = item.hrdSta;

    final String? fin = ref.watch(userNotifierProvider).user.fin;
    final bool isHrd =
        ref.watch(absenManualListControllerProvider.notifier).isHrdOrSpv(fin!);

    final bool isCurrentUser =
        ref.watch(userNotifierProvider).user.idUser == item.idUser;

    final bool isSpvApproved = item.spvSta;
    final bool isSpvEditable =
        ref.watch(absenManualListControllerProvider.notifier).isSpvEdit();

    final bool fullAkses = ref.watch(userNotifierProvider).user.fullAkses;

    _returnVisibility(ColumnCommandButtonType buttonType) {
      if (isHrd) {
        if (isCurrentUser == false) {
          if (isSpvApproved) {
            switch (buttonType) {
              case ColumnCommandButtonType.Edit:
                return true;
              case ColumnCommandButtonType.Delete:
                return false;
            }
          }
        } else {
          switch (buttonType) {
            case ColumnCommandButtonType.Edit:
              return true;
            case ColumnCommandButtonType.Delete:
              return true;
          }
        }
      } else {
        if (isCurrentUser) {
          if (isSpvEditable && isSpvApproved) {
            switch (buttonType) {
              case ColumnCommandButtonType.Edit:
                return true;
              case ColumnCommandButtonType.Delete:
                return true;
            }
          } else if (isSpvEditable && isSpvApproved == false) {
            switch (buttonType) {
              case ColumnCommandButtonType.Edit:
                return true;
              case ColumnCommandButtonType.Delete:
                return true;
            }
          } else if (!isSpvEditable && isSpvApproved) {
            switch (buttonType) {
              case ColumnCommandButtonType.Edit:
                return false;
              case ColumnCommandButtonType.Delete:
                return false;
            }
          } else {
            switch (buttonType) {
              case ColumnCommandButtonType.Edit:
                return true;
              case ColumnCommandButtonType.Delete:
                return false;
            }
          }
        } else {
          switch (buttonType) {
            case ColumnCommandButtonType.Edit:
              return true;
            case ColumnCommandButtonType.Delete:
              return false;
          }
        }
      }

      if (isHrdApproved) {
        switch (buttonType) {
          case ColumnCommandButtonType.Edit:
            return false;
          case ColumnCommandButtonType.Delete:
            return false;
        }
      }

      if (fullAkses) {
        switch (buttonType) {
          case ColumnCommandButtonType.Edit:
            return true;
          case ColumnCommandButtonType.Delete:
            return true;
        }
      }

      return false;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 280,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // 1.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID FORM
                    Text(
                      'ID Absen',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      item.idAbsenmnl.toString(),
                      style: Themes.customColor(9,
                          color: Palette.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // NAMA
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          item.fullname,
                          style: Themes.customColor(9,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // PT
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PT',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          item.comp,
                          style: Themes.customColor(9,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // DEPT
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Departemen',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            item.dept,
                            style: Themes.customColor(9,
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    //
                  ],
                ),
                //
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Izin',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(DateTime.parse(item.tgl)),
                          style: Themes.customColor(9,
                              color: Palette.blue, fontWeight: FontWeight.w500),
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
                          'Jam Awal',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'hh:mm a',
                          ).format(DateTime.parse(item.jamAwal)),
                          style: Themes.customColor(9,
                              color: Palette.blue, fontWeight: FontWeight.w500),
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
                          'Jam Akhir',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'hh:mm a',
                          ).format(DateTime.parse(item.jamAkhir)),
                          style: Themes.customColor(9,
                              color: Palette.tertiaryColor,
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
                          'Jenis Absen',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            '${item.jenisAbsen}',
                            style: Themes.customColor(9,
                                color: Palette.tertiaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 8,
            ),
            // 5
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keterangan',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        '${item.ket}',
                        style: Themes.customColor(9,
                            color: Palette.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(child: Container()),
            if (item.btlSta == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_returnVisibility(ColumnCommandButtonType.Edit))
                    TappableSvg(
                        assetPath: Assets.iconEdit,
                        onTap: () {
                          context.pop();
                          return context.pushNamed(
                              RouteNames.editAbsenManualRoute,
                              extra: item);
                        }),
                  SizedBox(
                    width: 8,
                  ),
                  if (_returnVisibility(ColumnCommandButtonType.Delete))
                    TappableSvg(assetPath: Assets.iconDelete, onTap: () {})
                ],
              )
          ],
        ),
      ),
    );
  }
}
