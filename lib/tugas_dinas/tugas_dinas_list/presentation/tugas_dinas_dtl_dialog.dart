import 'package:collection/collection.dart';
import 'package:face_net_authentication/tugas_dinas/create_tugas_dinas/application/create_tugas_dinas_notifier.dart';
import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../style/style.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../application/mst_user_list.dart';
import '../application/tugas_dinas_list.dart';
import '../application/tugas_dinas_list_notifier.dart';

class TugasDinasDtlDialog extends ConsumerWidget {
  const TugasDinasDtlDialog({Key? key, required this.item}) : super(key: key);

  final TugasDinasList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterUser = ref.watch(mstUserListNotifierProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 350,
        padding: EdgeInsets.all(12),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID FORM
                    Text(
                      'ID Form',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      item.idDinas.toString(),
                      style: Themes.customColor(9,
                          color: Palette.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // PT,
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
                          item.comp ?? "-",
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
                            item.dept ?? "-",
                            style: Themes.customColor(9,
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // PEMOHON
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pemohon',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            item.fullname ?? "-",
                            style: Themes.customColor(9,
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // PEMBERI
                    VAsyncValueWidget<List<MstUserList>>(
                      value: masterUser,
                      data: (mst) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pemberi',
                            style: Themes.customColor(7, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: 90,
                            child: Text(
                              item.idPemberi == null
                                  ? ''
                                  : mst
                                          .firstWhereOrNull((element) =>
                                              element.idUser == item.idPemberi!)
                                          ?.fullname ??
                                      '',
                              style: Themes.customColor(9,
                                  color: Palette.primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // PERUSAHAAN
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Perusahaan',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            item.perusahaan ?? "-",
                            style: Themes.customColor(9,
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // ALAMAT
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alamat',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          item.lokasi ?? "-",
                          style: Themes.customColor(9,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // KETERANGAN
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
                          width: 150,
                          child: Text(
                            item.ket ?? "-",
                            style: Themes.customColor(9,
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
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
                          'Tugas Dinas',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          item.kategori!,
                          style: Themes.customColor(9,
                              color: Palette.orange,
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
                          'Tanggal Awal',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(item.tglStart!),
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
                          'Tanggal Akhir',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(item.tglEnd!),
                          style: Themes.customColor(9,
                              color: Palette.tertiaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (item.jamStart != null) ...[
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
                            ).format(item.jamStart!),
                            style: Themes.customColor(9,
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                    if (item.jamEnd != null) ...[
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
                            ).format(item.jamEnd!),
                            style: Themes.customColor(9,
                                color: Palette.tertiaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Khusus',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                          child: Transform.scale(
                            scale: 0.5,
                            child: Checkbox(
                              fillColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              checkColor: Palette.primaryColor,
                              value: item.jenis,
                              onChanged: (val) {},
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              side: WidgetStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 2.0, color: Palette.primaryColor),
                              ),
                            ),
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
            if (item.btlSta == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (true)
                    TappableSvg(
                        assetPath: Assets.iconEdit,
                        onTap: () {
                          context.pop();
                          return context.pushNamed(
                              RouteNames.editTugasDinasRoute,
                              extra: item.toJson());
                        }),
                  SizedBox(
                    width: 8,
                  ),
                  if (true)
                    TappableSvg(
                        assetPath: Assets.iconDelete,
                        onTap: () {
                          return DialogHelper.showConfirmationDialog(
                              context: context,
                              label: 'Hapus form ? ',
                              onPressed: () async {
                                context.pop();
                                context.pop();
                                await ref
                                    .read(createTugasDinasNotifierProvider
                                        .notifier)
                                    .deleteTugasDinas(
                                        idDinas: item.idDinas!,
                                        onError: (msg) {
                                          return DialogHelper.showCustomDialog(
                                            msg,
                                            context,
                                          ).then((_) => ref
                                              .read(errLogControllerProvider
                                                  .notifier)
                                              .sendLog(errMessage: msg));
                                        });
                              });
                        })
                ],
              )
          ],
        ),
      ),
    );
  }
}
